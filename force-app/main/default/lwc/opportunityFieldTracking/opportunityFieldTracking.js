import { LightningElement, wire, track } from 'lwc';
import getOpportunityTracking from '@salesforce/apex/FieldTrackingController.getOpportunityTracking';

export default class OpportunityFieldTracking extends LightningElement {
    @track groupedOperations = [];

    columns = [
        { label: 'Field Name', fieldName: 'Field_Track__c' },
        { label: 'Object Name', fieldName: 'Object_Name__c' },
        { label: 'Date', fieldName: 'Action_Date__c', type: 'date' },
        { label: 'Time', fieldName: 'Action_Time__c', type: 'time'},
        { label: 'Status', fieldName: 'Status__c' },
        { label: 'Old Value', fieldName: 'Old_Value__c' },
        { label: 'New Value', fieldName: 'New_Value__c' },
        { label: 'User', fieldName: 'User__c' },
        { label: 'Identifier', fieldName: 'Identification__c' }
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
            const groupKey = record.Status__c;

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