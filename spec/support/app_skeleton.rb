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
      fs.write("config/settings.rb", <<~FILE)
        # frozen_string_literal: true

        module #{app_name}
          class Settings < Hanami::Settings
            # Define your app settings here, for example:
            #
            # setting :my_flag, default: false, constructor: Types::Params::Bool
          end
        end
      FILE

      example.run
    end
  ensure
    fs.delete_directory(dir)
  end
end

RSpec.configure do |config|
  config.include_context "in-app", type: :cli
end
