trigger FeedItemTrigger on Create_Feed_Item__e (after insert) {
        
    System.debug('Hola');
    System.debug(trigger.new);
    for(Create_Feed_Item__e temp: trigger.new){
        System.debug('********' + temp);
        List<String> idDocumentList = new List<String>();
        List<Attachment> lAtt = new List<Attachment>();
        if(!''.equals(temp.Lista_File__c) && temp.Lista_File__c != null)
        {
            idDocumentList = temp.Lista_File__c.split(',');
        }

        XCSReclamiUtils.creaCorrispondenza(new case(Id=temp.recordId__c), temp.Messaggio__c,idDocumentList ); 

    }
    
}