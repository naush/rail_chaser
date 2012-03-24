module RailChaser
  module Task
    def self.diff_files
      `git diff --name-only`.split("\n")
    end

    def self.stage_files
      `git diff --staged --name-only`.split("\n")
    end
  end
end
