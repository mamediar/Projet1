/**
 * @File Name          : GUA_Dettaglio_DealerCnt.cls
 * @Description        : 
 * @Author             : Khadim R Ndeye
 * @CreatedDate        : 24/10/2019
 */
 public with sharing class GUA_Dettaglio_FilialeCnt{
 @AuraEnabled
    public static Map<String ,Object> getCase(String idCase){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           Case cse = Gua_ManageUnitaAffariQuery.getFilaliByCase(idCase);
           System.debug('sucessMessage Gua_ManageUnitaAffariCnt Gua_ManageUnitaAffariCnt '+ cse);
           if(cse.Id == null){
               throw new CustomException('Nessun case trovato');
           }
           returnValue.put('data',cse);
       } catch (Exception e) {
            System.debug('errorMessage Gua_ManageUnitaAffariCnt Gua_ManageUnitaAffariCnt '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    }
    @AuraEnabled 
    public static Map<String ,Object>  getRecuperaUtenzeIntermediario(String role){
        Map<String ,Object> response = new  Map<String ,Object>();
         response.put('erreur', false);
        try {
            List<User> utentente = [SELECT Id, Name, UserRole.Name, Profile.Name, UserType, Email, FirstName, LastName, EmployeeNumber FROM User
                                    WHERE  UserRole.Name=:role AND Profile.Name='Branch Employee'];
            System.debug('utentente >> '+utentente);            
            response.put('utentente', utentente);
        } catch (Exception e) {
            System.debug('errorMessage GUA_Dettaglio2ContactCnt getRecuperaUtenzeIntermediario '+e.getMessage());
             response.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             response.put('erreur', true);
        }
     
        return response;
    }

    @AuraEnabled
    public static Map<String ,Object> getFilialeById(String idAccount){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           Account filialeCase = Gua_ManageUnitaAffariQuery.getFilialeById(idAccount);
           returnValue.put('filiale',filialeCase);
       } catch (Exception e) {
            System.debug('errorMessage GUA_DettaglioDealerCnt getFilialeById '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    }

    @AuraEnabled
    public static Map<String ,Object> getCapoFiliale(String idFiliale){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        returnValue.put('filiale', false);
        returnValue.put('resultat','');
       try {
            if(idFiliale!=null){
                returnValue.put('filiale', true);
                Account filiale = [SELECT Id,Name,CittaSede__pc,getCodice_Cliente__c,Provincia_Nascita__pc,Luogo_Nascita__pc,BillingAddress,ShippingStreet,
                                    ShippingCity, ShippingState, ShippingPostalCode, NameRoleReference__c,NameParentRoleReference__c
                                    FROM Account WHERE Id=:idFiliale];
                //RecordType.Name='Branch'
                Map<String, Object> filialeMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(filiale));
                if(filialeMap.keySet().contains('NameParentRoleReference__c')){
                     String roleReference = filiale.NameParentRoleReference__c;
                    roleReference=roleReference.replace('_', ' ');
                    User capoFiliale=[select id,name,profile.name,UserRole.Name from User
                                                    where  profile.name in (:PermissionUtils.BRANCH_MANAGER,:PermissionUtils.BRANCH_EMPLOYEE)
                                                    and UserRole.Name=:roleReference limit 1];
                    if(capoFiliale.Id!=null){
                        returnValue.put('resultat',capoFiliale);
                    }
                }else {
                }
       }else {
            returnValue.put('filiale', false);
       }
       } catch (Exception e) {
            System.debug('errorMessage GUA_DettaglioDealerCnt getCapoFiliale '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    }

     public class CustomException extends Exception {}
}