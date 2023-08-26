require "thor"

module TurboNativeInitializer
  class Generator < Thor::Group
    include Thor::Actions

    argument :name
    class_option :platform,   type: :string, enum: %w[ios android], required: true
    class_option :navigation, type: :string, enum: %w[stack tabs],  default: "stack"

    source_root File.expand_path("templates", __dir__)

    def self.exit_on_failure?
      true
    end

    def copy_template_files
      if options[:platform] == "ios" && options[:navigation] == "stack"
        # /TurboNativeProject/TurboNativeProject/...
        directory "ios_stack/TurboNativeProject/Controllers", "#{name}/#{name}/Controllers"
        directory "ios_stack/TurboNativeProject/Delegates", "#{name}/#{name}/Delegates"
        directory "ios_stack/TurboNativeProject/Resources", "#{name}/#{name}/Resources"
        copy_file "ios_stack/TurboNativeProject/Info.plist", "#{name}/#{name}/Info.plist"
        copy_file "ios_stack/TurboNativeProject/path-configuration.json", "#{name}/#{name}/path-configuration.json"
        template  "ios_stack/TurboNativeProject/TurboNativeProject.swift", "#{name}/#{name}/#{name}.swift"
        # /TurboNativeProject/TurboNativeProject.codeproj
        directory "ios_stack/TurboNativeProject.xcodeproj", "#{name}/#{name}.xcodeproj"
      elsif options[:platform] == "android" && options[:navigation] == "stack"
        
      else
        say "Template not implemented yet... =/"
      end
    end
  end
end
