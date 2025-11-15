# frozen_string_literal: true

require "test_helper"
require 'fluent/auditify/plugin/conf_v0legacy'

class TestV0LegacyConf
  def initialize
    @logger = Logger.new(nil)
    @plugin = Fluent::Auditify::Plugin::V0LegacyConf.new
    @plugin.instance_variable_set(:@log, @logger)
  end

  def parse(conf)
    @plugin.parse(conf)
  end
end

class Fluent::AuditifyConfV0LegacyTest < Test::Unit::TestCase

  setup do
    @plugin = TestV0LegacyConf.new
  end

  teardown do
    discard
  end

end
