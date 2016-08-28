ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    columns do
      column do
        panel "Site Metrics" do
          table do
            thead do
              tr do
                th "Resource Name"
                th "All Time"
                th "Last Month"
                th "Last Day"
              end
            end
            tbody do

              [Schematic, User, Render, Character, CharacterClaim, Block].each do |klass|
                tr do
                  td klass.name
                  td klass.count
                  td klass.where(["created_at > ?", 1.month.ago]).count
                  td klass.where(["created_at > ?", 1.day.ago]).count
                end
              end

            end
          end
        end
      end
    end

  end # content
end
