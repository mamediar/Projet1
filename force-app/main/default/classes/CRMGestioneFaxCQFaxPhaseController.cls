public without sharing class CRMGestioneFaxCQFaxPhaseController 
{
	@AuraEnabled
    public static wrapReturn phaseInit()
    {
        Integer actualYear = date.today().year();
        Integer actualMonth = date.today().month();
       
        List<optionWrap> listOptionYear = new List<optionWrap>();
        List<optionWrap> listOptionMonth = new List<optionWrap>();
//        List<aggregateWrap> listMockW = new List<aggregateWrap>();
       /* List<CRM_Fax_Excel__c> outsourcerConf = new List<CRM_Fax_Excel__c>();
      	List<Id> contentVersionToQuery = new List<Id>();
        Map<String,aggregateWrap> MapOuts = new Map<String,aggregateWrap>();
        Map<String,Id> mapContDocLink = new Map<String,Id>();
        Map<Id,ContentVersion> mapContentVersion = new Map<Id,ContentVersion>();
        
        outsourcerConf = [select outsourcer__c,id from CRM_Fax_Excel__c];
        for(CRM_Fax_Excel__c ex : outsourcerConf)
        {
            contentVersionToQuery.add(ex.id);
        }
        List<ContentDocumentLink> lConDocLink = [Select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId IN :contentVersionToQuery];
        for(ContentDocumentLink lk : lConDocLink)
        {
            mapContDocLink.put(lk.LinkedEntityId,lk.ContentDocumentId);
        }
        List<ContentVersion> lCVers = [Select Id,Title,ContentDocumentId,CreatedDate From ContentVersion Where ContentDocumentId In :mapContDocLink.values()];
        for(ContentVersion con : lCVers)
        {
            mapContentVersion.put(con.ContentDocumentId, con);
        }
        //aggregateWrap obj = new aggregateWrap();
		
        for (CRM_Fax_Excel__c Conf : outsourcerConf)  
        {
           if(MapOuts.get(Conf.outsourcer__c) == null)       
           {
               MapOuts.put(Conf.outsourcer__c, new aggregateWrap(Conf.outsourcer__c,(mapContDocLink.get(Conf.Id) != null ? (mapContentVersion.get(mapContDocLink.get(Conf.Id)) != null ? mapContentVersion.get(mapContDocLink.get(Conf.Id)).id + '' : '') : ''),(mapContDocLink.get(Conf.Id) != null ? (mapContentVersion.get(mapContDocLink.get(Conf.Id)) != null ? mapContentVersion.get(mapContDocLink.get(Conf.Id)).Title + '' : '') : ''),(mapContDocLink.get(Conf.Id) != null ? (mapContentVersion.get(mapContDocLink.get(Conf.Id)) != null ? String.valueof(mapContentVersion.get(mapContDocLink.get(Conf.Id)).CreatedDate ): '') : '')));            
           }
		}   */
       	for(Integer minYear = 2000; minYear <= actualYear; minYear ++)
        {
			listOptionYear.add(new optionWrap(minYear + '',minYear));
        }
         
		for (Integer i=1 ; i<=12 ; i++) {
            listOptionMonth.add(new optionWrap(i + '',i));
		}	 
        
        wrapReturn res = exceltablemethod();
        res.listOptionM = listOptionMonth;
        res.listOptionY = listOptionYear;
        res.actualY = actualYear;
        res.actualM = actualMonth;
        system.debug('Res: '+ res);
        return res;
    }
    
    @AuraEnabled
    public static wrapReturn PopulateTableChange (integer Anno, integer Mese){
        
        wrapReturn res = new wrapReturn();
        res = ExtractFaxCaseOnDate(Anno,Mese);
        system.debug('RES_POPULATE :***' + res);
        return res;
    }
    @AuraEnabled
    public static wrapReturn ExtractFaxCaseOnDate(integer Anno, integer Mese)
    {
       	Set<string> QMfax;
     //   List<CRM_QueueMailFaxConfig__c> FaxConfig = new List<CRM_QueueMailFaxConfig__c>();
        List<Case> CaseList = new List<Case>();
        Map<String,aggregateWrap> mapInviabili = new Map<String,aggregateWrap>();
        Map<String,aggregateWrap> mapDaControllare = new Map<String,aggregateWrap>();
        Map<String,aggregateWrap> mapInviati = new Map<String,aggregateWrap>();
        Map<String,aggregateWrap> mapContestati = new Map<String,aggregateWrap>();
        Map<String,aggregateWrap> mapRicontrollati = new Map<String,aggregateWrap>();
        
        
        RecordType r = [select id from recordType 
                        where developerName = 'CRM_Attivita_CQ'];
  		system.debug('MeseQuery: **** ' +Mese);
        CaseList = [select Id, ProcessType__c, Queue_Mail_Fax_Config__r.Outsourcer__c  from Case where RecordTypeId = :r.Id and ParentId = null and CALENDAR_YEAR(CreatedDate) = :Anno and CALENDAR_MONTH(CreatedDate) = :Mese];
        
      string MeseString; 
        
      if(Mese < 10)
      {
          MeseString = '0'+String.valueOf(Mese);
      }
       // system.debug('ListaProva: **** ' +CaseList);
        
        for(Case Phase : CaseList)
        {
           if(CaseUtils.GESTIONE_FAX_PROCESSTYPE_DA_CONTROLLARE.Equals(Phase.ProcessType__c))
           {  
                if(mapDaControllare.get(phase.Queue_Mail_Fax_Config__r.Outsourcer__c) != null)
                {
                   mapDaControllare.get(phase.Queue_Mail_Fax_Config__r.Outsourcer__c).count ++;
                }
               else
               {
                    mapDaControllare.put(phase.Queue_Mail_Fax_Config__r.Outsourcer__c, new aggregateWrap(Anno + MeseString + '',phase.Queue_Mail_Fax_Config__r.Outsourcer__c,1));
               }
           }
           else if(CaseUtils.GESTIONE_FAX_PROCESSTYPE_INVIABILE.Equals(Phase.ProcessType__c))
           {
               if(mapInviabili.get(phase.Queue_Mail_Fax_Config__r.Outsourcer__c) != null)
               {
                   mapInviabili.get(phase.Queue_Mail_Fax_Config__r.Outsourcer__c).count ++;
               } 
               else
               {
                    mapInviabili.put(phase.Queue_Mail_Fax_Config__r.Outsourcer__c, new aggregateWrap(Anno + MeseString +'',phase.Queue_Mail_Fax_Config__r.Outsourcer__c,1));
               }
           }
           else if(CaseUtils.GESTIONE_FAX_PROCESSTYPE_INVIATO.Equals(Phase.ProcessType__c))
           {
               if(mapInviati.get(phase.Queue_Mail_Fax_Config__r.Outsourcer__c) != null)
               {
                   mapInviati.get(phase.Queue_Mail_Fax_Config__r.Outsourcer__c).count ++;
               } 
               else
               {
                   mapInviati.put(phase.Queue_Mail_Fax_Config__r.Outsourcer__c, new aggregateWrap(Anno + MeseString + '',phase.Queue_Mail_Fax_Config__r.Outsourcer__c,1));
               }
           }
           else if(CaseUtils.GESTIONE_FAX_PROCESSTYPE_CONTESTATO.Equals(Phase.ProcessType__c)){
               if(mapContestati.get(phase.Queue_Mail_Fax_Config__r.Outsourcer__c) != null)
               {
                   mapContestati.get(phase.Queue_Mail_Fax_Config__r.Outsourcer__c).count ++;
               } 
               else
               {
                   mapContestati.put(phase.Queue_Mail_Fax_Config__r.Outsourcer__c, new aggregateWrap(Anno + MeseString + '',phase.Queue_Mail_Fax_Config__r.Outsourcer__c,1));
               }
           }
           else if(CaseUtils.GESTIONE_FAX_PROCESSTYPE_RICONTROLLATO.Equals(Phase.ProcessType__c)){
               if(mapRicontrollati.get(phase.Queue_Mail_Fax_Config__r.Outsourcer__c) != null)
               {
                   mapRicontrollati.get(phase.Queue_Mail_Fax_Config__r.Outsourcer__c).count ++;
               } 
               else
               {
                    mapRicontrollati.put(phase.Queue_Mail_Fax_Config__r.Outsourcer__c, new aggregateWrap(Anno + MeseString + '',phase.Queue_Mail_Fax_Config__r.Outsourcer__c,1));
               }
           }
           else
           		system.debug('ERRORE_NESSUNA_CASISTICA');
            
        }
        
        wrapReturn response = new wrapReturn();
        
        system.debug('listDaControllare :***' + mapDaControllare.values());
        response.listDaControllare = mapDaControllare.values() != null ? mapDaControllare.values() : new List<aggregateWrap>();
        response.listInviabili = mapInviabili.values() != null ? mapInviabili.values() : new List<aggregateWrap>();
        response.listInviati = mapInviati.values() != null ? mapInviati.values() : new List<aggregateWrap>();
        response.listContestati = mapContestati.values() != null ? mapContestati.values() : new List<aggregateWrap>();
        response.listRicontrollati = mapRicontrollati.values() != null ? mapRicontrollati.values() : new List<aggregateWrap>();
        
        return response;
    }
    
    @AuraEnabled
    public static wrapReturn ExtractOutToSend(list<string> outSourc,integer Anno, integer Mese)
    {     
        system.debug('ListaProva:   ' +outSourc);
        string pType= CaseUtils.GESTIONE_FAX_PROCESSTYPE_INVIABILE; 
        List<Case> CaseDaInviare = new List<Case>();
        boolean Esito= false;
    	List<Case> SubCaseDaInviare = new List<Case>();
        List<Group> AssegnazioneGruppo = new List<Group>();
        Map<String,Group> mapGruppi = new Map<String,Group>();
       
        Set<String> Gruppi = new Set<String>();
        Set<String> CasePadri = new Set<String>();
        try{
        	CaseDaInviare = [select Id,Queue_Mail_Fax_Config__r.Queue_Outsourcer__c,ProcessType__c  from Case where ProcessType__c = :pType 
                   and ParentId = null
                   and Queue_Mail_Fax_Config__r.Outsourcer__c = :outSourc
                   and CALENDAR_YEAR(CreatedDate) = :Anno
                   and CALENDAR_MONTH(CreatedDate) = :Mese];

        	for(Case toSend : CaseDaInviare)        
        	{
        		Gruppi.add(toSend.Queue_Mail_Fax_Config__r.Queue_Outsourcer__c);
            	CasePadri.add(toSend.Id);
        	}
        
        	system.debug ('Gruppi:  ' + Gruppi);
        
        	AssegnazioneGruppo = [select DeveloperName,Id  from Group where DeveloperName in :Gruppi];
        
        	for(Group toUpdate : AssegnazioneGruppo)        
        	{
         		mapGruppi.put(toUpdate.DeveloperName, toUpdate);              
       		}
 		
        	system.debug ('AssegnazioneGruppo:  ' + AssegnazioneGruppo);
        	system.debug ('MappaGruppo:  ' + mapGruppi);
        	if(!CaseDaInviare.isEmpty())
            {    
        		for(Case toSend : CaseDaInviare)        
        		{
            		toSend.ownerId=MapGruppi.Get(toSend.Queue_Mail_Fax_Config__r.Queue_Outsourcer__c).id; 
            		toSend.ProcessType__c= CaseUtils.GESTIONE_FAX_PROCESSTYPE_INVIATO;
        		}
                Esito = true;
                Update CaseDaInviare;
                
                SubCaseDaInviare = [select Id,Parent.Queue_Mail_Fax_Config__r.Queue_Outsourcer__c,ProcessType__c  from Case where ParentId in :CasePadri and status <> 'Gestito'];
	    		for(Case SubC : SubCaseDaInviare)        
        		{
        			SubC.ProcessType__c=CaseUtils.GESTIONE_FAX_PROCESSTYPE_INVIATO;
                    SubC.OwnerId = MapGruppi.Get(SubC.Parent.Queue_Mail_Fax_Config__r.Queue_Outsourcer__c).id;
        		}
          	  	if(!SubCaseDaInviare.isEmpty())
           		{ 
        			Update SubCaseDaInviare;
                }
                else
           		{
                 	//Esito = false;
            	}
            }
			else
            {
                 Esito = false;
            }
        }
        catch(Exception e){
            Esito = false;
            string err = 'updateCaseFail:'+e.getMessage();
            system.debug(err);
        }
        
        wrapReturn response = new wrapReturn(); 
        response.EsitoUpd = Esito;
        return response;     
    }
    
    @AuraEnabled
    public static wrapReturn GeneraReport(list<string> outSourc)
    {   
        List<CRM_Fax_Excel__c> outsourcerToSend = new List<CRM_Fax_Excel__c>();
        boolean res = true;
        Map<String, list<String>> mapListOut = new Map<String,list<String>>();
        Map<String, WrapRenderingPage> mapAggregate = new  Map<String, WrapRenderingPage>();
        List<Id> contentDocumentLinkToQuery = new List<Id>();
		outsourcerToSend = [select outsourcer__c, outsourcer_email__c,id from CRM_Fax_Excel__c where outsourcer__c in :outSourc];       
        
        for(CRM_Fax_Excel__c ExtId : outsourcerToSend)
        { 
            if(mapAggregate.get(ExtId.outsourcer__c) != null)
            {
            	mapAggregate.get(ExtId.outsourcer__c).objectsToAssign.add(ExtId.Id);
            }
            else
            {
                mapAggregate.put(ExtId.outsourcer__c , new WrapRenderingPage(new Map<String,String>{'filter'=> ExtId.outsourcer__c},new List<Id>{ExtId.Id}));
            }
            contentDocumentLinkToQuery.add(extId.id);
        }
        List<ContentDocumentLink> lConDocLink = [Select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId IN :contentDocumentLinkToQuery];
        List<Id> lDoc = new List<Id>();
        for(ContentDocumentLink lk : lConDocLink)
        {
            lDoc.add(lk.ContentDocumentId);
        }
        List<ContentDocument> cDoc = [Select id from ContentDocument Where id IN :lDoc];
        delete cDoc;
        try{
            for(String out : outSourc)
            {          
                GenerazioneXLS.generaExcelCustomVisualforcepage('/apex/CRMGestioneFax_ControlloQualitaReport',mapAggregate.get(out).mapParams, 'FAX_' + out + '_TMPL', mapAggregate.get(out).objectsToAssign);
            }  
        }
        catch(Exception e)
        {
            res = false;
            System.debug('**************** : ' + e);
        }
     	wrapReturn response = exceltablemethod();
        response.EsitoUpd = res;
        return response;
    }
               
    @AuraEnabled
    public static wrapReturn ExtractEmailOutsource(list<string> outSourcS)
    {
        List<CRM_Fax_Excel__c> outsourcerToSend = new List<CRM_Fax_Excel__c>();
        List<Messaging.SingleEmailMessage> ListSendMail = new List<Messaging.SingleEmailMessage>();
        Map<String, list<String>> mapListMail = new Map<String,list<String>>();
        Map<String, Id> mapLinkId = new Map<String,Id>();
        Map<Id, Id> mapLinkDocId = new Map<Id,Id>();
        Map<Id, Id> mapLinkvers = new Map<Id,Id>();
        boolean res = true;
        List<ContentDocumentlink> ListDoc = new List<ContentDocumentlink>();
        List<ContentVersion> ListVers = new List<ContentVersion>();
        Set<Id> newSetDoc = New Set<Id>();
        Set<Id> newSetLink = New Set<Id>();
         
		outsourcerToSend = [select outsourcer__c, outsourcer_email__c, Id from CRM_Fax_Excel__c where outsourcer__c in :outSourcS];      
        system.debug('outSourcS: **** ' +outSourcS);
        system.debug('outsourcerToSend: **** ' +outsourcerToSend);
        for(CRM_Fax_Excel__c ExtMail : outsourcerToSend)
        {
              
            if(mapListMail.get(ExtMail.outsourcer__c) != null)
            {
            	mapListMail.get(ExtMail.outsourcer__c).add(ExtMail.outsourcer_email__c);
            }
            else
            {
                mapListMail.put(ExtMail.outsourcer__c , new list<String> {ExtMail.outsourcer_email__c});
                mapLinkId.put(ExtMail.outsourcer__c, ExtMail.Id);
                newSetLink.add(ExtMail.Id);
            }    
        }  
        
		ListDoc = [select  LinkedEntityId, ContentDocumentId from ContentDocumentlink where LinkedEntityId IN :newSetLink];   
        
        for(ContentDocumentlink Doc : ListDoc)
        {            
                mapLinkDocId.put(Doc.LinkedEntityId, Doc.ContentDocumentId);
           		newSetDoc.add(Doc.ContentDocumentId);
        }      
        ListVers = [select  Id, ContentDocumentId from ContentVersion where ContentDocumentId in: newSetDoc];        
        for(ContentVersion Vers : ListVers)
        {            
                mapLinkvers.put(Vers.ContentDocumentId, Vers.Id);                  
        }
        try{
            for(String key : mapListMail.keyset() )
            {
                ListSendMail.add(EmailUtils.generateEmail('ReportControlloQualita', mapListMail.get(key),new list<Id>{mapLinkvers.get(mapLinkDocId.get(mapLinkId.get(key)))}));        
            }  
        }
      	catch(Exception e)
        {
            res = false;
        }
        EmailUtils.sendEmail(ListSendMail);  
        
        wrapReturn response = new wrapReturn(); 
        response.EsitoUpd = res;
        return response;
    }
    
    public static wrapReturn exceltablemethod()
    {
        List<CRM_Fax_Excel__c> outsourcerConf = new List<CRM_Fax_Excel__c>();
      	List<Id> contentVersionToQuery = new List<Id>();
        Map<String,aggregateWrap> MapOuts = new Map<String,aggregateWrap>();
        Map<String,Id> mapContDocLink = new Map<String,Id>();
        Map<Id,ContentVersion> mapContentVersion = new Map<Id,ContentVersion>();
        
        outsourcerConf = [select outsourcer__c,id from CRM_Fax_Excel__c];
        for(CRM_Fax_Excel__c ex : outsourcerConf)
        {
            contentVersionToQuery.add(ex.id);
        }
        List<ContentDocumentLink> lConDocLink = [Select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId IN :contentVersionToQuery];
        for(ContentDocumentLink lk : lConDocLink)
        {
            mapContDocLink.put(lk.LinkedEntityId,lk.ContentDocumentId);
        }
        List<ContentVersion> lCVers = [Select Id,Title,ContentDocumentId,CreatedDate From ContentVersion Where ContentDocumentId In :mapContDocLink.values()];
        for(ContentVersion con : lCVers)
        {
            mapContentVersion.put(con.ContentDocumentId, con);
        }
        for (CRM_Fax_Excel__c Conf : outsourcerConf)  
        {
           if(MapOuts.get(Conf.outsourcer__c) == null)       
           {
               MapOuts.put(Conf.outsourcer__c, new aggregateWrap(Conf.outsourcer__c,(mapContDocLink.get(Conf.Id) != null ? (mapContentVersion.get(mapContDocLink.get(Conf.Id)) != null ? mapContentVersion.get(mapContDocLink.get(Conf.Id)).id + '' : '') : ''),(mapContDocLink.get(Conf.Id) != null ? (mapContentVersion.get(mapContDocLink.get(Conf.Id)) != null ? mapContentVersion.get(mapContDocLink.get(Conf.Id)).Title + '' : '') : ''),(mapContDocLink.get(Conf.Id) != null ? (mapContentVersion.get(mapContDocLink.get(Conf.Id)) != null ? String.valueof(mapContentVersion.get(mapContDocLink.get(Conf.Id)).CreatedDate ): '') : '')));            
           }
		}  
        wrapReturn ret = new wrapReturn();
        ret.listWrapMock = MapOuts.values();
        return ret;
	}
    
    public static integer  CountErrore(Task tsk )
    {
         return  (tsk.identificazione__c == 'NO' ? 5 : 0  +  tsk.operativita__c == 'NO' ? 7 : 0  +  tsk.Note_OCS__c == 'NO' ? 3 : 0  +  Tsk.Archiviazione__c == 'NO' ? 5 : 0 );
    }
    
    public static double  PenaleBonus(double PercentualeErrOpp)
    {
        double PenaleBon;
        if (PercentualeErrOpp <= 7){
             PenaleBon = 0;
        }
        else if(PercentualeErrOpp > 20){
             PenaleBon = -1;
        }
        else if(PercentualeErrOpp > 7 && PercentualeErrOpp <= 13){
             PenaleBon= -0.5;
        }
         else if(PercentualeErrOpp > 13 && PercentualeErrOpp <= 20){
             PenaleBon= -0.75;
        }
        else{
            PenaleBon= +0.5;         
        }
        return  PenaleBon;
    }
    
    public static String VotoMedio(Integer ConteggioF)
    {
        String Voto;
        if (ConteggioF <= 2){
             Voto = '4';
        }
        else if(ConteggioF > 6){
             Voto = '1';
        }
        else if(ConteggioF > 2 && ConteggioF <= 4){
             Voto= '3';
        }
         else if(ConteggioF > 4 && ConteggioF <= 6){
             Voto= '2';
        }
        else{
            Voto= '0';         
        }
        return  Voto;
    }
    
    public class optionWrap
    {
        @AuraEnabled String label{get; set;}
        @AuraEnabled Integer value{get; set;}
        public optionWrap(String label,Integer value)
        {
            this.label = label;
            this.value = value;
        }
    }
    
    public class wrapRiepilogo
    {
        @AuraEnabled String Id_Gruppo{get; set;}
        @AuraEnabled String Prodotto {get; set;}
        @AuraEnabled String Campo_Utente {get; set;}
        @AuraEnabled Integer TOT_Semestre {get; set;}
        @AuraEnabled Integer Campione_Analiasi {get; set;}
        @AuraEnabled Integer Documenti_analizzati {get; set;}
        @AuraEnabled Integer Punteggio {get; set;}
        
        
        public wrapRiepilogo(String Id_Gruppo,String Prodotto,String Campo_Utente,Integer TOT_Semestre,Integer Campione_Analiasi, integer Documenti_analizzati, Integer Punteggio)
        {
            this.Id_Gruppo = Id_Gruppo;
            this.Prodotto = Prodotto;
            this.Campo_Utente = Campo_Utente;
            this.TOT_Semestre = TOT_Semestre;
            this.Campione_Analiasi= Campione_Analiasi;
            this.Documenti_analizzati=Documenti_analizzati;
            this.Punteggio= Punteggio;
        }
    }
    
    public class wrapReturn
    {
        @AuraEnabled public List<optionWrap> listOptionY {get; set;}
        @AuraEnabled public List<optionWrap> listOptionM  {get; set;}
        @AuraEnabled public List<optionWrap> listCaseFax  {get; set;}
        
        @AuraEnabled public List<aggregateWrap> listWrapMock  {get; set;} 
        @AuraEnabled public List<aggregateWrap> listDaControllare  {get; set;}
        @AuraEnabled public List<aggregateWrap> listInviabili {get; set;}
        @AuraEnabled public List<aggregateWrap> listInviati  {get; set;}
        @AuraEnabled public List<aggregateWrap> listContestati  {get; set;}
        @AuraEnabled public List<aggregateWrap> listRicontrollati  {get; set;}
        
        
        @AuraEnabled public List<wrapRiepilogo>  ListTotalRiepilogo  {get; set;}     
        
        @AuraEnabled public Integer actualM {get; set;}
        @AuraEnabled public Integer actualY {get; set;}
        @AuraEnabled public boolean EsitoUpd {get; set;}
        @AuraEnabled public String messRespo {get; set;}
	 }
    
    public class aggregateWrap
    {
        @AuraEnabled public String dataFiltro{get; set;}
        @AuraEnabled public String outsourcer{get; set;}
        @AuraEnabled public integer count{get; set;}
        @AuraEnabled public String email{get; set;}
        @AuraEnabled public String template{get; set;}
        @AuraEnabled public String fileG {get; set;}
        @AuraEnabled public String DGenerato {get; set;}
        @AuraEnabled public Id Id {get; set;}
        @AuraEnabled public string DeveloperName {get; set;}
        
        public aggregateWrap(String dataFiltro,String outsourcer, Integer count)
        {
            this.dataFiltro = dataFiltro;
            this.outsourcer = outsourcer;
            this.count = count;
        }
        public aggregateWrap(){}
        
        public aggregateWrap(string outsourcer,String fileG,String template,String Dgenerato){
            this.outsourcer = outsourcer; 
            this.fileG = fileG;
            this.template = template;
            this.Dgenerato = Dgenerato;
        }
           
    }
    
    public class WrapRenderingPage
    {
        @AuraEnabled public Map<String,String> mapParams {get; set;}
        @AuraEnabled public List<Id> objectsToAssign {get; set;}
        public WrapRenderingPage(Map<String,String> mapParams,List<Id> objectsToAssign){
            this.objectsToAssign = objectsToAssign;
            this.mapParams = mapParams;
        }
    }
    
  
}