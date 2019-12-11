public class NuovoCasoClienteController {
    @AuraEnabled
    public static List<MenuConfigMatrix__mdt> loadOpzioniNuovoCaso(String componentType){
        return [SELECT Label, Destination__c, Sort_Order__c, Type__c, ApexClass__c
                FROM MenuConfigMatrix__mdt
                WHERE Parent__c =: componentType AND View_Name__c =: 'CRM - Call Center'
                ORDER BY Sort_Order__c ASC];
    }
    
    @AuraEnabled
    public static XCSMenuActionResult doPreRedirect(MenuConfigMatrix__mdt item, String accountId){
       	system.debug(' Nuovo caso preRedirect account: ' + accountId);
        if(item.ApexClass__c == null) return null;
        
        Account account = [SELECT Id, getCodice_Cliente__c,Telefono_Cellulare__c,PersonEmail,Tipo_Intermediario__c FROM Account WHERE Id =: accountId];
            //[SELECT Id, getCodice_Cliente__c FROM Account WHERE Id =: accountId];
            //[SELECT Id, getCodice_Cliente__c FROM Account WHERE OCS_External_Id__c='C6404'];
            
            
            
        system.debug(' Istanzio la classe  ' + item.ApexClass__c );
        XCSMenuAction action = (XCSMenuAction)Type.forName(item.ApexClass__c).newInstance();
        action.setAccount(account);
        action.setMetadata(item);
        system.debug('Start pre redirect');
        XCSMenuActionResult res=action.preRedirect();
        system.debug('End pre redirect');
        res.getState().put('utenteSelezionato',accountId);
        return res;
    }
    
}