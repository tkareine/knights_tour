$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')

require 'knights-tour'

include KnightsTour

describe Application do
  it "should accept dimensions greater than zero" do
    lambda { Application.new(-1) }.should raise_error(ArgumentError)
    lambda { Application.new(0)  }.should raise_error(ArgumentError)
    lambda { Application.new(1)  }.should_not raise_error(ArgumentError)
    lambda { Application.new(8)  }.should_not raise_error(ArgumentError)
  end

  it "should accept dimension of one" do
    result = Application.new(1).solve

    result.to_s.should == <<-END
+--+
| 1|
+--+
    END
  end

  it "should accept dimension of n" do
    result = Application.new(1).solve

    result.to_s.should == <<-END
+--+--+--+--+
| 1| 4|16| 9|
+--+--+--+--+
| 8|12| 6| 3|
+--+--+--+--+
| 5| 2|10|17|
+--+--+--+--+
|11| 7|13|20|
+--+--+--+--+
    END
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
+--+--+--+
| 1| 2| 3|
+--+--+--+
|42|56|69|
+--+--+--+
| 7| 8| 9|
+--+--+--+
    END
  end
end
