require "spec_helper"

describe "evaluating a scalar expression" do
  let(:result) { Veritas::TD::Interpreter.new.eval(expr) }

  context "with a single-quoted string" do
    let(:expr) { "'foo \\' bar'" }

    it "returns a string" do
      result.should == "foo ' bar"
    end
  end

  context "with a double-quoted string" do
    let(:expr) { '"foo \\" bar"' }

    it "returns a string" do
      result.should == 'foo " bar'
    end
  end

  context "with an integer" do
    let(:expr) { "42" }

    it "returns the integer" do
      result.should == 42
    end
  end
end
