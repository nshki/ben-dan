import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['board', 'tile'];

  /**
   * Selects a tile from the player's hand.
   *
   * @param {Event} e - DOM event
   * @return {void}
   */
  selectTile(e) {
    if (this.notMyTurn()) { return; }

    this.deselectTiles();
    e.target.classList.add('selected');
    this.boardTarget.classList.add('placeable');
  }

  /**
   * Places selected tile on the board.
   *
   * @param {Event} e - DOM event
   * @return {void}
   */
  placeTile(e) {
    const tile = this.selectedTile();
    if (!tile) { return; }

    tile.classList.remove('selected');
    e.target.appendChild(tile);
    this.boardTarget.classList.remove('placeable');
  }

  /**
   * Returns whether it's the current player's turn.
   *
   * @return {Boolean} - True if current player's turn, false otherwise
   */
  notMyTurn() {
    return this.data.get('active') === 'false';
  }

  /**
   * Returns the currently selected hand tile, if any.
   *
   * @return {Element} - DOM element
   */
  selectedTile() {
    return this.tileTargets.find((tile) => {
      return tile.classList.contains('selected');
    });
  }

  /**
   * Deselects all tiles in hand.
   *
   * @return {void}
   */
  deselectTiles() {
    this.tileTargets.map((tile) => tile.classList.remove('selected'));
  }
};
