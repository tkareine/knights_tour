module KnightsTour
  module Meta #:nodoc:
    module VERSION #:nodoc:
      MAJOR = 0
      MINOR = 0
      TINY  = 2

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
    def initialize(dimension, start_position = [0, 0])
      dimension = dimension.to_i
      unless dimension > 0
        raise ArgumentError, "Dimension must be integer, greater than zero"
      end

      start_position = start_position.to_a
      if ((start_position.size != 2) or
          !(0...dimension).include?(start_position[0]) or
          !(0...dimension).include?(start_position[1]))
        raise ArgumentError, "Invalid start position value"
      end

      @dimension = dimension
      @start_position = start_position
      @solution = nil
    end

    def solve
      unless @solution
        field = Field.new(@dimension, @start_position)
        @solution = StringResult.new(traverse(field))
      end
      @solution
    end

    private

    def traverse(field)
      #puts StringResult.new(field)  # debug

      unless field.traversed?
        next_positions = field.find_next_positions_available

        next_positions.each do |next_position|
          new_field = traverse(field.dup.traverse_to(next_position))

          unless new_field.nil?
            return new_field  # return the first solution found
          end
        end

        nil   # no solutions found
      else
        field
      end
    end

    def choose_position(positions)
      positions[rand(positions.size)]
    end
  end

  class Field
    ## as [x, y] pairs
    LEGAL_STEPS = [ [-2,  1], [-1,  2], [ 1,  2], [ 2,  1],
                    [ 2, -1], [ 1, -2], [-1, -2], [-2, -1] ]

    attr_reader :grid, :num_steps

    def initialize(dimension, start_position)
      @grid = Array.new(dimension) { Array.new(dimension, 0) }
      @num_steps = 0
      traverse_to(start_position)
    end

    def initialize_copy(other)
      @grid = Marshal.load(Marshal.dump(other.grid))
      @num_steps = other.num_steps
    end

    def traversed?
      @grid.find { |row| row.include?(0) } == nil
    end

    def traverse_to(new_position)
      @num_steps += 1
      @position = new_position
      @grid[@position[0]][@position[1]] = @num_steps
      self
    end

    def find_next_positions_available
      positions = LEGAL_STEPS.map { |step| find_position(@position, step) }
      positions.reject { |pos| pos.nil? || (@grid[pos[0]][pos[1]] > 0) }
    end

    def find_position(from, step)
      x_pos = from[0] + step[0]
      y_pos = from[1] + step[1]

      if ((0...@grid.size).include?(x_pos) and
          (0...@grid.size).include?(y_pos))
        [x_pos, y_pos]
      else
        nil
      end
    end
  end

  class StringResult
    def initialize(result)
      if result.is_a?(Field)
        @result = grid_to_s(result.grid)
      else
        @result = "No solution found."
      end
    end

    def to_s
      @result
    end

    private

    def grid_to_s(grid)
      field_width = find_last_step(grid).to_s.length + 1

      separator_str = separator(field_width, grid[0].size)

      output = ""

      grid.each do |row|
        output += separator_str
        row_output = row.map { |step| "%#{field_width}s" % step }.join("|")
        output += "|#{row_output}|\n"
      end

      output += separator_str
    end

    private

    def separator(field_width, cols)
      ("+" + "-" * field_width) * cols + "+\n"
    end

    def find_last_step(grid)
      grid.map { |row| row.max }.max
    end
  end
end
