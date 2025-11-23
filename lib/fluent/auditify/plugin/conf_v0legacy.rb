require 'fluent/config/error'
require 'fluent/auditify/plugin/conf'
require 'fluent/auditify/parser/v1config'
require 'fluent/auditify/helper/test'
require 'fluent/config/element'
require 'pastel'
require_relative 'v0legacy_buffer'

module Fluent::Auditify::Plugin
  class V0LegacyConf < Conf
    Fluent::Auditify::Plugin.register_conf('yaml', self)

    include Fluent::Auditify::Plugin::V0LegacyConfBuffer

    def supported_platform?
      :any
    end

    def supported_file_extension?
      [:conf]
    end

    def transform(conf, options={})
      parser = Fluent::Auditify::Parser::V1ConfigParser.new
      modified = nil
      begin
        object = parser.parse(File.read(conf))
        object = parser.eval(object, { base_dir: File.dirname(conf),
                                       path: File.basename(conf) })
        modified = transform_buffer(object)
      rescue => e
        #puts e.parse_failure_cause.ascii_tree
        log.error { "Failed to transform <#{conf}>" }
      end
      modified
    end
  end
end
