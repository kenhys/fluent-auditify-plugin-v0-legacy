# frozen_string_literal: true

require_relative '../test_helper'
require 'fluent/auditify/plugin/conf_v0legacy'
require 'fluent/auditify/parsletutil'
require 'tmpdir'

class TestV0LegacyConf
  def initialize
    @logger = Logger.new(nil)
    @plugin = Fluent::Auditify::Plugin::V0LegacyConf.new
    @plugin.instance_variable_set(:@log, @logger)
  end

  def parse(conf)
    @plugin.parse(conf)
  end

  def transform(conf)
    @plugin.transform(conf)
  end
end

class Fluent::AuditifyConfV0LegacyTest < Test::Unit::TestCase

  setup do
    @plugin = TestV0LegacyConf.new
    @util = Fluent::Auditify::ParsletUtil.new
  end

  teardown do
    discard
  end

  sub_test_case 'buffer' do

    test 'transform' do
      Dir.mktmpdir do |tmpdir|
        Dir.glob('test/fixtures/buffer/*.conf') do |conf|
          expected_path = File.join(File.dirname(conf), "#{File.basename(conf, '.conf')}.expected")

          unless File.exist?(expected_path)
            next
          end

          FileUtils.cp(conf, tmpdir)
          path = File.join(tmpdir, File.basename(conf))
          modified = @plugin.transform(path)
          @util.export(modified)
          assert_equal(File.read(expected_path), File.read(path))
        end
      end
    end
  end
end
