require "knights_tour"

include KnightsTour

describe Application do
  it "should accept valid non-default board size" do
    lambda { Application.new(:size => -1)  }.should raise_error(ArgumentError)
    lambda { Application.new(:size => 0)   }.should raise_error(ArgumentError)
    lambda { Application.new(:size => 1)   }.should raise_error(ArgumentError)
    lambda { Application.new(:size => "1") }.should raise_error(ArgumentError)
    lambda { Application.new(:size => [-1, -1]) }.should raise_error(ArgumentError)
    lambda { Application.new(:size => [-1, 0])  }.should raise_error(ArgumentError)
    lambda { Application.new(:size => [0, -1])  }.should raise_error(ArgumentError)
    lambda { Application.new(:size => [0, 0])   }.should raise_error(ArgumentError)
    lambda { Application.new(:size => [0, 1])   }.should raise_error(ArgumentError)
    lambda { Application.new(:size => [1, 0])   }.should raise_error(ArgumentError)
    lambda { Application.new(:size => [1, 1]) }.should_not raise_error(ArgumentError)
    lambda { Application.new(:size => [3, 4]) }.should_not raise_error(ArgumentError)
    lambda { Application.new(:size => [5, 5]) }.should_not raise_error(ArgumentError)
  end

  it "should accept valid non-default start positions" do
    lambda { Application.new(:size => [1, 1], :start_at => -1) }.should raise_error(ArgumentError)
    lambda { Application.new(:size => [1, 1], :start_at => [ 0,  1]) }.should raise_error(ArgumentError)
    lambda { Application.new(:size => [1, 1], :start_at => [ 1,  0]) }.should raise_error(ArgumentError)
    lambda { Application.new(:size => [1, 1], :start_at => [ 1,  1]) }.should raise_error(ArgumentError)
    lambda { Application.new(:size => [1, 1], :start_at => [ 3,  4]) }.should raise_error(ArgumentError)
    lambda { Application.new(:size => [3, 7], :start_at => [ 4,  2]) }.should raise_error(ArgumentError)
    lambda { Application.new(:size => [3, 7], :start_at => [ 2,  7]) }.should raise_error(ArgumentError)
    lambda { Application.new(:size => [3, 7], :start_at => [ 3,  7]) }.should raise_error(ArgumentError)
    lambda { Application.new(:size => [1, 1], :start_at => [ 0,  0]) }.should_not raise_error(ArgumentError)
    lambda { Application.new(:size => [1, 2], :start_at => [ 0,  1]) }.should_not raise_error(ArgumentError)
    lambda { Application.new(:size => [2, 1], :start_at => [ 1,  0]) }.should_not raise_error(ArgumentError)
    lambda { Application.new(:size => [2, 2], :start_at => [ 0,  0]) }.should_not raise_error(ArgumentError)
    lambda { Application.new(:size => [2, 2], :start_at => [ 1,  1]) }.should_not raise_error(ArgumentError)
    lambda { Application.new(:size => [3, 7], :start_at => [ 2,  4]) }.should_not raise_error(ArgumentError)
    lambda { Application.new(:size => [5, 5], :start_at => [ 4,  4]) }.should_not raise_error(ArgumentError)
    lambda { Application.new(:size => [8, 8], :start_at => [ 7,  6]) }.should_not raise_error(ArgumentError)
  end

  it "should solve a board with size 1,1" do
    result = Application.new(:size => [1, 1]).solve
    result.to_s.should == <<-END
+--+
| 1|
+--+
    END
  end

  it "should solve a board with size 5,5" do
    result = Application.new(:size => [5, 5]).solve
    result.to_s.should == <<-END
+---+---+---+---+---+
|  1| 14|  9| 20|  3|
+---+---+---+---+---+
| 24| 19|  2| 15| 10|
+---+---+---+---+---+
| 13|  8| 25|  4| 21|
+---+---+---+---+---+
| 18| 23|  6| 11| 16|
+---+---+---+---+---+
|  7| 12| 17| 22|  5|
+---+---+---+---+---+
    END
  end

  it "should solve a board with size of 5,5, in start position 2,2" do
    result = Application.new(:size => [5, 5], :start_at => [2, 2]).solve
    result.to_s.should == <<-END
+---+---+---+---+---+
| 21| 12|  7|  2| 19|
+---+---+---+---+---+
|  6| 17| 20| 13|  8|
+---+---+---+---+---+
| 11| 22|  1| 18|  3|
+---+---+---+---+---+
| 16|  5| 24|  9| 14|
+---+---+---+---+---+
| 23| 10| 15|  4| 25|
+---+---+---+---+---+
    END
  end

  it "should solve a board with size of 3,7, in start position 2,4" do
    result = Application.new(:size => [3, 7], :start_at => [2, 4]).solve
    result.to_s.should == <<-END
+---+---+---+---+---+---+---+
| 11| 14| 17| 20|  3|  8|  5|
+---+---+---+---+---+---+---+
| 16| 21| 12|  9|  6| 19|  2|
+---+---+---+---+---+---+---+
| 13| 10| 15| 18|  1|  4|  7|
+---+---+---+---+---+---+---+
    END
  end

  it "should cache the result" do
    app = Application.new(:size => [1, 1])
    result = []
    result << app.solve
    result << app.solve
    result[0].should == result[1]
  end
end

describe Knight do
  before(:each) do
    @knight = Knight.new([5, 5], [0, 0])
    # broken board state, but it does not matter for testing
    @knight.instance_variable_set(
      :@board,
      [ [  1,  0,  0, 12,  3 ],
        [  0, 11,  2,  7, 18 ],
        [  0,  0,  0,  0, 13 ],
        [ 10, 15,  6,  0,  8 ],
        [  0, 19,  9, 14,  5 ] ])
    @knight.instance_variable_set(:@current_position, [1, 4])
    @knight.instance_variable_set(:@steps_taken, 18)
  end

  it "should find next positions available" do
    next_positions = @knight.send(:find_next_positions_at, @knight.current_position)
    next_positions.sort!  # ensure the order is not correct already
    next_positions.should == [ [0, 2], [2, 2], [3, 3] ]
  end

  it "should sort next positions by Warnsdorff's heuristics" do
    next_positions = @knight.send(:find_next_positions_at, @knight.current_position)
    next_positions.sort!  # ensure the order is not correct already
    next_positions.should == [ [0, 2], [2, 2], [3, 3] ]
    next_positions = @knight.send(:sort_by_warnsdorffs_heuristics, next_positions)
    next_positions.should == [ [3, 3], [2, 2], [0, 2] ]
  end

  it "should find next positions, sorted" do
    next_positions = @knight.find_next_positions
    next_positions.should == [ [3, 3], [2, 2], [0, 2] ]
  end
end

describe StringResult do
  it "should show the result correctly for a failed result" do
    StringResult.new(nil).to_s.should == "No solution found."
  end

  it "should show the result correctly for a trivial result" do
    knight = Knight.new([1, 1], [0, 0])
    knight.instance_variable_set(:@board, [[1]])
    result = StringResult.new(knight)
    result.to_s.should == <<-END
+--+
| 1|
+--+
    END
  end

  it "should show the result correctly for a non-trivial result" do
    # in reality, this is not a solvable board size
    knight = Knight.new([3, 3], [0, 0])
    knight.instance_variable_set(:@board, [[1, 2, 3], [42, 56, 69], [0, 0, 119]])
    knight.instance_variable_set(:@steps_taken, 119)
    StringResult.new(knight).to_s.should == <<-END
+----+----+----+
|   1|   2|   3|
+----+----+----+
|  42|  56|  69|
+----+----+----+
|   0|   0| 119|
+----+----+----+
    END
  end
end
