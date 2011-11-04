require "spec_helper"

describe "evaluating an arithmetic expression" do
  let(:result) { Veritas::TD::Interpreter.new.eval(expr) }

  context "for simple addition" do
    let(:expr) { "12 + 2" }

    it "returns the sum of the operands" do
      result.should == 14
    end
  end

  context "for simple subtraction" do
    let(:expr) { "12 - 2" }

    it "returns the difference of the operands" do
      result.should == 10
    end
  end

  context "for simple multiplication" do
    let(:expr) { "12 * 2" }

    it "returns the product of the operands" do
      result.should == 24
    end
  end

  context "for simple division" do
    let(:expr) { "12 / 2" }

    it "returns the quotient of the operands" do
      result.should == 6
    end
  end

  context "for division to a floating point" do
    let(:expr) { "5 / 2" }

    it "returns a float" do
      result.should == 2.5
    end
  end

  describe "operator precedence" do
    context "of '*' ... '+'" do
      let(:expr) { "2 * 2 + 1" }

      it "gives '*' higher precedence" do
        result.should == 5
      end
    end

    context "of '+' ... '*'" do
      let(:expr) { "2 + 2 * 1" }

      it "gives '*' higher precedence" do
        result.should == 4
      end
    end

    context "of '*' ... '-'" do
      let(:expr) { "2 * 2 - 1" }

      it "gives '*' higher precedence" do
        result.should == 3
      end
    end

    context "of '-' ... '*'" do
      let(:expr) { "4 - 2 * 2" }

      it "gives '*' higher precedence" do
        result.should == 0
      end
    end

    context "of '/' ... '+'" do
      let(:expr) { "2 / 2 + 1" }

      it "gives '/' higher precedence" do
        result.should == 2
      end
    end

    context "of '+' ... '/'" do
      let(:expr) { "2 + 4 / 2" }

      it "gives '/' higher precedence" do
        result.should == 4
      end
    end

    context "of '/' ... '-'" do
      let(:expr) { "2 / 2 - 1" }

      it "gives '/' higher precedence" do
        result.should == 0
      end
    end

    context "of '-' ... '/'" do
      let(:expr) { "2 - 4 / 2" }

      it "gives '/' higher precedence" do
        result.should == 0
      end
    end
  end
end
