import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['board', 'square', 'tile', 'hand', 'form', 'submit'];

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
   * Adds hover class to board square.
   *
   * @return {void}
   */
  hoverTile(e) {
    e.preventDefault();
    e.target.classList.add('hover')
  }

  /**
   * Removes hover class from board square.
   *
   * @return {void}
   */
  unhoverTile(e) {
    e.preventDefault();
    e.target.classList.remove('hover');
  }

  /**
   * Removes hover class from all board squares.
   *
   * @return {void}
   */
  clearHovers(e) {
    e.preventDefault();
    this.squareTargets.map((square) => square.classList.remove('hover'));
  }

  /**
   * Places selected tile on the board.
   *
   * @param {Event} e - DOM event
   * @return {void}
   */
  placeTile(e) {
    e.preventDefault();
    const tile = this.selectedTile();
    if (!tile || this.hasTile(e.target)) { return; }

    tile.classList.remove('selected');
    e.target.appendChild(tile);
    this.boardTarget.classList.remove('placeable');
    this.submitTarget.value = 'Submit';
    this.addToForm({ tile, boardTile: e.target });
  }

  /**
   * Shuffles tiles in hand. Uses technique based on the Fisher-Yates shuffle.
   * Ref: https://stackoverflow.com/a/11972692
   *
   * @return {void}
   */
  shuffle() {
    const tiles = this.handTarget.children;

    for (let i = tiles.length; i >= 0; i--) {
      this.handTarget.appendChild(tiles[Math.random() * i | 0])
    }
  }

  /**
   * Bring all tiles back to the hand.
   *
   * @return {void}
   */
  undo() {
    this.boardTarget.classList.remove('placeable');
    this.tileTargets.map((tile) => this.handTarget.appendChild(tile));
    this.submitTarget.value = 'Pass';
    this.formTarget.innerHTML = '';
  }

  // Private

  /**
   * Adds the given tile to the hidden form.
   *
   * @param {Element} tile - Placed tile element
   * @param {Element} boardTile - Space in which tile was placed
   */
  addToForm({ tile, boardTile }) {
    const { col, row } = boardTile.dataset;
    const { index } = tile.dataset;
    let data = document.createElement('input');
    data.type = 'hidden';
    data.name = 'placements[]';
    data.value = `${col}:${row}:${index}`;
    this.formTarget.appendChild(data);
  }

  /**
   * Determines if the given element already has a tile.
   *
   * @param {Element} el - DOM element
   * @return {Boolean} - True if already has tile, false otherwise
   */
  hasTile(el) {
    if (!el.classList.contains('board__tile')) { return true; }

    return el.children.length > 0;
  }

  /**
   * Deselects all tiles in hand.
   *
   * @return {void}
   */
  deselectTiles() {
    this.tileTargets.map((tile) => tile.classList.remove('selected'));
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
};
