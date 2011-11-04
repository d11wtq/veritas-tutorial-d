require "spec_helper"

describe "parsing a unary expression" do
  let(:result) { Veritas::TD::Interpreter.new.eval(expr) }

  context "for a negative integer" do
    let(:expr) { "- 42" }

    it "returns the integer" do
      result.should == -42
    end
  end

  context "for a positive integer" do
    let(:expr) { "+ 42" }

    it "returns the integer" do
      result.should == 42
    end
  end
end
