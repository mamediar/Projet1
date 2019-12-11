/**
 * @File Name          : Gua_ChiamataStandaloneOutboundCnt.cls
 * @Description        : 
 * @Author             : Mame Bousso kane
 * @CreatedDate        : 22/10/2019
 */
 public with sharing class Gua_ChiamataStandaloneOutboundCnt {
    @AuraEnabled
    public static Map<String ,Object> getFilialeByNameOrCodiceFiliale(String valueNameCF){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        try {
           List<Account> filiales = Gua_ManageUnitaAffariQuery.getFiliales(valueNameCF);
           returnValue.put('resultat',filiales);
            if(filiales.size() == 0){
            	returnValue.put('message', 'Nessun filiale trovato');
                throw new CustomException('Nessun filiale trovato');
            }
        } catch (Exception e) {
            System.debug('errorMessage Gua_ChiamataStandaloneOutboundCnt getFilialeByNameOrCodiceFiliale '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
        }
        return returnValue;
    }

    /**
        User useOperator=[select id,name,profile.name,UserRole.Name from User where id=:use and profile.name in (:PermissionUtils.BRANCH_MANAGER, :PermissionUtils.BRANCH_EMPLOYEE)];
                        String roleName = useOperator.UserRole.Name;
                        roleName=roleName.replace(' ', '_');
                        Account filiale = [SELECT Id,Name,CittaSede__pc,getCodice_Cliente__c,Provincia_Nascita__pc,Luogo_Nascita__pc,BillingAddress,ShippingStreet, 
                                        ShippingCity, ShippingState, ShippingPostalCode FROM Account WHERE RecordType.Name='Branch'
                                                                                        AND NameRoleReference__c =:roleName limit 1];
 */
    @AuraEnabled
    public static Map<String ,Object> getCapoFiliale(String valueNameCF){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        try {
            String use= UserInfo.getUserId();
            Boolean isbranch =PermissionUtils.isBranch(use);
            if(isbranch){
                User useOperator=[select id,name,profile.name,UserRole.Name from User where id=:use and profile.name in (:PermissionUtils.BRANCH_MANAGER, :PermissionUtils.BRANCH_EMPLOYEE)];
                String roleName = useOperator.UserRole.Name;
                roleName=roleName.replace(' ', '_');
                Account filiale = [SELECT Id,Name,CittaSede__pc,getCodice_Cliente__c,Provincia_Nascita__pc,Luogo_Nascita__pc,BillingAddress,ShippingStreet, 
                                        ShippingCity, ShippingState, ShippingPostalCode FROM Account WHERE RecordType.Name='Branch'
                                                                                        AND NameRoleReference__c =:roleName limit 1];
            }
        } catch (Exception e) {
            System.debug('errorMessage Gua_ChiamataStandaloneOutboundCnt getCapoFiliale '+e.getMessage());
            returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
            returnValue.put('erreur', true);
        }
        return returnValue;
    }
     public class CustomException extends Exception {}
}