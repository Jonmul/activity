public with sharing class ActivityTracking {
    public ActivityTracking() {
        
    }

    // Allows for use of method with an empty date value
    /*
    public static void ReCalcActivity(SObject[] myLeads){
        ReCalcActivity(myLeads,Datetime.newInstance(1900, 1, 1));
    }
    */

    // Clears tracking activity and recalculates the Activity tracking from the myDate
    // I.e. if myDate = Nov. 1st, 2017, then the Activity tracking will calculate as of Nov. 1st, 2017
    public static void ReCalcActivity(SObject[] myLeads){
        //set<ID> peopleIDs = new set<ID>(); // Set of People IDs
        Map<Id,SObject> thePeople = new Map<Id,SObject>(myLeads);
        //List<String> idList = new List<String>();

        for(SObject p:myLeads){
            ClearTracking(p);
            //peopleIDs.add((String)p.get('Id'));
            //idList.add((String)p.get('Id'));
        }


        List<Task> allActivity = [SELECT Id,WhoId,CreatedDate,Subject,Type,IsClosed FROM task WHERE WhoId IN :myLeads AND IsClosed=true ORDER BY CreatedDate desc];
        List<Task> theActivity = new List<Task>();

        for(Task t: allActivity){
            SObject p = thePeople.get(t.WhoId);
            Datetime resetTime = (Datetime)p.get('Reset_Tracking__c');
            if(resetTime <= t.CreatedDate){
                theActivity.add(t);
            }
        }

        CalculateActivity(theActivity);
    }

    public static void ClearTracking(SObject[] records){
        for(SObject p: records){
            ClearTracking(p);
        }
    }

    // This is meant to clear out all activity logged into the designated Lead/Contact date fields
    public static void ClearTracking(SObject record){
        

        // Clear Call date fields
        record.put('X1st_Call_Sent__c', null);
        record.put('X2nd_Call_Sent__c', null);
        record.put('X3rd_Call_Sent__c', null);
        record.put('X4th_Call_Sent__c', null);
        record.put('X5th_Call_Sent__c', null);
        record.put('X6th_Call_Sent__c', null);
        record.put('X7th_Call_Sent__c', null);
        record.put('X8th_Call_Sent__c', null);
        record.put('X9th_Call_Sent__c', null);
        record.put('X10th_Call_Sent__c', null);
        
        // Clear Email date fields
        record.put('X1st_Email_Sent__c', null);
        record.put('X2nd_Email_Sent__c', null);
        record.put('X3rd_Email_Sent__c', null);
        record.put('X4th_Email_Sent__c', null);
        record.put('X5th_Email_Sent__c', null);
        record.put('X6th_Email_Sent__c', null);
        record.put('X7th_Email_Sent__c', null);
        record.put('X8th_Email_Sent__c', null);
        record.put('X9th_Email_Sent__c', null);
        record.put('X10th_Email_Sent__c', null);

        // Might remove to prevent DML overload in batch calls
        //Update record;
    }


    // Pulls in a list of tasks, and iterates over the tasks to update call & email activity
    // useActivityDate: 
    // -----Allows for this Method to be used to update using old task data, or new task data
    // -----I.e. if I want to use the date on the Activity Record, then I would set useActivityDate = true.
    // tasks: 
    // -----Requires- whoID, type,id,createddate,subject,type
    public static void CalculateActivity(Task[] tasks){
        /***************
        * Variables
        ***************/
        list<Task> l_CTasks = new list<Task>(); // Tasks we'll be updating
        list<Task> l_LTasks = new list<Task>(); // Tasks we'll be updating
        set<ID> s_ContactIDs = new set<ID>(); // Set of Contact IDs
        set<ID> s_LeadIDs = new set<ID>(); // Set of Lead IDs
        Datetime myDate = Datetime.now();
        Map<Task,SObject> myPeopleMap = new Map<Task,SObject>();

        /***************
        * Initial Loop
        ***************/
        for(Task t:tasks) {
            // Add Task to working list and collect the Contact ID
            //if (t.WhatId == null && t.Subject.startsWith('Email:') && t.WhoId != null) {
            if (t.WhoId != null) {
                if (String.valueOf(t.WhoId).startsWith('003')){
                    l_CTasks.add(t);
                    s_ContactIDs.add(t.WhoId);
                } else if (String.valueOf(t.WhoId).startsWith('00Q')){
                    l_LTasks.add(t);
                    s_LeadIDs.add(t.WhoId);
                }
            }
        }

        List<Lead> theLeads = [SELECT Id,title,X1st_Email_Sent__c,X2nd_Email_Sent__c,X3rd_Email_Sent__c,X4th_Email_Sent__c,X5th_Email_Sent__c,X6th_Email_Sent__c,X7th_Email_Sent__c,X8th_Email_Sent__c,X9th_Email_Sent__c,X10th_Email_Sent__c,X1st_Call_Sent__c,X2nd_Call_Sent__c,X3rd_Call_Sent__c,X4th_Call_Sent__c,X5th_Call_Sent__c,X6th_Call_Sent__c,X7th_Call_Sent__c,X8th_Call_Sent__c,X9th_Call_Sent__c,X10th_Call_Sent__c FROM Lead WHERE Id IN :s_LeadIDs ];
        List<Contact> theContacts = [SELECT Id,title,X1st_Email_Sent__c,X2nd_Email_Sent__c,X3rd_Email_Sent__c,X4th_Email_Sent__c,X5th_Email_Sent__c,X6th_Email_Sent__c,X7th_Email_Sent__c,X8th_Email_Sent__c,X9th_Email_Sent__c,X10th_Email_Sent__c,X1st_Call_Sent__c,X2nd_Call_Sent__c,X3rd_Call_Sent__c,X4th_Call_Sent__c,X5th_Call_Sent__c,X6th_Call_Sent__c,X7th_Call_Sent__c,X8th_Call_Sent__c,X9th_Call_Sent__c,X10th_Call_Sent__c FROM Contact WHERE Id IN :s_ContactIDs ];

        //Map<Id,Lead> leadMap = new Map<Id,Lead>(theLeads);
        //Map<Id,Contact> contactMap = new Map<Id,Contact>(theContacts);
        Map<Id,SObject> peopleMap = new Map<Id,SObject>();
        peopleMap.putAll(theLeads);
        peopleMap.putAll(theContacts);

        //for(Lead l:theLeads){
            //l.title = 'this works';
            // This was to test the 'state' of the record being sent over.
            // Was curious whether Apex passes the full current state in-memory without saving?
            // Turns out, this does work!               
            //l.X1st_Call_Sent__c = Datetime.now();
            
            //UpdateCalls(l);
            //Calculate Activity
        //}

        for(Task t: tasks){
            if(t.WhoId != null && t.IsClosed==true){
                String myType = GetType(t);
                if(myType=='email'){
                    UpdateEmails(peopleMap.get(t.WhoId),t.CreatedDate);
                }else if(myType=='call'){
                    UpdateCalls(peopleMap.get(t.WhoId),t.CreatedDate);
                }
            }
        }

        //Update theLeads;
        //Update theContacts;
    }

    // Updates the Call history on the Lead or Contact record
    // myPerson:
    // ------- Must by Lead or Contact
    // myDate: (Optional)
    // ------- Specify the datetime to use. Uses 'now()' if no datetime is set
    // Required: Must update the Lead or Contact record after these methods are called.
    public static void UpdateCalls(SObject myPerson){
        Datetime myDate = Datetime.now();
        UpdateCalls(myPerson,myDate);
    }
    public static void UpdateCalls(SObject myPerson,Datetime myDate){

        //Call variables
        Datetime call1 = (Datetime)myPerson.get('X1st_Call_Sent__c');
        Datetime call2 = (Datetime)myPerson.get('X2nd_Call_Sent__c');
        Datetime call3 = (Datetime)myPerson.get('X3rd_Call_Sent__c');
        Datetime call4 = (Datetime)myPerson.get('X4th_Call_Sent__c');
        Datetime call5 = (Datetime)myPerson.get('X5th_Call_Sent__c');
        Datetime call6 = (Datetime)myPerson.get('X6th_Call_Sent__c');
        Datetime call7 = (Datetime)myPerson.get('X7th_Call_Sent__c');
        Datetime call8 = (Datetime)myPerson.get('X8th_Call_Sent__c');
        Datetime call9 = (Datetime)myPerson.get('X9th_Call_Sent__c');
        Datetime call10 = (Datetime)myPerson.get('X10th_Call_Sent__c');

        //Check which Call field needs to be updated
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
        }else if(call6 == null){
            myPerson.put('X6th_Call_Sent__c', myDate);
        }else if(call7 == null){
            myPerson.put('X7th_Call_Sent__c', myDate);
        }else if(call8 == null){
            myPerson.put('X8th_Call_Sent__c', myDate);
        }else if(call9 == null){
            myPerson.put('X9th_Call_Sent__c', myDate);
        }else if(call10 == null){
            myPerson.put('X10th_Call_Sent__c', myDate);
        }
    }

    // Updates the Email history on the Lead or Contact record
    // myPerson:
    // ------- Must by Lead or Contact
    // myDate: (Optional)
    // ------- Specify the datetime to use. Uses 'now()' if no datetime is set
    // Required: Must update the Lead or Contact record after these methods are called.
    public static void UpdateEmails(SObject myPerson){
        Datetime myDate = Datetime.now();
        UpdateEmails(myPerson,myDate);
    }
    public static void UpdateEmails(SObject myPerson,Datetime myDate){ 
        //Email Variables
        Datetime email1 = (Datetime)myPerson.get('X1st_Email_Sent__c');
        Datetime email2 = (Datetime)myPerson.get('X2nd_Email_Sent__c');
        Datetime email3 = (Datetime)myPerson.get('X3rd_Email_Sent__c');
        Datetime email4 = (Datetime)myPerson.get('X4th_Email_Sent__c');
        Datetime email5 = (Datetime)myPerson.get('X5th_Email_Sent__c');
        Datetime email6 = (Datetime)myPerson.get('X6th_Email_Sent__c');
        Datetime email7 = (Datetime)myPerson.get('X7th_Email_Sent__c');
        Datetime email8 = (Datetime)myPerson.get('X8th_Email_Sent__c');
        Datetime email9 = (Datetime)myPerson.get('X9th_Email_Sent__c');
        Datetime email10 = (Datetime)myPerson.get('X10th_Email_Sent__c');

        //Check which email field needs to be updated
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
        }else if(email6 == null){
            myPerson.put('X6th_Email_Sent__c', myDate);
        }else if(email7 == null){
            myPerson.put('X7th_Email_Sent__c', myDate);
        }else if(email8 == null){
            myPerson.put('X8th_Email_Sent__c', myDate);
        }else if(email9 == null){
            myPerson.put('X9th_Email_Sent__c', myDate);
        }else if(email10 == null){
            myPerson.put('X10th_Email_Sent__c', myDate);
        }
        //myPerson.put('X1st_Email_Sent__c', myDate);
        Datetime email12 = (Datetime)myPerson.get('X1st_Email_Sent__c');
        Datetime email22 = (Datetime)myPerson.get('X2nd_Email_Sent__c');
        Datetime email32 = (Datetime)myPerson.get('X3rd_Email_Sent__c');
        Datetime email42 = (Datetime)myPerson.get('X4th_Email_Sent__c');
        Datetime email52 = (Datetime)myPerson.get('X5th_Email_Sent__c');
        Datetime email62 = (Datetime)myPerson.get('X6th_Email_Sent__c');
        Datetime email72 = (Datetime)myPerson.get('X7th_Email_Sent__c');
        Datetime email82 = (Datetime)myPerson.get('X8th_Email_Sent__c');
        Datetime email92 = (Datetime)myPerson.get('X9th_Email_Sent__c');
        Datetime email102 = (Datetime)myPerson.get('X10th_Email_Sent__c');
    }

    // Returns the activity type of the record
    // Uses Subject line for higher accuracy when necessary (if Type is missing somehow)
    public static String GetType(Task t){
        
        if(t.Type != null){
            if( t.Type.toLowerCase().contains('email')){
                return 'email';
            }
            else if(t.Type.toLowerCase().contains('call')){
                return 'call';
            }
        }else if(t.Subject != null){
            if(t.Subject.toLowerCase().contains('email')){
                return 'email';
            }
            else if(t.Subject.toLowerCase().contains('call')){
                return 'call';
            }
        }
        return 'other';
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
