/**
 * Created by Salimata NGOM on 13/03/2019.
 */

public without sharing class IntervistaDomandeApexClass {

    @AuraEnabled
    public static List<String> getPicklistvalues(String objectName, String field_apiname,Boolean nullRequired) 
    {
           return COM_CommodityUtils.getPicklistValueSObject( objectName, field_apiname, nullRequired );
    }
   
    
    
    /*
    @AuraEnabled
    public static List<Com_Domande__c> getDomande(String FilialeName , String TipoCommodity )
    {
        List<COM_Domande__c> allDomande = new List<COM_Domande__c>();
                             allDomande = [SELECT Id,
                                                  Name,
                                                  Domanda1__c,
                                                  Domanda2__c,
                                                  Domanda3__c,
                                                  Domanda4__c,
                                                  Domanda5__c,
                                                  Domanda6__c,
                                                  Domanda7__c,
                                                  Domanda8__c,
                                                  Domanda9__c,
                                                  Domanda10__c
                                            FROM COM_Domande__c 
                                            WHERE Name =: TipoCommodity ];
        allDomande[0].Domanda10__c = allDomande[0].Domanda10__c.replace('$NomeFiliale',FilialeName);

        return allDomande;
    }*/
    
    @AuraEnabled
    public static  Risposte__c addResponseAssicurativo(Risposte__c respdomanda){
         system.debug('01_04_2019 respdomanda-->'+respdomanda);
         upsert  respdomanda;
         return respdomanda;
    }

    @AuraEnabled
    public static  Risposte__c addResponse(Risposte__c respdomanda ,COM_Intervista__c IntervistaIstance , 
                                           boolean ProdottoEV , boolean FilialePosta )
    {
        system.debug('03_04_2019 Risposta:  '+respdomanda);
        system.debug('03_04_2019 Intervista:'+IntervistaIstance);
        system.debug('03_04_2019 ProdottoEV:'+ProdottoEV);
        system.debug('03_04_2019 FilialePosta:'+FilialePosta);
        String NoteDynamic = '';
        /**Logica solo se ci sono 7 Domande: Poi da aggiungere la logica mancante**/
        Integer RisposteSi = 0,RisposteNo=0,RisposteNonRicorda=0;
        Boolean PrimaDomandaNo  = false;
        Boolean AttivitDiRecall = false;
        
        //Check prima domanda
        // Valori - Si
        //        - No
        //        - Non Ricorda
        if( respdomanda.Contratto1__c == 'Si' )
        {
            RisposteSi++;
        }
        else{
            if( respdomanda.Contratto1__c == 'Non Ricorda' )
            {
                RisposteNonRicorda++;
                RisposteSi++;
            }else if( respdomanda.Contratto1__c == 'No' )
            {
                PrimaDomandaNo=true;
                RisposteNo++;
                NoteDynamic += '- Copia Contratto [/]'+'\n';
            }
        }
        //Check seconda domanda
        // Valori - Si
        //        - No
        //        - Non Ricorda
        if( respdomanda.Secci1__c == 'Si' )
        {
            RisposteSi++;
        }
        else{
            if( respdomanda.Secci1__c == 'Non Ricorda')
            {
                RisposteNonRicorda++;
                RisposteSi++;
            }else if( respdomanda.Secci1__c == 'No')
            {
                RisposteNo++;//if( respdomanda.Secci1__c == 'No')
            }
        }
        
        //Check terza domanda
        // Valori - Non richiesta
        //        - Richiesta e ottenuta
        //        - Richiesta e non ottenuta
        //        - Non Ricorda
        if( respdomanda.Precontratto1__c == 'Si' )
        {
            RisposteSi++;
        }
        else{
            if( respdomanda.Precontratto1__c == 'Non Ricorda' )
            {
                RisposteNonRicorda++;
                RisposteSi++;
            }else if( respdomanda.Precontratto1__c == 'No')
            {
                RisposteNo++;
            }else if( respdomanda.Precontratto1__c == 'Non richiesta')
            {
                RisposteSi++;
            }else if( respdomanda.Precontratto1__c == 'Richiesta e ottenuta')
            {
                RisposteSi++;
            }else if( respdomanda.Precontratto1__c == 'Richiesta e non ottenuta')
            {
                RisposteNo++;
            }
            
        }
        
        //Check quarta domanda
        // Valori - Si
        //        - No
        //        - Non Ricorda
        if( respdomanda.Questionario_assicurativo1__c == 'Si' )
        {
            RisposteSi++;
        }
        else{
            if( respdomanda.Questionario_assicurativo1__c == 'Non Ricorda')
            {
                RisposteNonRicorda++;
                RisposteSi++;
            }else if( respdomanda.Questionario_assicurativo1__c == 'No' )
            {
                RisposteNo++;
            }            
        }
         
        //Check quinta domanda
        // Valori - Si
        //        - No
        //        - Non Ricorda
        if( respdomanda.Contratto_Assicurazione__c == 'Si' )
        {
            RisposteSi++;
        }
        else{
            if( respdomanda.Contratto_Assicurazione__c == 'Non Ricorda' )
            {
                RisposteNonRicorda++;
                RisposteSi++;
            }else if( respdomanda.Contratto_Assicurazione__c == 'No' )
            {
                RisposteNo++;
                NoteDynamic += '- Copia contratto/i assicurativo [/]'+'\n';
            }
        }
        
        //Check sesta domanda
        // Valori - Si
        //        - No
        //        - Non Ricorda
        if( respdomanda.Documenti_Assicurazione1__c == 'Si' )
        {
            RisposteSi++;
        }
        else{
            if( respdomanda.Documenti_Assicurazione1__c == 'Non Ricorda')
            {
                RisposteNonRicorda++;
                RisposteSi++;
            }else if( respdomanda.Documenti_Assicurazione1__c == 'No' )
            {
                RisposteNo++;
                NoteDynamic += '- Condizioni assicurative [/]'+'\n';
            }
        }
        
        
        //Check settima domanda
        if( respdomanda.Soddisfazione_Cliente1__c == 'Si' )
        {
            RisposteSi++;
        }else{
            if( respdomanda.Soddisfazione_Cliente1__c == 'Non Ricorda')
            {
                RisposteNonRicorda++;
                RisposteSi++;
            }else if( respdomanda.Soddisfazione_Cliente1__c == 'No')
            {
                RisposteNo++;
            }
        }
       
               
        if( PrimaDomandaNo == true )
        {
            respdomanda.Valutazione__c = 'NEGATIVO';
			IntervistaIstance.COM_Intervista_Utile__c = 'NO';
            IntervistaIstance.COM_Interview_Utils__c  = false; 
            IntervistaIstance.COM_Intervista_Non_Utile__c = true;
            IntervistaIstance.COM_Valutazione__c = 'NEGATIVO'; 
        }
        else{
                /** Gestione VALUTAZIONE PRODOTTO != 'EV' **/
                if( IntervistaIstance.COM_C_prod__c != 'EV' && ProdottoEV == false )
                {
                    if( RisposteSi > 6 || RisposteSi == 6 )
                    {
                        respdomanda.Valutazione__c = 'POSITIVO';
						IntervistaIstance.COM_Intervista_Utile__c = 'SI';
                        IntervistaIstance.COM_Interview_Utils__c  = true;
                        IntervistaIstance.COM_Intervista_Non_Utile__c = false;
                        IntervistaIstance.COM_Valutazione__c = 'POSITIVO'; 
                        
                        if( respdomanda.Id != null )
                        {
                            IntervistaIstance.COM_ATTIVIT_DI_RECALL_INTERNO_POST_COMM__c = 'SI';
                            AttivitDiRecall = true;
                        }
                    }else{
                        if( RisposteNo > 2 || RisposteNo == 2 )
                        {
                            respdomanda.Valutazione__c = 'NEGATIVO';
							IntervistaIstance.COM_Intervista_Utile__c = 'NO';
                            IntervistaIstance.COM_Interview_Utils__c  = false; 
                            IntervistaIstance.COM_Intervista_Non_Utile__c = true;
                            IntervistaIstance.COM_Valutazione__c = 'NEGATIVO'; 
                        }else{
                            respdomanda.Valutazione__c = 'NEGATIVO';
							IntervistaIstance.COM_Intervista_Utile__c = 'NO';
                            IntervistaIstance.COM_Interview_Utils__c  = false; 
                            IntervistaIstance.COM_Intervista_Non_Utile__c = true;
                            IntervistaIstance.COM_Valutazione__c = 'NEGATIVO'; 
                        }
                    }
                }
                /** Gestione VALUTAZIONE PRODOTTO == 'EV' **/
                if( IntervistaIstance.COM_C_prod__c == 'EV' && ProdottoEV == true )
                {
                    /**
            	        Se prodotto Evergreen (quattro domande)
	                    Negativo se : almeno 2 risposte "NO"
	                    Positivo se: almeno 3 risposte  "SI" **/
                      if( RisposteSi == 3 || RisposteSi > 3 )
                      {
                          respdomanda.Valutazione__c = 'POSITIVO';
						  IntervistaIstance.COM_Intervista_Utile__c = 'SI';
                          IntervistaIstance.COM_Interview_Utils__c  = true;
                          IntervistaIstance.COM_Intervista_Non_Utile__c = false;
                          IntervistaIstance.COM_Valutazione__c = 'POSITIVO'; 
                      }else{
                          if( RisposteNo > 2 || RisposteNo == 2 )
                          {
                              respdomanda.Valutazione__c = 'NEGATIVO';
							  IntervistaIstance.COM_Intervista_Utile__c = 'NO';
                              IntervistaIstance.COM_Interview_Utils__c  = false; 
                              IntervistaIstance.COM_Intervista_Non_Utile__c = true;
                              IntervistaIstance.COM_Valutazione__c = 'NEGATIVO'; 
                          }else{
                              respdomanda.Valutazione__c = 'NEGATIVO';
							  IntervistaIstance.COM_Intervista_Utile__c = 'NO';
                              IntervistaIstance.COM_Interview_Utils__c  = false; 
                              IntervistaIstance.COM_Intervista_Non_Utile__c = true;
                              IntervistaIstance.COM_Valutazione__c = 'NEGATIVO'; 
                          }
                      }
                }
        }
        system.debug('28_03_2019 respdomanda-->'+respdomanda);
        system.debug('27_05_2019 RisposteSi->'+RisposteSi+'-RisposteNo'+RisposteNo);
        respdomanda.Type__c = 'Filliale';
        respdomanda.Count_Positivi__c = RisposteSi;
        respdomanda.Count_Negativi__c = RisposteNo;
        respdomanda.Name    = IntervistaIstance.Name;
        upsert  respdomanda;

        /** Gestione Chiusa Conforme/Chiusa non Conforme Intervista con le seguenti regole:
         *  
           - Intervista utile (conforme), con valore SI/NO valorizzato come segue:
	             1. Se prodotto Evergreen (quattro domande)
                        1.1	NO se: irreperibile o non accetta, oppure se accetta ma ci sono 2 o più risposte “NON RICORDO” 		
                        1.2	SI se: Intervista conclusa e con meno di 2 "NON RICORDO"
                 2.	Se altro prodotto (sette domande)
                        2.1	NO se: irreperibile o non accetta, oppure se accetta ma ci sono 3 o più risposte “NON RICORDO” 		
                        2.2	SI se: Intervista conclusa e con meno di 3 "NON RICORDO"
          */
        
        if( FilialePosta == true )
        {
            if( respdomanda.COM_Filiale_Posta__c == 'Posta')
            {
                IntervistaIstance.Ritiro_Doc__c = 'P';
            }else if( respdomanda.COM_Filiale_Posta__c == 'Filiale' )
            {
                IntervistaIstance.Ritiro_Doc__c = 'F';
            }else{
                IntervistaIstance.Ritiro_Doc__c = '';
            }
        }else{
                IntervistaIstance.Ritiro_Doc__c = '';
        }
        
		update IntervistaIstance;
		
		/*
        if( IntervistaIstance.COM_C_prod__c == 'EV' && ProdottoEV == true )
        {
            if( IntervistaIstance.COM_Stato_Avanzamento_Intervista__c == 'Conclusa' )
            {
                boolean flag = false;
                if( RisposteNonRicorda == 2 || RisposteNonRicorda > 2 )
                {
                    IntervistaIstance.COM_Intervista_Utile__c = 'NO';
                    IntervistaIstance.COM_Interview_Utils__c  = false; 
                    IntervistaIstance.COM_Intervista_Non_Utile__c = true;
                    flag = true;
                }else{
                    IntervistaIstance.COM_Intervista_Utile__c = 'SI';
                    IntervistaIstance.COM_Interview_Utils__c  = true;
                    IntervistaIstance.COM_Intervista_Non_Utile__c = false;
                    flag = true;
                }
                if( flag == true )update IntervistaIstance;
            }
        }
        if( IntervistaIstance.COM_C_prod__c != 'EV' && ProdottoEV == false )
        {
            if( IntervistaIstance.COM_Stato_Avanzamento_Intervista__c == 'Conclusa' )
            {
                boolean flag = false;
                if( RisposteNonRicorda == 3 || RisposteNonRicorda > 3 )
                {
                    IntervistaIstance.COM_Intervista_Utile__c = 'NO';
                    IntervistaIstance.COM_Interview_Utils__c  = false; 
                    flag = true;
                }else{
                    IntervistaIstance.COM_Intervista_Utile__c = 'SI';
                    IntervistaIstance.COM_Interview_Utils__c  = true; 
                    flag = true;
                }
                if( flag == true )update IntervistaIstance;
            }
        }*/
        // Creazione Case
        if( FilialePosta == true && respdomanda.COM_Filiale_Posta__c == 'Posta')
        {
                 String NoteSTR                       = 'Si richiede la seguente documentazione relativa alla pratica n° '
                                                         +IntervistaIstance.Name+' in formato pdf : '+
                                                         '\n'+NoteDynamic;
                 List<XCS_Categoria__c> ListCategorie = new List<XCS_Categoria__c>();
                 ListCategorie                        = [ SELECT Id FROM XCS_Categoria__c WHERE External_Id__c = '1772' limit 1];  
                 AssignmentRule AR                    = [ SELECT Id, Name, SobjectType, Active 
                                                          FROM AssignmentRule 
                                                          WHERE SObjectType = 'Case' 
                                                         // AND Active = True 
                                                            AND Name = 'CodaCommodityFilliale Assignment' LIMIT 1];
             if( ListCategorie != null && ListCategorie.size() > 0 )
                 {
                
                 COM_CommodityUtils.InsertCaseFiliali( 'XCS_Post_Vendita', IntervistaIstance.COM_MD_Filiale__c, IntervistaIstance.COM_NomeCliente__c, IntervistaIstance.Id, 'CRM_POSTVENDITA', 
                                                       'PV_Da_Processare','1','No','Invio Documentazione', IntervistaIstance.Name , IntervistaIstance.COM_NomeCliente__r.getCodice_Cliente__c , 
                                                       NoteSTR , ListCategorie[0].Id , AR );
                 }else{
                       COM_CommodityUtils.InsertCaseFiliali( 'XCS_Post_Vendita', IntervistaIstance.COM_MD_Filiale__c, IntervistaIstance.COM_NomeCliente__c, IntervistaIstance.Id, 'CRM_POSTVENDITA', 
                                                       'PV_Da_Processare','1','No','Invio Documentazione', IntervistaIstance.Name , IntervistaIstance.COM_NomeCliente__r.getCodice_Cliente__c , 
                                                       NoteSTR , null /*ListCategorie[0].Id*/ , AR );
            
                 }
                          
        }
        return respdomanda;
    }
   
    
    @AuraEnabled
    public static Risposte__c getRisposta(String idIntervista) 
    {
        List<Risposte__c> ListRisp = new List<Risposte__c>();
        /*Risposte__c risposta*/ListRisp=[SELECT Id,Intervista__c,Intervista__r.COM_NomeCliente__r.Name,
                Contratto1__c,Secci1__c,Precontratto1__c,Questionario_assicurativo1__c,
                Contratto_Assicurazione__c,Documenti_Assicurazione1__c, Soddisfazione_Cliente1__c ,
                Count_Negativi__c,Count_Positivi__c,Valutazione__c,COM_Note_Contratto__c,COM_Note_Secci__c,
                                            COM_Note_Precontratto__c,COM_Note_Questionario_Assicurativo__c,
                                            COM_Note_Contratto_Assicurazione__c,COM_Note_Documenti_Assicurazione__c,
                                            COM_Note_Soddisfazione_Cliente__c
                              FROM Risposte__c WHERE Intervista__r.Id =: idIntervista ];//limit 1];
        if(ListRisp != null && ListRisp.size()>0)
            return ListRisp[0];
        else return new Risposte__c();
    }
    
    @AuraEnabled
    public static SObject updateIntervista (SObject param)
    {
        upsert  param;
        return param;
    }
    
    @AuraEnabled
    public static String getLimitCINZFromCS()
    {
       COM_Comodity_Questionario__c CSInstance = COM_Comodity_Questionario__c.getInstance('1F');
       return CSInstance.COM_Limite_Cin_Z__c;
    }
    
    @AuraEnabled
    public static Integer getCountIntervisteCINZ_G( /*ID AccountId*/ )
    {
           Integer mnth = System.Today().Month();
           return [ SELECT COUNT() FROM COM_Intervista__c
                    WHERE /*COM_MD_Filiale__c    =: AccountId AND */
                          COM_Stato_Avanzamento_IntervistaASS__c = 'Conclusa' AND
                          Com_Current_Period_Assicurativo__c     = true ];
                          /*
                          COM_cin_z_calc__c = 'G' AND
                          CALENDAR_MONTH(createddate)=:mnth]; */
    }
}