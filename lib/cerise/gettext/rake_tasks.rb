# frozen_string_literal: true

Hanami::CLI::RakeTasks.register_tasks do
  require "gettext/tools/task"
  require "hanami/setup"

  GetText::Tools::Task.define do |task|
    task.locales = Hanami.app.settings.locales
    task.files = Dir["{app,lib}/**/*.{rb,erb}"]
    task.domain = Hanami.app.app_name.name
  end
end
