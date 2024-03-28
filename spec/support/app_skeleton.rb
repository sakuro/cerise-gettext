# frozen_string_literal: true

require "tmpdir"

RSpec.shared_context "in-app" do
  let(:fs) { Dry::Files.new }
  let(:dir) { Dir.mktmpdir }
  let(:app) { "app" }
  let(:app_name) { "App" }

  around do |example|
    fs.chdir(dir) do
      fs.mkdir("config")
      fs.write("config/app.rb", <<~APP_RB)
        require "hanami"

        module #{app_name}
          class App < Hanami::App
          end
        end
      APP_RB

      fs.write("config/settings.rb", <<~SETTINGS_RB)
        module #{app_name}
          class Settings < Hanami::Settings
          end
        end
      SETTINGS_RB

      example.run
    end
  ensure
    fs.delete_directory(dir)
  end
end

RSpec.configure do |config|
  config.include_context "in-app", type: :cli
end
