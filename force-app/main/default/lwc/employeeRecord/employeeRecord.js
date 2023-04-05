import { LightningElement, track, api, wire } from 'lwc';
import fetchContactsByReportingManager from '@salesforce/apex/fetchRelatedContacts.fetchContactsByReportingManager';
import USER_ID from "@salesforce/user/Id";

const COLUMNS = [
    { label: 'First Name', fieldName: 'FirstName', type: 'text' },
    { label: 'Last Name', fieldName: 'LastName', type: 'text' },
    { label: 'Work Email', fieldName: 'Email', type: 'text'},
    { label: 'Phone', fieldName: 'Phone', type: 'number' },
];

export default class EmployeeRecord extends LightningElement {

    Reporting_Manager__c;
    finalData;
    @track recordsToDisplay;
    columns = COLUMNS;

    connectedCallback(){
        fetchContactsByReportingManager({userId: USER_ID})
        .then((result)=>{
            this.finalData = result;
            this.recordViewerHandler();
        })
    }

    recordViewerHandler() {

        let data = [];
        for (let index = 0; index < this.finalData.length; index++) {
            if(this.finalData[index] != undefined) {
                data.push({
                    Id : this.finalData[index].Id,
                    FirstName : this.finalData[index].FirstName,
                    LastName : this.finalData[index].LastName,
                    Email : this.finalData[index].Email,
                    Phone : this.finalData[index].Phone,
                });
            }   
        }
        this.recordsToDisplay = data;
        
    }
}