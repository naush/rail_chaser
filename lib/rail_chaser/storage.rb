require 'sqlite3'

module RailChaser
  module Errors
    class NoDataSetError < StandardError; end
  end

  class Storage
    attr_accessor :options

    def initialize(options={:db_path => 'spec.db'})
      @options = options
    end

    def self.create(options={:db_path => 'spec.db'})
      storage = RailChaser::Storage.new(options)
      storage.destroy!
      storage.create!
      storage
    end

    def classes
      @connection.execute("SELECT file from classes").flatten
    end

    def specs
      @connection.execute("SELECT file from specs").flatten
    end

    def add_class(file)
      @connection.execute("INSERT INTO classes (file) values ('#{file}');")
    end

    def add_spec(file)
      @connection.execute("INSERT INTO specs (file) values ('#{file}');")
    end

    def associate_spec_with_class(spec_id, class_id)
      @connection.execute("INSERT INTO specs_classes (spec_id, class_id) values (#{spec_id}, #{class_id});")
    end

    def find_spec_by_file(file)
      @connection.execute("SELECT id FROM specs WHERE file = '#{file}';").first.first
    end

    def find_class_by_file(file)
      @connection.execute("SELECT id FROM classes WHERE file = '#{file}';").first.first
    end

    def find_specs_by_class(file)
      sql = <<-SQL
SELECT s.file
FROM specs_classes sc JOIN classes c JOIN specs s ON sc.class_id = c.id AND sc.spec_id = s.id
WHERE c.file LIKE '%#{file}';
      SQL
      @connection.execute(sql).flatten
    end

    def db_path
      options[:db_path]
    end

    def load!
      raise RailChaser::Errors::NoDataSetError unless File.exists?(db_path)
      @connection = SQLite3::Database.open(db_path)
    end

    def destroy!
      File.delete(db_path) if File.exists?(db_path)
    end

    def create!
      @connection = SQLite3::Database.new(db_path)

      # PRAGMA foreign_keys = ON;
      sql = <<-SQL
CREATE TABLE IF NOT EXISTS specs(
  id INTEGER PRIMARY KEY NOT NULL,
  file TEXT UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS classes(
  id INTEGER PRIMARY KEY NOT NULL,
  file TEXT UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS specs_classes(
  spec_id INTEGER, class_id INTEGER,
  FOREIGN KEY (spec_id) REFERENCES spec(id) ON DELETE CASCADE,
  FOREIGN KEY (class_id) REFERENCES class(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS spec_index ON specs_classes(spec_id);
CREATE INDEX IF NOT EXISTS class_index ON specs_classes(class_id);
      SQL

      @connection.execute_batch(sql)
    end

    def save!(example_collection)
      example_collection.classes.each do |klass|
        add_class(klass)
      end

      example_collection.each_spec_and_classes do |spec, classes|
        add_spec(spec)
        spec_id = find_spec_by_file(spec)

        classes.each do |klass|
          class_id = find_class_by_file(klass)
          associate_spec_with_class(spec_id, class_id)
        end
      end
    end
  end
end
