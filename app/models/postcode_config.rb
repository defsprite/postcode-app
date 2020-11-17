# frozen_string_literal: true

class PostcodeConfig
  def self.extra_postcodes
    @extra_postcodes ||= file_content["extra_postcodes"].map(&:strip)
  end

  def self.lsoa_prefixes
    @lsoa_prefixes ||= file_content["lsoa_prefixes"].map(&:strip)
  end

  def self.file_content
    @file_content ||= YAML.safe_load(File.open(Rails.root.join("config", "postcodes.yml")))
  end
end
