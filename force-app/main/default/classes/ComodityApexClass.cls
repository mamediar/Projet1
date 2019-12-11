/**
  * @description: apex class contains implements method of commodity
  * @date:04/03/2019
  * @author:Salimata NGOM
  */

public class ComodityApexClass {
    
    @AuraEnabled
    public static boolean getUserInfos() {
        system.debug('Class:ComodityApexClass//Method:getUserInfos()');
        User usr                = [ SELECT Id,UserRole.Name FROM User WHERE Id =: UserInfo.getUserId()];
        //Profile ProfileInstance = [ SELECT Id,Name FROM Profile WHERE Id =: UserInfo.getProfileId() ];
        //system.debug('15_04_2019 ProfileInstance:::>>>'+ProfileInstance);
        //if (ProfileInstance.Name == 'CC&Commodity') {
        //    return false;
        //}
        if( usr.UserRole.Name == 'Numero Blu')
        {
            return false;
        }else if( usr.UserRole.Name == 'Call Center Interno')
        {
            return true;
        }
        return true;
    }
    @AuraEnabled
    public static List<Account> getAllFiliale() {

        List<Account> allFilialeAccounts = new List<Account>();
        Integer mnth = System.Today().MOnth();
        List<COM_Intervista__c> interviewList=[SELECT Id ,COM_MD_Filiale__r.Name , COM_MD_Filiale__r.CodiceClienteFilled__c,
                 COM_MD_Filiale__c,COM_N_Telefono_Cel__c,Ritiro_Doc__c,COM_Status__c,
                 LastModifiedBy.Name,COM_Stato_Avanzamento_Intervista__c,COM_Intervista_Non_Utile__c
        FROM COM_Intervista__c WHERE COM_Current_Period_Filiale__c = true /*where  COM_Stato_Avanzamento_Intervista__c = 'Nuovo'
        and CALENDAR_MONTH(createddate)=:mnth*/];


        Set<Id> AccountIds = new Set<Id>();
        for(COM_Intervista__c interview:interviewList){
            AccountIds.add( interview.COM_MD_Filiale__c );
        }

        allFilialeAccounts = [ SELECT Id,Name,OCS_External_Id__c,CodiceClienteFilled__c,
                                    COM_NumeroTotali_Pratiche__c,COM_PraticheChiuse_Conforme__c,
                                    COM_ChiusoNon_Conforme__c,COM_Numero_Pratiche_Filiale__c,COM_Numero_Pratiche_Conf_Filiale__c,
                                    COM_Numero_Pratiche_NConf_Filiale__c,getCodice_Cliente__c,COM_Numero_Pratiche_ConfEV_Filiale__c
                               FROM Account
                               WHERE Id in : AccountIds ];
        
        return allFilialeAccounts;

    }

    /**
    * @description: execute Query Filtered
    * @date::05/03/2019
    * @author:Salimata NGOM
    * @params: NameFiliale,codiceFiliale,numeroPratiche,chiusoConforme,chiusoNonConforme
    * @modification:
   */
    @AuraEnabled
    public static List<Account> execQueryFiltered(String NameFiliale,String codiceFiliale,String numeroPratiche,String chiusoConforme,String chiusoNonConforme) {
       List<Account> allFilialeAccounts = new List<Account>();
        Integer mnth = System.Today().MOnth();
           List<COM_Intervista__c> interviewList=[SELECT Id, COM_Status__c ,
                Ritiro_Doc__c,COM_MD_Filiale__r.COM_Numero_Pratiche_ConfNonEV_Filiale__c,
                COM_MD_Filiale__r.Name , COM_MD_Filiale__r.CodiceClienteFilled__c,
                                                  COM_MD_Filiale__r.COM_Numero_Pratiche_ConfEV_Filiale__c,
                COM_Stato_Avanzamento_Intervista__c,createddate,COM_Intervista_Non_Utile__c,COM_MD_Filiale__c
           FROM COM_Intervista__c WHERE COM_Current_Period_Filiale__c = true /*AND COM_Stato_Avanzamento_Intervista__c='Nuovo'*/
           /*AND CALENDAR_MONTH(createddate)=:mnth*/ ];
        Set<Id> AccountIds = new Set<Id>();
        for(COM_Intervista__c interview:interviewList){
            AccountIds.add( interview.COM_MD_Filiale__c );
        }
        string tempNameFiliale;
        if(String.isBlank(NameFiliale)){
            tempNameFiliale='';
        }else{
            tempNameFiliale=NameFiliale+'%';
        }
        String ConditionOfSearch='';
        if( !String.isBlank(codiceFiliale))ConditionOfSearch=' CodiceClienteFilled__c =:codiceFiliale ';
        if( !String.isBlank(NameFiliale))ConditionOfSearch  = 'Name like :tempNameFiliale ';
        if( !String.isBlank(numeroPratiche))
        {    
             Decimal NumeroPraticheDec = Decimal.valueOf( numeroPratiche );
             ConditionOfSearch=' COM_Numero_Pratiche_Filiale__c=: NumeroPraticheDec ';
        }
        if( !String.isBlank(chiusoConforme))
        {
            Decimal NumeroPraticheConfDec = Decimal.valueOf( chiusoConforme );
            ConditionOfSearch=' COM_Numero_Pratiche_Conf_Filiale__c=:NumeroPraticheConfDec ';
        }
        if( !String.isBlank(chiusoNonConforme))
        {
            Decimal NumeroPraticheNConfDec = Decimal.valueOf( chiusoNonConforme );
            ConditionOfSearch=' COM_Numero_Pratiche_NConf_Filiale__c=:NumeroPraticheNConfDec ';
        }

        String QueryToDo = ' Select Id,Name,getCodice_Cliente__c,COM_Numero_Pratiche_ConfEV_Filiale__c,CodiceClienteFilled__c,OCS_External_Id__c,COM_Numero_Pratiche_Filiale__c,COM_NumeroTotali_Pratiche__c,COM_PraticheChiuse_Conforme__c,COM_ChiusoNon_Conforme__c,COM_Numero_Pratiche_Conf_Filiale__c,COM_Numero_Pratiche_NConf_Filiale__c  '+
                           ' FROM Account '+
                           ' WHERE '+ConditionOfSearch+' AND Id IN :AccountIds ';
        List<Account> ListOfAcc = Database.query(QueryToDo);
        system.debug('01_04_2019 ListOfAcc: '+ListOfAcc );
        return ListOfAcc;
        /*
            allFilialeAccounts = [
                    Select Id,Name,OCS_External_Id__c,COM_NumeroTotali_Pratiche__c,COM_PraticheChiuse_Conforme__c,COM_ChiusoNon_Conforme__c
                    FROM Account
                    WHERE ((OCS_External_Id__c =:codiceFiliale)
                    OR (Name like :tempNameFiliale)
                    OR (COM_NumeroTotali_Pratiche__c=:numeroPratiche)
                    OR (COM_PraticheChiuse_Conforme__c=:chiusoConforme)
                    OR (COM_ChiusoNon_Conforme__c=:chiusoNonConforme))
                    AND Id IN :AccountIds
            ];

        return allFilialeAccounts; */
    }
 /**
* @description: execute Query Filtered Pratiche
* @date::12/03/2019
* @author:Salimata NGOM
* @params: NameFiliale,codiceFiliale
* @modification:
*/
    @AuraEnabled
  public static List<COM_Intervista__c> execQueryFilteredPratiche( String NameFiliale,String NameCliente ) {
      system.debug('ParametroUno:'+NameCliente);
            system.debug('NameFiliale:'+NameFiliale);

                Integer mnth = System.Today().Month();
                string tempNameFiliale;
                if(String.isBlank(NameFiliale)){
                    tempNameFiliale='';
                }else{
                    tempNameFiliale=NameFiliale+'%';
                }
                 
                List<COM_Intervista__c> interviewList = [ SELECT Id,COM_Stato_Avanzamento_Intervista__c,COM_NomeCliente__c,COM_CRMNome_Cliente_Formula__c,COM_Data_Esito__c,
                                                                 COM_CRMNome_Filiale_Formula__c , COM_Ultimo_Esito_FIL__c ,COM_MD_Filiale__c, 
                                                                 COM_NomeCliente__r.Name , /*Owner.Name,*/COM_NomeCliente__r.Phone , COM_NomeCliente__r.Acquisition_Date__c , COM_Status__c , COM_cin_z_calc__c , 
                                                                 COM_MD_Filiale__r.CodiceClienteFilled__c,COM_date_first_contacted__c , COM_D_liquid__c , LastModifiedDate , COM_MD_Filiale__r.Name,COM_N_Telefono_Cel__c,
                                                                 Ritiro_Doc__c,COM_C_prod__c , COM_CRMRichiamare_il__c , COM_callback_notes__c,COM_Intervista_Non_Utile__c,COM_MD_Filiale__r.getCodice_Cliente__c,
                                                                 COM_MD_Filiale__r.COM_Numero_Pratiche_Conf_Filiale__c,COM_MD_Filiale__r.COM_Numero_Pratiche_ConfEV_Filiale__c,
                                                                 COM_MD_Filiale__r.COM_Numero_Pratiche_ConfNonEV_Filiale__c,COM_AC_SESSO__c,COM_ATTIVIT_DI_RECALL_INTERNO_POST_COMM__c,
                                                                 COM_Data_Esito_ASS__c
                                                          FROM COM_Intervista__c  
                                                          WHERE COM_Current_Period_Filiale__c = true AND
                                                                COM_Stato_Avanzamento_Intervista__c !='' AND
                                                                ( (COM_NomeCliente__r.Name =:NameCliente) OR 
                                                                  (COM_MD_Filiale__r.Name like :tempNameFiliale) ) 
                                                                ORDER BY COM_CRMRichiamare_il__c ASC NULLS LAST ];

    return interviewList;
}

/**
 * @description:get all list of interviews
 * @date::08/03/2019
 * @author:Salimata NGOM
 * @params: none
 * @return: List<COM_Intervista__c>
 * @modification:
*/

@AuraEnabled
public static List<COM_Intervista__c> getAllInterviews() 
{
       Integer mnth = System.Today().Month();
       Datetime dateToday = System.now();
        List<COM_Intervista__c> interviewList=new List<COM_Intervista__c>();
        List<COM_Intervista__c> orderList=new List<COM_Intervista__c>();
        List<COM_Intervista__c> resultList=new List<COM_Intervista__c>();

       
        interviewList = [SELECT Id,COM_Stato_Avanzamento_Intervista__c,
                                COM_NomeCliente__c, COM_CRMNome_Cliente_Formula__c,
                                COM_CRMNome_Filiale_Formula__c ,
                                COM_CRMTelefono_Cliente_Formula__c,COM_NomeCliente__r.Name , 
                                COM_MD_Filiale__r.Name , COM_MD_Filiale__r.CodiceClienteFilled__c,COM_Data_Esito__c,
                                COM_NomeCliente__r.Phone , COM_Ultima_Modifica_Utente__c ,LastModifiedBy.Name,COM_Interview_Utils__c,COM_NomeCliente__r.Acquisition_Date__c ,
                                COM_date_first_contacted__c , COM_D_liquid__c , LastModifiedDate ,
                                COM_C_prod__c  , COM_callback_notes__c ,COM_CRMRichiamare_il__c,COM_Status__c,
                                COM_Ultimo_Esito_FIL__c,COM_Intervista_Non_Utile__c,COM_N_Telefono_Cel__c,COM_cin_z_calc__c,Ritiro_Doc__c,
                                COM_MD_Filiale__r.COM_Numero_Pratiche_Conf_Filiale__c,COM_ATTIVIT_DI_RECALL_INTERNO_POST_COMM__c, 
                         COM_Data_Esito_ASS__c,
                         COM_MD_Filiale__r.COM_Numero_Pratiche_ConfEV_Filiale__c,COM_MD_Filiale__r.COM_Numero_Pratiche_ConfNonEV_Filiale__c,COM_AC_SESSO__c,
                          (SELECT Id, Contratto1__c,Secci1__c,Precontratto1__c,Questionario_assicurativo1__c,Contratto_Assicurazione__c,Documenti_Assicurazione1__c ,
                          Soddisfazione_Cliente1__c , Count_Positivi__c, Count_Negativi__c ,Valutazione__c FROM Risposte__r  WHERE Type__c = 'Filliale' )
                         FROM COM_Intervista__c 
                         WHERE ( COM_Stato_Avanzamento_Intervista__c= 'Nuovo' OR  
                                 COM_Stato_Avanzamento_Intervista__c = 'Richiamare' OR 
                                 COM_Stato_Avanzamento_Intervista__c = 'In corso' OR 
                                 COM_Stato_Avanzamento_Intervista__c = 'Non accetta' OR 
                                 COM_Stato_Avanzamento_Intervista__c = 'Conclusa' OR 
                                 COM_Stato_Avanzamento_Intervista__c = 'Irreperibile' OR
                                 COM_Stato_Avanzamento_Intervista__c = 'Non Risponde' ) AND
                                 COM_Current_Period_Filiale__c = true /* AND
                                 Com_Current_Period_Assicurativo__c  = true*/ AND COM_CRMRichiamare_il__c <=: dateToday
                                 ORDER BY COM_CRMRichiamare_il__c DESC ];
                                 //+ FieldToOrderBy+ ' '+TypeOfOrder;
                          //' AND CALENDAR_MONTH(createddate)=:mnth order by '+FieldToOrderBy+ ' '+TypeOfOrder;
       orderList = [SELECT Id,COM_Stato_Avanzamento_Intervista__c,
                                COM_NomeCliente__c, COM_CRMNome_Cliente_Formula__c,COM_Data_Esito__c,
                                COM_CRMNome_Filiale_Formula__c ,
                                COM_CRMTelefono_Cliente_Formula__c,COM_NomeCliente__r.Name ,
                                COM_MD_Filiale__r.Name , COM_MD_Filiale__r.CodiceClienteFilled__c,COM_Status__c,
                                COM_NomeCliente__r.Phone , COM_Ultima_Modifica_Utente__c  , LastModifiedBy.Name,COM_Interview_Utils__c,COM_NomeCliente__r.Acquisition_Date__c ,
                                COM_date_first_contacted__c , COM_D_liquid__c , LastModifiedDate ,
                                COM_C_prod__c  , COM_callback_notes__c ,COM_CRMRichiamare_il__c,
                                COM_Ultimo_Esito_FIL__c,COM_Intervista_Non_Utile__c,COM_N_Telefono_Cel__c,COM_cin_z_calc__c,Ritiro_Doc__c,
                                COM_MD_Filiale__r.COM_Numero_Pratiche_Conf_Filiale__c,COM_ATTIVIT_DI_RECALL_INTERNO_POST_COMM__c,
                    COM_Data_Esito_ASS__c,
                    COM_MD_Filiale__r.COM_Numero_Pratiche_ConfEV_Filiale__c,COM_MD_Filiale__r.COM_Numero_Pratiche_ConfNonEV_Filiale__c,COM_AC_SESSO__c,
                    (SELECT Id, Contratto1__c,Secci1__c,Precontratto1__c,Questionario_assicurativo1__c,Contratto_Assicurazione__c,Documenti_Assicurazione1__c ,
                          Soddisfazione_Cliente1__c , Count_Positivi__c, Count_Negativi__c ,Valutazione__c FROM Risposte__r WHERE Type__c = 'Filliale')
                         FROM COM_Intervista__c 
                         WHERE ( COM_Stato_Avanzamento_Intervista__c= 'Nuovo' OR  
                                 COM_Stato_Avanzamento_Intervista__c = 'Richiamare' OR 
                                 COM_Stato_Avanzamento_Intervista__c = 'In corso' OR 
                                 COM_Stato_Avanzamento_Intervista__c = 'Non accetta' OR 
                                 COM_Stato_Avanzamento_Intervista__c = 'Conclusa' OR 
                                 COM_Stato_Avanzamento_Intervista__c = 'Irreperibile' OR
                                 COM_Stato_Avanzamento_Intervista__c = 'Non Risponde') AND
                                 COM_Current_Period_Filiale__c = true /*AND
                                 Com_Current_Period_Assicurativo__c  = true*/ AND 
                                 (COM_CRMRichiamare_il__c >: dateToday OR COM_CRMRichiamare_il__c = null)
                                 ];

                                 
     resultList.addAll(interviewList);
     resultList.addAll(orderList);
     System.debug('List1.Risposte__r' + resultList[0].Risposte__r);
    return resultList;       //return Database.query(QueryToDo);     

}
 
    
@AuraEnabled
public static List<COM_Intervista__c> getAllInterviewsOrderBy( String FieldToOrderBy , String TypeOfOrder  ) 
{
       Integer mnth     = System.Today().Month();
       String QueryToDo;
       if (FieldToOrderBy=='COM_CRMRichiamare_il__c') {
           QueryToDo = ' SELECT Id,COM_Stato_Avanzamento_Intervista__c,COM_Data_Esito_ASS__c,'+
                          ' COM_NomeCliente__c, COM_CRMNome_Cliente_Formula__c,COM_Data_Esito__c,'+
                          ' COM_CRMNome_Filiale_Formula__c ,COM_MD_Filiale__r.Name , COM_MD_Filiale__r.CodiceClienteFilled__c,'+
                          ' COM_CRMTelefono_Cliente_Formula__c,'+
                          ' COM_NomeCliente__r.Name ,'+
                          ' COM_NomeCliente__r.Phone , COM_NomeCliente__r.Acquisition_Date__c ,COM_ATTIVIT_DI_RECALL_INTERNO_POST_COMM__c,'+
                          ' COM_date_first_contacted__c , COM_Interview_Utils__c, COM_D_liquid__c , LastModifiedDate , COM_AC_SESSO__c,'+
                          ' COM_C_prod__c  , COM_callback_notes__c,LastModifiedBy.Name ,COM_CRMRichiamare_il__c,Ritiro_Doc__c,COM_MD_Filiale__r.COM_Numero_Pratiche_ConfEV_Filiale__c,'+
                          ' COM_Ultimo_Esito_FIL__c,COM_Intervista_Non_Utile__c,COM_MD_Filiale__r.COM_Numero_Pratiche_ConfNonEV_Filiale__c,COM_cin_z_calc__c,COM_N_Telefono_Cel__c,COM_Status__c '+
                          ' FROM COM_Intervista__c  '+  
                          ' WHERE ( COM_Stato_Avanzamento_Intervista__c=\'Nuovo\' OR '+ 
                          ' COM_Stato_Avanzamento_Intervista__c = \'Richiamare\' OR '+
                          ' COM_Stato_Avanzamento_Intervista__c = \'In corso\' OR '+
                          ' COM_Stato_Avanzamento_Intervista__c = \'Non accetta\' OR '+
                          ' COM_Stato_Avanzamento_Intervista__c = \'Conclusa\' OR'+ 
                          ' COM_Stato_Avanzamento_Intervista__c = \'Irreperibile\' ) AND'+
                          ' COM_Current_Period_Filiale__c = true AND'+
                          ' Com_Current_Period_Assicurativo__c  = true order by '+ FieldToOrderBy+ ' '+TypeOfOrder+' NULLS LAST';
       }else{
            QueryToDo = ' SELECT Id,COM_Stato_Avanzamento_Intervista__c,COM_Data_Esito__c,'+
                          ' COM_NomeCliente__c, COM_CRMNome_Cliente_Formula__c,COM_ATTIVIT_DI_RECALL_INTERNO_POST_COMM__c,'+
                          ' COM_CRMNome_Filiale_Formula__c ,COM_MD_Filiale__r.Name , COM_MD_Filiale__r.CodiceClienteFilled__c,'+
                          ' COM_CRMTelefono_Cliente_Formula__c,COM_Data_Esito_ASS__c,'+
                          ' COM_NomeCliente__r.Name , '+
                          ' COM_NomeCliente__r.Phone , COM_NomeCliente__r.Acquisition_Date__c ,'+
                          ' COM_date_first_contacted__c , LastModifiedBy.Name,COM_Interview_Utils__c, COM_D_liquid__c , LastModifiedDate ,COM_AC_SESSO__c,'+
                          ' COM_C_prod__c  , COM_callback_notes__c ,COM_MD_Filiale__r.COM_Numero_Pratiche_ConfNonEV_Filiale__c,COM_CRMRichiamare_il__c,Ritiro_Doc__c,COM_MD_Filiale__r.COM_Numero_Pratiche_ConfEV_Filiale__c,'+
                          ' COM_Ultimo_Esito_FIL__c,COM_Intervista_Non_Utile__c,COM_cin_z_calc__c,COM_N_Telefono_Cel__c,COM_Status__c '+
                          ' FROM COM_Intervista__c  '+
                          ' WHERE ( COM_Stato_Avanzamento_Intervista__c=\'Nuovo\' OR '+ 
                          ' COM_Stato_Avanzamento_Intervista__c = \'Richiamare\' OR '+
                          ' COM_Stato_Avanzamento_Intervista__c = \'In corso\' OR '+
                          ' COM_Stato_Avanzamento_Intervista__c = \'Non accetta\' OR '+
                          ' COM_Stato_Avanzamento_Intervista__c = \'Conclusa\' OR'+ 
                          ' COM_Stato_Avanzamento_Intervista__c = \'Irreperibile\' ) AND'+
                          ' COM_Current_Period_Filiale__c = true AND'+
                          ' Com_Current_Period_Assicurativo__c  = true order by '+ FieldToOrderBy+ ' '+TypeOfOrder;
       }
       
                          //' AND CALENDAR_MONTH(createddate)=:mnth order by '+FieldToOrderBy+ ' '+TypeOfOrder;
    
       List<COM_Intervista__c> interviewList=new List<COM_Intervista__c>();
       return Database.query(QueryToDo);     
}
    
@AuraEnabled
public static List<COM_Intervista__c> getAllInterviewDaRichiamare()
{
        String QueryToDo = ' SELECT Id,COM_Stato_Avanzamento_Intervista__c,'+
                          ' COM_NomeCliente__c, COM_CRMNome_Cliente_Formula__c,COM_Data_Esito__c,'+
                          ' COM_CRMNome_Filiale_Formula__c ,COM_MD_Filiale__r.Name , COM_MD_Filiale__r.CodiceClienteFilled__c,'+
                          ' COM_CRMTelefono_Cliente_Formula__c,'+
                          ' COM_NomeCliente__r.Name ,COM_ATTIVIT_DI_RECALL_INTERNO_POST_COMM__c, '+
                          ' COM_NomeCliente__r.Phone , LastModifiedBy.Name,COM_Interview_Utils__c , COM_NomeCliente__r.Acquisition_Date__c ,'+
                          ' COM_date_first_contacted__c , COM_D_liquid__c , LastModifiedDate ,COM_AC_SESSO__c,'+
                          ' COM_C_prod__c    , COM_callback_notes__c ,COM_MD_Filiale__r.COM_Numero_Pratiche_ConfNonEV_Filiale__c, '+ // COM_CRMRichiamare_il__c
                          ' COM_Ultimo_Esito_FIL__c,COM_Data_Esito_ASS__c,COM_Intervista_Non_Utile__c,Ritiro_Doc__c,COM_Status__c,COM_MD_Filiale__r.COM_Numero_Pratiche_ConfEV_Filiale__c '+
                          ' FROM COM_Intervista__c  '+
                          ' WHERE COM_Stato_Avanzamento_IntervistaASS__c = \'Richiamare\' ';
        List<COM_Intervista__c> interviewList=new List<COM_Intervista__c>();
       return Database.query(QueryToDo);        
}
    
/**Orlando
 * 
 * */
@AuraEnabled
public static String getLimitCINZFromCS()
{
       COM_Comodity_Questionario__c CSInstance = COM_Comodity_Questionario__c.getInstance('1F');
       return CSInstance.COM_Limite_Cin_Z__c;
}   
       
@AuraEnabled
public static List<COM_Intervista__c> getInterviewTuttiContatti()
{
      Datetime dateToday = System.now();
      Datetime test = dateToday.addMinutes(30);
      Integer mnth = System.Today().Month();
      List<COM_Intervista__c> interviewList = new List <COM_Intervista__c>();
      List<COM_Intervista__c> interList = new List <COM_Intervista__c>();
      List<COM_Intervista__c> secondList = new List <COM_Intervista__c>();
      List<COM_Intervista__c> totalList = new List <COM_Intervista__c>();
    
     interviewList=[select Id, COM_Stato_Avanzamento_Intervista__c,COM_Stato_Avanzamento_IntervistaASS__c,COM_ATTIVIT_DI_RECALL_INTERNO_POST_COMM__c,
                                                        COM_NomeCliente__c, COM_CRMNome_Cliente_Formula__c,Ritiro_Doc__c,COM_Status_ASS__c,
                                                        COM_CRMNome_Filiale_Formula__c,COM_N_Telefono_Cel__c,
                                                        COM_NomeCliente__r.Name, /*Owner.Name,*/ COM_NomeCliente__r.Phone , COM_Status__c ,
                                                        COM_NomeCliente__r.Acquisition_Date__c, COM_Interview_Utils__c, COM_date_first_contacted__c,COM_MD_Filiale__c,COM_cin_z_calc__c,
                                                        COM_D_liquid__c, LastModifiedBy.Name, COM_CRMRichiamare_ilASS__c, LastModifiedDate, COM_C_prod__c ,COM_MD_Filiale__r.Name , COM_MD_Filiale__r.CodiceClienteFilled__c,
                                                       COM_CRMRichiamare_il__c, COM_callback_notes__c , COM_callbackASS_notes__c, COM_Ultimo_Esito_FIL__c,
                   COM_Intervista_Non_Utile__c,COM_Ultimo_Esito_ASS__c,COM_MD_Filiale__r.COM_Numero_Pratiche_ConfEV_Filiale__c,COM_AC_SESSO__c, COM_count_non_rispASS__c, COM_count_richiamaASS__c,
                   COM_MD_Filiale__r.COM_Numero_Pratiche_ConfNonEV_Filiale__c, Com_Current_Period_Assicurativo__c,
                   COM_C_Serv1__c,COM_C_Serv2__c,COM_C_serv3__c,COM_C_serv4__c,COM_C_serv5__c,
                   COM_Data_Esito__c,COM_Data_Esito_ASS__c
                                            FROM COM_Intervista__c 
                                            WHERE Com_Current_Period_Assicurativo__c  = true AND COM_CRMRichiamare_ilASS__c <=: test 
                                            ORDER BY COM_CRMRichiamare_ilASS__c DESC
                                            ];
     interList=orderListAssicurativos(interviewList);                           
     secondList=[select Id, COM_Stato_Avanzamento_Intervista__c,COM_Stato_Avanzamento_IntervistaASS__c,COM_ATTIVIT_DI_RECALL_INTERNO_POST_COMM__c,
                 COM_Data_Esito__c,COM_Data_Esito_ASS__c,
                                                        COM_NomeCliente__c, COM_CRMNome_Cliente_Formula__c,Ritiro_Doc__c,COM_Status_ASS__c,
                                                        COM_CRMNome_Filiale_Formula__c, LastModifiedBy.Name, COM_N_Telefono_Cel__c,
                                                        COM_NomeCliente__r.Name, /*Owner.Name,*/ COM_NomeCliente__r.Phone , COM_Status__c , COM_count_non_rispASS__c, COM_count_richiamaASS__c,
                                                        COM_NomeCliente__r.Acquisition_Date__c, COM_Interview_Utils__c, COM_date_first_contacted__c,COM_MD_Filiale__c,COM_cin_z_calc__c,
                                                        COM_D_liquid__c, COM_CRMRichiamare_ilASS__c, LastModifiedDate, COM_C_prod__c ,COM_MD_Filiale__r.Name , COM_MD_Filiale__r.CodiceClienteFilled__c,
                                                       COM_CRMRichiamare_il__c, COM_callbackASS_notes__c, COM_callback_notes__c , COM_AC_SESSO__c,
                 COM_Ultimo_Esito_FIL__c,COM_Intervista_Non_Utile__c,COM_Ultimo_Esito_ASS__c,
                 COM_MD_Filiale__r.COM_Numero_Pratiche_ConfEV_Filiale__c,COM_MD_Filiale__r.COM_Numero_Pratiche_ConfNonEV_Filiale__c, Com_Current_Period_Assicurativo__c,COM_C_Serv1__c,COM_C_Serv2__c,COM_C_serv3__c,COM_C_serv4__c,COM_C_serv5__c 
                                            FROM COM_Intervista__c
                                            WHERE Com_Current_Period_Assicurativo__c  = true AND
                                            (COM_CRMRichiamare_ilASS__c = null OR COM_CRMRichiamare_ilASS__c >: test ) 
                                            ORDER BY COM_D_liquid__c DESC NULLS LAST
                                            ];
    secondList= orderListAssicurativos(secondList);                                       
    totalList.addAll(interviewList);
    totalList.addAll(secondList);
    return totalList;

}
    
/**
 * @description:get all list of interviews
 * @date::08/03/2019
 * @author:Salimata NGOM
 * @params: none
 * @return: List<COM_Intervista__c>
 * @modification: Method Only for Assicurativo
*/
@AuraEnabled
public static List<COM_Intervista__c> getAllInterviewsWithoutFilter() 
{     
    //Integer cinValue = 0; 
      Datetime dateToday = System.now();
      Datetime test = dateToday.addMinutes(30);
      Integer mnth = System.Today().Month();
      List<COM_Intervista__c> interviewList = new List <COM_Intervista__c>();
      List<COM_Intervista__c> interList = new List <COM_Intervista__c>();
      List<COM_Intervista__c> secondList = new List <COM_Intervista__c>();
      List<COM_Intervista__c> totalList = new List <COM_Intervista__c>();
      COM_Comodity_Questionario__c CSIstance = COM_Comodity_Questionario__c.getInstance('1F');
      Integer cinValue = Integer.valueOf (CSIstance.COM_Limite_Cin_Z__c);
    
      Integer NumberOfIntervistaStatusConclusa = [SELECT COUNT() 
                                                  FROM COM_Intervista__c 
                                                  WHERE COM_Stato_Avanzamento_IntervistaASS__c = 'Conclusa' AND 
                                                        Com_Current_Period_Assicurativo__c     = true ];
    
    if ( NumberOfIntervistaStatusConclusa < cinValue /*cinValue < 20*/ ) {
        
    interviewList=[select Id, COM_Stato_Avanzamento_Intervista__c,COM_Stato_Avanzamento_IntervistaASS__c,COM_ATTIVIT_DI_RECALL_INTERNO_POST_COMM__c,
                                                        COM_NomeCliente__c, COM_CRMNome_Cliente_Formula__c,Ritiro_Doc__c,COM_Status_ASS__c,
                                                        COM_CRMNome_Filiale_Formula__c,COM_N_Telefono_Cel__c,
                                                        COM_NomeCliente__r.Name, /*Owner.Name,*/ COM_NomeCliente__r.Phone , COM_Status__c ,
                                                        COM_NomeCliente__r.Acquisition_Date__c, COM_Interview_Utils__c, COM_date_first_contacted__c,COM_MD_Filiale__c,COM_cin_z_calc__c,
                                                        COM_D_liquid__c, LastModifiedBy.Name, COM_CRMRichiamare_ilASS__c, LastModifiedDate, COM_C_prod__c ,COM_MD_Filiale__r.Name , COM_MD_Filiale__r.CodiceClienteFilled__c,
                                                       COM_CRMRichiamare_il__c, COM_callback_notes__c , COM_callbackASS_notes__c, COM_Ultimo_Esito_FIL__c,
                   COM_Intervista_Non_Utile__c,COM_Ultimo_Esito_ASS__c,COM_MD_Filiale__r.COM_Numero_Pratiche_ConfEV_Filiale__c,COM_AC_SESSO__c, COM_count_non_rispASS__c, COM_count_richiamaASS__c,
                   COM_MD_Filiale__r.COM_Numero_Pratiche_ConfNonEV_Filiale__c, Com_Current_Period_Assicurativo__c,
                   COM_C_Serv1__c,COM_C_Serv2__c,COM_C_serv3__c,COM_C_serv4__c,COM_C_serv5__c,
                   COM_Data_Esito__c,COM_Data_Esito_ASS__c
                                            FROM COM_Intervista__c 
                                            WHERE Com_Current_Period_Assicurativo__c  = true AND COM_CRMRichiamare_ilASS__c <=: test 
                                                  AND COM_cin_z_calc__c != 'V'
                                            ORDER BY COM_CRMRichiamare_ilASS__c DESC
                                            ];
     interList=orderListAssicurativos(interviewList);                           
     secondList=[select Id, COM_Stato_Avanzamento_Intervista__c,COM_Stato_Avanzamento_IntervistaASS__c,COM_ATTIVIT_DI_RECALL_INTERNO_POST_COMM__c,
                 COM_Data_Esito__c,COM_Data_Esito_ASS__c,
                                                        COM_NomeCliente__c, COM_CRMNome_Cliente_Formula__c,Ritiro_Doc__c,COM_Status_ASS__c,
                                                        COM_CRMNome_Filiale_Formula__c, LastModifiedBy.Name, COM_N_Telefono_Cel__c,
                                                        COM_NomeCliente__r.Name, /*Owner.Name,*/ COM_NomeCliente__r.Phone , COM_Status__c , COM_count_non_rispASS__c, COM_count_richiamaASS__c,
                                                        COM_NomeCliente__r.Acquisition_Date__c, COM_Interview_Utils__c, COM_date_first_contacted__c,COM_MD_Filiale__c,COM_cin_z_calc__c,
                                                        COM_D_liquid__c, COM_CRMRichiamare_ilASS__c, LastModifiedDate, COM_C_prod__c ,COM_MD_Filiale__r.Name , COM_MD_Filiale__r.CodiceClienteFilled__c,
                                                       COM_CRMRichiamare_il__c, COM_callbackASS_notes__c, COM_callback_notes__c , COM_AC_SESSO__c,
                 COM_Ultimo_Esito_FIL__c,COM_Intervista_Non_Utile__c,COM_Ultimo_Esito_ASS__c,
                 COM_MD_Filiale__r.COM_Numero_Pratiche_ConfEV_Filiale__c,COM_MD_Filiale__r.COM_Numero_Pratiche_ConfNonEV_Filiale__c, Com_Current_Period_Assicurativo__c,COM_C_Serv1__c,COM_C_Serv2__c,COM_C_serv3__c,COM_C_serv4__c,COM_C_serv5__c 
                                            FROM COM_Intervista__c
                                            WHERE Com_Current_Period_Assicurativo__c  = true AND COM_cin_z_calc__c != 'V' AND 
                                            (COM_CRMRichiamare_ilASS__c = null OR COM_CRMRichiamare_ilASS__c >: test ) 
                                            ORDER BY COM_D_liquid__c DESC NULLS LAST
                                            ];
    secondList= orderListAssicurativos(secondList);                                       
    totalList.addAll(interviewList);
    totalList.addAll(secondList);
    return totalList;

    } else {
        
    interviewList=[select Id, COM_Stato_Avanzamento_Intervista__c,COM_Stato_Avanzamento_IntervistaASS__c,COM_ATTIVIT_DI_RECALL_INTERNO_POST_COMM__c,
                                                        COM_NomeCliente__c, COM_CRMNome_Cliente_Formula__c,Ritiro_Doc__c,COM_Status_ASS__c,
                                                        COM_CRMNome_Filiale_Formula__c,COM_N_Telefono_Cel__c,
                                                        COM_NomeCliente__r.Name, /*Owner.Name,*/ COM_NomeCliente__r.Phone , COM_Status__c ,
                                                        COM_NomeCliente__r.Acquisition_Date__c, COM_Interview_Utils__c, COM_date_first_contacted__c,COM_MD_Filiale__c,COM_cin_z_calc__c,
                                                        COM_D_liquid__c, LastModifiedBy.Name, COM_CRMRichiamare_ilASS__c, LastModifiedDate, COM_C_prod__c ,COM_MD_Filiale__r.Name , COM_MD_Filiale__r.CodiceClienteFilled__c,
                                                       COM_CRMRichiamare_il__c, COM_callback_notes__c , COM_callbackASS_notes__c, COM_Ultimo_Esito_FIL__c,
                   COM_Intervista_Non_Utile__c,COM_Ultimo_Esito_ASS__c,COM_MD_Filiale__r.COM_Numero_Pratiche_ConfEV_Filiale__c,COM_AC_SESSO__c, COM_count_non_rispASS__c, COM_count_richiamaASS__c,
                   COM_MD_Filiale__r.COM_Numero_Pratiche_ConfNonEV_Filiale__c, Com_Current_Period_Assicurativo__c,
                   COM_C_Serv1__c,COM_C_Serv2__c,COM_C_serv3__c,COM_C_serv4__c,COM_C_serv5__c,
                   COM_Data_Esito__c,COM_Data_Esito_ASS__c
                                            FROM COM_Intervista__c 
                                            WHERE Com_Current_Period_Assicurativo__c  = true AND COM_CRMRichiamare_ilASS__c <=: test AND COM_cin_z_calc__c = 'R'
                                            ORDER BY COM_CRMRichiamare_ilASS__c DESC
                                            ];                          
     secondList=[select Id, COM_Stato_Avanzamento_Intervista__c,COM_Stato_Avanzamento_IntervistaASS__c,COM_ATTIVIT_DI_RECALL_INTERNO_POST_COMM__c,
                 COM_Data_Esito__c,COM_Data_Esito_ASS__c,
                                                        COM_NomeCliente__c, COM_CRMNome_Cliente_Formula__c,Ritiro_Doc__c,COM_Status_ASS__c,
                                                        COM_CRMNome_Filiale_Formula__c, LastModifiedBy.Name,COM_N_Telefono_Cel__c,
                                                        COM_NomeCliente__r.Name, /*Owner.Name,*/ COM_NomeCliente__r.Phone , COM_Status__c , COM_count_non_rispASS__c, COM_count_richiamaASS__c,
                                                        COM_NomeCliente__r.Acquisition_Date__c, COM_Interview_Utils__c, COM_date_first_contacted__c,COM_MD_Filiale__c,COM_cin_z_calc__c,
                                                        COM_D_liquid__c, COM_CRMRichiamare_ilASS__c, LastModifiedDate, COM_C_prod__c ,COM_MD_Filiale__r.Name , COM_MD_Filiale__r.CodiceClienteFilled__c,
                                                       COM_CRMRichiamare_il__c, COM_callbackASS_notes__c, COM_callback_notes__c , COM_AC_SESSO__c,
                 COM_Ultimo_Esito_FIL__c,COM_Intervista_Non_Utile__c,COM_Ultimo_Esito_ASS__c,
                 COM_MD_Filiale__r.COM_Numero_Pratiche_ConfEV_Filiale__c,COM_MD_Filiale__r.COM_Numero_Pratiche_ConfNonEV_Filiale__c, Com_Current_Period_Assicurativo__c,COM_C_Serv1__c,COM_C_Serv2__c,COM_C_serv3__c,COM_C_serv4__c,COM_C_serv5__c 
                                            FROM COM_Intervista__c
                                            WHERE Com_Current_Period_Assicurativo__c  = true AND COM_cin_z_calc__c = 'R' AND
                                            (COM_CRMRichiamare_ilASS__c = null OR COM_CRMRichiamare_ilASS__c >: test ) 
                                            ORDER BY COM_D_liquid__c DESC NULLS LAST
                                            ];                                    
    totalList.addAll(interviewList);
    totalList.addAll(secondList);
    return totalList;
    }
}

/**
 * @description:get all list of interviews
 * @date::07/05/2019
 * @author:Mady COLY
 * @params: none
 * @return: List<COM_Intervista__c>
 * @modification: Method Only for Assicurativo
*/
@AuraEnabled
public static List<COM_Intervista__c> getAllInterviewsForAssicurativos() 
{
       List<String> filter=new List<String>();
       filter.add('R');
       filter.add('G');
       filter.add('V');
      List<COM_Intervista__c> intervistaList = new List <COM_Intervista__c>();
      List<COM_Intervista__c> totalList = new List <COM_Intervista__c>();
        for(String myFiltre: filter){
            System.debug('myFiltre: '+myFiltre);
       intervistaList=[select Id,COM_Data_Esito_ASS__c,COM_Stato_Avanzamento_Intervista__c,COM_Stato_Avanzamento_IntervistaASS__c,COM_ATTIVIT_DI_RECALL_INTERNO_POST_COMM__c,
                                                        COM_NomeCliente__c, COM_CRMNome_Cliente_Formula__c,Ritiro_Doc__c,COM_Status_ASS__c,
                                                        COM_CRMNome_Filiale_Formula__c,COM_N_Telefono_Cel__c,
                                                        COM_NomeCliente__r.Name, /*Owner.Name,*/ COM_NomeCliente__r.Phone , COM_Status__c ,
                                                        COM_NomeCliente__r.Acquisition_Date__c, COM_Interview_Utils__c, COM_date_first_contacted__c,COM_MD_Filiale__c,COM_cin_z_calc__c,
                                                        COM_D_liquid__c, LastModifiedBy.Name,COM_CRMRichiamare_ilASS__c, LastModifiedDate, COM_C_prod__c ,COM_MD_Filiale__r.Name , COM_MD_Filiale__r.CodiceClienteFilled__c,
                                                       COM_CRMRichiamare_il__c, COM_callback_notes__c , COM_callbackASS_notes__c, COM_Ultimo_Esito_FIL__c,
                   COM_Intervista_Non_Utile__c,COM_Ultimo_Esito_ASS__c,COM_MD_Filiale__r.COM_Numero_Pratiche_ConfEV_Filiale__c, COM_count_non_rispASS__c, COM_count_richiamaASS__c,
                   COM_MD_Filiale__r.COM_Numero_Pratiche_ConfNonEV_Filiale__c,COM_AC_SESSO__c,COM_Data_Esito__c
                                            FROM COM_Intervista__c 
                                            WHERE Com_Current_Period_Assicurativo__c  = true AND COM_cin_z_calc__c =:myFiltre
                                            ];  
            totalList.addAll(intervistaList);
        }
       return totalList;                                     

}

/**
 * @description:order list of assicurativos 
 * @date::08/05/2019
 * @author:Mady COLY
 * @params: List<COM_Intervista__c>
 * @return: List<COM_Intervista__c>
 * @modification: Method Only for Assicurativo
*/

public static List<COM_Intervista__c> orderListAssicurativos(List<COM_Intervista__c> assicurativosList) 
{
        List<COM_Intervista__c> orderAssicurativosList=new List<COM_Intervista__c>();
        List<COM_Intervista__c> intervistaR=new List<COM_Intervista__c>();
        List<COM_Intervista__c> intervistaG=new List<COM_Intervista__c>();
        List<COM_Intervista__c> intervistaV=new List<COM_Intervista__c>();
       for(COM_Intervista__c intervista: assicurativosList){
           if(intervista.COM_cin_z_calc__c=='R')
                intervistaR.add(intervista);
            else if(intervista.COM_cin_z_calc__c=='G')
                intervistaG.add(intervista);
            else
                intervistaV.add(intervista); 
       }
       orderAssicurativosList.addAll(intervistaR);
       orderAssicurativosList.addAll(intervistaG);
       orderAssicurativosList.addAll(intervistaV);
       return orderAssicurativosList;
}

/**
* @description:get one interviews
* @date::08/03/2019
* @author:Salimata NGOM
* @params: idintervista
* @return: COM_Intervista__c
* @modification: 08/04/2019, to add the "COM_cin_z_calc__c"
*/
@AuraEnabled
public static COM_Intervista__c getDettagliIntervista(string idintervista) {
            Integer mnth = System.Today().MOnth();
             COM_Intervista__c interview= new COM_Intervista__c();
             interview=[select Id, Name, COM_Stato_Avanzamento_Intervista__c,COM_NomeCliente__c,Ritiro_Doc__c,
                               COM_Data_Esito_ASS__c,COM_Interview_Utils__c, COM_NomeCliente__r.Name ,COM_D_Carico__c,COM_Stato_Avanzamento_IntervistaASS__c,
                               COM_NomeCliente__r.Phone , COM_NomeCliente__r.Acquisition_Date__c,
                               COM_Data_Scadenza_Recesso__c,COM_Status__c,COM_ATTIVIT_DI_RECALL_INTERNO_POST_COMM__c,
                               COM_date_first_contacted__c ,COM_N_Telefono_Cel__c,COM_NTelefono1__c,
                               COM_D_liquid__c , LastModifiedBy.Name,LastModifiedDate ,COM_C_prod__c /* COM_CRMRichiamare_il__c */, 
                               COM_callback_notes__c , COM_Ultimo_Esito_FIL__c, COM_cin_z_calc__c, COM_Durata_Sanitarie__c,
                               COM_Intervista_Accettata__c,COM_interview_accepted__c,COM_Intervista_Non_Utile__c,
                               COM_CSER_Descrizione1__c,COM_Data_Esito__c,
                               COM_CSER_Descrizione2__c,COM_PLC_NUM_RATE__c,
                               COM_CSER_Descrizione3__c,COM_Status_ASS__c, COM_count_non_rispASS__c, COM_count_richiamaASS__c,
                               COM_CSER_Descrizione4__c,COM_MD_Filiale__r.COM_Numero_Pratiche_ConfNonEV_Filiale__c,
                               COM_CSER_DESCRIZIONE5__c,COM_MD_Filiale__c,COM_MD_Filiale__r.Name,COM_MD_Filiale__r.COM_Numero_Pratiche_ConfEV_Filiale__c,COM_AC_SESSO__c
             FROM COM_Intervista__c  /*WHERE COM_Stato_Avanzamento_Intervista__c='Nuovo'
                                                AND CALENDAR_MONTH(createddate)=:mnth and */ WHERE Id=:idintervista ];
             system.debug('Intervista: '+interview);
             if( interview.COM_Stato_Avanzamento_Intervista__c == 'Nuovo')
             {
                 interview.COM_Status__c = 'Processing'; update interview;
             }
             return interview;
 }
/**
* @description:get one interviews for any status
* @date::08/03/2019
* @author:Salimata NGOM
* @params: idintervista
* @return: COM_Intervista__c
* @modification:
*/
@AuraEnabled
public static COM_Intervista__c getassicurativoDetail(string idintervista) {
Integer mnth = System.Today().Month();
COM_Intervista__c interview= new COM_Intervista__c();
interview=[select Id, COM_MD_Filiale__r.COM_Numero_Pratiche_ConfEV_Filiale__c,
 COM_MD_Filiale__r.COM_Numero_Pratiche_ConfNonEV_Filiale__c,
  /*  COM_CRMRichiamare_il__c */
           Name, COM_Stato_Avanzamento_Intervista__c,COM_NomeCliente__c,Ritiro_Doc__c,COM_ATTIVIT_DI_RECALL_INTERNO_POST_COMM__c,
                               COM_Interview_Utils__c, COM_NomeCliente__r.Name ,COM_D_Carico__c,COM_Stato_Avanzamento_IntervistaASS__c,
                               COM_NomeCliente__r.Phone , COM_Data_Esito_ASS__c,COM_NomeCliente__r.Acquisition_Date__c,
                               COM_Data_Scadenza_Recesso__c,COM_Status__c,
                               COM_date_first_contacted__c ,COM_N_Telefono_Cel__c,COM_NTelefono1__c,
                               COM_D_liquid__c , LastModifiedDate ,COM_C_prod__c /* COM_CRMRichiamare_il__c */, 
                               COM_callback_notes__c , COM_Ultimo_Esito_FIL__c, COM_cin_z_calc__c, COM_Durata_Sanitarie__c,
                               COM_Intervista_Accettata__c,COM_interview_accepted__c,COM_Intervista_Non_Utile__c,
                               COM_CSER_Descrizione1__c,COM_PLC_NUM_RATE__c,
                               COM_CSER_Descrizione2__c,
                               COM_CSER_Descrizione3__c,
                               COM_CSER_Descrizione4__c,COM_Data_Esito__c,COM_Provenienza__c, 
                               COM_CSER_DESCRIZIONE5__c,COM_C_Serv1__c,COM_C_Serv2__c,COM_C_serv3__c,COM_C_serv4__c,COM_C_serv5__c, COM_MD_Filiale__c,COM_MD_Filiale__r.Name,COM_Importo_Rata__c,
                               COM_D_delibera__c,COM_Ultimo_Esito_ASS__c,COM_N_Telefono2__c,COM_AC_SESSO__c, COM_count_non_rispASS__c, COM_count_richiamaASS__c
FROM COM_Intervista__c  WHERE/*
CALENDAR_MONTH(createddate)=:mnth and*/ Id=:idintervista ];
     if( interview.COM_Stato_Avanzamento_IntervistaASS__c == 'Nuovo')
             {
                 interview.COM_Status_ASS__c = 'Processing'; update interview;
             }
    
return interview;
}

/**
* @description:get risposta of intervista
* @date::18/03/2019
* @author:Salimata NGOM
* @params: none
* @return: Risposte__c
* @modification:
*/
@AuraEnabled
public static Risposte__c getRisposta(String idIntervista) 
{
       List<Risposte__c> ListRisposte = new List<Risposte__c>();
       /*Risposte__c*/ ListRisposte       =[ SELECT Id,Intervista__c,Intervista__r.COM_NomeCliente__r.Name,
                                         Contratto1__c,Secci1__c,Precontratto1__c,Questionario_assicurativo1__c,
                                         Contratto_Assicurazione__c,Documenti_Assicurazione1__c, Soddisfazione_Cliente1__c ,
                                         Count_Negativi__c,Count_Positivi__c,Valutazione__c,
                                            /*COM_Note_Contratto__c,*/COM_Note_Secci__c,
                                            COM_Note_Precontratto__c,COM_Note_Questionario_Assicurativo__c,
                                            COM_Note_Contratto_Assicurazione__c,COM_Note_Documenti_Assicurazione__c,
                                            COM_Note_Soddisfazione_Cliente__c
                                            FROM Risposte__c WHERE Intervista__r.Id =: idIntervista AND Type__c = 'Filliale'];
       if( ListRisposte != null && ListRisposte.size() > 0 )return ListRisposte[0];
       return null;
                                         //return risposta;
}

    /**
* @description:get risposta of intervista
* @date:18/03/2019
* @author: Mamadou Lamine CAMARA
* @params: none
* @return: Risposte__c
* @modification: 09/04/2019 to add D6__C, D7__c, D8__c
*/
    @AuraEnabled
    public static Risposte__c getRispostaAssicurativo(String idIntervista)
    {
        List<Risposte__c> ListRisposte = new List<Risposte__c>();
        /*Risposte__c*/ ListRisposte       =[ SELECT Id,Intervista__c,Intervista__r.COM_NomeCliente__r.Name,
                                                        D0__C,D1__c,D2__c,D3__c,D4__c,D5__c,D6__c,D7__c,D8__c
                                                    FROM Risposte__c WHERE Intervista__r.Id =: idIntervista and Type__c = 'Assicurativo'];
        if( ListRisposte != null && ListRisposte.size() > 0 )return ListRisposte[0];
        return null;
        //return risposta;
    }
/**
* @description:get commodity check
* @date::27/03/2019
* @author:Salimata NGOM
* @params: none
* @return: List<COM_CRMComodity_Check_Asc_Desc__c>
* @modification: 10/05/2019
*/
@AuraEnabled
public static Map<String,Object> getCommodityCheck(COM_Intervista__c InterviewObj)
{
         Map<String,Object> mapCommodityCheck=new Map<String, Object>();
        List<COM_CRMComodity_Check_Asc_Desc__c> ListCOM = new List<COM_CRMComodity_Check_Asc_Desc__c>();
        List<String> ListOfStringCSERV = new List<String>();
        List<String> ListOfStringCSERVNotExist = new List<String>();
        mapCommodityCheck.put('error',false);
        Integer indexOfFlag = 0;
        if(InterviewObj!=null)
        {
             System.debug('in if of InterviewObj ');
             System.debug('InterviewObj.COM_C_Serv1__c: '+InterviewObj.COM_C_Serv1__c);
            if( InterviewObj.COM_C_Serv1__c != null)
            {
                ListOfStringCSERV.add( InterviewObj.COM_C_Serv1__c );
                
            } if( InterviewObj.COM_C_Serv2__c != null)
            {
                ListOfStringCSERV.add( InterviewObj.COM_C_Serv2__c );
            } if( InterviewObj.COM_C_serv3__c != null)
            {
                ListOfStringCSERV.add( InterviewObj.COM_C_serv3__c );
            } if( InterviewObj.COM_C_serv4__c != null)
            {
                ListOfStringCSERV.add( InterviewObj.COM_C_serv4__c );
            } if( InterviewObj.COM_C_serv5__c != null)
            {
                 ListOfStringCSERV.add( InterviewObj.COM_C_serv5__c );
            }
       }
        if( ListOfStringCSERV != null && ListOfStringCSERV.size() > 0 )
        {
               
                for(String stringCSERV: ListOfStringCSERV)
                {
                    System.debug('stringCSERV: '+stringCSERV);
                    COM_CRMComodity_Check_Asc_Desc__c comodityCheck = NULL;
                    try{
                          comodityCheck =  [SELECT Id,COM_CRMTipo__c,Name,
                              COM_CRMDefinizione__c,
                              COM_CRMflag_prod_sani_non_conn__c,
                              Descrizione__c,
                              COM_CRMTermini_Recesso__c,
                              COM_CRMEstinzione__c,COM_CRMCalcolo_giorni_recesso__c
                              from COM_CRMComodity_Check_Asc_Desc__c 
                              WHERE Name =: stringCSERV LIMIT 1];
                            
                        //for (Object COM_CRMComodity_Check_Asc_Desc__c: comodityCheck) {
                            if (comodityCheck.COM_CRMflag_prod_sani_non_conn__c == 'S') {
                                indexOfFlag++;
                            }
                        //}
                              System.debug('COM_CRMComodity_Check_Asc_Desc__c:'+comodityCheck);
                               ListCOM.add(comodityCheck);   
                      } catch (QueryException e) {
                           mapCommodityCheck.put('error',true);
                          ListOfStringCSERVNotExist.add(stringCSERV);
                          System.debug('query' +e.getMessage());
                          System.debug('error' +e.getCause());
                      }
                }          
        }
        mapCommodityCheck.put('index',indexOfFlag);
        mapCommodityCheck.put('listCom',ListCOM);
        mapCommodityCheck.put('ListOfStringCSERVNotExist',ListOfStringCSERVNotExist);
        System.debug('getCommodityCheck, la taille du map: '+mapCommodityCheck.size());
        System.debug('le map: '+mapCommodityCheck); 
    
        return mapCommodityCheck;
    }
    /**
* @description:get commodity check
* @date::
* @author:Salimata NGOM
* @params: none
* @return: List<COM_CRMComodity_Check_Asc_Desc__c>
* @modification:
*/
@AuraEnabled
public static SObject updateIntervista (SObject param){
    system.debug('04_05_2019 param->'+param);
    try {
        upsert  param;
        System.debug('mise à jour reussi');
    } catch (DmlException e) {
        System.debug('error message: '+e.getMessage() );
        System.debug('error cause: '+e.getCause() );
        return null;
    }

return param;
}
    /**
* @description:add all Response
* @date::01/04/2019
* @author: Mamadou Lamine CAMARA
* @params: none
* @return: Risposte__c
* @modification:
*/
    @AuraEnabled
    public static  Risposte__c addResponseAssicurativo(Risposte__c respdomanda){
         system.debug('01_04_2019 Risposta: '+respdomanda);
         respdomanda.Type__c      = 'Assicurativo';
         //respdomanda.RecordtypeId = COM_CommodityUtils.getRisposteRecordTypeId('Assicurativo');
         system.debug('01_04_2019 respdomanda-->'+respdomanda);
         upsert  respdomanda;
         return respdomanda;
    }
    @AuraEnabled 
    public static List<COM_Intervista__c> getPraticheFiltrate( String FiltroPratiche )
    {
        
           String ConditionOnStato = '';
           if( FiltroPratiche == 'N')ConditionOnStato  = ' WHERE COM_Stato_Avanzamento_Intervista__c = \'Nuovo\' OR COM_Stato_Avanzamento_Intervista__c = \'Richiamare\'';
           if( FiltroPratiche == 'C')ConditionOnStato  = ' WHERE COM_Stato_Avanzamento_Intervista__c = \'Conclusa\' ';
           if( FiltroPratiche == 'NN')ConditionOnStato = ' WHERE COM_Stato_Avanzamento_Intervista__c != \'Nuovo\' ';
           if( FiltroPratiche == 'R')ConditionOnStato  = ' WHERE COM_Stato_Avanzamento_Intervista__c = \'Richiamare\' ';
           if( FiltroPratiche == 'NG')ConditionOnStato = ' WHERE COM_Stato_Avanzamento_Intervista__c = \'Non Risponde\'  OR COM_Stato_Avanzamento_Intervista__c = \'Non accetta\' OR COM_Stato_Avanzamento_Intervista__c = \'Irreperibile\' ';
           String QueryToDo = ' SELECT Id,COM_Stato_Avanzamento_Intervista__c,COM_Data_Esito_ASS__c,'+
                          ' COM_NomeCliente__c, COM_CRMNome_Cliente_Formula__c,COM_ATTIVIT_DI_RECALL_INTERNO_POST_COMM__c,COM_Data_Esito__c,'+
                          ' COM_CRMNome_Filiale_Formula__c ,'+
                          ' COM_CRMTelefono_Cliente_Formula__c,Ritiro_Doc__c,'+
                          ' COM_NomeCliente__r.Name , COM_MD_Filiale__r.COM_Numero_Pratiche_ConfEV_Filiale__c , '+
                          ' COM_NomeCliente__r.Phone , COM_NomeCliente__r.Acquisition_Date__c , COM_cin_z_calc__c , '+
                          ' COM_date_first_contacted__c , COM_D_liquid__c , LastModifiedDate ,'+
                          ' COM_C_prod__c ,  COM_CRMRichiamare_il__c , COM_AC_SESSO__c , COM_MD_Filiale__r.COM_Numero_Pratiche_ConfNonEV_Filiale__c,COM_callback_notes__c , COM_N_Telefono_Cel__c ,COM_Status__c,'+
                          ' COM_Ultimo_Esito_FIL__c,COM_Intervista_Non_Utile__c,COM_MD_Filiale__c,COM_MD_Filiale__r.Name,COM_MD_Filiale__r.getCodice_Cliente__c '+
                          ' FROM COM_Intervista__c  '+ ConditionOnStato;
                          //' WHERE COM_Stato_Avanzamento_IntervistaASS__c =: FiltroPratiche ';
          List<COM_Intervista__c> interviewList=new List<COM_Intervista__c>();
          return Database.query(QueryToDo);
    }
    @AuraEnabled
    public static Integer getSUMProdottoEV( String IDFiliale , String Prodotto )
    {
           system.debug('02_05_2019 ---- IDFiliale+'+IDFiliale+'-Prodotto:'+Prodotto);
           Integer Contatore = [SELECT COUNT() FROM COM_Intervista__c 
                                  WHERE COM_MD_Filiale__c =: IDFiliale 
                                    AND COM_C_prod__c =: Prodotto 
                                    AND COM_Current_Period_Filiale__c = true
                                    AND COM_Interview_Utils__c = true];
           system.debug('Contatore->'+Contatore);
           return 9;
        //return Contatore;
    }
    @AuraEnabled
    public static Integer getSUMProdottoEVInProgress( String IDFiliale , String Prodotto )
    {
           return [ SELECT COUNT() FROM COM_Intervista__c 
                                   WHERE COM_MD_Filiale__c =: IDFiliale 
                                   AND   COM_C_prod__c     =: Prodotto
                                   AND   COM_Status__c     = 'In Progress'];    
    }
    
}