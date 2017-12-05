@isTest 
public class TestTaskUpdate {
    static testMethod void insertNewUser(){
        Task t = new Task();
        Task t1 = new Task();
        Task t2 = new Task();
        Task t3 = new Task();
        Task t4 = new Task();
        Task t5 = new Task();
        Task t6 = new Task();
        t.Subject = 'Email: Test Email';
        t1.Subject = 'Call';
        t2.Subject = 'Call Left Voicemail';
        t3.Subject = 'Call No Voicemail';
        t4.Subject = 'Email Connect';
        t5.Subject = 'Meeting';
        t6.Subject = 'Demo';
        insert t;
        insert t1;
        insert t2;
        insert t3;
        insert t4;
        insert t5;
        insert t6;
    }
}