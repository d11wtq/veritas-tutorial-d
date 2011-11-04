require "spec_helper"

describe "evaluating whitespace" do
  let(:result) { Veritas::TD::Interpreter.new.eval(expr) }

  context "with a space" do
    let(:expr) { " " }

    it "does nothing" do
      result.should be_nil
    end
  end
end
