require "thor"

module TurboNativeInitializer
  class Generator < Thor::Group
    include Thor::Actions

    argument :name

    class_option :platform,   type: :string, enum: %w[ios android], required: true
    class_option :navigation, type: :string, enum: %w[stack tabs], default: "stack"
    class_option :package,    type: :string, default: "dev.hotwire.turbo"

    source_root File.expand_path("templates", __dir__)

    def self.exit_on_failure?
      true
    end

    def copy_template_files
      case options.platform
      when "ios"
        directory "#{project}/TurboNativeProject/Configuration", "#{name}/#{name}/Configuration"
        directory "#{project}/TurboNativeProject/Controllers", "#{name}/#{name}/Controllers"
        directory "#{project}/TurboNativeProject/Delegates", "#{name}/#{name}/Delegates"
        directory "#{project}/TurboNativeProject/Extensions", "#{name}/#{name}/Extensions"
        directory "#{project}/TurboNativeProject/Resources", "#{name}/#{name}/Resources"
        directory "#{project}/TurboNativeProject/Strada", "#{name}/#{name}/Strada"
        directory "#{project}/TurboNativeProject.xcodeproj", "#{name}/#{name}.xcodeproj"
        template  "#{project}/TurboNativeProject/TurboNativeProject.swift", "#{name}/#{name}/#{name}.swift"
      when "android"
        directory "#{project}/base", "#{name}"
        directory "#{project}/app/src/main/java/dev/hotwire/turbo/turbonativeproject", "#{name}/app/src/main/java/#{package_path}"
      end
    end

    private
      def project
        "#{options[:platform]}_#{options[:navigation]}"
      end

      def package_name
        "#{options[:package]}.#{name.downcase}"
      end

      def package_path
        package_name.split(".").join("/")
      end

      def bundle_identifier
        "#{options[:package]}.#{name}"
      end
  end
end
