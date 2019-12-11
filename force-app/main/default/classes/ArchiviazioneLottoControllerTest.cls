@isTest
public class ArchiviazioneLottoControllerTest {
    
    @isTest
    public static void selectContractsTest(){
        
        // DATI SCAFFOLDING DB
        // ====================================================         
        Account tempAccount = new Account(Name = 'Filiale Test');
        insert tempAccount;
        SFALotto__c tempLotto = new SFALotto__c(Status__c = '1',OCSLottoId__c = '5009196');
        SFALotto__c tempLottoInShipping = new SFALotto__c(Status__c = '2',OCSLottoId__c = '5009197');
        insert tempLotto;
        insert tempLottoInShipping;
        Contract tempContract = new Contract(        	
            AccountId = tempAccount.Id,
            ContractNumber__c = '000018797094',
            FlagAccollo__c = 0,
            Status = 'LI',
            Procedure__c = 'CO'          
        );
        Case tempCase = new Case(SFALotto__c = tempLotto.Id);                        
        insert tempContract;
        insert tempCase;  
        
        //CASO No.1 SUCCESS
        // ===================================================
        ArchiviazioneLottoController.GenericElement GE = ArchiviazioneLottoController.selectContracts((tempContract.Procedure__c + tempContract.ContractNumber__c),tempCase.Id,'No Accollo');
        //System.debug('GE Contratto ID: ' + GE.contratto.Id);
        System.assertEquals(tempContract.Id, GE.contratto.Id);
        
        //CASO No.2 CONTRACT IN SHIPPING
        // ===================================================  
        tempContract.SFALotto__c = tempLottoInShipping.Id;
        update tempContract;
        GE = ArchiviazioneLottoController.selectContracts((tempContract.Procedure__c + tempContract.ContractNumber__c),tempCase.Id,'No Accollo');
        System.assertEquals('Il codice contratto è già presente in un lotto che è in attesa di spedizione', GE.message);
        
        //CASO No.3 NO CONTRACT FOUND
        // ===================================================      
        GE = ArchiviazioneLottoController.selectContracts(tempContract.ContractNumber__c, tempCase.Id, 'No Accollo');
        System.assertEquals('error', GE.statusMessage);
        
        //CASO No.4 CONTRACT ALREADY INSIDE THE LOT
        // ===================================================  
        tempContract.SFALotto__c = tempLotto.Id;
        update tempContract;
        GE = ArchiviazioneLottoController.selectContracts((tempContract.Procedure__c + tempContract.ContractNumber__c),tempCase.Id,'No Accollo');
        System.assertEquals('warning', GE.statusMessage);
        
        //CASO No.5 FAILED
        // =================================================== 
        GE = ArchiviazioneLottoController.selectContracts('',tempCase.Id,'No Accollo');
        System.assert(GE.contratto == null);
        System.assert(GE.message == null);
        System.assert(GE.statusMessage == null);
        
        
    }
}