# frozen_string_literal: true

require "hanami/cli"
require "zeitwerk"

# @see Cerise::GetText
module Cerise
  # RuboCop support for Hanami application.
  module GetText
    # @api private
    # rubocop:disable Metrics/MethodLength
    def self.gem_loader
      @gem_loader ||= Zeitwerk::Loader.new.tap do |loader|
        root = File.expand_path("..", __dir__)
        loader.tag = "cerise-gettext"
        loader.inflector = Zeitwerk::GemInflector.new("#{root}/cerise-gettext.rb")
        loader.push_dir(root)
        loader.ignore(
          "#{root}/cerise-gettext.rb",
          "#{root}/cerise/gettext/{commands/install,rake_tasks,version}.rb"
        )
        loader.inflector.inflect("gettext" => "GetText")
      end
    end
    # rubocop:enable Metrics/MethodLength

    gem_loader.setup

    require_relative "gettext/version"

    require_relative "gettext/commands/install"

    begin
      require_relative "gettext/rake_tasks"
    rescue NoMethodError
      # this will fail during hanami install
    end

    Hanami::CLI.after "install", Commands::Install if Hanami::CLI.within_hanami_app?
  end
end
