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
      if ios_stack?
        directory "ios_stack/TurboNativeProject/Configuration", "#{name}/#{name}/Configuration"
        directory "ios_stack/TurboNativeProject/Controllers", "#{name}/#{name}/Controllers"
        directory "ios_stack/TurboNativeProject/Delegates", "#{name}/#{name}/Delegates"
        directory "ios_stack/TurboNativeProject/Resources", "#{name}/#{name}/Resources"
        template  "ios_stack/TurboNativeProject/TurboNativeProject.swift", "#{name}/#{name}/#{name}.swift"
        directory "ios_stack/TurboNativeProject.xcodeproj", "#{name}/#{name}.xcodeproj"
      elsif android_stack?
        # android_stack/app
        copy_file "android_stack/app/.gitignore", "#{name}/app/.gitignore"
        template  "android_stack/app/build.gradle.kts", "#{name}/app/build.gradle.kts"
        copy_file "android_stack/app/proguard-rules.pro", "#{name}/app/proguard-rules.pro"

        # android_stack/app/src/main
        directory "android_stack/app/src/main/assets", "#{name}/app/src/main/assets"
        directory "android_stack/app/src/main/java/dev/hotwire/turbo/turbonativeproject", "#{name}/app/src/main/java/#{package_path}"
        directory "android_stack/app/src/main/res", "#{name}/app/src/main/res"
        template  "android_stack/app/src/main/AndroidManifest.xml", "#{name}/app/src/main/AndroidManifest.xml"

        # android_stack/gradle
        directory "android_stack/gradle", "#{name}/gradle"

        # android_stack
        copy_file "android_stack/build.gradle.kts", "#{name}/build.gradle.kts"
        copy_file "android_stack/gradle.properties", "#{name}/gradle.properties"
        copy_file "android_stack/gradlew", "#{name}/gradlew"
        copy_file "android_stack/gradlew.bat", "#{name}/gradlew.bat"
        copy_file "android_stack/local.properties", "#{name}/local.properties"
        template  "android_stack/settings.gradle.kts", "#{name}/settings.gradle.kts"
      else
        say "Template not implemented yet... =/"
      end
    end

    private
      def ios_stack?
        options[:platform] == "ios" && options[:navigation] == "stack"
      end

      def android_stack?
        options[:platform] == "android" && options[:navigation] == "stack"
      end

      def package
        options[:package]
      end

      def package_name
        "#{package}.#{name.downcase}"
      end

      def package_path
        package.split(".").join("/")
      end

      def bundle_identifier
        "#{package}.#{name}"
      end
  end
end
