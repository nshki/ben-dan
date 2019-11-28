# frozen_string_literal: true

# Top level class all models inherit from.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
