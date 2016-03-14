Refinery::Plugin.module_eval do

  def self.register(&_block)
    yield(plugin = new)

    raise ArgumentError, "A plugin MUST have a name!: #{plugin.inspect}" if plugin.name.blank?

    # Set defaults.
    plugin.menu_match ||= %r{refinery/#{plugin.name}(/.+?)?$}
    plugin.always_allow_access ||= false
    plugin.class_name ||= plugin.name.camelize

    # add the new plugin to the collection of registered plugins
    unless ::Refinery::Plugins.registered.find_by_name(plugin.name)
      ::Refinery::Plugins.registered.unshift plugin
    end
  end

end