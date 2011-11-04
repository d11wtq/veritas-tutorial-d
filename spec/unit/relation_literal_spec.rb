require "spec_helper"

describe "parsing a relation literal" do
  let(:result) { Veritas::TD::Interpreter.new.eval(expr) }

  context "for an empty zero-attribute relation" do
    let(:expr) { "RELATION {}" }

    it "returns TABLE_DUM" do
      result.should == Veritas::TABLE_DUM
    end
  end
end
