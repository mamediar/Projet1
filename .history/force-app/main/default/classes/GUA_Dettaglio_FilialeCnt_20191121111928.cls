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
           System.debug('errorMessage Gua_ManageUnitaAffariCnt Gua_ManageUnitaAffariCnt '+ cse);
           if(cse.Id == null){
               throw new CustomException('Nessun case trovato');
           }
           returnValue.put('case',cse);
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
     public class CustomException extends Exception {}
}