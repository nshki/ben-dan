import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['board', 'tile', 'hand', 'control', 'form'];

  /**
   * Selects a tile from the player's hand.
   *
   * @param {Event} e - DOM event
   * @return {void}
   */
  selectTile(e) {
    if (this.notMyTurn() || this.notInHand(e.target)) { return; }

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
    if (!tile || this.hasTile(e.target)) { return; }

    tile.classList.remove('selected');
    e.target.appendChild(tile);
    this.boardTarget.classList.remove('placeable');
    this.controlTargets.map((control) => control.disabled = false);
    this.addToForm({ tile, boardTile: e.target });
  }

  /**
   * Bring all tiles back to the hand.
   *
   * @return {void}
   */
  undo() {
    this.boardTarget.classList.remove('placeable');
    this.tileTargets.map((tile) => this.handTarget.appendChild(tile));
    this.controlTargets.map((control) => control.disabled = true);
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
   * Returns whether the given element is in the hand.
   *
   * @param {Element} el - DOM element
   * @return {Boolean} - True if in hand, false otherwise
   */
  notInHand(el) {
    return !el.parentNode.classList.contains('game-ui__hand__tiles');
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
