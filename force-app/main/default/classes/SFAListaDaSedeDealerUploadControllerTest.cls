@isTest
public with sharing class SFAListaDaSedeDealerUploadControllerTest {



    @TestSetup
    static void makeData(){
        
    }

    
 	@isTest
    static void testInit(){	    
        Test.startTest();
        String resultJSON = SFAListaDaSedeDealerUploadController.initForm();
		Test.stopTest();
        System.assertNotEquals(null, JSON.deserialize(resultJSON, List<List<sObject>>.class));
    }    

 	@isTest
    static void testReportUpload(){	    
        Test.startTest();
        String resultJSON = SFAListaDaSedeDealerUploadController.reportUpload(DateTime.now());
		Test.stopTest();
        System.assertNotEquals(null, JSON.deserialize(resultJSON, SFA_ListeCaricate__c.class));    
    }    

 	@isTest
    static void test_getListaCheckWithOffset(){	    
        Test.startTest();
        List<SFA_ListaCheck__c> lista = SFAListaDaSedeDealerUploadController.getListaCheckWithOffset('10','1',DateTime.now());
		Test.stopTest();
        System.assert(lista.size()==0);    
    }    

 	@isTest
    static void testprocessData(){	    
        List<String> fields = new List<String>();
        SFA_TipologiaLista__c tipoAtt = new SFA_TipologiaLista__c();
        insert tipoAtt;

        SFA_ListeCaricate__c listeCaricate = new SFA_ListeCaricate__c(Nome_Lista__c = 'nome_lista',Tipo_Attivita__c = tipoAtt.id);
        insert listeCaricate;
        Test.startTest();						
        SFAListaDaSedeDealerUploadController.processData('fileData',fields,tipoAtt.id,'nome_lista','tipo_lista',date.today());
		Test.stopTest();
        // verify
        List<SFA_ListeCaricate__c> listeCaricateAfter = [SELECT ID,Numero_righe__c,Data_Visibilita__c FROM SFA_ListeCaricate__c];
        System.assert(listeCaricateAfter[0].Data_Visibilita__c == date.today());  
    }    

 	@isTest
    static void test_getTipologiaAttivitaFromLista(){	    
        List<String> fields = new List<String>();
        SFA_TipologiaLista__c tipoAtt = new SFA_TipologiaLista__c();
        insert tipoAtt;
        SFA_ListeCaricate__c listeCaricate = new SFA_ListeCaricate__c(Nome_Lista__c = 'nome_lista',Tipo_Attivita__c = tipoAtt.id);
        insert listeCaricate;
        Test.startTest();
        Id resultID = SFAListaDaSedeDealerUploadController.getTipologiaAttivitaFromLista(listeCaricate.id);
		Test.stopTest();
        System.assertNotEquals(null,resultID);  
    }    


 	@isTest
    static void test_ricercaPerOcsID(){	    

        List<RecordType> rDealer = [Select id  From RecordType  Where sObjectType = 'Account'and RecordType.Name = 'Dealer'];
        Account acc = new Account(
            Name = 'MARIO ROSSI',                        
            Data_Nascita__c = Date.valueOf('1944-08-23'),
            Utilizzato_per_Reclami__c = false,           
            COM_NumeroTotali_Pratiche__c = '0',          
            Customer_Type__c = 'Compass',
            OCS_External_Id__c ='C5000',
            Codice_Cliente__c ='5000',
            Partita_IVA__c = '12345678901',
            recordtypeid=rDealer[0].id
        );
        insert acc;
        Test.startTest();
        Integer result =  SFAListaDaSedeDealerUploadController.ricercaPerOcsID(acc);
		Test.stopTest();
        System.assertEquals(1, result);
    }    

 
 	@isTest
    static void test_ricercaPerPIva(){	    

       List<RecordType> rDealer = [Select id  From RecordType  Where sObjectType = 'Account'and RecordType.Name = 'Dealer'];
       Account acc = new Account(
            Name = 'MARIO ROSSI2',                        
            Data_Nascita__c = Date.valueOf('1944-08-23'),
            Utilizzato_per_Reclami__c = false,           
            COM_NumeroTotali_Pratiche__c = '0',          
            Customer_Type__c = 'Compass',
            OCS_External_Id__c ='C50001',
            Codice_Cliente__c ='50001',
            Partita_IVA__c = '12345678901',
            recordtypeid=rDealer[0].id
        );
        insert acc;
        Test.startTest();
        Integer result = SFAListaDaSedeDealerUploadController.ricercaPerPIva(acc);
		Test.stopTest();
        System.assertEquals(1, result);

    }    

}