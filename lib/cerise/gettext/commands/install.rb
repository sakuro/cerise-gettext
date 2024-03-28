# frozen_string_literal: true

require "erb"

require "hanami/cli/command"

# @see Cerise::GetText::Commands::Install
module Cerise
  # @see Cerise::GetText::Commands::Install
  module GetText
    # @see Cerise::GetText::Commands::Install
    module Commands
      ENVIRONMENTS = %w(development test).freeze
      private_constant :ENVIRONMENTS

      # @api private
      class Install < Hanami::CLI::Command
        # Installs GetText configurations
        #
        # - .gitignore - ignore gettext work files
        # - config/settings.rb - locale settings
        # - .env.development.local - LOCALES (colon separated languages)
        # - .env.test.local - ditto
        # @api private
        def call(*, **)
          append_gitignore
          append_settings
          append_envvars
          append_middlewares
        end

        private def append_gitignore
          fs.append(
            fs.expand_path(".gitignore"),
            fs.read(fs.expand_path(fs.join("..", "generators", "dot.gitignore"), __dir__))
          )
        end

        private def append_settings
          fs.inject_line_at_class_bottom("config/settings.rb", "Settings", <<~SETTING)
            setting :locales, constructor: ->(v) { v.split(":").map(&:strip) }
          SETTING
        end

        private def append_envvars
          ENVIRONMENTS.each do |environment|
            fs.append(".env.#{environment}.local", <<~LOCALES)
              LOCALES=#{locales.join(":")}
            LOCALES
          end
        end

        private def append_middlewares
          fs.inject_line_after_last("config/app.rb", "require", <<~REQUIRE)
            require "locale/middleware"
          REQUIRE
          fs.inject_line_at_class_bottom("config/app.rb", "App", <<~MIDDLEWARE)
            config.middleware.use Locale::Middleware
          MIDDLEWARE
        end

        private def locales
          @locales ||= (%w[en] + locales_from_env).uniq
        end

        private def locales_from_env
          ENV.values_at(*%w[LC_ALL LC_MESSAGES LANG]).flat_map {|value| value.to_s.scan(/\A[a-z]{2}/) }
        end
      end
    end
  end
end
