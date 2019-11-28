# frozen_string_literal: true

# == Schema Information
#
# Table name: words
#
#  id         :bigint           not null, primary key
#  spelling   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Represents a valid word that can be played.
class Word < ApplicationRecord
  validates :spelling, presence: true
end
