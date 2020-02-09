# frozen_string_literal: true

# Channel for ongoing game events.
class GamesChannel < ApplicationCable::Channel
  def subscribed
    stream_from("game_#{params[:id]}")
  end
end
