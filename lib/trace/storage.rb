require 'sqlite3'

module Trace
  class Storage
    def initialize
      destroy!
      create!
    end

    def add_class(name)
      @connection.execute("INSERT INTO classes (name) values ('#{name}');")
    end

    def add_spec(description)
      @connection.execute("INSERT INTO specs (description) values ('#{description}');")
    end

    def associate_spec_with_class(spec_id, class_id)
      @connection.execute("INSERT INTO specs_classes (spec_id, class_id) values (#{spec_id}, #{class_id});")
    end

    def find_spec_by_description(description)
      @connection.execute("SELECT id FROM specs WHERE description = '#{description}';").first.first
    end

    def find_class_by_name(name)
      @connection.execute("SELECT id FROM classes WHERE name = '#{name}';").first.first
    end

    def find_specs_by_class(name)
      sql = <<-SQL
SELECT s.description
FROM specs_classes sc JOIN classes c JOIN specs s ON sc.class_id = c.id AND sc.spec_id = s.id
WHERE c.name = '#{name}';
      SQL
      @connection.execute(sql)
    end

    def destroy!
      File.delete("trace.db") if File.exists?("trace.db")
    end

    def create!
      @connection = SQLite3::Database.new("trace.db")

      # PRAGMA foreign_keys = ON;
      sql = <<-SQL
CREATE TABLE IF NOT EXISTS specs(id INTEGER PRIMARY KEY NOT NULL, description TEXT UNIQUE NOT NULL);
CREATE TABLE IF NOT EXISTS classes(id INTEGER PRIMARY KEY NOT NULL, name TEXT UNIQUE NOT NULL);
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

      example_collection.each_description_and_classes do |description, classes|
        add_spec(description)
        spec_id = find_spec_by_description(description)

        classes.each do |klass|
          class_id = find_class_by_name(klass)
          associate_spec_with_class(spec_id, class_id)
        end
      end
    end
  end
end
