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
        directory "ios_stack", name
        rename_file "#{name}/TurboNativeProject.xcodeproj", "#{name}/#{name}.xcodeproj"
        rename_file "#{name}/TurboNativeProject/TurboNativeProject.swift", "#{name}/TurboNativeProject/#{name}.swift"
        rename_file "#{name}/TurboNativeProject", "#{name}/#{name}"
      elsif options[:platform] == "android" && options[:navigation] == "stack"
        directory "android_stack", name
        rename_file "#{name}/app/src/main/java/dev/hotwire/turbo/turbonativeproject", "#{name}/app/src/main/java/dev/hotwire/turbo/#{name.downcase}"
      else
        say "Template not implemented yet... =/"
      end
    end

    private
      def rename_file(old_name, new_name)
        say_status :rename, "#{old_name} to #{new_name}"

        old_name = File.expand_path(old_name, destination_root)
        new_name = File.expand_path(new_name, destination_root)
        File.rename(old_name, new_name)
      end
  end
end
