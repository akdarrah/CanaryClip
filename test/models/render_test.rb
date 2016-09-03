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

  test "A Render::RenderSceneWorker is queued when render is scheduled!" do
    Render::RenderSceneWorker
      .expects(:perform_at)
      .with(@render.id)
      .once

    @render.schedule!
  end

  test "Schematic is published once the last render is completed" do
    Render.any_instance.stubs(:schedule_job)

    @schematic = create(:schematic, state: "rendering")
    @schematic.send(:create_renders)
    assert @schematic.rendering?

    renders = @schematic.renders.to_a
    assert_equal renders.count, 5

    4.times do
      render = renders.shift

      assert render.render!
      assert render.complete!
      assert @schematic.reload.rendering?
    end

    final_render = renders.shift

    assert final_render.render!
    assert final_render.complete!
    assert @schematic.reload.published?
  end

end
