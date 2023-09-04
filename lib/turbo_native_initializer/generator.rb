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
      if ios?
        # project/TurboNativeProject
        directory "#{project}/TurboNativeProject/Configuration", "#{name}/#{name}/Configuration"
        directory "#{project}/TurboNativeProject/Controllers", "#{name}/#{name}/Controllers"
        directory "#{project}/TurboNativeProject/Delegates", "#{name}/#{name}/Delegates"
        directory "#{project}/TurboNativeProject/Resources", "#{name}/#{name}/Resources"
        template  "#{project}/TurboNativeProject/TurboNativeProject.swift", "#{name}/#{name}/#{name}.swift"

        # project
        directory "#{project}/TurboNativeProject.xcodeproj", "#{name}/#{name}.xcodeproj"
      end

      if android?
        # project/app
        copy_file "#{project}/app/.gitignore", "#{name}/app/.gitignore"
        copy_file "#{project}/app/proguard-rules.pro", "#{name}/app/proguard-rules.pro"
        template  "#{project}/app/build.gradle.kts", "#{name}/app/build.gradle.kts"

        # project/app/src/debug
        directory "#{project}/app/src/debug", "#{name}/app/src/debug"

        # project/app/src/main
        directory "#{project}/app/src/main/assets", "#{name}/app/src/main/assets"
        directory "#{project}/app/src/main/java/dev/hotwire/turbo/turbonativeproject", "#{name}/app/src/main/java/#{package_path}"
        directory "#{project}/app/src/main/res", "#{name}/app/src/main/res"
        template  "#{project}/app/src/main/AndroidManifest.xml", "#{name}/app/src/main/AndroidManifest.xml"

        # project/gradle
        directory "#{project}/gradle", "#{name}/gradle"

        # project
        copy_file "#{project}/build.gradle.kts", "#{name}/build.gradle.kts"
        copy_file "#{project}/gradle.properties", "#{name}/gradle.properties"
        copy_file "#{project}/gradlew", "#{name}/gradlew"
        copy_file "#{project}/gradlew.bat", "#{name}/gradlew.bat"
        copy_file "#{project}/local.properties", "#{name}/local.properties"
        template  "#{project}/settings.gradle.kts", "#{name}/settings.gradle.kts"
      end
    end

    private
      def ios?
        options[:platform] == "ios"
      end

      def android?
        options[:platform] == "android"
      end

      def project
        "#{options[:platform]}_#{options[:navigation]}"
      end

      def package_path
        options[:package].split(".").join("/")
      end

      def package_name
        "#{options[:package]}.#{name.downcase}"
      end

      def bundle_identifier
        "#{options[:package]}.#{name}"
      end
  end
end
