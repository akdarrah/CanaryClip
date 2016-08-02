class Render::RenderSceneWorker
  include Sidekiq::Worker

  def perform(render_id)
  end
end
