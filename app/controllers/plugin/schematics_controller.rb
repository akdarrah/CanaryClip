class Plugin::SchematicsController < Plugin::BaseController
  before_filter :find_schematic, only: [:download]
  before_filter :log_impression, only: [:download]
  before_filter :track_downloads, only: [:download]

  def create
    @schematic = Schematic.new(create_params)
    @schematic.character = @character

    if @schematic.save
      @schematic.collect_metadata!

      render_plugin_text I18n.t('plugin.schematics.upload_success', permalink: @schematic.permalink)
    else
      render_plugin_text I18n.t('plugin.schematics.validation_error')
    end
  end

  def download
    send_file @schematic.file.path
  end

  private

  def create_params
    params.require(:schematic)
      .permit(:raw_schematic_data)
  end

  def find_schematic
    @schematic = Schematic.find_by_permalink(params[:id])

    if @schematic.blank?
      render_plugin_text I18n.t('plugin.schematics.not_found', permalink: params[:id])
    end
  end

  def log_impression
    impressionist(@schematic)
  end

  def track_downloads
    TrackedDownload.create!(
      :character => @character,
      :schematic => @schematic
    )
  end

end
