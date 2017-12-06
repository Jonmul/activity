public with sharing class ActivityTracking {
    public ActivityTracking() {
        
    }

    // Allows for use of method with an empty date value
    public static void ReCalcActivity(Lead myLead){
        ReCalcActivity(myLead,Date.newInstance(1900, 1, 1));
    }

    // Clears tracking activity and recalculates the Activity tracking from the myDate
    // I.e. if myDate = Nov. 1st, 2017, then the Activity tracking will calculate as of Nov. 1st, 2017
    public static void ReCalcActivity(Lead myLead,Date myDate ){

    }

    public static void ClearActivity(SObject record){

    }

    public static void CalculateActivity(Task[] tasks){
        /***************
        * Variables
        ***************/
        //list<Task> l_Tasks = new list<Task>(); // Tasks we'll be updating
        set<ID> s_ContactIDs = new set<ID>(); // Set of Contact IDs
        set<ID> s_LeadIDs = new set<ID>(); // Set of Lead IDs

        /***************
        * Initial Loop
        ***************/
        for(Task t:tasks) {
             
            // Add Task to working list and collect the Contact ID
            //if (t.WhatId == null && t.Subject.startsWith('Email:') && t.WhoId != null) {
            if (t.WhoId != null) {
                // only for Contacts
                if (String.valueOf(t.WhoId).startsWith('003')){
                    //l_Tasks.add(t);
                    s_ContactIDs.add(t.WhoId);
                } else if (String.valueOf(t.WhoId).startsWith('00Q')){
                    //l_Tasks.add(t);
                    s_LeadIDs.add(t.WhoId);
                }
            }
             
        }

        List<Lead> theLeads = [SELECT Id,title,X1st_Email_Sent__c,X2nd_Email_Sent__c,X3rd_Email_Sent__c,X4th_Email_Sent__c,X5th_Email_Sent__c,X1st_Call_Sent__c,X2nd_Call_Sent__c,X3rd_Call_Sent__c,X4th_Call_Sent__c,X5th_Call_Sent__c FROM Lead WHERE Id IN :s_LeadIDs ];

        for(Lead l:theLeads){
            //l.title = 'this works';
            UpdateCalls(l);
            //Calculate Activity
        }
        Update theLeads;
    }

    public static void UpdateCalls(SObject myPerson){
        Datetime myDate = Datetime.now();
        UpdateCalls(myPerson,myDate);
    }

        
    public static void UpdateCalls(SObject myPerson,Datetime myDate){    
        //Datetime myDate = Datetime.now();

        //calls
        Datetime call1 = (Datetime)myPerson.get('X1st_Call_Sent__c');
        Datetime call2 = (Datetime)myPerson.get('X2nd_Call_Sent__c');
        Datetime call3 = (Datetime)myPerson.get('X3rd_Call_Sent__c');
        Datetime call4 = (Datetime)myPerson.get('X4th_Call_Sent__c');
        Datetime call5 = (Datetime)myPerson.get('X5th_Call_Sent__c');


        if(call1 == null){
            myPerson.put('X1st_Call_Sent__c', myDate);
        }else if(call2 == null){
            myPerson.put('X2nd_Call_Sent__c', myDate);
        }else if(call3 == null){
            myPerson.put('X3rd_Call_Sent__c', myDate);
        }else if(call4 == null){
            myPerson.put('X4th_Call_Sent__c', myDate);
        }else if(call5 == null){
            myPerson.put('X5th_Call_Sent__c', myDate);
        }
        //emails?
        Datetime email1 = (Datetime)myPerson.get('X1st_Email_Sent__c');
        Datetime email2 = (Datetime)myPerson.get('X2nd_Email_Sent__c');
        Datetime email3 = (Datetime)myPerson.get('X3rd_Email_Sent__c');
        Datetime email4 = (Datetime)myPerson.get('X4th_Email_Sent__c');
        Datetime email5 = (Datetime)myPerson.get('X5th_Email_Sent__c');
    }

    /* Temporary holding place for field API names
        X1st_Call_Sent__c
        X1st_Email_Sent__c
        X2nd_Call_Sent__c
        X2nd_Email_Sent__c
        X3rd_Call_Sent__c
        X3rd_Email_Sent__c
        X4th_Call_Sent__c
        X4th_Email_Sent__c
        X5th_Call_Sent__c
        X5th_Email_Sent__c
    */

   
    
}
