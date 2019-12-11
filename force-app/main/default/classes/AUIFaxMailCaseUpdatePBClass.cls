public class AUIFaxMailCaseUpdatePBClass 
{
    @invocableMethod
    public static void ricercaStatoPratica (List<Case> cases)
    {
        List<Case> listCase = new List<Case>();
        for(Case c : cases)
        {
            Case cNew = new Case(Id = c.id);
            cNew.type = XCSCompassConstants.CASETYPECRM;
            cNew.Status = CaseUtils.APERTO;
            cNew.Categoria_Riferimento__r = XCS_CategoriaUtil.getCategoryForExternalId(XCS_CategoriaUtil.AUI_GESTIONE_FAX_MAIL);
            listCase.add(cNew);
        } 
        update listCase;
        System.debug('LISTA CASE AUI' + listCase);
    }
    
}