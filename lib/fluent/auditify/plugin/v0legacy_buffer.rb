module Fluent
  module Auditify
    module Plugin
      module V0LegacyConfBuffer

        BUFFER_CONVERT_TABLE = {
          'buffer_type' => '@type',
          'buffer_path' => 'path',
          'num_threads' => 'flush_thread_count',
          'flush_interval' => 'flush_interval',
          'try_flush_interval' => 'flush_thread_interval',
          'queued_chunk_flush_interval' => 'flush_thread_burst_interval',
          'disable_retry_limit' => 'retry_forever',
          'retry_limit' => 'retry_max_times',
          'max_retry_wait' => 'retry_max_interval',
          'buffer_chunk_limit' => 'chunk_limit_size',
          'buffer_queue_limit' => 'queue_limit_length',
          'buffer_queue_full_action' => 'overflow_action',
          'flush_at_shutdown' => 'flush_at_shutdown',
          'time_slice_format' => 'timekey',
          'time_slice_wait' => 'timekey_wait',
          'timezone' => 'timekey_zone',
          'localtime' => 'timekey_use_utc',
          'utc' => 'timekey_use_utc'
        }

        def transform_buffer(object)
          modified = []
          object.each do |directive|
            if directive[:match]
              buffer_section_exist = directive[:body].any? { |kv| kv[:section] }
              body = []
              buffer_body = []
              directive[:body].each do |key_value|
                if buffer_section_exist
                  body << key_value
                else
                  if BUFFER_CONVERT_TABLE.key?(key_value[:name].to_s)
                    new_key = BUFFER_CONVERT_TABLE[key_value[:name].to_s]
                    if key_value[:name].to_s == 'localtime'
                      if key_value[:value] != nil
                        key_value[:value] = !key_value[:value]
                      else
                        key_value[:value] = 'false'
                      end
                    end
                    if key_value[:value]
                      buffer_body << {name: new_key, value: key_value[:value],
                                      __PATH__: directive[:__PATH__],__BASE__: directive[:__BASE__]}
                    else
                      buffer_body << {name: new_key,
                                      __PATH__: directive[:__PATH__],__BASE__: directive[:__BASE__]}
                    end
                  else
                    body << key_value
                  end                               
                end
              end
              unless buffer_body.empty?
                body << {section: {name: 'buffer'}, body: buffer_body, name: 'buffer',
                         __PATH__: directive[:__PATH__],__BASE__: directive[:__BASE__]}
              end
              modified_directive = {match: directive[:match], pattern: directive[:pattern],
                                    body: body, __BASE__: directive[:__BASE__], __PATH__: directive[:__PATH__]}
              modified << modified_directive
            else
              modified << directive
            end
          end
          modified
        end
      end
    end
  end
end

