public class LinkEvoController {
   
    public static String getUrl(String sTask)
    {
        String env = getEnv();  
        String UrlTemp = CompassParametersUtils.getValue('evo.url.' + env);
        String Url = String.isEmpty(UrlTemp) ?  CompassParametersUtils.getValue('evo.url.' + sTask) : UrlTemp;
        return String.isEmpty(Url) ? CompassParametersUtils.getValue('evo.url') : Url;
    }
    public static String getUser(String sTask,boolean forceUser)
    {
		String env = getEnv();
        String User = CompassParametersUtils.getValue('evo.url.user.' + sTask);
        user =  String.isEmpty(user) ?CompassParametersUtils.getValue('evo.url.user.default') : User;
        String userlogged = [SELECT Alias FROM User Where Id = :userinfo.getUserId()].Alias;
     
        System.debug(forceUser);
        System.debug(sTask);
    	return (!forceUser && String.isEmpty(env) && sTask.equals('PTACLCAAS')) ? userlogged :  user; 
    }
	public static String getPwd(String sTask,boolean forcePwd)
    {
      	String pwd = CompassParametersUtils.getValue('evo.url.pwd.' + sTask);
        return String.isEmpty(pwd) ?CompassParametersUtils.getValue('evo.url.pwd.default') : pwd;    
    }
    public static String getEnv()
    {
        return CompassParametersUtils.getValue('evo.url.env');
    }
    
    @AuraEnabled
    // tra attributi in input esisteva anche uno chiamato office di tipo String da valutare dove fixare
    public static String doInit(boolean force,String sTask, String sLinkage, String sUrlritorno, String CIP, String numeroPratica, String tipoPratica,String infoPre, String infoPost){
        System.debug('SONO DENTRO IL CONTROLLER APEX LINK EVO');
        String res = getUrl(sTask);
        XCS_CompassParameters__c userLogged = new XCS_CompassParameters__c();
        XCS_CompassParameters__c user;
        XCS_CompassParameters__c password;
        XCS_CompassParameters__c sys = XCS_CompassParameters__c.getValues('evo.url.system.default');
        XCS_CompassParameters__c tipoLogin = XCS_CompassParameters__c.getValues('evo.url.tipo_login.default');
       	XCS_CompassParameters__c env = XCS_CompassParameters__c.getValues('evo.url.env.' + CompassParametersUtils.getValue('evo.url.env'));
        String envString = env == null ? '' : env.Value__c;

        userLogged.Label__c = 'user';
        userLogged.Value__c = [SELECT Alias FROM User Where Id = :userinfo.getUserId()].Alias;
        if(sTask != null) sLinkage = 'TK000003B1'.equalsIgnoreCase(sTask) ? 'RICERCA' : 'PTACLCAAS'.equalsIgnoreCase(sTask) ? 'AS' : sLinkage;
      
        
        CIP = (String.isEmpty(CIP) ? '' : CIP.leftPad(9 , '0'));
        numeroPratica = numeroPratica.leftPad(12 , '0');
        res += '?user=' + getUser(sTask,force) +
            '&pwd=' + getPwd(sTask,force) +
            '&newpwd='+
            '&env=' + envString +
            '&terminale=' + getUser(sTask,force) +
            '&' + sys.Label__c + '=' + sys.Value__c +
            '&task=' + sTask +
            '&linkage=' + sLinkage + 
            '&parametri=' + infoPre + CIP + numeroPratica + infoPost +
            '&' + tipoLogin.Label__c + '=' + tipoLogin.Value__c +
            '&urlritorno=' + sUrlritorno; 
            
        
        System.debug(res);
        return res;
    }
}