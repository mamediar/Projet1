trigger AppointmentTrigger on XCS_Appointment__c (before insert,after insert, 
                                            before update, after update, 
                                            before delete, after delete,
                                            after undelete) {
    new AppointmentTriggerHandler().run();
}