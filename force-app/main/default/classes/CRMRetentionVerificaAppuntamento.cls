public class CRMRetentionVerificaAppuntamento implements Schedulable{
    
    public static FINAL string noteUTR = 'Retention TF - Coda APT - da UTR';
    public static FINAL string noteCS = 'Retention TF - Coda APT - da CS';
    public static FINAL string OCSNoteCS = 'Retention TF - Pianificato Recall telefonico - Coda APT - da CS';
    public static FINAL string OCSNoteUTR = 'Retention TF - Pianificato Recall telefonico - Coda APT - da UTR';
    
    public static void execute(SchedulableContext ct){
        Map<String,XCSNoteUtils.wrapNoteTitle> mapObjectNote = new Map<String,XCSNoteUtils.wrapNoteTitle>();
        List<String> caseIdFromEvent = new list<String>();
        List<Case> caseToInsert = new List<Case>();
        Recordtype rtNote = new Recordtype(id = RecordTypeUtil.getRecordType('XCS_Messaggio__c','Note'));
        ID recordtypeCase = RecordTypeUtil.getRecordtype('Case','CRMRetentionCliente');
        List<XCS_Messaggio__c> notesOCS = new List<XCS_Messaggio__c>();
     //   List<Case> caseToInsertUTR = new List<Case>();
        Group codaTfrApt = [Select id from group where Developername = 'Q369'][0];
        Product2 prdRet = [Select id from product2 where rss_External_Id__c = '6162'][0];
        List <Event> evList = [SELECT case__c FROM EVENT WHERE activityDate=YESTERDAY AND isChild = false AND (Disposition__r.External_Id__c in('AP19','AP20','AP21','AP22','AP28','AP29','AP1') OR Disposition__c = null) AND case__c != null];
        for(event ev : evList){
            caseIdFromEvent.add(ev.case__c);
        }
        List<CRM_Retention__c> retentionList = [Select id,case__r.Accountid,LoanNumber__c from CRM_Retention__c where ProductCode__c = 'PP' AND case__c IN :caseIdFromEvent];
        List<Event> evListFromUTR = [SELECT Id,case__r.NumeroPratica__c,case__r.Accountid, Prodotto__c, Product__c FROM Event where ActivityDate = Yesterday and isChild = false and product__r.name = 'Retention' and prodotto__c = 'Task Force'  and (Disposition__r.External_Id__c in('AP19','AP20','AP21','AP22','AP28','AP29','AP1') OR Disposition__c = null) and case__r.Categoria_riferimento__r.External_Id__c = '1036' and case__r.status != 'Annullato'];
        For(CRM_Retention__c ret : retentionList){
            caseToInsert.add(new Case(ProcessType__c = 'RetentionPrestiti_RetentionTF_APT',recordtypeid = recordtypeCase,Subject = 'Retention TF - Coda APT - da CS',OwnerId = codaTfrApt.id,NumeroPratica__c = ret.LoanNumber__c,accountId = ret.case__r.accountid,product__c = prdRet.id,categoria_riferimento__r = new XCS_Categoria__c(External_Id__c ='1036')));
      	}
        For(Event evUTR : evListFromUTR){
            caseToInsert.add(new Case(ProcessType__c = 'RetentionPrestiti_RetentionTF_APT',recordtypeid = recordtypeCase,Subject = 'Retention TF - Coda APT - da UTR',OwnerId = codaTfrApt.id,NumeroPratica__c = evUTR.case__r.NumeroPratica__c,accountId = evUTR.case__r.Accountid,product__c = prdRet.id,categoria_riferimento__r = new XCS_Categoria__c(External_Id__c ='1036')));
        }
        System.debug('CASE DA INSERIRE :' + caseToInsert);
        Insert caseToInsert;
        System.debug('CASE Inseriti  :' + caseToInsert);
        For(Case c : caseToInsert){
            if(c.subject.indexOf('UTR') >= 0){
                mapObjectNote.put(c.id,new XCSNoteUtils.wrapNoteTitle(XCSNoteUtils.SYSTEM_NOTE_TITLE,noteUTR));
                notesOCS.add(OCSGestioneNoteInvoker.createOCSNote(rtNote, '', c.Account.getCodice_Cliente__c, c.NumeroPratica__c, '', 'A', 'P', OCSNoteUTR ));
            }
            else{
                mapObjectNote.put(c.id,new XCSNoteUtils.wrapNoteTitle(XCSNoteUtils.SYSTEM_NOTE_TITLE,noteCS));
                notesOCS.add(OCSGestioneNoteInvoker.createOCSNote(rtNote, '', c.Account.getCodice_Cliente__c, c.NumeroPratica__c, '', 'A', 'P', OCSNoteCS));
            }  
        }
        XCSNoteUtils.insertObjectsNotes(mapObjectNote);
        insert notesOCS;
        
        /*
        List <Event> evListFromUTR = [SELECT Id, Prodotto__c, Product__c FROM Event where ActivityDate = Yesterday and isChild = false and product__r.name = 'Retention' and prodotto__c = 'Task Force'  and (Disposition__r.External_Id__c in('19','20','21','22','28','29','1') OR Disposition__c = null) and case__r.Categoria_riferimento__r.External_Id__c = '1036'];
       /* For(Event ev : evListFrom){
            caseToInsert.add(new Case(Subject = 'Retention TF - Coda APT - da CS',accountId = ev.whatId,product__c = prdRet.id,categoria_riferimento__r = new XCS_Categoria__c(External_Id__c ='1036')));
      } */ 
      
    }
    
    public class caseNoteWrap{
        Case caso;
        ContentNote cn;
        
    }
}