require 'test_helper'

class RenderTest < ActiveSupport::TestCase

  def setup
    @render = create(:render)
  end

  test "State machine life cycle" do
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
  end

  test "A Render::RenderSceneWorker is queued when render is scheduled!" do
    Render::RenderSceneWorker
      .expects(:perform_async)
      .with(@render.id)
      .once

    @render.schedule!
  end

end
