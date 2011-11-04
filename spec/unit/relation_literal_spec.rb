require "spec_helper"

describe "evaluating a relation literal" do
  let(:td)       { Veritas::TD::Interpreter.new }
  let(:relation) { td.eval expr }

  context "with no attributes or tuples" do
    let(:expr) { "RELATION {}" }

    it "returns TABLE_DUM" do
      relation.should == Veritas::TABLE_DUM
    end
  end

  context "with no attribites and one tuple" do
    let(:expr) { "RELATION { TUPLE {} }" }

    it "returns TABLE_DEE" do
      relation.should == Veritas::TABLE_DEE
    end
  end

  context "with one attribute and one tuple" do
    let(:expr) { "RELATION { TUPLE { ID 20 } }" }

    it "returns a relation with the same tuple" do
      relation.header.should == [ [:ID, Integer] ]
      relation.should == Veritas::Relation.new([ [:ID, Integer] ], [ [20] ])
    end
  end

#  let(:relation) do
#    td.eval <<-EXPR
#    RELATION { TUPLE { ID 20, NAME 'One' },
#               TUPLE { ID 30, NAME 'Two' } }
#		EXPR
#  end
#  let(:relation) do
#    td.eval "RELATION { TUPLE { } }"
#  end

#  it "returns a relation" do
#    relation.should be_a_kind_of(Veritas::Relation)
#  end
end
