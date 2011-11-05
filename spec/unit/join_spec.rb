require "spec_helper"

describe "evaluating a join" do
  let(:result) { Veritas::TD::Interpreter.new.eval(expr) }

  context "between two relation literals" do
    let(:expr) do
      <<-TDQL
      RELATION { TUPLE { UNO 20, UNAME 'Bob'  },
                 TUPLE { UNO 21, UNAME 'Pete' },
                 TUPLE { UNO 22, UNAME 'Jen'  } }
      JOIN
      RELATION { TUPLE { UNO 20, ROLE 'Manager'   },
                 TUPLE { UNO 22, ROLE 'Recruiter' } }
      TDQL
    end

    it "returns the relation representing the join" do
      result.should == Veritas::Relation.new(
        [ [:UNO, Integer], [:UNAME, String], [:ROLE, String] ],
        [
          [20,              "Bob",            "Manager"   ],
          [22,              "Jen",            "Recruiter" ]
        ]
      )
    end
  end
end
