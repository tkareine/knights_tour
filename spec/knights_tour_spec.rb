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

  it "should solve dimension of 1" do
    result = Application.new(1).solve
    result.to_s.should == <<-END
+--+
| 1|
+--+
    END
  end

  it "should solve dimension of 4" do
    result = Application.new(4).solve
    result.to_s.should =~ /^(\+--\+--\+--\+--\+\n(\|\s*\d+){4}\|\n){4}\+--\+--\+--\+--\+\n$/
  end

  it "after solving, should cache the result" do
    app = Application.new(4)
    result = []
    result << app.solve
    result[0].to_s.should =~ /^(\+--\+--\+--\+--\+\n(\|\s*\d+){4}\|\n){4}\+--\+--\+--\+--\+\n$/
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
