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

require 'test_helper'

class WordTest < ActiveSupport::TestCase
  test 'valid word' do
    word = FactoryBot.build(:word)

    assert(word.valid?)
  end

  test 'blanks are invalid' do
    word_nil = FactoryBot.build(:word, spelling: nil)
    word_spaces = FactoryBot.build(:word, spelling: '   ')

    assert_not(word_nil.valid?)
    assert_not(word_spaces.valid?)
  end
end
