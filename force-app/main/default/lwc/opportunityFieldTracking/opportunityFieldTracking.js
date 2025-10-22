import { LightningElement, wire, track } from 'lwc';
import getOpportunityTracking from '@salesforce/apex/FieldTrackingController.getOpportunityTracking';

export default class OpportunityFieldTracking extends LightningElement {
    @track groupedOperations = [];

    columns = [
        { label: 'Field Name', fieldName: 'Harsh02__Field_Track__c' },
        { label: 'Object Name', fieldName: 'Harsh02__Object_Name__c' },
        { label: 'Date', fieldName: 'Harsh02__Action_Date__c', type: 'date' },
        { label: 'Time', fieldName: 'Harsh02__Action_Time__c', type: 'time'},
        { label: 'Status', fieldName: 'Harsh02__Status__c' },
        { label: 'Old Value', fieldName: 'Harsh02__Old_Value__c' },
        { label: 'New Value', fieldName: 'Harsh02__New_Value__c' },
        { label: 'User', fieldName: 'Harsh02__User__c' },
        { label: 'Opportunity Name', fieldName: 'Harsh02__Identification__c' }
    ];

    @wire(getOpportunityTracking)
    wiredData({ data, error }) {
        if (data) {
            this.groupedOperations = this.processAndGroupData(data);
        } else if (error) {
            console.error(error);
        }
    }

    processAndGroupData(records) {
        const groups = {};

        records.forEach(record => {
            const groupKey = record.Harsh02__Status__c;

            if (!groups[groupKey]) {
                groups[groupKey] = {
                    key: groupKey,
                    title: `${groupKey} Operations`, 
                    records: []
                };
            }

            groups[groupKey].records.push({ ...record});
        });

        return Object.values(groups);
    }
}
