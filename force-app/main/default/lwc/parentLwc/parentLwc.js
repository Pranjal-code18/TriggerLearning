import { LightningElement } from 'lwc';

export default class ParentLwc extends LightningElement {
    startCounter = 0;
    handleStartChange(event) {
      this.startCounter = event.target.value;
    }
}