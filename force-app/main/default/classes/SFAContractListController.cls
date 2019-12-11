public class SFAContractListController {

  @AuraEnabled
  public static List<Contract> getContratti(String colonne, List<String> workStatus, String caseId) {

    String query = 'SELECT Id, ' + colonne +
      ' FROM Contract' +
      ' WHERE WorkStatus__c IN :workStatus AND Case__r.Id = :caseId';

    List<Contract> contrattiList = Database.query(query);

    return contrattiList;
  }

}