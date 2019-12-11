public class SFAArchiviazioneLottiRedParCaseCntrl {

	public static PageReference redirectToCase()
    {      
        String idLotto = ApexPages.currentPage().getParameters().get('id');
        system.debug('**************HOLA' + ApexPages.currentPage().getParameters().get('id'));
        
        PageReference pageRef = new PageReference('/' + [Select id from Case where Sfalotto__c = : idLotto AND Categoria_Riferimento__r.External_Id__c = 'AT0004'].id );
        return pageRef;
    }
}