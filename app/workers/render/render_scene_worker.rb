class Render::RenderSceneWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'chunky'

  def perform(render_id)
    # Give the transaction time to finish
    sleep 1

    @render = Render.find(render_id)
    SceneRenderer.new(@render).render!
  end
end
