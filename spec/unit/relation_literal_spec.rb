require "spec_helper"

describe "evaluating a relation literal" do
  let(:td)       { Veritas::TD::Interpreter.new }
  let(:relation) do
    td.eval <<-EXPR
    RELATION { TUPLE { ID 20, NAME 'One' },
               TUPLE { ID 30, NAME 'Two' } }
		EXPR
  end

  it "returns a relation" do
    relation.should be_a_kind_of(Veritas::Relation)
  end
end
