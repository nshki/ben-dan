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
# Indexes
#
#  index_words_on_spelling  (spelling)
#

FactoryBot.define do
  factory :word do
    spelling { 'Word' }
  end
end
