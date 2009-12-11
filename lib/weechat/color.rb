class Color
  def self.from_weechat_config(v)
    Weechat.color(v)
  end
end

module Weechat
  class << self
    alias_method :old_color, :color
    def color(name)
      color = Weechat.old_color(name)
      color.empty? ? nil : color
    end
    alias_method :get_color, :color
  end
end
