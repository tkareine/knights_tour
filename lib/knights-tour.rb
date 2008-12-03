require 'logger'

module KnightsTour
  module Meta #:nodoc:
    module VERSION #:nodoc:
      MAJOR = 0
      MINOR = 0
      TINY  = 1

      def self.to_s
        [ MAJOR, MINOR, TINY ].join('.')
      end
    end

    COPYRIGHT = 'Copyright (c) Tuomas Kareinen'

    LICENSE = 'Licensed under the terms of MIT license.'

    def self.version
      "#{File.basename($0)} #{Meta::VERSION}\n#{Meta::COPYRIGHT}\n#{Meta::LICENSE}"
    end
  end

  class Application
    attr_reader :dimension

    def initialize(dimension, log_output = $stdout)
      dimension = dimension.to_i
      raise ArgumentError unless dimension > 0

      @dimension = dimension
      @position = [1, 1]

      @logger = Logger.new(log_output)
    end

    def log_level
      @logger.level
    end

    def log_level=(level)
      @logger.level = level
    end

    def solve
      raise StandardError, "Implement me!"
    end
  end
end
