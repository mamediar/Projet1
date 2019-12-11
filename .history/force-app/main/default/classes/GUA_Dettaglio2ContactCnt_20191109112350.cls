/**
 * @File Name          : GUA_Dettaglio2ContactCnt.cls
 * @Description        : 
 * @Author             : Mame Bousso kane
 * @CreatedDate        : 02/10/2019
 */
 public with sharing class GUA_Dettaglio2ContactCnt {
     
    @AuraEnabled 
    public static Map<String ,Object>  getRecuperaUtenzeIntermediario(String codiceIntermediario,String codiceUtenza){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        RecuperaUtenzeIntermediarioInvoker intermediarioInvoker= new RecuperaUtenzeIntermediarioInvoker();
        RecuperaUtenzeIntermediarioInvoker.RecuperaUtenzeIntermediarioRequestDTO objectIn= new RecuperaUtenzeIntermediarioInvoker.RecuperaUtenzeIntermediarioRequestDTO();
        objectIn.codiceIntermediario=codiceIntermediario;
        objectIn.codiceUtenza=codiceUtenza;
        RecuperaUtenzeIntermediarioInvoker.Response response= new RecuperaUtenzeIntermediarioInvoker.Response();
        
        returnValue.put('erreur', false);
        try {
            response = RecuperaUtenzeIntermediarioInvoker.invoke(objectIn);
            System.debug('response '+response);
               returnValue.put('resultat', response.recuperaUtenzeIntermediarioResponse.utenze);
            
        } catch (Exception e) {
            System.debug('errorMessage GUA_Dettaglio2ContactCnt getRecuperaUtenzeIntermediario '+e.getMessage());
             returnValue.put('erreur', true);
        }
     
        return returnValue;
    }
     
     @AuraEnabled 
    public static Map<String ,Object>  resetPassWord(String utenza){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        ResetPasswordPasscomInvoker resetPasswordPasscomInvoker = new ResetPasswordPasscomInvoker();
       
        //'00000669M0';
        ResetPasswordPasscomInvoker.Response response= new ResetPasswordPasscomInvoker.Response();
		
        returnValue.put('erreur', false);
        try {
            System.debug(' ResetPasswordPasscomInvoker utenza '+utenza);
            response = resetPasswordPasscomInvoker.invoke(utenza);
            System.debug(' ResetPasswordPasscomInvoker response '+response);
            returnValue.put('resultat', response);
        } catch (Exception e) {
            System.debug('errorMessage GUA_Dettaglio2ContactCnt resetPassWord '+e.getMessage());
             returnValue.put('erreur', true);
        }
     
        return returnValue;
    }


}