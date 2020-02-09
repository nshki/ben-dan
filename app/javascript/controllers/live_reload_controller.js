import { Controller } from 'stimulus';
import { createConsumer } from '@rails/actioncable';

export default class extends Controller {
  connect() {
    const channel = { channel: 'GamesChannel', id: this.data.get('game-id') };
    this.consumer = this.consumer || createConsumer();
    this.consumer.subscriptions.create(channel, {
      received(data) {
        Turbolinks.visit(location.toString());
      }
    });
  }
};
