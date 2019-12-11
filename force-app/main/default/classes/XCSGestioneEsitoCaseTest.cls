@isTest
public class XCSGestioneEsitoCaseTest 
{
    @isTest
    static void testXCSGestioneEsitoCase()
    {
        Case c = new Case();
        Profile p = new Profile();
        c.ActivityType__c='CRM_GDS';
        p.Name='luca';
        CaseEsitiConfig__mdt Esito = new CaseEsitiConfig__mdt();
        insert c;
		boolean isTrue = false ;         
       List<String> listaesiti =  XCSGestioneEsitoCase.getEsiti (c.Id);
       	system.debug(listaesiti);
        for(String a : listaesiti)
        {
            if(a.equals('Altro'))
            {
                isTrue = true;
            }
        }
        system.assert(isTrue);
    }
    
    @isTest
    static void testUpdateCase()
    {
        Case c = new Case();
        c.Esito__c='positivo';
        c.Status='New';
        c.Note__c='';
        insert c; 
        XCSGestioneEsitoCase.updateCase (c.Id, c.Esito__c ,c.Note__c);
    }
    
    @isTest static void testHandleCase(){
        Case c=new Case();
        insert c;
        XCSGestioneEsitoCase.handleCase('Ciccia',c.Id,'Testtt');
        XCSGestioneEsitoCase.handleCase('Gestita',c.Id,'Testtt');
        XCSGestioneEsitoCase.handleCase('Annullata',c.Id,'Testtt');
    }
    
}