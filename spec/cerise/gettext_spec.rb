# frozen_string_literal: true

RSpec.describe Cerise::GetText, type: :cli do
  let(:locales) { %w[en ja] }
  let(:files) { ["app/action.rb", "app/view.rb"] }

  before do
    allow(Hanami).to receive_message_chain(:app, :settings, :locales).and_return(locales)
    allow(Hanami).to receive_message_chain(:app, :app_name, :name).and_return(app_name)
    allow(Dir).to receive(:[]).with("{app,lib}/**/*.{rb,erb}").and_return(files)
  end

  it "defines Rake tasks for handling *.po and *.mo files" do
    expected_tasks = %w[gettext gettext:mo:update gettext:po:add gettext:po:update gettext:pot:create]
    expected_tasks += locales.flat_map {|locale| %W[gettext:mo:#{locale}:update gettext:po:#{locale}:update] }

    Hanami::CLI::RakeTasks.install_tasks

    actual_tasks = Rake.application.tasks.map(&:name)

    expect(actual_tasks).to include(*expected_tasks)
  end
end
