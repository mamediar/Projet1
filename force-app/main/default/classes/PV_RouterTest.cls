/**
 * @File Name          : PV_RouterTest.cls
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 2019-6-20 09:22:52
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-6-20 09:06:34   Andrea Vanelli     Initial Version
**/
@isTest (SeeAllData=true)
public with sharing class PV_RouterTest {
	static final String Status_PV_Da_Processare = 'PV_Da_Processare';

	@isTest static void testOK() {

// prendo un ufficio
String uffId = [Select Id from Account where RecordType.Name = 'Uffici e Altro' AND Codice_Ufficio__c = 'back'][0].Id;
// prendo la categoria variazione anagrafica step 2
String categId = [SELECT Id FROM XCS_Categoria__c WHERE External_Id__c = '1763'][0].Id;

//inserisco una regola fittizzia con step 9 che usa le cond extra e porta a uff_inserimento, con anche il set extra
XCS_PV_Config__c regola = new XCS_PV_Config__c();
regola.Step__c = '9';
regola.XCS_Categoria__c = categId;
regola.Stato__c = Status_PV_Da_Processare;
regola.Name = 'testrule';
regola.Descrizione_Step__c ='desc testrule';
regola.Condizioni__c = 'FlagCarteDaRitirare__c==true';
regola.Set_Coda__c = 'UFF_INSERIMENTO';
regola.Set_Stato__c = 'Closed';
regola.Set_Step__c = '10';
regola.Set_Altro__c = 'Step_PV__c=11';
insert regola;



// preparo un case
   List<Case> cases = new List<Case>();
   Case caseObj = new Case(
    Categoria_Riferimento__c = 	categId,
    Step_PV__c = '9',
    Status = Status_PV_Da_Processare,
    FlagCarteDaRitirare__c = true,Branch__c = uffId );
   cases.add(caseObj);

   // non processabile
   caseObj = new Case(
    Categoria_Riferimento__c = 	categId,
    Step_PV__c = '99',
    Status = Status_PV_Da_Processare,
    FlagCarteDaRitirare__c = true,Branch__c = uffId );
   cases.add(caseObj);

   Test.startTest();
   PV_Router.startPVRouter(cases);
   Test.stopTest();


	}    
}