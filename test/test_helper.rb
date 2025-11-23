# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require 'fluent/auditify'
require 'fluent/auditify/plugin'
require 'fluent/auditify/helper/test'

require 'tmpdir'
require 'test-unit'

include Fluent::Auditify::Helper::Test

def test_fixture_path(path)
  File.join(File.expand_path('../fixtures', __FILE__), path)
end

def test_fixture_expected_path(path)
  dir = File.dirname(path)
  expected = "#{File.basename(path, '.conf')}.expected"
  File.join(File.expand_path('../fixtures', __FILE__), dir, expected)
end
