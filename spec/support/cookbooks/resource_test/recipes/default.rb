# encoding: utf-8
# frozen_string_literal: true

attrs = node['resource_test']

send(attrs['resource'], attrs['name']) do
  attrs['properties'].to_h.each { |k, v| send(k, v) unless v.nil? }
  # The plugin and push properties of the config resource are special properties
  # that can be called multiple times.
  attrs['multiproperties'].to_h.each do |k, v|
    v.to_h.each do |subk, subv|
      send(k, subk => subv)
    end
  end
  action attrs['action'] unless attrs['action'].nil?
end
