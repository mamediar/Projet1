/**
    * @description: 
    * @date::27/06/2019
    * @author:Aminata GUEYE
    * @modification: NONE
    */

global class COM_BatchSFDCFuturo implements Database.Batchable<sObject> , Database.Stateful
{
    
    //Attributes
    @testvisible private String queryToDO        = '';


    //Constructor
    global COM_BatchSFDCFuturo() {
        
         queryToDo        =    'SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById,'+
            'LastActivityDate, COM_AGENTE__c, COM_AGENTE_FUTURO__c, COM_Area__c,'+
            'COM_CATEGORIA_PRODOTTO__c, COM_CED_TELEFONO_CELL__c, COM_CED_TELEFONO1__c, COM_CED_TELEFONO2__c, COM_COD_SUB_AGENTE__c,'+
            'COM_CODICE_AGENTE__c, COM_CODICE_CEDENTE__c, COM_CODICE_PRODOTTO__c, COM_ChiusoNon_Conforme__c, COM_Current_Period_Futuro__c,'+
            'COM_Numero_Pratiche_Futuro__c, COM_PraticheChiuse_Conforme__c, richiamare_il__c,'+
            'COM_SESSO_CEDENTE__c, COM_Status_FUTURO__c, COM_TIPO_PRODOTTO__c, Ultimo_Esito__c'+
            ' FROM Com_Commodity_Survey__c '+
            ' WHERE ( COM_Status_FUTURO__c = \'Processing\') AND LastModifiedDate <'+Datetime.now().addMinutes(-20).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        
  
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
            checkFuturoToElaborate( scope );     
        }catch(Exception ErrorException ){
            
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
    private void checkFuturoToElaborate(List<SObject> listComFuturo)
    {
        system.debug('27_06_2019 COM_BatchSFDCFuturo::'+listComFuturo);
        List<Com_Commodity_Survey__c> listComFuturoToUpdate = new List<Com_Commodity_Survey__c>();
        
        if( listComFuturo != null && listComFuturo.size() > 0 )
        {
            for( SObject SSObj : listComFuturo)
            {
                Com_Commodity_Survey__c FuturoObj = ( Com_Commodity_Survey__c )SSObj;
                if( FuturoObj.COM_Status_FUTURO__c == 'Processing')
                {
                    FuturoObj.COM_Status_FUTURO__c  = 'New';
                }
                listComFuturoToUpdate.add( FuturoObj );
            }
        }
        if( listComFuturoToUpdate != null && listComFuturoToUpdate.size() > 0 )
        {
            update listComFuturoToUpdate;
        }
    }
}