import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['button'];

  /**
   * Toggles the dropdown by activating the dropdown button.
   *
   * @param {Event} e - DOM event
   * @return {void}
   */
  toggle(e) {
    this.buttonTarget.classList.toggle('is-active');
  }

  /**
   * Hides the dropdown.
   *
   * @param {Event} e - DOM event
   * @return {void}
   */
  hide(e) {
    if (e.target == this.buttonTarget) { return; }

    this.buttonTarget.classList.remove('is-active');
  }
};
