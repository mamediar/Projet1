public class SFAArchiveLostContractsController {

  @AuraEnabled
  public static void setContractsArchived(List<Id> contratti) {

    String query = 'SELECT Id, WorkStatus__c, Case__c' +
      ' FROM Contract' +
      ' WHERE Id IN :contratti';

    List<Contract> contrattiList = Database.query(query);

    if (contrattiList.size() > 0) {

      Id caseId = contrattiList[0].Case__c;

  		for (Contract contratto : contrattiList) {
  			contratto.WorkStatus__c='405';
  		}

  		update contrattiList;

      List<Contract> cList = [SELECT Id FROM Contract WHERE WorkStatus__c = '4' AND Case__c = :caseId];

      if (cList.size() == 0) {
        List<Case> caseList = [SELECT Id FROM Case WHERE Id = :caseId LIMIT 1];
        caseList[0].status = 'Closed';
        update caseList;
      }

    }

  }

}