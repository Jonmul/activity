@isTest 
public class TestTaskUpdate {
    static testMethod void insertNewUser(){

        Lead l = new Lead();
        Contact c = new Contact();

        l.LastName = 'TestLead';
        l.Company = 'ABC Company';

        c.LastName = 'TestContact';

        insert l;
        insert c;

        Task t1 = new Task();
        Task t2 = new Task();
        Task t3 = new Task();
        Task t4 = new Task();
        Task t5 = new Task();
        Task t6 = new Task();
        Task t7 = new Task();
        Task t8 = new Task();
        Task t9 = new Task();
        Task t10 = new Task();
        Task t11 = new Task();

        t1.Subject = 'Call';
        t2.Subject = 'Call Connect';
        t3.Subject = 'Call No Voicemail';
        t4.Subject = 'Call';
        t5.Subject = 'Call no answer';
        t6.Subject = 'Email';
        t7.Subject = 'Email Connect';
        t8.Subject = 'Email Again';
        t9.Subject = 'Email RE: This thing';
        t10.Subject = 'Email';
        t11.Subject = 'Meeting';

        t1.Type = 'Call';
        t6.Type = 'Email';

        t1.WhoId = l.Id;
        t2.WhoId = l.Id;
        t3.WhoId = l.Id;
        t4.WhoId = l.Id;
        t5.WhoId = l.Id;
        t6.WhoId = l.Id;
        t7.WhoId = l.Id;
        t8.WhoId = l.Id;
        t9.WhoId = l.Id;
        t10.WhoId = l.Id;
        t11.WhoId = l.Id;

        t1.Status='Completed';
        t2.Status='Completed';
        t3.Status='Completed';
        t4.Status='Completed';
        t5.Status='Completed';
        t6.Status='Completed';
        t7.Status='Completed';
        t8.Status='Completed';
        t9.Status='Completed';
        t10.Status='Completed';
        t11.Status='Completed';

        insert t1;
        insert t2;
        insert t3;
        insert t4;
        insert t5;
        insert t6;
        insert t7;
        insert t8;
        insert t9;
        insert t10;
        insert t11;

        /*
        * For Reference:

            t1.Subject = 'Call';
            t2.Subject = 'Call Connect';
            t3.Subject = 'Call No Voicemail';
            t4.Subject = 'Call';
            t5.Subject = 'Call no answer';
            t6.Subject = 'Email';
            t7.Subject = 'Email Connect';
            t8.Subject = 'Email Again';
            t9.Subject = 'Email RE: This thing';
            t10.Subject = 'Email';
        */

        System.assertEquals(t1.CreatedDate,l.X1st_Call_Sent__c);
        System.assertEquals(t2.CreatedDate,l.X2nd_Call_Sent__c);
        System.assertEquals(t3.CreatedDate,l.X3rd_Call_Sent__c);
        System.assertEquals(t4.CreatedDate,l.X4th_Call_Sent__c);
        System.assertEquals(t5.CreatedDate,l.X5th_Call_Sent__c);

        System.assertEquals(t6.CreatedDate,l.X1st_Email_Sent__c);
        System.assertEquals(t7.CreatedDate,l.X2nd_Email_Sent__c);
        System.assertEquals(t8.CreatedDate,l.X3rd_Email_Sent__c);
        System.assertEquals(t9.CreatedDate,l.X4th_Email_Sent__c);
        System.assertEquals(t10.CreatedDate,l.X5th_Email_Sent__c);

        Test.setCreatedDate(t1.Id, DateTime.newInstance(2012,12,12));
        Test.setCreatedDate(t2.Id, DateTime.newInstance(2012,12,13));
        Test.setCreatedDate(t3.Id, DateTime.newInstance(2012,12,14));
        Test.setCreatedDate(t4.Id, DateTime.newInstance(2012,12,15));
        Test.setCreatedDate(t5.Id, DateTime.newInstance(2012,12,16));

        Test.setCreatedDate(t6.Id, DateTime.newInstance(2012,12,17));
        Test.setCreatedDate(t7.Id, DateTime.newInstance(2012,12,18));
        Test.setCreatedDate(t8.Id, DateTime.newInstance(2012,12,19));
        Test.setCreatedDate(t9.Id, DateTime.newInstance(2012,12,20));
        Test.setCreatedDate(t10.Id, DateTime.newInstance(2012,12,21));

        l.Clear_Tracking__c = DateTime.newInstance(2011,12,12);
        Update l;
        c.Clear_Tracking__c = DateTime.newInstance(2011,12,12);
        Update c;

        l.Reset_Tracking__c = DateTime.newInstance(2011,12,12);
        Update l;
        c.Reset_Tracking__c = DateTime.newInstance(2011,12,12);
        Update c;       

        System.assertEquals(t1.CreatedDate,l.X1st_Call_Sent__c);
        System.assertEquals(t2.CreatedDate,l.X2nd_Call_Sent__c);
        System.assertEquals(t3.CreatedDate,l.X3rd_Call_Sent__c);
        System.assertEquals(t4.CreatedDate,l.X4th_Call_Sent__c);
        System.assertEquals(t5.CreatedDate,l.X5th_Call_Sent__c);

        System.assertEquals(t6.CreatedDate,l.X1st_Email_Sent__c);
        System.assertEquals(t7.CreatedDate,l.X2nd_Email_Sent__c);
        System.assertEquals(t8.CreatedDate,l.X3rd_Email_Sent__c);
        System.assertEquals(t9.CreatedDate,l.X4th_Email_Sent__c);
        System.assertEquals(t10.CreatedDate,l.X5th_Email_Sent__c);
    }
}