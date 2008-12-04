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

    def initialize(dimension)
      dimension = dimension.to_i
      raise ArgumentError unless dimension > 0

      @dimension = dimension
      @position = [1, 1]

      @logger = Logger.new($stdout)
    end

    def log_level
      @logger.level
    end

    def log_level=(level)
      @logger.level = level
    end

    def solve
      StringResult.new(solve_tour)
    end

    private

    def solve_tour
      [[1]]   # TODO: do the implementation
    end
  end

  class StringResult
    def initialize(result)
      @result = result.to_a
    end

    def to_s
      output = ""

      @result.each do |row|
        output += separator(row.size)
        row_output = row.map { |step| "%2s" % step }.join("|")
        output += "|#{row_output}|\n"
      end

      output += separator(@result[0].size)
    end

    private

    def separator(length)
      "+--" * length + "+\n"
    end
  end
end
