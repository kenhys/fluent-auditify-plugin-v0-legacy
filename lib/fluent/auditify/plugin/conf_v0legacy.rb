require 'fluent/config/error'
require 'fluent/auditify/plugin/conf'
require 'fluent/config/element'

module Fluent::Auditify::Plugin
  class V0LegacyConf < Conf
    Fluent::Auditify::Plugin.register_conf('yaml', self)

    def supported_platform?
      :any
    end

    def supported_file_extension?
      [:conf]
    end

    def parse(conf)
    end

    def correct(conf)
    end
  end
end
