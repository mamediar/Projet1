public class ApriSchermataEVOController {

    @AuraEnabled
    public static String doInit(String sTask, String sLinkage, String sUrlritorno, String CIP, String numeroPratica, String office){
        String res = '';
        
        XCS_CompassParameters__c user = (XCS_CompassParameters__c.getValues('evo.url.user.' + sTask) == null) ? XCS_CompassParameters__c.getValues('evo.url.user.default') : XCS_CompassParameters__c.getValues('evo.url.user.' + sTask);
        XCS_CompassParameters__c password = (XCS_CompassParameters__c.getValues('evo.url.pwd.' + sTask) == null) ? XCS_CompassParameters__c.getValues('evo.url.pwd.default') : XCS_CompassParameters__c.getValues('evo.url.pwd.' + sTask);
        XCS_CompassParameters__c env = XCS_CompassParameters__c.getValues('evo.url.env.default');
        XCS_CompassParameters__c sys = XCS_CompassParameters__c.getValues('evo.url.system.default');
        XCS_CompassParameters__c tipoLogin = XCS_CompassParameters__c.getValues('evo.url.tipo_login.default');

        if(sTask != null) sLinkage = 'TK000003B1'.equalsIgnoreCase(sTask) ? 'RICERCA' : 'PTACLCAAS'.equalsIgnoreCase(sTask) ? 'AS' : sLinkage;
        
        res = String.isBlank(CompassParametersUtils.getValue('evo.url.env')) ? CompassParametersUtils.getValue('evo.url') : CompassParametersUtils.getValue(('evo.url.' + (CompassParametersUtils.getValue('evo.url.env'))));
        res += '?task=' + sTask + 
            '&linkage=' + sLinkage + 
            '&urlritorno=' + sUrlritorno + 
            '&parametri=' + CIP + numeroPratica + office +
            '&' + user.Label__c + '=' + user.Value__c +
            '&' + password.Label__c + '=' + password.Value__c +
            '&' + env.Label__c + '=' + env.Value__c +
            '&terminale=' + user.Value__c +
            '&' + sys.Label__c + '=' + sys.Value__c +
            '&' + tipoLogin.Label__c + '=' + tipoLogin.Value__c;
                    
        System.debug(res);
        return res;
    }
}