public class SFACaseListController {

  @AuraEnabled
  public static List<Case> getCases(String colonne, List<String> status, String caseId) {

    String query = 'SELECT Id, ShowCase__c, ' + colonne +
      ' FROM Case';
	if (status != null && caseId != null)  {
    	query += ' WHERE Status IN :status AND ParentId = :caseId';
	}
	else if (status != null && caseId == null)  {
    	query += ' WHERE Status IN :status';
	}
	else if (status == null && caseId != null)  {
    	query += ' WHERE ParentId = :caseId';
	}

    List<Case> caseList = Database.query(query);

    return caseList;
  }

}