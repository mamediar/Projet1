/**
 * @File Name          : GUA_GestioneQueueCnt.cls
 * @Description        : 
 * @Author             : Mame Bousso kane
 * @CreatedDate        : 20/09/2019
 */
public class GUA_GestioneQueueCnt {
    
    @AuraEnabled
    public static Map<String ,Object> getQueus(){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           List<Group> queus = Gua_ManageUnitaAffariQuery.getQueus();
           returnValue.put('resultat',queus);
       } catch (Exception e) {
            System.debug('errorMessage Gua_ManageUnitaAffariCnt Gua_ManageUnitaAffariCnt '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    }
}