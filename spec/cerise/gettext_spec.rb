# frozen_string_literal: true

require "rake"

RSpec.describe Cerise::GetText, type: :cli do
  let(:locales) { %w[en ja] }

  before do
    allow(Hanami::CLI).to receive(:within_hanami_app?).and_return(true)
    allow(Hanami).to receive_message_chain(:app, :settings, :locales).and_return(locales)
  end

  xit "defines Rake tasks for handling *.po and *.mo files" do
    expected_tasks = %w[gettext gettext:mo:update gettext:po:add gettext:po:update gettext:pot:create]
    expected_tasks += locales.flat_map {|locale| %W[gettext:mo:#{locale}:update gettext:po:#{locale}:update] }
    actual_tasks = Rake.application.tasks.map(&:name)

    expect(actual_tasks).to include(*expected_tasks)
  end
end
