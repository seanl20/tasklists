# frozen_string_literal: true

class InstallHoardable < ActiveRecord::Migration[7.2]
  def change
    create_function :hoardable_prevent_update_id
    create_function :hoardable_source_set_id
    create_function :hoardable_version_prevent_update
    create_enum :hoardable_operation, %w[update delete insert]
  end
end
