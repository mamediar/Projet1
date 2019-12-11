@isTest
/**
 *  Orlando.S
 * 
 * */
public class IntervistaDomandeApexClass_TestClass {
    
       static testMethod void testName() 
       {
              //Creazione Account di tipo Branch
              Account Filiale_ACC = CreateAccount('Branch');
              //Creazione Person Account
              Account Person_ACC  = CreateAccount('PAccount');
              //Creazione Categoria
              XCS_Categoria__c CategoriaIstance = new XCS_Categoria__c();
              CategoriaIstance.External_Id__c   = '1772';
              Insert CategoriaIstance;
              //Creazione AssugnmentRule
              Case CaseFiliale                        = new Case();
              insert CaseFiliale;
           
             
           
              //Creazione Intervista Object
              COM_Intervista__c IntervistaIstance                   = new COM_Intervista__c();
              IntervistaIstance.Name                                = 'Intervista001';
              IntervistaIstance.COM_Stato_Avanzamento_Intervista__c = 'Nuovo';
              IntervistaIstance.COM_MD_Filiale__c                   = Filiale_ACC.Id;
              IntervistaIstance.COM_NomeCliente__c                  = Person_ACC.Id;
              IntervistaIstance.COM_C_prod__c                       = 'EV';    
              insert IntervistaIstance;
              // Creazione Risposte
              Risposte__c RispostaIstance                           = new Risposte__c();
              RispostaIstance.Intervista__c                         = IntervistaIstance.Id;
              RispostaIstance.COM_Filiale_Posta__c                  = 'Posta';

              insert RispostaIstance;
              // Creazione Oggetti Domanda
              /*
              Com_Domande__c DomandaObj                             = new Com_Domande__c();
              DomandaObj.Name                                       = '1';
              DomandaObj.Contenuto_Domanda__c                       = 'Contenuto Domanda Test';
              insert DomandaObj; */
              //Creazione Custom Setting
              COM_Comodity_Questionario__c CSInstance               = new COM_Comodity_Questionario__c();
              CSInstance.Name                                       = '1F';
              CSInstance.COM_Limite_Cin_Z__c                        = '10';
              insert CSInstance;
              
              //Copertura classe Intervista Domande Apex Class
              IntervistaDomandeApexClass.getPicklistvalues( 'Risposte__c' , 'Contratto1__c' , false );
              //IntervistaDomandeApexClass.getDomande();
              IntervistaDomandeApexClass.getRisposta( IntervistaIstance.Id );
              IntervistaDomandeApexClass.getCountIntervisteCINZ_G( /*Filiale_ACC.Id*/ );
              IntervistaDomandeApexClass.updateIntervista( IntervistaIstance );
              IntervistaDomandeApexClass.getLimitCINZFromCS();
              IntervistaDomandeApexClass.addResponseAssicurativo( RispostaIstance );
              IntervistaDomandeApexClass.addResponse( RispostaIstance , IntervistaIstance , true , false);
              IntervistaIstance.COM_C_prod__c                       = 'V';
              update IntervistaIstance;
              RispostaIstance.Contratto1__c = 'Si';
              RispostaIstance.Secci1__c = 'Si';
              RispostaIstance.Precontratto1__c = 'Si';
              RispostaIstance.Questionario_assicurativo1__c = 'Si';
              RispostaIstance.Contratto_Assicurazione__c = 'Si';
              RispostaIstance.Documenti_Assicurazione1__c = 'Si';
              RispostaIstance.Soddisfazione_Cliente1__c = 'Si';
              update RispostaIstance;
              IntervistaDomandeApexClass.addResponse( RispostaIstance , IntervistaIstance , false , false);
           
              IntervistaIstance.COM_Stato_Avanzamento_Intervista__c = 'Conclusa';
              update IntervistaIstance;
              IntervistaDomandeApexClass.addResponse( RispostaIstance , IntervistaIstance , false , true);
              IntervistaIstance.COM_C_prod__c                       = 'EV';
              update IntervistaIstance;
              IntervistaDomandeApexClass.addResponse( RispostaIstance , IntervistaIstance , true ,true);
              RispostaIstance.Contratto1__c = 'Si';
              RispostaIstance.Secci1__c = 'No';
              RispostaIstance.Precontratto1__c = 'No';
              update RispostaIstance;
              IntervistaDomandeApexClass.addResponse( RispostaIstance , IntervistaIstance , true ,true);
              RispostaIstance.Contratto1__c = 'Non Ricorda';
              RispostaIstance.Secci1__c = 'Non Ricorda';
              RispostaIstance.Precontratto1__c = 'Non Ricorda';
              RispostaIstance.Questionario_assicurativo1__c = 'No';
              RispostaIstance.Contratto_Assicurazione__c = 'Si';
              RispostaIstance.Documenti_Assicurazione1__c = 'Si';
              RispostaIstance.Soddisfazione_Cliente1__c = 'Si';
              update RispostaIstance;
              IntervistaDomandeApexClass.addResponse( RispostaIstance , IntervistaIstance , true ,true);
              RispostaIstance.Contratto1__c = 'No';
              RispostaIstance.Secci1__c = 'Si';
              RispostaIstance.Precontratto1__c = 'Si';
              RispostaIstance.Questionario_assicurativo1__c = 'Si';
              RispostaIstance.Contratto_Assicurazione__c = 'Non Ricorda';
              RispostaIstance.Documenti_Assicurazione1__c = 'Non Ricorda';
              RispostaIstance.Soddisfazione_Cliente1__c = 'Non Ricorda';
              update RispostaIstance;
              IntervistaDomandeApexClass.addResponse( RispostaIstance , IntervistaIstance , true ,true);
              IntervistaDomandeApexClass.addResponse( RispostaIstance , IntervistaIstance , true ,true);
              RispostaIstance.Contratto1__c = 'No';
              RispostaIstance.Secci1__c = 'Si';
              RispostaIstance.Precontratto1__c = 'Non richiesta';
              RispostaIstance.Questionario_assicurativo1__c = 'Non Ricorda';
              RispostaIstance.Contratto_Assicurazione__c = 'No';
              RispostaIstance.Documenti_Assicurazione1__c = 'No';
              RispostaIstance.Soddisfazione_Cliente1__c = 'No';
              update RispostaIstance;
              IntervistaDomandeApexClass.addResponse( RispostaIstance , IntervistaIstance , true ,true);

              COM_CommodityUtils.getAccountRecordTypeId('Branch');
              COM_CommodityUtils.getRisposteRecordTypeId('Assicurativo');
              
              
               
     
       }
       static Account CreateAccount( String TypeOfAccount )
       {
              Account Acc      = new Account();
              if( TypeOfAccount == 'Branch')
              {
                Acc.Name         = 'Name_Acc_Test';
                Acc.RecordTypeId = getAccountRecordTypeId();
              }
              if( TypeOfAccount == 'PAccount')
              {
                Acc.LastName = 'TestPAcc';
                Acc.RecordTypeId = getPAccountRecordTypeId();
              }
              insert Acc;
              return Acc;
       }
       static Id getAccountRecordTypeId() 
       {
              Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Branch').getRecordTypeId();
              return RecordTypeId;
       }
       static Id getPAccountRecordTypeId()
       {
              Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
              return recordTypeId;
       }
}