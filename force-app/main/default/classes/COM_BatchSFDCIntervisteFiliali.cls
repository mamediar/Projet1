/**
* @Author:      Orlando S.
* @Description:
* 
* */
global class COM_BatchSFDCIntervisteFiliali implements Database.Batchable<sObject> , Database.Stateful
{
    //Attributes
    @testvisible private String queryToDO        = '';
    
    
    //Constructor
    global COM_BatchSFDCIntervisteFiliali()
    {
        if( !Test.isRunningTest())
        {
            
        queryToDo        =    'SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById,'+
            'SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate,'+ 
            'COM_NomeCliente__c, COM_Stato_Avanzamento_Intervista__c, COM_Importo_liquidato__c, COM_D_Carico__c,'+ 
            'COM_D_liquid__c, COM_C_prod__c, COM_NTelefono1__c, COM_N_Telefono2__c, COM_N_Telefono_Cel__c, COM_Indirizzo__c,'+ 
            'COM_CAP__c, COM_Comune__c, COM_Provincia__c, COM_Loc_nas__c, COM_Prov_Nas__c, COM_C_Serv1__c, COM_CSER_Descrizione1__c,'+ 
            'COM_C_Serv2__c, COM_CSER_Descrizione2__c, COM_C_serv3__c, COM_CSER_Descrizione3__c, COM_C_serv4__c,'+ 
            'COM_CSER_Descrizione4__c, COM_C_serv5__c, COM_CSER_DESCRIZIONE5__c, COM_Importo_Rata__c, COM_AC_SESSO__c,'+ 
            'COM_D_delibera__c, COM_PLC_NUM_RATE__c, COM_Durata_Sanitarie__c, COM_Data_Scadenza_Recesso__c, COM_cin_z_calc__c,'+
            'COM_service1_cin__c, COM_service1_cin_z__c, COM_Service2_cin__c, COM_service2_cin_z__c, COM_service3_cin__c,'+ 
            'COM_service3_cin_z__c, COM_service4_cin__c, COM_service4_cin_z__c, COM_service5_cin__c, COM_service5_cin_z__c,'+ 
            'COM_interview_accepted__c, COM_Provenienza__c,'+
            'COM_date_first_contacted__c, COM_Date_CallBack__c, COM_callback_notes__c, COM_CRMTelefono_Cliente_Formula__c,'+
            'COM_Data_Esito__c, COM_count_non_risp__c, COM_count_richiama__c, COM_data_caricamento__c, COM_CRMRichiamare_il__c,'+
            'COM_CRMNome_Cliente_Formula__c, COM_CRMNome_Filiale_Formula__c, COM_MD_Filiale__c, COM_Status__c,'+
            'COM_Stato_Avanzamento_IntervistaASS__c, COM_CRMRichiamare_ilASS__c, COM_callbackASS_notes__c,'+
            'COM_Valutazione__c, COM_Status_ASS__c, COM_Current_Period__c, Com_Intervista_Number__c, COM_Intervista_Utile__c,'+
            'COM_Intervista_Accettata__c, COM_Interview_Utils__c, Type__c '+
            ' FROM COM_Intervista__c '+
            ' WHERE ( COM_Status__c = \'Processing\' OR COM_Status_ASS__c = \'Processing\' ) AND LastModifiedDate < '+Datetime.now().addMinutes(-20).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        }else{
            
             queryToDo        =    'SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById,'+
            'SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate,'+ 
            'COM_NomeCliente__c, COM_Stato_Avanzamento_Intervista__c, COM_Importo_liquidato__c, COM_D_Carico__c,'+ 
            'COM_D_liquid__c, COM_C_prod__c, COM_NTelefono1__c, COM_N_Telefono2__c, COM_N_Telefono_Cel__c, COM_Indirizzo__c,'+ 
            'COM_CAP__c, COM_Comune__c, COM_Provincia__c, COM_Loc_nas__c, COM_Prov_Nas__c, COM_C_Serv1__c, COM_CSER_Descrizione1__c,'+ 
            'COM_C_Serv2__c, COM_CSER_Descrizione2__c, COM_C_serv3__c, COM_CSER_Descrizione3__c, COM_C_serv4__c,'+ 
            'COM_CSER_Descrizione4__c, COM_C_serv5__c, COM_CSER_DESCRIZIONE5__c, COM_Importo_Rata__c, COM_AC_SESSO__c,'+ 
            'COM_D_delibera__c, COM_PLC_NUM_RATE__c, COM_Durata_Sanitarie__c, COM_Data_Scadenza_Recesso__c, COM_cin_z_calc__c,'+
            'COM_service1_cin__c, COM_service1_cin_z__c, COM_Service2_cin__c, COM_service2_cin_z__c, COM_service3_cin__c,'+ 
            'COM_service3_cin_z__c, COM_service4_cin__c, COM_service4_cin_z__c, COM_service5_cin__c, COM_service5_cin_z__c,'+ 
            'COM_interview_accepted__c, COM_Provenienza__c,'+
            'COM_date_first_contacted__c, COM_Date_CallBack__c, COM_callback_notes__c, COM_CRMTelefono_Cliente_Formula__c,'+
            'COM_Data_Esito__c, COM_count_non_risp__c, COM_count_richiama__c, COM_data_caricamento__c, COM_CRMRichiamare_il__c,'+
            'COM_CRMNome_Cliente_Formula__c, COM_CRMNome_Filiale_Formula__c, COM_MD_Filiale__c, COM_Status__c,'+
            'COM_Stato_Avanzamento_IntervistaASS__c, COM_CRMRichiamare_ilASS__c, COM_callbackASS_notes__c,'+
            'COM_Valutazione__c, COM_Status_ASS__c, COM_Current_Period__c, Com_Intervista_Number__c, COM_Intervista_Utile__c,'+
            'COM_Intervista_Accettata__c, COM_Interview_Utils__c, Type__c '+
            ' FROM COM_Intervista__c '+
            ' WHERE ( COM_Status__c = \'Processing\' OR COM_Status_ASS__c = \'Processing\' ) ';
   
        }


    }
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        return Database.getQueryLocator( queryToDO );
    }
    //Execute Method
    global void execute(Database.BatchableContext BC, List<SObject> scope ) 
    {
        try {
            checkInterviewsToElaborate( scope );     
        }catch( Exception ErrorException )
        {
            
        }
    }
    //Finish Method
    global void finish(Database.BatchableContext BC) 
    {
        AsyncApexJob job = [ SELECT Id,
                            ApexClass.Name,
                            CompletedDate,
                            JobType,
                            NumberOfErrors,
                            JobItemsProcessed,
                            TotalJobItems,
                            CreatedBy.Email,
                            CreatedBy.Name,
                            Createddate 
                            FROM AsyncApexJob
                            WHERE Id =: BC.getJobId() ];
        
    }
    
    /********************************Work Methods*************************************/
    @testvisible 
    private void checkInterviewsToElaborate(List<SObject> listInterviews )
    {
        
        system.debug('04_04_2019 COM_BatchSFDCIntervisteFiliali/checkInterviewsToElaborate/listaInterviews::'+listInterviews);
        List<COM_Intervista__c> listInterviewsToUpdate = new List<COM_Intervista__c>();
        
        if( listInterviews != null && listInterviews.size() > 0 )
        {
            for( SObject SSObj : listInterviews )
            {
                COM_Intervista__c InterviewObj = ( COM_Intervista__c )SSObj;
                if( InterviewObj.COM_Status__c == 'Processing')
                {
                    InterviewObj.COM_Status__c     = 'New';
                }
                if( InterviewObj.COM_Status_ASS__c == 'Processing' )
                {
                    InterviewObj.COM_Status_ASS__c    = 'New';
                }
                
                listInterviewsToUpdate.add( InterviewObj );
            }
        }
        if( listInterviewsToUpdate != null && listInterviewsToUpdate.size() > 0 )
        {
            update listInterviewsToUpdate;
        }
    }
    
}