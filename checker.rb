#!/usr/bin/env ruby

require 'logger'
require 'json'
require 'date'
require 'byebug'

class Checker
  attr_reader :logger
  # attr_accessor :settings

  def initialize
    @pwd = Dir.pwd
    @logger = Logger.new("#{@pwd}/logfile.log")
    load_settings
  end

  def run
    logger.info('Program started')
    new_date = `phantomjs #{@pwd}/ge-cancellation-checker.phantom.js`.strip
    @logger.info("New Date is: #{new_date}")

    if better_date(new_date)
      # do stuff
    end
  end

  def load_settings
    file = File.read("#{@pwd}/config.json")
    @settings = JSON.parse(file)
  rescue SystemCallError => e
    logger.fatal("Config file does not exist. Error: #{e}")
    exit 1
  end

  private

  def better_date(date)
    new_date = Date.parse(date)
    current_date = Date.parse(@settings['current_interview_date_str'])

    new_date < current_date
  end
end

Checker.new.run
