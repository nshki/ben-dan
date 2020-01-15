# frozen_string_literal: true

# Given a player, provides methods to assist in rendering their score.
class ScorePresenter
  # Constructor.
  #
  # @param {GameUser} player - GameUser instance
  # @param {Game} game - Game instance
  # @param {String} bem_base - Base class to extend with BEM
  def initialize(player:, game:, bem_base:)
    @player = player
    @game = game
    @bem_base = bem_base
  end

  # Returns classes for the parent score element.
  #
  # @return {String} - `class` attribute value
  def parent_css_classes
    classes = [@bem_base]
    classes.push("#{@bem_base}--active") if @game.current_player == @player
    classes.join(' ')
  end

  # Returns the player's username.
  #
  # @return {String} - Player's username
  def name
    @player.user.username
  end

  # Returns classes for the element displaying a player's name.
  #
  # @return {String} - `class` attribute value
  def name_css_classes
    "#{@bem_base}__name"
  end

  # Returns the player's score.
  #
  # @return {Integer} - Player's score
  def score
    @player.score
  end

  # Returns classes for the element displaying point values.
  #
  # @return {String} - `class` attribute value
  def score_css_classes
    "#{@bem_base}__points"
  end
end
