import { LightningElement, wire, track } from 'lwc';
import getOpportunityTracking from '@salesforce/apex/FieldTrackingController.getOpportunityTracking';

export default class OpportunityFieldTracking extends LightningElement {
    @track groupedOperations = [];
    nsPrefix = '';

    columns = [];

    connectedCallback() {
        this.columns = [
            { label: 'Field Name', fieldName: this.nsPrefix + 'Field_Track__c' },
            { label: 'Object Name', fieldName: this.nsPrefix + 'Object_Name__c' },
            { label: 'Date', fieldName: this.nsPrefix + 'Action_Date__c', type: 'date' },
            { label: 'Time', fieldName: this.nsPrefix + 'Action_Time__c', type: 'time' },
            { label: 'Status', fieldName: this.nsPrefix + 'Status__c' },
            { label: 'Old Value', fieldName: this.nsPrefix + 'Old_Value__c' },
            { label: 'New Value', fieldName: this.nsPrefix + 'New_Value__c' },
            { label: 'User', fieldName: this.nsPrefix + 'User__c' },
            { label: 'Identifier', fieldName: this.nsPrefix + 'Identification__c' }
        ];
    }

    @wire(getOpportunityTracking)
    wiredData({ data, error }) {
        if (data) {
            if (data.length > 0 && this.nsPrefix === '') {
                const sampleField = Object.keys(data[0]).find(f => f.endsWith('Field_Track__c'));
                if (sampleField && sampleField.includes('__')) {
                    this.nsPrefix = sampleField.split('__')[0] + '__';
                }
            }

            this.groupedOperations = this.processAndGroupData(data);
        } else if (error) {
            console.error(error);
        }
    }

    processAndGroupData(records) {
        const groups = {};

        records.forEach(record => {
            const statusField = this.nsPrefix + 'Status__c';
            const groupKey = record[statusField] || 'Unspecified';

            if (!groups[groupKey]) {
                groups[groupKey] = {
                    key: groupKey,
                    title: `${groupKey} Operations`,
                    records: []
                };
            }

            groups[groupKey].records.push({ ...record });
        });

        return Object.values(groups);
    }
}
