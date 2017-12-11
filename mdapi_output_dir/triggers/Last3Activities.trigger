trigger Last3Activities on Task (after insert) {
    /*
    // ---- Here Be The Old Code
    //
    List<Task> tsk = new List<Task>{};
    Map<String, Object> params = new Map<String, Object>();
        for(Task t: Trigger.new){
            String ObjectType = '';
            String myID = t.WhoId;
            String activityID = t.Id;
            if(myID != null){
                if(myID.left(3)=='00Q'){
                    ObjectType = 'Lead';
                }else if(myID.left(3)=='003'){
                    ObjectType = 'Contact';
                }
        	}
                params.put('ID',myID);
                params.put('ObjectType',ObjectType);
                params.put('ActivityID',activityID);
                
                Flow.Interview.X3Activities myFlow = new Flow.Interview.X3Activities(params);
                myFlow.start();
                
        }*/
        //
        // ---- Here Be The New Code
        //
    List<Task> hasId = new List<Task>();
    List<ID> noId = new List<ID>();

    for(Task t: Trigger.new){
        if(t.WhoId == null){
            noId.add(t.Id);
        }else{
            hasId.add(t);
        }
    }

    if(hasId.size()>0){ActivityTracking.CalculateActivity(hasId);}
    if(noId.size()>0){ActivityTracking.CalculateActivityFuture(noId);}
}