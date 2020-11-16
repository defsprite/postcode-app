class PostcodeConfig
  def self.extra_postcodes
    full_config["extra_postcodes"].map(&:strip)
  end

  def self.lsoa_prefixes
    full_config["lsoa_prefixes"].map(&:strip)
  end

  def self.full_config
    @full_config ||= YAML.safe_load(File.open(Rails.root.join("config", "postcodes.yml")))
  end
end
