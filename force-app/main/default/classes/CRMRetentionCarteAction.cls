public class CRMRetentionCarteAction extends XCSMenuAction
{
    public override XCSMenuActionResult preRedirect()
    {
        // Chiamo i servizi
        OCSRecuperaRetentionCarteResponse retCarResponse = OCSRecuperaRetentionCarteInvoker.invoke(getAccount().getCodice_Cliente__c);       
        Case c = new Case
            (
                Subject = CRMRetentionUtil.CASERETENTIONCARTESUBJECT,
                recordtypeid = RecordtypeUtil.getCaseRecordType(RecordtypeUtil.RETENTIONCLIENTE),
                AccountId = getAccount().id,
                categoria_riferimento__r = XCS_CategoriaUtil.getCategoryForExternalId(XCS_CategoriaUtil.BACKOFFICEINBOUNDCATEGORYCODE),
                Product__c = Product2Util.getProductFromExternalId(Product2Util.RETENTIONPRODUCTCODE).id,
                processType__c = CRMRetentionUtil.CASERETENTIONCARTEPROCESSTYPEINBOUND,
                type = XCSCompassConstants.CASETYPECRM
            );
        Insert c;
        String userAlias = [SELECT Alias FROM User Where Id = :userinfo.getUserId()].Alias;        
        List<CRM_Retention__c> retentionList = new List<CRM_Retention__c>();
        if (retCarResponse.recuperaRetentionCarteResponse.elencoCarte != null) {
            
            for(OCSRecuperaRetentionCarteResponse.CartaResponse cr : retCarResponse.recuperaRetentionCarteResponse.elencoCarte)
            {
                system.debug('Carta: ' + cr.numCarta);
                retentionList.add(new CRM_Retention__c
                                  (
                                      Utente__c = userAlias,
                                      Action__c = ''.equals(cr.esitoRetention) ? 'KO' : cr.esitoRetention.toUpperCase(),
                                      ProductDescription__c = cr.prodottoAttributo,
                                      LoanStatusAttribute__c = cr.bloccoCarta,
                                      Source__c = 'M',
                                      LoanType__c = 'CA',
                                      LoanNumber__c = cr.numCarta,
                                      LoanStatus__c = cr.statoCarta,
                                      ProductCode__c = cr.prodottoCarta,
                                      RetentionValue__c = cr.valoreRetention,
                                      Customer__c = getAccount().id,
                                      Case__c = c.id,
                                      Type__c = CRMRetentionUtil.RETENTIONTYPEREQUESTED
                                  )             
                                 );  
            }
        }
        if(retentionList.size() > 0)
        {
            insert retentionList;
        }
        XCSMenuActionResult res = new XCSMenuActionResult('standard__recordPage');
        res.getAttributes().setRecordId(c.Id);
        res.getAttributes().setObjectApiName(res.CASEAPINAME);	
        res.getAttributes().setActionName(res.VIEWACTION);
        return res;
    }
}