# frozen_string_literal: true

require 'test_helper'

# rubocop:disable Style/ClassAndModuleChildren
class ApplicationCable::ConnectionTest < ActionCable::Connection::TestCase
  # rubocop:enable Style/ClassAndModuleChildren

  # test "connects with cookies" do
  #   cookies.signed[:user_id] = 42
  #
  #   connect
  #
  #   assert_equal connection.user_id, "42"
  # end
end
