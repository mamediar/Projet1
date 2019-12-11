@isTest
public class ApriSchermataEVOControllerTest {
    @isTest
    public static void doInitTest(){
        XCS_CompassParameters__c evo = new XCS_CompassParameters__c();
        evo.Name = 'evo.url';
        evo.Label__c = 'evo.url';
        evo.Value__c = 'https://compassweb.int.compassonline.it/evo/feest/TaskLauncherNoPwd';       
        XCS_CompassParameters__c evoEnv = new XCS_CompassParameters__c();
        evoEnv.Name = 'evo.url.env';
        evoEnv.Label__c = 'evo.url.env';
        evoEnv.Value__c = 'demo';
        XCS_CompassParameters__c evoDemo = new XCS_CompassParameters__c();
        evoDemo.Name = 'evo.url.demo';
        evoDemo.Label__c = 'evo.url.demo';       
        evoDemo.Value__c = 'https://sviluppo.passcom.compassonline.it/compass-demo/feest/TaskLauncher';
        XCS_CompassParameters__c userDefault = new XCS_CompassParameters__c();
        userDefault.Name = 'evo.url.user.default';
        userDefault.Label__c = 'user';
        userDefault.Value__c = 'CD2670';
        XCS_CompassParameters__c user = new XCS_CompassParameters__c();
        user.Name = 'evo.url.user.PTACLCAAS';
        user.Label__c = 'user';
        user.Value__c = 'CUCFI000';                
        XCS_CompassParameters__c pwdDefault = new XCS_CompassParameters__c();
        pwdDefault.Name = 'evo.url.pwd.default';
        pwdDefault.Label__c = 'pwd';
        pwdDefault.Value__c = 'bebba004';
        XCS_CompassParameters__c pwd = new XCS_CompassParameters__c();
        pwd.Name = 'evo.url.pwd.PTACLCAAS';
        pwd.Label__c = 'pwd';
        pwd.Value__c = 'standalone01';        
        XCS_CompassParameters__c env = new XCS_CompassParameters__c();
        env.Name = 'evo.url.env.default';
        env.Label__c = 'env';
        env.Value__c = 'DEMOC';
        XCS_CompassParameters__c sys = new XCS_CompassParameters__c();
        sys.Name = 'evo.url.system.default';
        sys.Label__c = 'system';
        sys.Value__c = 'SYSSETT0';        
        XCS_CompassParameters__c tipoLog = new XCS_CompassParameters__c();
        tipoLog.Name = 'evo.url.tipo_login.default';
        tipoLog.Label__c = 'tipo_login';
        tipoLog.Value__c = 'W';
        
        insert evo;
        insert evoEnv;
        insert evoDemo;
        insert userDefault;
        insert user;
        insert pwdDefault;
        insert pwd;       
        insert env;
        insert sys;
        insert tipoLog;
        
        String expected = ApriSchermataEVOController.doInit('PTACLCAAS','DEFAULT','closewindow','162888430','0000000000','00000000               I');
		String actual = 'https://sviluppo.passcom.compassonline.it/compass-demo/feest/TaskLauncher?task=PTACLCAAS&linkage=AS&urlritorno=closewindow&parametri=162888430000000000000000000               I&user=CUCFI000&pwd=standalone01&env=DEMOC&terminale=CUCFI000&system=SYSSETT0&tipo_login=W';        
        system.assertEquals(expected,actual);
    }
}