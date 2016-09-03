SECRETS = YAML.load_file("#{Rails.root.to_s}/config/secrets.yml")[Rails.env].with_indifferent_access

PLUGIN_AUTHENTICITY_TOKEN = SECRETS[:plugin][:authenticity_token]
