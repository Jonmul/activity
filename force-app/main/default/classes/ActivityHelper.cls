public with sharing class ActivityHelper {
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
}