# frozen_string_literal: true

require 'test_helper'

class GameCreatorTest < ActiveSupport::TestCase
  test 'creates a new game given board dimensions' do
    result = GameCreator.call(num_horiz_tiles: 2, num_vert_tiles: 2)

    assert(result.is_a?(Game))
  end
end
