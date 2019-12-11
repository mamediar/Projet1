public without sharing class CRMGestioneFaxReportController {
	public String filter {get;set;}
    public List <WrapTotalExcel>  ListTotalExcelOut {get;set;}
    public List <wrapRiepilogo>  ListTotalRiepilogo {get;set;}
    public double VotoMedio {get;set;}
    
    public void init(){
         this.filter=ApexPages.currentPage().getParameters().get('filter');
          
        integer MesePrecedente = date.today().month();
        
        List<Case> SubCaseList = new List<Case>();
        List<Task> TaskList = new List<Task>();
        List<CRMFax_Group__c> FaxGroupList = new List<CRMFax_Group__c>();
        List<CRMFax_GroupCategoryProduct__c> FaxGroupCategList = new List<CRMFax_GroupCategoryProduct__c>();
        List<WrapTotalExcel> listExcelAgregate = new List<WrapTotalExcel>();
        List<wrapRiepilogo> listRiepilogo = new List<wrapRiepilogo>();
        
        Integer CountCase= 0;
        integer SommaVotiTotale;
        double PercentualeErrOpp =0;
        double MediaVotiTot =0;
        double PenaleBon;
        
        Map<String,CRMFax_GroupCategoryProduct__c> mapProdCateg = new Map<String,CRMFax_GroupCategoryProduct__c>();
        Map<String,task> mapTaskCase = new Map<String,task>();
        Map<String,wrapRiepilogo> mapRiepilogo = new Map<String,wrapRiepilogo>();
   
        FaxGroupList = [select Id,Name,External_Id__c,Fax_max__c,Fax_min__c, Outsourcer__c,prodottiGruppo__c,TotaliUltimo6Mesi__c, OwnerId,CampioneDaLavorare__c,NumeroAttualeCampione__c
                       from CRMFax_Group__c where Outsourcer__c = :filter ];
        
        
        
        if(!FaxGroupList.isEmpty()){
            for(CRMFax_Group__c FaxG : FaxGroupList)
        	{
				mapRiepilogo.put(FaxG.External_Id__c+'' , new wrapRiepilogo(
            	FaxG.External_Id__c+'',
            	FaxG.prodottiGruppo__c,
            	FaxG.Name,
            	integer.valueof(FaxG.TotaliUltimo6Mesi__c),
            	integer.valueof(FaxG.CampioneDaLavorare__c),
                0,
            	0
            	));      
  
        	}  
            
        	FaxGroupCategList = [select Id,groupid__c,groupid__r.Name,groupid__r.prodottiGruppo__c, groupid__r.External_Id__c, categoryId__c,productid__c,categoryId__r.External_Id__c,productid__r.RSS_External_Id__c
                       from CRMFax_GroupCategoryProduct__c where groupid__c in :FaxGroupList];
        }
        
        if(!FaxGroupCategList.isEmpty()){
        	for(CRMFax_GroupCategoryProduct__c GCP : FaxGroupCategList)
        	{
        		mapProdCateg.put(GCP.productid__r.RSS_External_Id__c+'-'+GCP.categoryId__r.External_Id__c , GCP);           
        	}        
        }
        
        System.debug('MesePrecedente:**** ' + MesePrecedente);  
        RecordType r = [select id from recordType where developerName = 'CRM_Attivita_CQ'];
        
        SubCaseList = [select id, parent.CaseNumber, parent.CreatedDate, NumeroPratica__c, Categoria_Riferimento__r.External_Id__c,Categoria_Riferimento__r.name,Product__r.RSS_External_Id__c,Product__r.name,Utente_Lavorazione__c ,sla_minutes__c, 
                       UtenteInvioOutsourcer__c, DataInvioOutsourcer__c, Queue_Mail_Fax_Config__r.Outsourcer__c 
                       from Case where  ParentId <> null
                       and RecordTypeId = :r.Id
                       and CALENDAR_MONTH(CreatedDate) = :MesePrecedente
                   	   ];
        if(!SubCaseList.isEmpty()){
        	TaskList = [select WhatId, Type, SLA__c,Identificazione__c,Operativita__c,Note_OCS__c ,Archiviazione__c,Note__c, DataLavorazione__c,UtenteLavorazione__c  
                    from task where WhatId in :SubCaseList];
        }
        if(!TaskList.isEmpty()){
        	for(Task TaskC : TaskList)
        	{
        		mapTaskCase.put(TaskC.WhatId +'-'+ TaskC.Type , TaskC);
       		}
        }
        System.debug('Mappa:**** ' + mapProdCateg);
         System.debug('MappaTask :**** ' + mapTaskCase);
       	
        

        
        for(case SubCase : SubCaseList)
        {
             System.debug('Chiave:**** '+ SubCase.Product__r.RSS_External_Id__c+'-'+SubCase.Categoria_Riferimento__r.External_Id__c);
            if(mapProdCateg.get(SubCase.Product__r.RSS_External_Id__c+'-'+SubCase.Categoria_Riferimento__r.External_Id__c) != null)
           	 {
                WrapTotalExcel objW = new WrapTotalExcel();
                
                objW.Incident = SubCase.parent.CaseNumber;
                objW.Data_richiesta = string.valueOfGmt(SubCase.parent.CreatedDate);
                objW.Pratica = SubCase.NumeroPratica__c != null ? SubCase.NumeroPratica__c+'' : '';
                objW.Group_id = mapProdCateg.get(SubCase.Product__r.RSS_External_Id__c+'-'+SubCase.Categoria_Riferimento__r.External_Id__c).groupid__r.External_Id__c+'';
                objW.Campo_Utente = mapProdCateg.get(SubCase.Product__r.RSS_External_Id__c+'-'+SubCase.Categoria_Riferimento__r.External_Id__c).groupid__r.Name;
                objW.Categoria = SubCase.Categoria_Riferimento__r.name;
                objW.Prodotto = SubCase.Product__r.name;
                objW.Operatore = SubCase.Utente_Lavorazione__c;
                objW.sla_minutes = SubCase.sla_minutes__c != null ? SubCase.sla_minutes__c +'' : '';
                
                 
                objW.SLA = mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F1)!= null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F1).SLA__c : '';
                objW.Identificazione = mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F1) != null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F1).Identificazione__c : '';
                objW.Operativita = mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F1) != null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F1).Operativita__c : '';
                objW.Note = mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F1) != null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F1).Note_OCS__c : '';
                objW.Archiviazione = mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F1) != null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F1).Archiviazione__c : '';
                objW.Commenti = mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F1) != null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F1).Note__c : '';
                objW.Controllo = mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F1) != null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F1).UtenteLavorazione__c : '';
                objW.audit_controller_date = mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F1) != null ? string.valueOfGmt(mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F1).DataLavorazione__c) : '';
                objW.audit_controller_approved_user = SubCase.UtenteInvioOutsourcer__c;
                objW.audit_controller_approved_date = string.valueOfGmt(SubCase.DataInvioOutsourcer__c);
                
                objW.audit_controller_SLA = mapTaskCase.get(SubCase.Id+'-'+CompassUtils.GESTIONE_TASK_FAX_TYPE_F2) != null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F2).SLA__c : '';
                objW.audit_outsourcer_identification = mapTaskCase.get(SubCase.Id+'-'+CompassUtils.GESTIONE_TASK_FAX_TYPE_F2) != null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F2).Identificazione__c : '';
                objW.audit_outsourcer_operation = mapTaskCase.get(SubCase.Id+'-'+CompassUtils.GESTIONE_TASK_FAX_TYPE_F2) != null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F2).Operativita__c : '';
                objW.audit_outsourcer_ocs_notes = mapTaskCase.get(SubCase.Id+'-'+CompassUtils.GESTIONE_TASK_FAX_TYPE_F2) != null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F2).Note_OCS__c : '';
                objW.audit_outsourcer_archiviation = mapTaskCase.get(SubCase.Id+'-'+CompassUtils.GESTIONE_TASK_FAX_TYPE_F2) != null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F2).Archiviazione__c : '';
                objW.audit_outsourcer_note = mapTaskCase.get(SubCase.Id+'-'+CompassUtils.GESTIONE_TASK_FAX_TYPE_F2) != null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F2).Note__c : '';
                objW.audit_outsourcer_user = mapTaskCase.get(SubCase.Id+'-'+CompassUtils.GESTIONE_TASK_FAX_TYPE_F2) != null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F2).UtenteLavorazione__c : '';
                objW.audit_outsourcer_date = mapTaskCase.get(SubCase.Id+'-'+CompassUtils.GESTIONE_TASK_FAX_TYPE_F2) != null ? string.valueOfGmt( mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F2).DataLavorazione__c) : '';
                    
                objW.audit_controller_SLA2 = mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F3) != null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F3).SLA__c : '';
                objW.audit_after_identification = mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F3) != null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F3).Identificazione__c : '';
                objW.audit_after_operation = mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F3) != null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F3).Operativita__c : '';
                objW.audit_after_ocs_notes = mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F3) != null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F3).Note_OCS__c : '';
                objW.audit_after_archiviation = mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F3) != null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F3).Archiviazione__c : '';
                objW.audit_after_note = mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F3) != null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F3).Note__c : '';
                objW.audit_after_user = mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F3) != null ? mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F3).UtenteLavorazione__c : '';
                objW.audit_after_date = mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F3) != null ? string.valueOfGmt(mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F3).DataLavorazione__c) : '';
                
                if(mapTaskCase.get(SubCase.Id+'-'+CompassUtils.GESTIONE_TASK_FAX_TYPE_F1) != null){
                    if(mapTaskCase.get(SubCase.Id+'-'+CompassUtils.GESTIONE_TASK_FAX_TYPE_F1).SLA__c  != null)
                    {
                    	integer ConteggioF1 = CountErrore(mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F1));
                    	objW.Count_Errore_f1 = ConteggioF1+'';
                    	objW.Voto_Netto_f1 = VotoMedio(ConteggioF1);
                    }
                    else { 
                        objW.Count_Errore_f1 = '-';
                        objW.Voto_Netto_f1 ='';
                    } 
                
    				objW.Errore_Operativita_f1 =  mapTaskCase.get(SubCase.Id+'-'+CompassUtils.GESTIONE_TASK_FAX_TYPE_F1).Operativita__c == 'NO' ? '1' : '0'  ;
                }
                if(mapTaskCase.get(SubCase.Id+'-'+CompassUtils.GESTIONE_TASK_FAX_TYPE_F2) != null){ 
                	if(mapTaskCase.get(SubCase.Id+'-'+CompassUtils.GESTIONE_TASK_FAX_TYPE_F2).SLA__c  != null){
                   	 	integer ConteggioF2 = CountErrore(mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F2));
                   	 	objW.Count_Errore_f2 = ConteggioF2+'';
                    objW.Voto_Netto_f2 = VotoMedio(ConteggioF2);
                	}
                	else { 
                   	 	objW.Count_Errore_f2 = '-';
                    	objW.Voto_Netto_f2 ='';
                	}
    				objW.Errore_Operativita_f2 =  mapTaskCase.get(SubCase.Id+'-'+CompassUtils.GESTIONE_TASK_FAX_TYPE_F2).Operativita__c == 'NO' ? '1' : '0'  ;
                }
               if(mapTaskCase.get(SubCase.Id+'-'+CompassUtils.GESTIONE_TASK_FAX_TYPE_F3) != null){    
                	
                   if(mapTaskCase.get(SubCase.Id+'-'+CompassUtils.GESTIONE_TASK_FAX_TYPE_F3).SLA__c  != null){
                    	integer ConteggioF3 = CountErrore(mapTaskCase.get(SubCase.Id+'-'+ CompassUtils.GESTIONE_TASK_FAX_TYPE_F3));
                    	objW.Count_Errore_f3 = ConteggioF3+'';
                   		objW.Voto_Netto_f3 = VotoMedio(ConteggioF3);
                	}
                	else { 
                    	objW.Count_Errore_f3 = '-';
                    	objW.Voto_Netto_f3 ='';
               		}
    				objW.Errore_Operativita_f3 =  mapTaskCase.get(SubCase.Id+'-'+CompassUtils.GESTIONE_TASK_FAX_TYPE_F3).Operativita__c == 'NO' ? '1' : '0'  ;
               }
               objW.Voto_Finale = 0;
                 
               if(mapTaskCase.get(SubCase.Id+'-'+CompassUtils.GESTIONE_TASK_FAX_TYPE_F1) != null || mapTaskCase.get(SubCase.Id+'-'+CompassUtils.GESTIONE_TASK_FAX_TYPE_F3) != null){   
                	
                   if(objW.Voto_Netto_f3 != null && objW.Voto_Netto_f3 != ''){       
                    	objW.Voto_Finale = integer.valueof(objW.Voto_Netto_f3);
                   }
                   else if(objW.Voto_Netto_f1 != null && objW.Voto_Netto_f1 != '')
                   {
                       objW.Voto_Finale = integer.valueof(objW.Voto_Netto_f1);
                   }    
                   else
                   {
                       objW.Voto_Finale = 0;
                   }
                   
                   if(objW.Errore_Operativita_f3 != null && objW.Errore_Operativita_f3 != ''){   
                		objW.ERRORE_OPER_FINALE = objW.Errore_Operativita_f3;
                   }
                   else if(objW.Errore_Operativita_f1 != null && objW.Errore_Operativita_f1 != ''){
                       objW.ERRORE_OPER_FINALE = objW.Errore_Operativita_f1;
                   }
                   else{
                       objW.ERRORE_OPER_FINALE = '';
                   }
               }
               
               if(mapProdCateg.get(SubCase.Product__r.RSS_External_Id__c+'-'+SubCase.Categoria_Riferimento__r.External_Id__c) != null)                                                                               
               {   
                   
                   if(mapRiepilogo.get(mapProdCateg.get(SubCase.Product__r.RSS_External_Id__c+'-'+SubCase.Categoria_Riferimento__r.External_Id__c).groupid__r.External_Id__c+'') != null)
                   {
                       mapRiepilogo.get(mapProdCateg.get(SubCase.Product__r.RSS_External_Id__c+'-'+SubCase.Categoria_Riferimento__r.External_Id__c).groupid__r.External_Id__c+'').Documenti_analizzati ++ ;
                       mapRiepilogo.get(mapProdCateg.get(SubCase.Product__r.RSS_External_Id__c+'-'+SubCase.Categoria_Riferimento__r.External_Id__c).groupid__r.External_Id__c+'').Punteggio += integer.valueof(objW.Voto_Finale);   
                   } 
                }
                 
               	CountCase++;
                
                PercentualeErrOpp =+ objW.ERRORE_OPER_FINALE != null ? integer.valueof(objW.ERRORE_OPER_FINALE) : 0 ;
                SommaVotiTotale =+ objW.Voto_Finale != null ? integer.valueof(objW.Voto_Finale) : 0 ;
                
               
           
               listExcelAgregate.add(objW);         
        	}
        }  
        
        System.debug('VerificaFunionamento1:**** ' + CountCase);  
        System.debug('VerificaFunionamento2:**** ' + listExcelAgregate);  
        if(CountCase != 0){
            PercentualeErrOpp = (PercentualeErrOpp/CountCase)*100 ;
            PenaleBon = PenaleBonus(PercentualeErrOpp);
        	MediaVotiTot = (SommaVotiTotale/CountCase)+PenaleBon ;
        }
        System.debug('MappaRiepilogo: ** '+mapRiepilogo);
        
		for(String key : mapRiepilogo.keyset() )
        {
            if(mapRiepilogo.get(key).punteggio != 0)
            	 mapRiepilogo.get(key).punteggio = mapRiepilogo.get(key).punteggio / mapRiepilogo.get(key).Documenti_analizzati; 	       
        }
       
        
	  this.ListTotalExcelOut = listExcelAgregate;
      this.ListTotalRiepilogo  = mapRiepilogo.values(); 
      this.VotoMedio  = MediaVotiTot;
        
    }
    
 	public static integer  CountErrore(Task tsk )
    {
        system.debug('COUNT****** '+ tsk.identificazione__c + '+'  +  tsk.operativita__c +'+'+  tsk.Note_OCS__c +'+'+ Tsk.Archiviazione__c);
        Integer Somma=0;
        if(tsk.identificazione__c == 'NO'){
            Somma +=  5;
        }
        else{
            Somma += 0;
        }
        
        if(tsk.operativita__c == 'NO'){
            Somma +=  7;
        }
        else{
            Somma += 0;
        }
        
        if(tsk.Note_OCS__c == 'NO'){
            Somma +=  3;
        }
        else{
            Somma += 0;
        }
        if(tsk.Archiviazione__c == 'NO'){
            Somma +=  5;
        }
        else{
            Somma += 0;
        }
        system.debug('Somma****** '+Somma);
         return Somma;
             //((tsk.identificazione__c == 'NO' ? 5 : 0)  +  (tsk.operativita__c == 'NO' ? 7 : 0 ) +  (tsk.Note_OCS__c == 'NO' ? 3 : 0 ) + (Tsk.Archiviazione__c == 'NO' ? 5 : 0 ));
    }
    
    public static double  PenaleBonus(double PercentualeErrOpp)
    {
        double PenaleBon;
        if(PercentualeErrOpp == 0){
           PenaleBon= +0.5;       
        }
        else if (PercentualeErrOpp <= 7){
             PenaleBon = 0;
        }   
        else if(PercentualeErrOpp > 7 && PercentualeErrOpp <= 13){
             PenaleBon= -0.5;
        }
        else if(PercentualeErrOpp > 13 && PercentualeErrOpp <= 20){
             PenaleBon= -0.75;
        }
        else if (PercentualeErrOpp > 20){
             PenaleBon = -1;
        }
        else{
            system.debug('CRMGestioneFaxReportController__PERCENTUALE NULL!!!!!!');
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

public class wrapRiepilogo
    {
        public String Id_Gruppo{get; set;}
        public String Prodotto {get; set;}
        public String Campo_Utente {get; set;}
        public Integer TOT_Semestre {get; set;}
        public Integer Campione_Analiasi {get; set;}
        public Integer Documenti_analizzati {get; set;}
        public Integer Punteggio {get; set;}
        
        
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

	public class aggregateWrap
    {
        public String dataFiltro{get; set;}
        public String outsourcer{get; set;}
        public integer count{get; set;}
        public String email{get; set;}
        public String template{get; set;}
        public String fileG {get; set;}
        public Date DGenerato {get; set;}
        public Id Id {get; set;}
        public string DeveloperName {get; set;}
        
        public aggregateWrap(String dataFiltro,String outsourcer, Integer count)
        {
            this.dataFiltro = dataFiltro;
            this.outsourcer = outsourcer;
            this.count = count;
        }
        public aggregateWrap(){}
        
        public aggregateWrap(string outsourcer){
            this.outsourcer = outsourcer;    
        }
           
    }

  	public class WrapTotalExcel
    {
         public string Incident {get; set;}
         public String Data_richiesta {get; set;}
         public String Pratica {get; set;}
         public string Group_id {get; set;}
         public string Campo_Utente {get; set;}
         public string Categoria {get; set;}
         public string Prodotto {get; set;}
         public string Operatore {get; set;}
         public string sla_minutes {get; set;}
         public string SLA {get; set;}
         public string Identificazione {get; set;}
         public string Operativita {get; set;}
         public string Note {get; set;}
         public string Archiviazione {get; set;}
         public string Commenti {get; set;}       
         public String Controllo {get; set;}
         public String audit_controller_date {get; set;}
        
         public string audit_controller_approved_user {get; set;}
         public String audit_controller_approved_date {get; set;}
        
         public string audit_controller_SLA {get; set;}
         public string audit_outsourcer_identification {get; set;}
         public string audit_outsourcer_operation {get; set;}
         public string audit_outsourcer_ocs_notes {get; set;}
         public string audit_outsourcer_archiviation {get; set;}
         public string audit_outsourcer_note {get; set;}
         public string audit_outsourcer_user {get; set;}
         public String audit_outsourcer_date {get; set;}
        
         public string audit_controller_SLA2 {get; set;}
         public string audit_after_identification {get; set;}
         public string audit_after_operation {get; set;}
         public string audit_after_ocs_notes {get; set;}
         public string audit_after_archiviation {get; set;}
         public string audit_after_note {get; set;}
         public string audit_after_user {get; set;}
         public String audit_after_date {get; set;}
        
         public String Count_Errore_f1 {get; set;}
         public string Voto_Netto_f1 {get; set;}
         public string Errore_Operativita_f1 {get; set;}
      	 public String Count_Errore_f2 {get; set;}
         public string Voto_Netto_f2 {get; set;}
         public string Errore_Operativita_f2 {get; set;}
         public String Count_Errore_f3 {get; set;}
         public string Voto_Netto_f3 {get; set;}
         public string Errore_Operativita_f3 {get; set;}
         public Integer Voto_Finale {get; set;}
         public string ERRORE_OPER_FINALE{get; set;}
                  
        }  
}