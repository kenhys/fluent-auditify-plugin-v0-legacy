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

  sub_test_case 'transform buffer' do

    data(
      'buffer/buffer_chunk_limit.conf' => 'buffer/buffer_chunk_limit.conf',
      'buffer/buffer_queue_full_action.conf' => 'buffer/buffer_queue_full_action.conf',
      'buffer/disable_retry_limit.conf' => 'buffer/disable_retry_limit.conf',
      'buffer/timezone.conf' => 'buffer/timezone.conf',
      'buffer/utc.conf' => 'buffer/utc.conf',
      'buffer/buffer_path.conf' => 'buffer/buffer_path.conf',
      'buffer/buffer_type.conf' => 'buffer/buffer_type.conf',
      'buffer/flush_at_shutdown.conf' => 'buffer/flush_at_shutdown.conf',
      'buffer/flush_interval.conf' => 'buffer/flush_interval.conf',
      'buffer/localtime.conf' => 'buffer/localtime.conf',
      'buffer/max_retry_wait.conf' => 'buffer/max_retry_wait.conf',
      'buffer/num_threads.conf' => 'buffer/num_threads.conf',
      'buffer/queued_chunk_flush_interval.conf' => 'buffer/queued_chunk_flush_interval.conf',
      'buffer/retry_limit.conf' => 'buffer/retry_limit.conf',
      'buffer/time_slice_format.conf' => 'buffer/time_slice_format.conf',
      'buffer/time_slice_wait.conf' => 'buffer/time_slice_wait.conf',
      'buffer/try_flush_interval.conf' => 'buffer/try_flush_interval.conf'
    )
    test 'transform' do |data|
      conf = data
      Dir.mktmpdir do |tmpdir|
        buffer_dir = File.dirname(test_fixture_path(conf))
        expected_path = File.join(buffer_dir, "#{File.basename(conf, '.conf')}.expected")

        unless File.exist?(expected_path)
          next
        end

        FileUtils.cp(test_fixture_path(conf), tmpdir)
        path = File.join(tmpdir, File.basename(conf))
        modified = @plugin.transform(path)
        @util.export(modified)
        assert_equal(File.read(expected_path), File.read(path))
      end
    end
  end
end
