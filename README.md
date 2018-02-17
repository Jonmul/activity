# Activity Cadence Tracking  App
Hello!

This Salesforce application is built to support a 10-call and 10-email cadence tracking, and dynamically control where the tracking starts, ends, and (as needed) reset/recalculate the tracking as of a specific date. Only tracks the first activity of any given day. I.e. 10 calls to 1 Lead on the same day are not tracked as 1 through 10 calls, but simply 1 call. Generally, this makes it very simple to report on a more controlled outreach cadence, and only taking into account Activity as of a system/admin-defined datetime.

The overall functionality is built to support Admin control over how the reset/clearing functionality behaves, generally reducing the need for Developer intervention when adjusting functionality. For example: nothing in this code will in-of-itself trigger clearing Activity, I've added a process-builder update to control the timestamping to reset and/or clear activity in Production.

Supports tracking on Lead & Contact records. 

As most core functionality is simply calling a generic "Object", this application could technically support tracking on additional objects that utilize Activities. Provided the corresponding Activity fields and 'Key Fields' are added to the Object(s), similar methods added to a Trigger for said Object, and "Activity" Trigger updated for full suport.

## Functionality & Key Fields

- Clear Tracking
  - Type: DateTime
  - Effect: Changes to this field will trigger a full-clearing of Activity tracking on the corresponding Object.
  - Description: This is built with the intention that any admin or developer can change the timestamp value to trigger clearing of the Activity tracking on the Lead / Contact Records. This functionality requires a workflow-rule, Process-Builder, or similar field update to trigger the functionality.

- Reset Tracking
  - Type: DateTime
  - Effect: Changes to this field will trigger a reset of Activity tracking on the corresponding Object, tracking Calls & Emails back to the exact DateTime value.
  - Description: This is built with the intention that any admin or developer can change the timestamp value to trigger Reset of the Activity tracking on the Lead / Contact Records. This functionality requires a workflow-rule, Process-Builder, or similar field update to trigger the functionality.

- Last Call
  - Type: Date
  - Effect: Managed by App, tracks the last call made against the record.
  - Description: This is generally used to see the Last Call to the record, could be used externally (e.g. Process-Builder by an Admin). This is similar to the default Salesforce-managed "Last Activity", but is more flexible and specific to Call Activity.

- Last Email
  - Type: Date
  - Effect: Managed by App, tracks the last email made against the record.
  - Description: This is generally used to see the Last Email to the record, could be used externally (e.g. Process-Builder by an Admin). This is similar to the default Salesforce-managed "Last Activity", but is more flexible and specific to Call Activity.

- Last Activity Trigger
  - Type: DateTime
  - Effect: Has the Last Activity DateTime of a record.
  - Description: To be usable by Admin to build workflows/Process-builder updates on a record based on Last Activity changing (when default Salesforce-managed Last Activity is unavailable in the tool).

- 1st -> 10th Call (10 separate fields)
  - Type: Date
  - Effect: Stores Date of Activity, calculated by the application
  - Description: NA
  
- 1st -> 10th Email (10 separate fields)
  - Type: Date
  - Effect: Stores Date of Activity, calculated by the application
  - Description: NA

## Dev, Build and Test
This application has unit-tests built-in, and has been tested to function properly on bulk record updates and inserts. 

For Reseting Activity: The limits of the functionality are theoretically higher than any realistic operations a normal system may face - generally are limited by the SOQL query limits and potential number of Activities against a set of records.

E.g. SOQL query limit is 50,000 records, so a batch update of Leads or Contacts would need to have less than 50,000 Activity records. With typical high batch sizes of 200-500; there is a 250 - 100 average Activities per-record maximum processing ability. Given the user-defined timeframe for reseting Activity, it is very unlikely you will hit that limit (and you may simply reduce the batch size).

Other functionality is not expected to hit scaling issues.

## Resources
jonmul3@gmail.com if you have questions! 

## Description of Files and Directories
/force-app/main/default/objects/Lead/fields/

Contains core Lead fields

/force-app/main/default/objects/Contact/fields/

Contains core Contact fields

/force-app/main/default/classes/

Contains 3 core classes:
- ActivityHelper
  - Helper class that detects the type of Activity based on Subject (if Type is unavailable)

- ActivityTracking
  - Core functionality class for all Tracking calculation.

- TestTaskUpdate
  - Test Class with basic unit tests and code-coverage.
  
/force-app/main/default/triggers/

Contains 3 core Triggers:
- Contact Trigger
  - Trigger for Contact-record updates on the core reset/clearing fields, triggering functionality in the application
- Lead Trigger
  - Trigger for Lead-record updates on the core reset/clearing fields, triggering functionality in the application
- Last3Activities
  - Contains functionality to trigger tracking against the Lead/Contact Objects when a new Activity is inserted. Contact tracking is done via asynchronously due to Salesforce's backend association of email Activity with Email-to-Salesforce.

## Issues
Last Activity Trigger does not currently function as intended when using Reset_Activity. Needs to be adjusted to us the Activity date and/or time of the Activity record(s), however, this is not core functionality.

## Storing queries for future use:

sfdx force:data:soql:query --query "Select t.Who.FirstName, t.Who.LastName, t.Who.Id, t.who.email, t.WhoId, t.Who.Type, t.Status, t.Id, t.Description, t.ActivityDate From Task t"
