/**
    * @description: 
    * @date::27/06/2019
    * @author:Aminata GUEYE
    * @modification: NONE
    */
global class COM_BatchSFDCIntervisteIntegrativo implements Database.Batchable<sObject>, Database.Stateful
{

   //Attributes
    @testvisible private String queryToDO        = '';


    //Constructor
    global COM_BatchSFDCIntervisteIntegrativo() {

       queryToDo = 'SELECT Id, IsDeleted, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById,'+
            'Owner.Name, COM_Num_Non_Risponde__c, COM_Num_richiamare__c, COM_Richiamare_il__c, COM_Current_Period__c, COM_Data_Esito__c,'+
            'COM_Intervista_Number__c, COM_Ultimo_Esito__c, Limite_mensile__c, Note__c, Durata_Sanitarie__c, Ac_Cap__c,'+
            'Imp_Rata__c, Ac_Telefono_Sede__c, Ac_Telefono_Cel__c, Ac_Telefono_2__c, Ac_Telefono__c,'+
            'Ac_Sesso__c, Ac_Rag_Sociale_2__c, Ac_Rag_Sociale_1__c, CodiceServizio5__c, CodiceServizio4__c,'+
            'CodiceServizio3__c, CodiceServizio2__c, CodiceServizio1__c, Plc_Tipo_Prodotto__c,'+
            'Plc_Agente__c, Plc_Convenzionato__c, Plc_Prodotto__c, Plc_Cliente__c, Data_Liquidazione__c,'+
            'Stato__c, Status__c, Type__c, Name, Regione__c, Area__c, Plc_filiale__c, COM_Data_Scadenza_Recesso__c'+
            ' FROM Intervista_integrativo__c '+
            ' WHERE (Status__c = \'Processing\')  AND LastModifiedDate <'+Datetime.now().addMinutes(-20).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    }

    //Start Method
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        return Database.getQueryLocator( queryToDO );
    }
    //Execute Method
    global void execute(Database.BatchableContext bc, List<SObject> scope ) 
    {
        try {
            checkIntegrativoToElaborate( scope );     
        }catch( Exception e )
        {
            system.debug(e.getMessage());
        }
    }
    //Finish Method
    global void finish(Database.BatchableContext bc) 
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
                            WHERE Id =: bc.getJobId() ];
        System.debug('job>>> '+job);
        System.debug('recordsProcessed >>> ');
        System.debug(Datetime.now().addMinutes(-20).formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''));
    }

    /********************************Work Methods*************************************/
    @testvisible 
    private void checkIntegrativoToElaborate(List<SObject> listIntegrativo)
    {
        system.debug('27_06_2019 COM_BatchSFDCIntervisteIntegrativo::'+listIntegrativo);
        List<Intervista_integrativo__c> listIntegrativoToUpdate = new List<Intervista_integrativo__c>();
        
        if( listIntegrativo != null && listIntegrativo.size() > 0 )
        {
            for( SObject sObj : listIntegrativo)
            {
                Intervista_integrativo__c integrativoObj = ( Intervista_integrativo__c )sObj;
                if( integrativoObj.Status__c == 'Processing')
                {
                    integrativoObj.Status__c  = 'New';
                }
                listIntegrativoToUpdate.add( integrativoObj );
            }
        }
        if( listIntegrativoToUpdate != null && listIntegrativoToUpdate.size() > 0 )
        {
            update listIntegrativoToUpdate;
        }
    }
}