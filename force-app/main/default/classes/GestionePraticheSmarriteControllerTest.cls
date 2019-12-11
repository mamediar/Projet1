@isTest
public class GestionePraticheSmarriteControllerTest{
    
    @isTest
    public static void selectContractTest(){
        Case tempCase = new Case();
        Account tempAccount = new Account(name = 'Filiale Test');
        insert tempAccount;
        insert tempCase;
        List<Contract> tempContractListExpected = new List<Contract>();
        for(Integer i = 0; i < 8; i++)
            tempContractListExpected.add(new Contract(
                AccountId = tempAccount.Id,
                WorkStatus__c = '404',
                Case__c = tempCase.Id,
                FlagAccollo__c = 0
            ));
        insert tempContractListExpected;
        List<Contract> actualContractList = GestionePraticheSmarriteController.selectContract(tempCase.Id, false);
        for(Integer i = 0; i < actualContractList.size(); i++)
            System.assertEquals(tempContractListExpected.get(i).Id, actualContractList.get(i).Id);
        
        //System.assertEquals(tempContractListExpected, actualContractList);
    }
    
    @isTest
    public static void updateStatusTest(){
        Account tempAccount = new Account(name = 'Filiale Test');
        insert tempAccount;
        List<Contract> tempContractList = generateTempContracts(tempAccount);
        insert tempContractList;
        System.assert(GestionePraticheSmarriteController.updateStatus('Trovato', tempContractList)); // Trovato == '400'
        for(Contract c : tempContractList) System.assertEquals('400', c.WorkStatus__c);
    }    
    
    @isTest
    public static void closeCaseIfTest(){
        Case tempCase = new Case(Note__c = 'Boia');
        Account tempAccount = new Account(name = 'Filiale Test');
        insert tempCase;
        insert tempAccount;
        List<Contract> tempContractList = generateTempContracts(tempAccount);
        insert tempContractList;
        //System.debug(GestionePraticheSmarriteController.closeCaseIf(tempContractList, '400', tempCase.Id, 'Note'));
        GestionePraticheSmarriteController.closeCaseIf(tempContractList, '400', tempCase.Id, 'Note');
        tempCase = [select id, status from case where id =: tempCase.Id];
        System.assertEquals('Closed', tempCase.Status);
    }
    
    @isTest static void closeCaseApexTest(){
        Case tempCase = new Case();
        tempCase.Status='New';
        insert tempCase;
        GestionePraticheSmarriteController.closeCaseApex(tempCase.Id);
    }
    
    public static List<Contract> generateTempContracts(Account tempAccount){
        List<Contract> res = new List<Contract>();
        for(Integer i = 0; i < 8; i++)
            res.add(new Contract(
                AccountId = tempAccount.Id,
                WorkStatus__c = '404',
                FlagAccollo__c = 0
            ));
        return res;
    }
}