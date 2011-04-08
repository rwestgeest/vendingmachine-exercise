require 'adapter/sensor_collection'
require 'adapter/actuator_collection'

module Adapter
  def self.actuators
    @@actuators ||= ActuatorCollection.new
  end
  def self.sensors
    @@sensors ||= SensorCollection.new
  end
end
