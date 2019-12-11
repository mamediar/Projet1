trigger EventTrigger on Event (before insert,                 
                                     after insert,                                       
                                     before update, 
                                     after update, 
                                     before delete, 
                                     after delete, 
                                     after undelete) {
new EventHandler().run();
}