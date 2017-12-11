trigger LeadTrigger on Lead (before update) {

    List<Lead> clearList = new List<Lead>();
    List<Lead> resetList = new List<Lead>();

    //List<Lead> theLeads = new List<Lead>();

    for(Lead l: Trigger.new){
        if(l.Clear_Tracking__c != Trigger.oldMap.get(l.Id).Clear_Tracking__c ){
            clearList.add(l);
        }
        if(l.Reset_Tracking__c != Trigger.oldMap.get(l.Id).Reset_Tracking__c){
            resetList.add(l);
        }
    }

    if(clearList.size()> 0){
        ActivityTracking.ClearTracking(clearList);
    }
    if(resetList.size()> 0){
        ActivityTracking.ReCalcActivity(resetList);
        //Update resetList;
    }
    /*
    for(Lead l: Trigger.new){
        System.debug('Email 1: ' + l.X1st_Email_Sent__c);
        System.debug('Email 2: ' + l.X2nd_Email_Sent__c);
        System.debug('Email 3: ' + l.X3rd_Email_Sent__c);

        System.debug('Call 1: ' + l.X1st_Call_Sent__c);
        System.debug('Call 2: ' + l.X2nd_Call_Sent__c);
        System.debug('Call 3: ' + l.X3rd_Call_Sent__c);
    }*/
}