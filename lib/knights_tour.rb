module KnightsTour
  module Meta #:nodoc:
    module VERSION #:nodoc:
      MAJOR = 0
      MINOR = 1
      TINY  = 0

      def self.to_s
        [ MAJOR, MINOR, TINY ].join('.')
      end
    end

    COPYRIGHT = 'Copyright (c) Tuomas Kareinen'

    LICENSE = 'Licensed under the terms of the "MIT license". See README.rdoc.'

    def self.version
      "#{File.basename($0)} #{Meta::VERSION}\n#{Meta::COPYRIGHT}\n#{Meta::LICENSE}"
    end
  end

  class Application
    def initialize(params = {})
      @size = parse_size(params[:size] || [8, 8])
      @start_at = parse_start_position(params[:start_at] || [0, 0])
      @solution = nil
    end

    def solve
      unless @solution
        board = Board.new(@size, @start_at)
        @solution = StringResult.new(traverse(board))
      end
      @solution
    end

    private

    def parse_pair(param)
      unless param.is_a?(Array)
        param = param.to_s.split(',')
      end
      [param[0].to_i, param[1].to_i]
    end

    def parse_size(size)
      size = parse_pair(size)
      unless size[0] > 0 && size[1] > 0
        raise ArgumentError,
              "Board size must be a pair of positive (non-zero) " \
              "integers, separated by a comma"
      end
      size
    end

    def parse_start_position(start_position)
      start_position = parse_pair(start_position)
      unless (0...@size[0]).include?(start_position[0]) &&
             (0...@size[1]).include?(start_position[1])
        raise ArgumentError,
              "Initial position must be a pair of positive integers " \
              "within the size limits of the board, separated by a comma " \
              "(for example, 0,5 is acceptable for board size 6,6)"
      end
      start_position
    end

    # Traverse the board.
    #
    # The algorithm is a recursive backtracking search for a first solution
    # to the problem. The board is copied and modified by moving the knight
    # to a new position in each recursive step of the algorithm, instead of
    # modifying a single shared board in place.
    def traverse(board)
      #puts StringResult.new(board)  # debug

      unless board.traversed?
        next_positions = board.find_next_positions_available
        # Optimization by trying next positions in a specific order.
        next_positions = order_by_warnsdorffs_rule(next_positions, board)
        next_positions.each do |next_position|
          new_board = traverse(board.dup.traverse_to(next_position))

          unless new_board.nil?
            return new_board  # return the first solution found
          end
        end

        nil   # no solutions found
      else
        board
      end
    end

    # Optimization by applying Warnsdorff's rule: attempt to avoid dead
    # ends by favoring positions with the lowest number of next available
    # positions (thus, isolated positions become visited first). The rule
    # is heuristic.
    #
    # References:
    #   <http://mathworld.wolfram.com/KnightsTour.html>
    #   <http://web.telia.com/~u85905224/knight/eWarnsd.htm>
    def order_by_warnsdorffs_rule(positions, board)
      positions.sort_by do |position|
        board.find_next_positions_available(position).size
      end
    end
  end

  class Board
    ## as [x, y] pairs
    LEGAL_STEPS = [ [-2,  1], [-1,  2], [ 1,  2], [ 2,  1],
                    [ 2, -1], [ 1, -2], [-1, -2], [-2, -1] ]

    attr_reader :grid, :num_steps

    def initialize(size, start_at)
      @grid = Array.new(size[0]) { Array.new(size[1], 0) }
      @num_steps = 0
      traverse_to(start_at)
    end

    def initialize_copy(other)
      @grid = Marshal.load(Marshal.dump(other.grid))
      @num_steps = other.num_steps
    end

    def traversed?
      last_step = grid.size * grid[0].size
      @num_steps == last_step
    end

    def traverse_to(new_position)
      @num_steps += 1
      @position = new_position
      @grid[@position[0]][@position[1]] = @num_steps
      self
    end

    def find_next_positions_available(after_position = @position)
      positions = LEGAL_STEPS.map { |step| position_after_step(after_position, step) }
      positions.reject { |pos| pos.nil? || (@grid[pos[0]][pos[1]] > 0) }
    end

    def position_after_step(from, step)
      x_pos = from[0] + step[0]
      y_pos = from[1] + step[1]

      if (0...@grid.size).include?(x_pos) && (0...@grid[0].size).include?(y_pos)
        [x_pos, y_pos]
      else
        nil
      end
    end
  end

  class StringResult
    def initialize(result)
      if result.is_a?(Board)
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
      board_width = find_last_step(grid).to_s.length + 1

      separator_str = separator(board_width, grid[0].size)

      output = ""

      grid.each do |row|
        output += separator_str
        row_output = row.map { |step| "%#{board_width}s" % step }.join("|")
        output += "|#{row_output}|\n"
      end

      output += separator_str
    end

    def separator(board_width, cols)
      ("+" + "-" * board_width) * cols + "+\n"
    end

    def find_last_step(grid)
      grid.map { |row| row.max }.max
    end
  end
end
