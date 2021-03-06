# frozen_string_literal: true

gem "bundler", "< 1.16"

begin
  require "bundler/inline"
rescue LoadError => e
  $stderr.puts "Bundler version 1.10 or later is required. Please update your Bundler"
  raise e
end

gemfile(true) do
  source "https://rubygems.org"

  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  gem "rails", github: "rails/rails"
  gem "arel", github: "rails/arel"
end

require "active_job"
require "minitest/autorun"

# Ensure backward compatibility with Minitest 4
Minitest::Test = MiniTest::Unit::TestCase unless defined?(Minitest::Test)

class BuggyJob < ActiveJob::Base
  def perform
    puts "performed"
  end
end

class BuggyJobTest < ActiveJob::TestCase
  def test_stuff
    assert_enqueued_with(job: BuggyJob) do
      BuggyJob.perform_later
    end
  end
end
