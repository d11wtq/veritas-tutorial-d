require "spec_helper"

describe "evaluating a relation literal" do
  let(:td)       { Veritas::TD::Interpreter.new }
  let(:relation) { td.eval expr }

  context "for an empty relation" do
    let(:expr) { "RELATION {}" }

    it "returns TABLE_DUM" do
      relation.should == Veritas::TABLE_DUM
    end
  end

  context "for an attributeless relation with one tuple" do
    let(:expr) { "RELATION { TUPLE {} }" }

    it "returns TABLE_DEE" do
      relation.should == Veritas::TABLE_DEE
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
