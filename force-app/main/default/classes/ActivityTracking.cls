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

    // This is meant to clear out all activity logged into the designated Lead/Contact date fields
    public static void ClearTracking(SObject record){
        
        // Clear Call date fields
        record.put('X1st_Call_Sent__c', null);
        record.put('X2nd_Call_Sent__c', null);
        record.put('X3rd_Call_Sent__c', null);
        record.put('X4th_Call_Sent__c', null);
        record.put('X5th_Call_Sent__c', null);

        // Clear Email date fields
        record.put('X1st_Email_Sent__c', null);
        record.put('X2nd_Email_Sent__c', null);
        record.put('X3rd_Email_Sent__c', null);
        record.put('X4th_Email_Sent__c', null);
        record.put('X5th_Email_Sent__c', null);

        // Might remove to prevent DML overload in batch calls
        Update record;
    }

    public static void CalculateActivity(Task[] tasks){
        /***************
        * Variables
        ***************/
        list<Task> l_CTasks = new list<Task>(); // Tasks we'll be updating
        list<Task> l_LTasks = new list<Task>(); // Tasks we'll be updating
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
                    l_CTasks.add(t);
                    s_ContactIDs.add(t.WhoId);
                } else if (String.valueOf(t.WhoId).startsWith('00Q')){
                    l_LTasks.add(t);
                    s_LeadIDs.add(t.WhoId);
                }
            }
             
        }

        List<Lead> theLeads = [SELECT Id,title,X1st_Email_Sent__c,X2nd_Email_Sent__c,X3rd_Email_Sent__c,X4th_Email_Sent__c,X5th_Email_Sent__c,X1st_Call_Sent__c,X2nd_Call_Sent__c,X3rd_Call_Sent__c,X4th_Call_Sent__c,X5th_Call_Sent__c FROM Lead WHERE Id IN :s_LeadIDs ];

        for(Lead l:theLeads){
            //l.title = 'this works';
            // This was to test the 'state' of the record being sent over.
            // Was curious whether Apex passes the full current state in-memory without saving?
            // Turns out, this does work!               
            //l.X1st_Call_Sent__c = Datetime.now();
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
    }
    public static void UpdateEmails(SObject myPerson){

        Datetime myDate = Datetime.now();
        UpdateEmails(myPerson,myDate);
    }

    public static void UpdateEmails(SObject myPerson,Datetime myDate){ 
        //emails?
        Datetime email1 = (Datetime)myPerson.get('X1st_Email_Sent__c');
        Datetime email2 = (Datetime)myPerson.get('X2nd_Email_Sent__c');
        Datetime email3 = (Datetime)myPerson.get('X3rd_Email_Sent__c');
        Datetime email4 = (Datetime)myPerson.get('X4th_Email_Sent__c');
        Datetime email5 = (Datetime)myPerson.get('X5th_Email_Sent__c');

        if(email1 == null){
            myPerson.put('X1st_Email_Sent__c', myDate);
        }else if(email2 == null){
            myPerson.put('X2nd_Email_Sent__c', myDate);
        }else if(email3 == null){
            myPerson.put('X3rd_Email_Sent__c', myDate);
        }else if(email4 == null){
            myPerson.put('X4th_Email_Sent__c', myDate);
        }else if(email5 == null){
            myPerson.put('X5th_Email_Sent__c', myDate);
        }
    }

    public static void UpdateType(Task[] tasks){
        for(Task t : tasks){
            if(t.Subject != null && t.Type == null){
                if(t.Subject.contains('Email Connect')){
                    t.Type = 'Email Connect';
                }
                else if(t.Subject.contains('Email')){
                    t.Type = 'Email';
                }
                else if(t.Subject.contains('Call No Voicemail')){
                    t.Type = 'Call No Voicemail';
                }
                else if(t.Subject.contains('Call Left Voicemail')){
                    t.Type = 'Call Left Voicemail';
                }
                else if(t.Subject.contains('Call')){
                    t.Type = 'Call';
                }
                else if(t.Subject.contains('Meeting')){
                    t.Type = 'Meeting';
                }
                else if(t.Subject.contains('Demo')){
                    t.Type = 'Demo';
                }
            }
        }        
    }
/*
            else {
                if(t.Subject.contains('Email')){
                    return 'Email';
                }else if(t.Subject.contains('Call')){
                    return 'Call';
                }
            }*/

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
