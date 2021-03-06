require "meerstats/engine"
require "meerstats/configuration"
require "meerstats/installer"
require "meerstats/lazy_metric"

module Meerstats
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.metrics
    @metrics ||= []
  end

  def self.add_daily(name, scope)
    add(name, scope: scope, type: 'daily')
  end

  def self.add_cumulative(name, scope)
    add(name, scope: scope, type: 'cumulative')
  end

  def self.add(name, scope:, type: 'daily')
    if metric = metrics.find { |m| m.name == name }
      metric.scope = scope
    else
      metrics << LazyMetric.new(name, scope: scope, type: type)
    end
  end

  def self.statistics_for(name, days_ago: 1)
    metric = metrics.find { |m| m.name == name.to_sym }
    metric.compute(days_ago: days_ago)
  end
end
