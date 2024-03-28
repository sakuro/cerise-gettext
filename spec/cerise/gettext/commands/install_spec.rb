# frozen_string_literal: true

RSpec.describe Cerise::GetText::Commands::Install, type: :cli do
  describe "#call" do
    subject(:install) { described_class.new(fs:) }

    let(:arbitrary_argument) { {} }

    before do
      stub_const("ENV", "LC_MESSAGES" => "C", "LANG" => "ja")
    end

    it "appends .gitignore entries" do
      install.call(arbitrary_argument)

      expect(fs.read(".gitignore")).to include(<<~GITIGNORE)
        po/*.pot
        po/*/*.edit.po
        po/*/*.po.time_stamp
        locale/**/*.mo
      GITIGNORE
    end

    it "adds locales setting to config/settings.rb" do
      install.call(arbitrary_argument)

      expect(fs.read("config/settings.rb")).to include <<~SETTING
        setting :locales, constructor: ->(v) { v.split(":").map(&:strip) }
      SETTING
    end

    it "adds LOCALES envvar to .env.development.local" do
      install.call(arbitrary_argument)

      expect(fs.read(".env.development.local")).to include <<~ENV
        LOCALES=en:ja
      ENV
    end

    it "adds LOCALES envvar to .env.test.local" do
      install.call(arbitrary_argument)

      expect(fs.read(".env.test.local")).to include <<~ENV
        LOCALES=en:ja
      ENV
    end

    it "adds require to config/app.rb" do
      install.call(arbitrary_argument)

      expect(fs.read("config/app.rb")).to include <<~APP
        require "locale/middleware"
      APP
    end

    it "adds middleware line config/app.rb" do
      install.call(arbitrary_argument)

      expect(fs.read("config/app.rb")).to include <<~APP
        config.middleware.use Locale::Middleware
      APP
    end
  end
end
