@isTest
public with sharing class SFAUtenzeNominativePDFControllerTest {

    @isTest
    public static void test1(){
        XCS_Categoria__c cat2 = new XCS_Categoria__c(External_Id__c = 'AT0114');
        insert cat2;
        Case cas = TestDataFactory.insertCase();
        Comunicazione_Utenze__c com = new Comunicazione_Utenze__c(Canale__c = '2',	Utenza__c= '323232',CaseAttivit_di_Riferimento__c = cas.id);
        insert com;  
        Test.startTest();
        PageReference pageRef = Page.SFAUtenzeNominativePDF;
        Test.setCurrentPage(pageRef);        
        ApexPages.StandardController sc = new ApexPages.StandardController(cas); 
        ApexPages.currentPage().getParameters().put('IdCase',cas.id);
        SFAUtenzeNominativePDFController contr = new SFAUtenzeNominativePDFController(sc);
        contr.init();
        Test.stopTest();
        System.assert(contr.utenzeNominaliList!=null && contr.utenzeNominaliList.size()==1);
    }
}