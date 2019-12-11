public class CRMRetentionPrestitiAction extends XCSMenuAction
{
    public override XCSMenuActionResult preRedirect()
    {
        Account a = getAccount();
        OCSRecuperaDatiRetentionResponse res = OCSRecuperaDatiRetentionInvoker.invoke(a.getCodice_Cliente__c, 'CO', '');
        String descRetention = '';
        String tempPratica = '';
        List<String[]> lPratiche = new List<String[]>();
        Map<String,String> mapPratiche = new Map<String,String>();
        List<String> lPraticheSi = new List<String>();
        List<String> lPraticheNo = new List<String>();
        List<OCSRecuperaDatiRetentionResponse.PraticheResponse> listResponse = res.recuperaDatiRetentionResponse.elencoPratiche;
        List<PraticheRetention> listPraticheRetention = new List<PraticheRetention>();
        boolean retentionNonPossibile = false;
        List<Account_Retention__c> listAR = [SELECT Id, Esito__c, Valore__c, Partner__c, Prt1__c, Prt2__c, Prt3__c, Prt4__c, Prt5__c, Prt6__c, Prt7__c, Prt8__c, Offerta__c, Customer__c FROM Account_Retention__c where Customer__c = :a.Id];
        Account_Retention__c ar = (listAR.isEmpty() ? null : listAR.get(0));
        if(ar != null)
        {
            for(Integer i = 1; i <= 8 ; i++)
            {
                if(ar.get('Prt' + i + '__c') != null && !''.equals(ar.get('Prt' + i + '__c')))
                {
                    String tempString = (String)ar.get('Prt' + i + '__c');
                    String[] tempStringVector = tempString.split('\\|');
                    lPratiche.add(tempStringVector);
                    mapPratiche.put(tempStringVector[1],tempStringVector[0]);
                }
            }
            if(String.isNotBlank(ar.Esito__c) && String.isNotBlank(ar.Valore__c))
            {
                if(ar.Partner__c)
                {
                    for(String[] pr : lPratiche)
                    {
                        if(pr[0].equalsIgnoreCase('SI'))
                        {
                            lPraticheSi.add(pr[1]); 
                            system.debug('holllaaaaa');
                        }
                        else
                        {
                            lPraticheNo.add(pr[1]);
                        }
                    }
                    if(lPraticheSi.size() >= listResponse.size())
                    {
                        descRetention = CRMRetentionUtil.SOLO_CONTRATTI_ATTIVI;		
                        retentionNonPossibile = true;
                    }
                    else
                    {
                        descRetention = CRMRetentionUtil.CONTRATTI_ATTIVI;
                    }
                }
            }
            else
            {
                descRetention = CRMRetentionUtil.INFORMAZIONI_MANCANTI;
                RetentionNonPossibile = true;
            }
        }
        else
        {
            descRetention = CRMRetentionUtil.INFORMAZIONI_MANCANTI;
            RetentionNonPossibile = true;
        }
        if(!RetentionNonPossibile)
        {
            for(OCSRecuperaDatiRetentionResponse.PraticheResponse l : listResponse)
            {
                PraticheRetention prt = new PraticheRetention();
                prt.tipoPratica = l.tipoPratica;
                prt.numPratica = l.numPratica;
                prt.statoPratica = l.statoPratica;
                prt.attributoPratica = l.attributoPratica;
                prt.dataPrimaScadenza = l.dataPrimaScadenza;
                prt.dataUltimaScadenza = l.dataUltimaScadenza;
                prt.codProdotto = l.codProdotto;
                prt.desProdotto = l.desProdotto;
                prt.modalitaPagamento = l.modalitaPagamento;
                prt.importoFinanziato = l.importoFinanziato;
                prt.montante = l.montante;
                prt.saldoPratica = l.saldoPratica;
                prt.dataEstinzione = l.dataEstinzione;
                prt.dataLiquidazione = l.dataLiquidazione;
                prt.codCliente = l.codCliente;
                prt.agente = l.agente;
                prt.partner = (mapPratiche.get(l.numPratica) != null) ? mapPratiche.get(l.numPratica) : 'NO';
                prt.source = 'M';
                listPraticheRetention.add(prt);
                
            }
        }
        Map<String,Object> mapres = new Map<String,Object>();
        mapres.put('c__retentionNonPossibile' , retentionNonPossibile);
        mapres.put('c__retentionDesc',descRetention);
        mapres.put('c__listaRetention',listPraticheRetention);
        mapres.put('c__arrayLength',listPraticheRetention.size());
        mapres.put('c__esitoCliente', ar != null ? ar.Esito__c : '');
        mapres.put('c__valoreCliente', ar != null ? ar.Valore__c : '');
        mapres.put('c__customerId', a.id);
        mapres.put('c__customerEmail' , String.isNotBlank(a.personEmail) ? a.PersonEmail : '');
        mapres.put('c__customerTelefono',String.isNotBlank(a.Telefono_Cellulare__c) ? a.Telefono_Cellulare__c : '');
        mapres.put('c__esitoDescriptionCustomer' ,CRMRetentionUtil.MAP_ESITO_DESCRIPTION.get(ar != null ? ar.Esito__c : ''));
        mapres.put('c__redirectComponentName' , XCSCompassConstants.POSTVENDITA_LAUNCHER_COMPONENT);
        mapres.put('c__redirectPostvenditaId' , XCSCompassConstants.POSTVENDITA_ID_ESTINZIONE_ANTICIPATA);
        XCSMenuActionResult resResult = new XCSMenuActionResult('standard__component');
        resResult.getAttributes().setComponentName('c__CRMRetentionPrestitiPrework');
        resResult.setState(mapres);
        return resResult;   
    }
    public class PraticheRetention
    {
        @AuraEnabled
        public String tipoPratica {get; set;}
        @AuraEnabled
        public String numPratica {get; set;}
        @AuraEnabled
        public String statoPratica {get; set;}
        @AuraEnabled
        public String attributoPratica {get; set;}
        @AuraEnabled
        public String dataPrimaScadenza {get; set;}
        @AuraEnabled
        public String dataUltimaScadenza {get; set;}
        @AuraEnabled
        public String codProdotto {get; set;}
        @AuraEnabled
        public String desProdotto {get; set;}
        @AuraEnabled
        public String modalitaPagamento {get; set;}
        @AuraEnabled
        public String importoFinanziato {get; set;}
        @AuraEnabled
        public String montante {get; set;}
        @AuraEnabled
        public String saldoPratica {get; set;}
        @AuraEnabled
        public String dataEstinzione {get; set;}
        @AuraEnabled
        public String dataLiquidazione {get; set;}
        @AuraEnabled
        public String codCliente {get; set;}
        @AuraEnabled
        public String agente {get; set;}
        @AuraEnabled
        public String partner {get; set;}
        @AuraEnabled
        public String source {get;set;}
    }
    public class PraticheResponseWrap
    {
        @AuraEnabled
        public String listRetention {get; set;} 
    }
}