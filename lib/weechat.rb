if not defined? Weechat
  raise LoadError.new('The weechat gem can only be required from scripts ' +
  'that are run under the WeeChat IRC client using the Ruby plugin.')
end

require 'pp'

module Weechat
  VERSION = "0.0.1"
  module Helper
    def command_callback(id, buffer, args)
      # TODO this mimics weechat's current behaviour for the C API.
      # sophisticated argument parsing will come, some day.
      Weechat::Command.find_by_id(id).call(Weechat::Buffer.new(buffer), *args.split(" "))
    end

    def command_run_callback(id, buffer, command)
      Weechat::Hooks::CommandRunHook.find_by_id(id).call(Weechat::Buffer.new(buffer), command)
    end

    def timer_callback(id, remaining)
      Weechat::Timer.find_by_id(id).call(remaining.to_i)
    end

    def input_callback(method, buffer, input)
      Weechat::Buffer.call_input_callback(method, buffer, input)
    end

    def close_callback(method, buffer)
      Weechat::Buffer.call_close_callback(method, buffer)
    end
  end

  class << self
    def exec(command, buffer=nil)
      Weechat.command(buffer.to_s, command)
    end
    alias_method :send_command, :exec
    alias_method :execute, :exec

    def puts(text, buffer = nil)
      buffer = case buffer
               when nil
                 ""
               when :current
                 Weechat::Buffer.current
               else
                 buffer
               end
      Weechat.print(buffer.to_s, text.to_s)
      nil # to mimic Kernel::puts
    end

    def p(object, buffer = nil)
      self.puts(object.inspect, buffer)
    end

    def pp(object, buffer = nil)
      puts(object.pretty_inspect, buffer)
    end

    # Writes text to the WeeChat log +weechat.log+
    #
    # @return [void]
    def log(text)
      Weechat.log_print(text)
    end

    def integer_to_bool(int)
      int == 0 ? false : true
    end

    def bool_to_integer(bool)
      bool ? 1 : 0
    end

    alias_method :old_mkdir_home, :mkdir_home
    alias_method :old_mkdir, :mkdir
    alias_method :old_mkdir_parents, :mkdir_parents
    def mkdir_home(*args)
      integer_to_bool(old_mkdir_home(*args))
    end

    def mkdir(*args)
      integer_to_bool(old_mkdir(*args))
    end

    def mkdir_parents(*args)
      integer_to_bool(old_mkdir_parents(*args))
    end
  end
end

require 'weechat/terminal.rb'
require 'weechat/property.rb'
require 'weechat/properties.rb'
require 'weechat/exceptions.rb'
require 'weechat/utilities.rb'
require 'weechat/pointer.rb'
require 'weechat/hook.rb'
require 'weechat/timer.rb'
require 'weechat/command.rb'
require 'weechat/input.rb'
require 'weechat/buffer.rb'
require 'weechat/window.rb'
require 'weechat/server.rb'
require 'weechat/infolist.rb'
require 'weechat/prefix.rb'
require 'weechat/color.rb'
require 'weechat/plugin.rb'
require 'weechat/rubyext/string.rb'
require 'weechat/hooks.rb'
require 'weechat/script.rb'
