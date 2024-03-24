# frozen_string_literal: true

return unless Hanami::CLI.within_hanami_app?

require "gettext/tools/task"
require "hanami/prepare"

GetText::Tools::Task.define do |task|
  task.locales = Hanami.app.settings.locales
  task.files = Dir["{app,lib}/**/*.{rb,erb}"]
  task.domain = Hanami.app.app_name.name
end
