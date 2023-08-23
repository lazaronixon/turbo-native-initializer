require "thor"

module TurboNativeInitializer
  class Generator < Thor::Group
    include Thor::Actions

    argument :name, desc: "The project name"

    class_option :platform,   type: :string, enum: %w[ios android], required: true
    class_option :navigation, type: :string, enum: %w[stack tabs],  default: "stack"

    source_root File.expand_path("templates", __dir__)

    def self.exit_on_failure?
      true
    end

    def copy_template_files
      directory "#{options[:platform]}_#{options[:navigation]}", name
    end

    def rename_template_files
    end
  end
end
