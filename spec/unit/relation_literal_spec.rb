require "spec_helper"

describe "parsing a relation literal" do
  let(:result) { Veritas::TD::Interpreter.new.eval(expr) }

  context "for the TABLE_DEE constant" do
    let(:expr) { "TABLE_DEE" }

    it "returns TABLE_DEE" do
      result.should == Veritas::TABLE_DEE
    end
  end

  context "for the TABLE_DUM constant" do
    let(:expr) { "TABLE_DUM" }

    it "returns TABLE_DUM" do
      result.should == Veritas::TABLE_DUM
    end
  end

  context "for an empty zero-attribute relation" do
    let(:expr) { "RELATION {}" }

    it "returns TABLE_DUM" do
      result.should == Veritas::TABLE_DUM
    end
  end

  context "for a single-tuple zero-attribute relation" do
    let(:expr) { "RELATION { TUPLE {} }" }

    it "returns TABLE_DEE" do
      result.should == Veritas::TABLE_DEE
    end
  end

  context "for a single-tuple single-attribute relation" do
    let(:expr) { "RELATION { TUPLE { ID 20 } }" }

    it "returns a relation with the same tuple" do
      result.should == Veritas::Relation.new(
        [ [:ID, Integer] ],
        [ [20] ]
      )
    end
  end

  context "for a single-tuple multiple-attribute relation" do
    let(:expr) { "RELATION { TUPLE { ID 20, NAME 'Bob', ADMIN TRUE } }" }

    it "returns a relation with the same tuple" do
      result.should == Veritas::Relation.new(
        [ [:ID, Integer], [:NAME, String], Veritas::Attribute::Boolean.new(:ADMIN) ],
        [ [20,            'Bob',           true                                  ] ]
      )
    end
  end
end
