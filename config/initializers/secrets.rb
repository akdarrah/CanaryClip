SECRETS = YAML.load_file("#{Rails.root.to_s}/config/secrets.yml")[Rails.env].with_indifferent_access

ATTR_ENCRYPTED_KEY = SECRETS[:attr_encrypted_key]
