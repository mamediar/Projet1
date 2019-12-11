public class CRMRetentionCheckDispositionAction extends XCSDispositionAction
{
    //private String tipoRevoca;
    //public void setTipoRevoca(String tipoRevoca){this.tipoRevoca = tipoRevoca;}
    public override XCSDispositionResult execute()
    {
        CRM_Retention__c retention = (CRM_Retention__c)getSObject();
        XCS_Disposition__c disposition = (XCS_Disposition__c)getDisposition();
        String motivoRevoca = '';
        boolean check = false;
        boolean tempCheck = false;
        System.debug('[][][][][][][][][]' + disposition + '###############' +disposition.Visibility__c);
        String tRevoca = 'NO'.equalsIgnoreCase(disposition.Visibility__c) ? CRMRetentionUtil.TRATTENUTO : CRMRetentionUtil.REVOCATO ;
        System.debug('############' + tRevoca);
        OCSRecuperaStatoRichiestePSVResponse.ResponseClass res = CRMRetentionUtil.getLastValueOfPSVService(retention.LoanNumber__c, retention.LoanType__c); 
        system.debug('******1');
        if(res != null && res.stato.equals('30') && res.blocco.equals(''))
        {
            system.debug('******2');
            if(tRevoca.equalsIgnoreCase(res.codAzione))
            {
                system.debug('******5 FINISH');
                check = true;
            }
        }
        if(!check)
        {
            if(CRMRetentionUtil.TRATTENUTO.equals(tRevoca))
            {
                motivoRevoca = CRMRetentionUtil.MESSAGGIO_ERRORE_PRD;
            }
            else
            {
                motivoRevoca = CRMRetentionUtil.MESSAGGIOERRORE;
            }
        }
        XCSDispositionResult response = new XCSDispositionResult();
        response.result = check;
        response.messagge = motivoRevoca;
        system.debug(response);
        return response;
    }
}