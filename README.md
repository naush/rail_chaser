## Rail Chaser
Finds the minimum set of specs based on dependency analysis.

## Install

    rake build
    gem install rail_chaser-0.0.1.gem

## Setup

Edit Rakefile:

    require 'rail_chaser/task'
    RailChaser::Task.new

Edit spec_helper.rb:

    require 'rail_chaser'
    RailChaser.on

## Usage

    rake spec # generate spec.db
    rake spec:min

## Configuration

    RailChaser.on do |config|
      config.skip_gem = false # default true
      config.skip_ruby_core = false # default true
      config.skip_spec = false # default true
      # config.db_path defaults to 'spec.db', not available yet
    end