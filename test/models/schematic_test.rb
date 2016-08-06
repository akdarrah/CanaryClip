require 'test_helper'

class SchematicTest < ActiveSupport::TestCase

  def setup
    @schematic = create(:schematic)
  end

  test "State machine life cycle" do
    assert @schematic.new?
    assert_raise(StateMachine::InvalidTransition){ @schematic.render! }
    assert_raise(StateMachine::InvalidTransition){ @schematic.publish! }

    assert @schematic.collect_metadata!

    assert @schematic.collecting_metadata?
    assert_raise(StateMachine::InvalidTransition){ @schematic.collect_metadata! }
    assert_raise(StateMachine::InvalidTransition){ @schematic.publish! }

    assert @schematic.render!

    assert @schematic.rendering?
    assert_raise(StateMachine::InvalidTransition){ @schematic.collect_metadata! }
    assert_raise(StateMachine::InvalidTransition){ @schematic.render! }

    assert @schematic.publish!
    assert @schematic.published?
  end

end
