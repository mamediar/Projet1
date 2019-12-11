/**
 * @File Name          : Gua_DatiaggiuntiviCnt.cls
 * @Description        : 
 * @Author             : Dieynaba Diallo
 * @CreatedDate        : 03/12/2019
 */
public with sharing  class Gua_DatiaggiuntiviCnt {
    
    @AuraEnabled
    public static Map<String ,Object> getDatiaggiuntiviByCase(String idCase){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           Case dealerCase = Gua_ManageUnitaAffariQuery.getDatiaggiuntiviByCase(idCase);
           returnValue.put('case',dealerCase);
       } catch (Exception e) {
            System.debug('errorMessage GUA_DettaglioDealerCnt getDatiaggiuntiviByCase '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    }

}