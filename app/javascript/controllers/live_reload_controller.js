import { Controller } from 'stimulus';
import { createConsumer } from '@rails/actioncable';

export default class extends Controller {
  /**
   * Subscribes to the GamesChannel on mount.
   *
   * @return {void}
   */
  connect() {
    const channel = { channel: 'GamesChannel', id: this.data.get('game-id') };
    this.consumer = this.consumer || createConsumer();
    this.subscription = this.consumer.subscriptions.create(channel, {
      received(data) {
        Turbolinks.visit(location.toString());
      }
    });
  }

  /**
   * Unsubscribes from the GamesChannel on dismount.
   *
   * @return {void}
   */
  disconnect() {
    if (this.subscription) {
      this.consumer.subscriptions.remove(this.subscription);
    }
  }
};
