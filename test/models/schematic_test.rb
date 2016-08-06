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

  test "A Schematic::CollectMetadataWorker is queued when schematic is collecting metadata" do
    Schematic::CollectMetadataWorker
      .expects(:perform_async)
      .with(@schematic.id)
      .once

    assert @schematic.new?
    assert @schematic.collect_metadata!
    assert @schematic.collecting_metadata?
  end

  test "Renders are created and scheduled when transitioning to rendering" do
    Schematic.any_instance.stubs(:schedule_metadata_collection)

    refute @schematic.renders.exists?

    assert @schematic.new?
    assert @schematic.collect_metadata!
    assert @schematic.collecting_metadata?
    assert @schematic.render!
    assert @schematic.rendering?

    CameraAngle::AVAILABLE.each do |camera_angle|
      render = @schematic.renders.where(camera_angle: camera_angle).first

      assert render.present?
      assert render.scheduled?
    end
  end

end
