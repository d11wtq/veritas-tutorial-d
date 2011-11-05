require "spec_helper"

describe "evaluating a relvar" do
  let(:relations)   { { :USERS => Veritas::Relation.new([ [:UNO, Integer] ], [ [1] ]) } }
  let(:interpreter) { Veritas::TD::Interpreter.new(relations) }
  let(:result)      { interpreter.eval(expr) }

  context "given the name of a base relvar" do
    let(:expr) { "USERS" }

    it "returns the relvar from the registry" do
      result.should == relations[:USERS]
    end
  end

  context "given the name of a base relvar with different casing" do
    let(:expr) { "users" }

    it "returns the relvar from the registry" do
      result.should == relations[:USERS]
    end
  end

  context "given the name of an undefined relvar" do
    let(:expr) { "dogs" }

    it "raises an exception" do
      expect { result }.to raise_error(RuntimeError)
    end
  end
end
