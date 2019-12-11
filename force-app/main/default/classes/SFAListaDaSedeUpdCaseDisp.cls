global class SFAListaDaSedeUpdCaseDisp implements Database.Batchable<sObject> {

    global List<Case> caseParent;
    global SFAListaDaSedeUpdCaseDisp(List<Case> caseParent) {
    	this.caseParent = caseParent;
        System.debug('Fine Batch UpdateCase Disposition, caseParent '+caseParent.size()+' Case'+caseParent);
    }
    global Iterable<sObject> start(Database.BatchableContext bc) {
        
        return this.caseParent;
    }
    global void execute(Database.BatchableContext bc, List<case> scope) {
        Set<case> caseToUpdate = new Set<case>();
        for(Case c : scope) {
        	caseToUpdate.add(SFAListaDaSedeAttivitaFilialeController.getCaseChildInfo(c));
        }
        List<Case> listCasOne = new List<Case>();
        listCasOne.addAll(caseToUpdate);
        upsert listCasOne;
    }
    global void finish(Database.BatchableContext bc){ 
    	System.debug('Fine Batch UpdateCase Disposition, elaborati '+caseParent.size()+' Case');
    }
}