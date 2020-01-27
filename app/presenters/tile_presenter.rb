# frozen_string_literal: true

# Given a tile, provides methods to assist in rendering it.
class TilePresenter
  # Constructor.
  #
  # @param {Hash} tile - { tile: String, rule: String }
  # @param {String} bem_base - Base class to extend with BEM
  # @return {TilePresenter} - Instance
  def initialize(tile:, bem_base:)
    @tile = tile&.symbolize_keys
    @bem_base = bem_base
  end

  # Placed tile, if any.
  #
  # @return {String} - Tile content
  def content
    return if @tile.blank?

    @tile[:tile]
  end

  # The point value of the tile, if any.
  #
  # @return {Integer} - Point value of tile
  def points
    return if content.blank?

    ScoreCalculator::STANDARD_VALUES[content.to_sym]
  end

  # The value to be plugged directly into a DOM element's `class` attribute.
  #
  # @return {String} - `class` attribute value
  def css_classes
    classes = [@bem_base]
    classes.push("#{@bem_base}--#{@tile[:rule]}") if @tile.present?
    classes.join(' ')
  end
end
