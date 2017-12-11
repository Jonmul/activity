trigger ContactTrigger on Contact (before update) {
    List<Contact> clearList = new List<Contact>();
    List<Contact> resetList = new List<Contact>();

    //List<Contact> theContacts = new List<Contact>();

    for(Contact l: Trigger.new){
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
}