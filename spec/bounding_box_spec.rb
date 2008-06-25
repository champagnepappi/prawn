require File.join(File.expand_path(File.dirname(__FILE__)), "spec_helper")

describe "A bounding box" do

  before(:each) do
    @x      = 100
    @y      = 125
    @width  = 50
    @height = 75
    @box = Prawn::Document::BoundingBox.new(nil, [@x,@y], :width  => @width,
                                                          :height => @height )
  end

  it "should have an anchor at (x, y - height)" do
    @box.anchor.should == [@x,@y-@height]           
  end

  it "should have a left boundary of 0" do
    @box.left.should == 0
  end
  
  it "should have a right boundary equal to the width" do
    @box.right.should == @width
  end

  it "should have a top boundary of height" do
    @box.top.should == @height
  end

  it "should have a bottom boundary of 0" do
    @box.bottom.should == 0
  end

  it "should have a top-left of [0,height]" do
    @box.top_left.should == [0,@height]
  end

  it "should have a top-right of [width,height]" do
    @box.top_right.should == [@width,@height]
  end

  it "should have a bottom-left of [0,0]" do
    @box.bottom_left.should == [0,0]
  end

  it "should have a bottom-right of [width,0]" do
    @box.bottom_right.should == [@width,0]
  end

  it "should have an absolute left boundary of x" do
    @box.absolute_left.should == @x
  end

  it "should have an absolute right boundary of x + width" do
    @box.absolute_right.should == @x + @width
  end

  it "should have an absolute top boundary of y" do
    @box.absolute_top.should == @y
  end

  it "should have an absolute bottom boundary of y - height" do
    @box.absolute_bottom.should == @y - @height
  end

  it "should have an absolute bottom-left of [x,y-height]" do
    @box.absolute_bottom_left.should == [@x, @y - @height]
  end

  it "should have an absolute bottom-right of [x+width,y-height]" do
    @box.absolute_bottom_right.should == [@x + @width , @y - @height]
  end

  it "should have an absolute top-left of [x,y]" do
    @box.absolute_top_left.should == [@x, @y]
  end

  it "should have an absolute top-right of [x+width,y]" do
    @box.absolute_top_right.should == [@x + @width, @y]
  end
  

end

describe "drawing bounding boxes" do

  it "should restore the margin box when bounding box exits" do
    @pdf = Prawn::Document.new
    margin_box = @pdf.bounds

    @pdf.bounding_box [100,500] do
      #nothing
    end

    @pdf.bounds.should == margin_box

  end

  it "should restore the parent bounding box when calls are nested" do
    @pdf = Prawn::Document.new
    @pdf.bounding_box [100,500], :width => 300, :height => 300 do 

      @pdf.bounds.absolute_top.should  == 500
      @pdf.bounds.absolute_left.should == 100 

      @pdf.bounding_box [50,200], :width => 100, :height => 100 do
        @pdf.bounds.absolute_top.should == 200 
        @pdf.bounds.absolute_left.should == 50
      end

      @pdf.bounds.absolute_top.should  == 500
      @pdf.bounds.absolute_left.should == 100 

    end
  end
end
