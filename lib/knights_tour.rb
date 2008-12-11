module KnightsTour
  module Meta #:nodoc:
    module VERSION #:nodoc:
      MAJOR = 0
      MINOR = 2
      TINY  = 2

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
      @board_size = parse_board_size(params[:size] || [8, 8])
      @knight_starts_at = parse_position_on_board(
          params[:start_at] || [0, 0],
          @board_size)
      @solution = nil
    end

    def solve
      unless @solution
        knight = Knight.new(@board_size, @knight_starts_at)
        @solution = StringResult.new(traverse(knight))
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

    def parse_board_size(size)
      size = parse_pair(size)
      unless size[0] > 0 && size[1] > 0
        raise ArgumentError,
              "Board size must be a pair of positive (non-zero) " \
              "integers, separated by a comma"
      end
      size
    end

    def parse_position_on_board(position, board_size)
      position = parse_pair(position)
      unless (0...board_size[0]).include?(position[0]) &&
             (0...board_size[1]).include?(position[1])
        raise ArgumentError,
              "Position must be a pair of positive integers within the " \
              "size limits of the board, separated by a comma " \
              "(for example, 0,5 is acceptable for board size 6,6)"
      end
      position
    end

    # Traverse the knight on the board.
    #
    # The algorithm is a recursive backtracking search for a first solution
    # to the problem. The board is copied and modified by moving the knight
    # to a new position in each recursive step of the algorithm, instead of
    # modifying a single shared board in place.
    def traverse(knight)
      #$stdout.puts StringResult.new(board)  # debug

      unless knight.traversed?
        next_positions = knight.find_next_positions
        next_positions.each do |next_position|
          knight = traverse(knight.dup.traverse_to(next_position))
          unless knight.nil?
            return knight   # return the first solution found
          end
        end
      end

      knight  # no solutions found, or already found
    end
  end

  class Knight
    ## as [x, y] pairs
    LEGAL_STEPS = [ [-2,  1], [-1,  2], [ 1,  2], [ 2,  1],
                    [ 2, -1], [ 1, -2], [-1, -2], [-2, -1] ]

    attr_reader :board, :steps_taken, :current_position

    def initialize(board_size, start_at)
      @board = Array.new(board_size[0]) { Array.new(board_size[1], 0) }
      @steps_taken = 0
      traverse_to(start_at)
    end

    def initialize_copy(other)
      @board = Marshal.load(Marshal.dump(other.board))
      @steps_taken = other.steps_taken
    end

    def traversed?
      last_step = @board.size * @board[0].size
      @steps_taken == last_step
    end

    def traverse_to(new_position)
      @steps_taken += 1
      @current_position = new_position
      @board[@current_position[0]][@current_position[1]] = @steps_taken
      self
    end

    def find_next_positions
      sort_by_warnsdorffs_heuristics(find_next_positions_at(@current_position))
    end

    private

    # Optimization by applying Warnsdorff's heuristics: attempt to avoid
    # dead ends by favoring positions with the lowest number of next
    # available positions (thus, isolated positions become visited first).
    #
    # References:
    #   <http://mathworld.wolfram.com/KnightsTour.html>
    #   <http://web.telia.com/~u85905224/knight/eWarnsd.htm>
    def sort_by_warnsdorffs_heuristics(positions)
      positions.sort_by do |position|
        find_next_positions_at(position).size
      end
    end

    def find_next_positions_at(position)
      positions = LEGAL_STEPS.map do |step|
        position_after_step(position, step)
      end
      positions.reject { |pos| pos.nil? || (@board[pos[0]][pos[1]] > 0) }
    end

    def position_after_step(from, step)
      x_pos = from[0] + step[0]
      y_pos = from[1] + step[1]

      if (0...@board.size).include?(x_pos) &&
         (0...@board[0].size).include?(y_pos)
        [x_pos, y_pos]
      else
        nil
      end
    end
  end

  class StringResult
    def initialize(result)
      if result.is_a?(Knight)
        @result = board_to_s(result.board, result.steps_taken)
      else
        @result = "No solution found."
      end
    end

    def to_s
      @result
    end

    private

    def board_to_s(board, steps_taken)
      square_width = steps_taken.to_s.length + 1
      separator_str = separator(square_width, board[0].size)

      output = ""

      board.each do |row|
        output << separator_str
        row_output = row.map { |step| "%#{square_width}s" % step }.join("|")
        output << "|#{row_output}|\n"
      end

      output << separator_str
    end

    def separator(board_width, cols)
      ("+" << "-" * board_width) * cols << "+\n"
    end
  end
end
