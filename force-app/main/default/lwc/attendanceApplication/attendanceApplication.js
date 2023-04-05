import { LightningElement, track, wire } from 'lwc';
import createRecord from '@salesforce/apex/AttendanceController.createRecord';
import Id from '@salesforce/user/Id';
import updateAttendanceRecord from '@salesforce/apex/AttendanceController.updateAttendanceRecord';
import getDetails from '@salesforce/apex/AttendanceController.getDetails';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import checkTimeValidity from '@salesforce/apex/AttendanceController.checkTimeValidity';
import getCustomSettings from '@salesforce/apex/AttendanceController.getCustomSettings';
import fetchContactsByUserId from '@salesforce/apex/AttendanceController.fetchContactsByUserId';



const COLUMNS = [
    //{ label: 'Attendance Date', fieldName: 'Attendance_Date', type: 'text' },
    { label: 'Date and Time(IN)', fieldName: 'Date_and_Time_IN', type: 'datetime' },
    { label: 'Date and Time(OUT)', fieldName: 'Date_and_Time_OUT', type: 'datetime'},
    { label: 'Total Worked Hours', fieldName: 'Total_Worked_Hours', type: 'text' },
];

export default class Punch extends LightningElement {
    date;
    time;
    submitButton;
    PUNCHOUT;
    PunchInDateTime;
    PunchOutDateTime;
    presence;
    hour;
    msg;
    title;
    variant;
    minutes;
    a=1;
    subject = "Mark my attendnace";
    @track btn1=false;
    @track btn2=true;
    @track btn3 = false;
    @track showpopUp = false;
    @track showSpinner = false;

    connectedCallback() {
        var now = new Date(); 
        this.hour = now.getHours();
        this.minutes = now.getMinutes();
        console.log('minutes>',this.minutes);
        this.getRecord();
    }

    getRecord() {
        getDetails({currentUserId: Id}).then(result=>{
            
            this.presence=result.length;
            if(result.length == 0) {
                this.PunchOutDateTime = "";
                this.PunchInDateTime = "";
                this.btn1=false;
                this.btn2=false;
            }
            else if(result.length == 1) {
            this.PunchInDateTime = this.convertDateTime(result[0].punchIn);
            this.PunchOutDateTime =result[0].punchOut;
            if(this.PunchOutDateTime === undefined) {
                this.PunchOutDateTime = "";
                this.btn2 = false;
            }
            else{
                this.PunchOutDateTime = this.convertDateTime(result[0].punchOut);
            }
            if(this.PunchInDateTime === undefined) {
                this.PunchInDateTime = "";
                this.btn1 = false; //
            }
            }
            else if(result.length == 2) {
            if(result[0].punchIn != undefined) {
                this.PunchInDateTime = this.convertDateTime(result[0].punchIn);
            }
            else{
                this.PunchInDateTime = this.convertDateTime(result[1].punchIn);
            }

            if(result[0].punchOut != undefined) {
                this.PunchOutDateTime = this.convertDateTime(result[0].punchOut);
            }
            else{
                this.btn2 = false;
                this.PunchOutDateTime = this.convertDateTime(result[1].punchOut);
            }
            }
        })
    }
    submitButton = document.getElementById("submit");

    convertDateTime(s) {
        var date = s.substring(0,10);
        var time = s.substring(11,13);
        let t = 0;
        let mintSec;
        if(time>12){
            for(let i=13;i<=time;i++){
               t = t+1;
            }
            mintSec = t + ':'+s.substring(14,16)+' PM';
        }
        else if(time == 12) {
            mintSec = time + ':'+s.substring(14,16)+' PM';
        }
        else{
            mintSec = time +':'+s.substring(14,16)+' AM';
        }
        return date+ ' , ' + mintSec;
    }

//create new attendance record when user punch in
    createAttendanceRecord() {
        this.showSpinner = true;
        let currentHour = parseInt(this.hour);
        console.log('currentTime',currentHour);
        getCustomSettings({}).then(result=>{
            let fixedHour = parseInt(result.substring(0,2));
            if(currentHour >= fixedHour) {
                this.title = 'Warning';
                this.msg = 'You have tried to Punch in after 11:00 AM.';
                this.variant = 'warning';
                this.toastEvt(this.title, this.msg, this.variant);
            }
        })
      
        createRecord({currentUserId: Id})
        .then(result => {
            this.getRecord();
            this.btn1 = true;
            this.btn2 = false;
            this.showSpinner = false;
                this.title = 'Success';
                this.msg = 'Punch In Successfully';
                this.variant = 'success';
                this.toastEvt(this.title, this.msg, this.variant);
        })
        .catch(error =>{
            this.showSpinner = false;
            this.connectedCallback();
                this.title = 'Error';
                this.msg = 'You cannot punch in more than once';
                this.variant = 'error';
                this.toastEvt(this.title, this.msg, this.variant);
            this.connectedCallback();
        })
       
        }

    updateAttendanceRecord() {
        this.getRecord();
        this.showSpinner = true;
        checkTimeValidity({currentUserId: Id}).then(result=>{
        updateAttendanceRecord({currentUserId: Id}).then(result => {
            this.getRecord();
            console.log('result',result);
            this.showSpinner = false;
            this.title = 'Success';
            this.msg = 'Punch Out Successfully';
            this.variant = 'success';
            this.toastEvt(this.title, this.msg, this.variant);
            this.btn1 = true;
            this.btn2 = true;
            this.showSpinner = false;
        })
        .catch(error =>{
            this.showSpinner = false;
            console.error("error:" +JSON.stringify(error));
                this.title = 'error';
                this.msg = 'You cannot punch out more than once';
                this.variant = 'record';
                this.toastEvt(this.title, this.msg, this.variant);
        })
            });
        this.showSpinner=false;
    }
    editEmployee(){
        this.showpopUp = true;
    }
    handleChildResponse(event) {
        this.showpopUp = false;
    }

    toastEvt(title, msg, variant) {
        const evt = new ShowToastEvent({
            title: this.title,
            message: this.msg,
            variant: this.variant,
        });
        this.dispatchEvent(evt);
        this.showSpinner = false;
    }



    // Display attendances

        finalData;
        @track recordsToDisplay;
        columns = COLUMNS;
    
        connectedCallback(){
            console.log('attendanceId',Id);
            fetchContactsByUserId({userId: Id})
            .then((result)=>{
                console.log('result',result);
                this.finalData = result;
                this.recordViewerHandler();
            })
        }
    
        recordViewerHandler() {
    
            let data = [];
            console.log('finalDate',this.finalData);
           console.log('substring',this.finalData[0].Date_and_Time_OUT__c.substring(0,10));
            for (let index = 0; index <= this.finalData.length; index++) {
                if(this.finalData[index] != undefined) {
                   // console.log('substring',Date_and_Time_IN.substring(0,10));
                    data.push({
                       // Attendance_Date : this.finalData[index].Date_and_Time_IN__c.substring(0,10),
                        Date_and_Time_IN : this.finalData[index].Date_and_Time_IN__c,
                        Date_and_Time_OUT : this.finalData[index].Date_and_Time_OUT__c,
                        Total_Worked_Hours : this.finalData[index].Total_Worked_Hours__c,
                    });
                    console.log('data',data);
                }   
            }
            this.recordsToDisplay = data;
            console.log('recordsToDisplay',this.recordsToDisplay);
        }
}