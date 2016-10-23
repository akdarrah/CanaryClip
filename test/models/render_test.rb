require 'test_helper'

class RenderTest < ActiveSupport::TestCase

  def setup
    @render = create(:render)
  end

  test "State machine life cycle" do
    Render.any_instance.stubs(:publish_schematic)

    assert @render.pending?
    assert_raise(StateMachine::InvalidTransition){ @render.render! }
    assert_raise(StateMachine::InvalidTransition){ @render.complete! }

    assert @render.schedule!

    assert @render.scheduled?
    assert_raise(StateMachine::InvalidTransition){ @render.schedule! }
    assert_raise(StateMachine::InvalidTransition){ @render.complete! }

    assert @render.render!
    assert_raise(StateMachine::InvalidTransition){ @render.schedule! }
    assert_raise(StateMachine::InvalidTransition){ @render.render! }

    assert @render.complete!
    assert @render.completed?
  end

  # Render#schedule_job

  test "A Render::SceneRendererWorker is queued when a non-primary render is scheduled!" do
    @render.stubs(:primary_render?).returns(false)

    Render::SceneRendererWorker
      .expects(:perform_async)
      .once

    @render.schedule!
  end

  test "A Render::PreferredSceneRendererWorker is queued when a primary render is scheduled!" do
    @render.stubs(:primary_render?).returns(true)

    Render::PreferredSceneRendererWorker
      .expects(:perform_async)
      .once

    @render.schedule!
  end

  # Render#publish_schematic

  # The primary render will always be rendered first, so the schematic
  # will be published while the other renders are not complete
  test "Schematic is published once the primary render is completed" do
    Render.any_instance.stubs(:schedule_job)

    @schematic = create(:schematic, state: "rendering")
    @schematic.send(:create_renders)
    assert @schematic.rendering?

    renders = @schematic.renders.to_a.reverse
    assert_equal renders.count, 5

    4.times do
      render = renders.shift
      refute render.send(:primary_render?)

      assert render.render!
      assert render.complete!
      assert @schematic.reload.rendering?
    end

    final_render = renders.shift
    assert final_render.send(:primary_render?)

    assert final_render.render!
    assert final_render.complete!
    assert @schematic.reload.published?
  end

  # Render#primary_render

  test "Only a render with PRIMARY camera angle and standard resolution is primary" do
    assert_equal CameraAngle::PRIMARY, @render.camera_angle
    assert_equal Render::STANDARD_RESOLUTION, @render.resolution
    assert @render.send(:primary_render?)

    CameraAngle::SECONDARY.each do |other_angle|
      @render.camera_angle = other_angle
      refute @render.send(:primary_render?)
    end

    @render.resolution = Render::HIGH_RESOLUTION
    CameraAngle::AVAILABLE.each do |other_angle|
      @render.camera_angle = other_angle
      refute @render.send(:primary_render?)
    end
  end

end
