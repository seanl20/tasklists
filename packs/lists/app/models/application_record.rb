module Lists
  def self.table_name_prefix
    nil
  end

  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
