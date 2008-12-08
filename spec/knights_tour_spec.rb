$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

require 'knights_tour'

include KnightsTour

describe Application do
  it "should accept dimensions greater than zero" do
    lambda { Application.new(-1) }.should raise_error(ArgumentError)
    lambda { Application.new(0)  }.should raise_error(ArgumentError)
    lambda { Application.new(1)  }.should_not raise_error(ArgumentError)
    lambda { Application.new(8)  }.should_not raise_error(ArgumentError)
  end

  it "should accept non-default start positions" do
    lambda { Application.new(1, [-1,  0]) }.should raise_error(ArgumentError)
    lambda { Application.new(1, [ 0, -1]) }.should raise_error(ArgumentError)
    lambda { Application.new(1, [-1, -1]) }.should raise_error(ArgumentError)
    lambda { Application.new(1, [ 1,  1]) }.should raise_error(ArgumentError)
    lambda { Application.new(4, [ 3,  4]) }.should raise_error(ArgumentError)
    lambda { Application.new(1, [ 0,  0]) }.should_not raise_error(ArgumentError)
    lambda { Application.new(4, [ 0,  0]) }.should_not raise_error(ArgumentError)
    lambda { Application.new(4, [ 1,  0]) }.should_not raise_error(ArgumentError)
    lambda { Application.new(4, [ 3,  3]) }.should_not raise_error(ArgumentError)
    lambda { Application.new(8, [ 7,  6]) }.should_not raise_error(ArgumentError)
  end

  it "should solve dimension of 1" do
    result = Application.new(1).solve
    result.to_s.should == <<-END
+--+
| 1|
+--+
    END
  end

  it "should solve dimension of 5" do
    result = Application.new(5).solve
    result.to_s.should == <<-END
+---+---+---+---+---+
|  1| 20| 17| 12|  3|
+---+---+---+---+---+
| 16| 11|  2|  7| 18|
+---+---+---+---+---+
| 21| 24| 19|  4| 13|
+---+---+---+---+---+
| 10| 15|  6| 23|  8|
+---+---+---+---+---+
| 25| 22|  9| 14|  5|
+---+---+---+---+---+
    END
  end

  it "should solve dimension of 5, in start position 2,2" do
    result = Application.new(5, [2, 2]).solve
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

  it "should cache the result" do
    app = Application.new(1)
    result = []
    result << app.solve
    result << app.solve
    result[0].should == result[1]
  end
end

describe StringResult do
  it "should show the result correctly for a failed result" do
    StringResult.new(nil).to_s.should == "No solution found."
  end

  it "should show the result correctly for a trivial result" do
    field = Field.new(1, [0, 0])
    field.instance_variable_set(:@grid, [[1]])
    result = StringResult.new(field)
    result.to_s.should == <<-END
+--+
| 1|
+--+
    END
  end

  it "should show the result correctly for a non-trivial result" do
    # this is not a solvable dimension
    field = Field.new(3, [0, 0])
    field.instance_variable_set(:@grid, [[1, 2, 3], [42, 56, 69], [0, 0, 119]])
    StringResult.new(field).to_s.should == <<-END
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
