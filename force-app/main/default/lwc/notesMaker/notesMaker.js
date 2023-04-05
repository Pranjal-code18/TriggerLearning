import { LightningElement, track } from 'lwc';

export default class NotesMaker extends LightningElement {
    @track isModalOpen = false;
    createNote() {
        console.log('button clicked');
        isModalOpen = true;
    }
}