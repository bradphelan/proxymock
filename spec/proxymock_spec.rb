require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'proxymock'

class Fing
	attr_accessor :x
	attr_accessor :y
	def bar
		@x = 10
	end
	def bing
		@y = 20
	end
end

describe "proxy mock" do
	it "should work" do
		b = Fing.new
		b.should_receive!(:bar).once.ordered
		b.should_receive!(:bing).once.ordered
		b.should_receive!(:bar).once.ordered
		b.bar
		b.bing
		b.bar
		b.x.should == 10
		b.y.should == 20
	end
end
