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

  it "should solve dimension of 4, in start position 0,0" do
    srand 42
    result = Application.new(4).solve
    result.to_s.should == <<-END
+---+---+---+---+
|  1| 14|  5| 10|
+---+---+---+---+
|  6| 17|  2| 19|
+---+---+---+---+
| 13|  4| 15|  8|
+---+---+---+---+
| 16|  7| 18|  3|
+---+---+---+---+
    END
  end

  it "should solve dimension of 8, in start position 6,7" do
    srand 42
    result = Application.new(8, [6, 7]).solve
    result.to_s.should == <<-END
+---+---+---+---+---+---+---+---+
| 46| 61| 28| 31| 88| 63| 58| 33|
+---+---+---+---+---+---+---+---+
| 29|  8| 89| 62| 59| 34| 87| 64|
+---+---+---+---+---+---+---+---+
| 42| 47| 60| 55| 90| 65| 70| 57|
+---+---+---+---+---+---+---+---+
|  7| 54| 81| 12| 67| 72| 19| 22|
+---+---+---+---+---+---+---+---+
| 78| 41| 48|  5| 80| 91| 66| 71|
+---+---+---+---+---+---+---+---+
| 53|  6| 37| 24| 95| 16| 73| 18|
+---+---+---+---+---+---+---+---+
| 40| 77| 96| 51| 38| 75| 94|  1|
+---+---+---+---+---+---+---+---+
| 97| 52| 39| 76| 93|  2| 17| 74|
+---+---+---+---+---+---+---+---+
    END
  end

  it "should cache the result" do
    app = Application.new(4, [0, 0])
    result = []
    result << app.solve
    result << app.solve
    result[0].should == result[1]
  end
end

describe StringResult, "with trivial length" do
  before(:each) do
    @result = StringResult.new([[1]])
  end

  it "should show the result correctly" do
    @result.to_s.should == <<-END
+--+
| 1|
+--+
    END
  end
end

describe StringResult, "with non-trivial length" do
  before(:each) do
    @result = StringResult.new([[1, 2, 3], [42, 56, 69], [7, 8, 9]])
  end

  it "should show the result correctly" do
    @result.to_s.should == <<-END
+---+---+---+
|  1|  2|  3|
+---+---+---+
| 42| 56| 69|
+---+---+---+
|  7|  8|  9|
+---+---+---+
    END
  end
end
