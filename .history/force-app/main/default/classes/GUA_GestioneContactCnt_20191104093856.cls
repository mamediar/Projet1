/**
 * @File Name          : GUA_GestioneContactCnt.cls
 * @Description        : 
 * @Author             : Mame Bousso kane
 * @CreatedDate        : 20/09/2019
 */
public with sharing class GUA_GestioneContactCnt {
    
    @AuraEnabled
    public static Map<String ,Object> getContactCaseByQueue(Group grp){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           List<Case> contactsCase = Gua_ManageUnitaAffariQuery.getContactsCaseByQueue(grp);
           returnValue.put('resultat',contactsCase);
       } catch (Exception e) {
            System.debug('errorMessage GUA_GestioneContactCnt getContactByQueue '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    } 

    @AuraEnabled
    public static Map<String ,Object> filterContactCaseByCampagna(Group grp, String nameCampagna, String orderCriter){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           List<Case> contactsCase = Gua_ManageUnitaAffariQuery.filterCaseByCampagna(grp, nameCampagna, orderCriter);
           System.debug('contactsCase'+contactsCase);
           returnValue.put('resultatFilter',contactsCase);
       } catch (Exception e) {
            System.debug('errorMessage GUA_GestioneContactCnt getContactByQueue '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    } 
    
    @AuraEnabled
    public static Map<String,Object> filterCaseByNomeOcsCF(String nome, String codiceOcs, String utenzoCF, String pageSize, String pageNumber){
        System.debug('################## running  filterCaseByNomeOcsCF');
        Map<String, Object> returnValue = new Map<String, Object>();
        returnValue.put('error',false);
          List<Case> cntactsCases = new  List<Case> ();
      
        System.debug('##################  codiceOcs '+codiceOcs);
        try {
            if(String.isNotEmpty(codiceOcs) || String.isNotEmpty(nome) ){
                  cntactsCases = Gua_ManageUnitaAffariQuery.filterCaseByCodiceOcsNome( codiceOcs,  nome,  utenzoCF, pageSize, pageNumber);
                   returnValue.put('cntactsCases', cntactsCases);
            }
            else{
                System.debug('############################# ');
                RecuperaUtenzeIntermediarioInvoker.RecuperaUtenzeIntermediarioRequestDTO req = new   RecuperaUtenzeIntermediarioInvoker.RecuperaUtenzeIntermediarioRequestDTO();
                req.codiceIntermediario = utenzoCF;
                req.codiceUtenza = utenzoCF;
                RecuperaUtenzeIntermediarioInvoker.Response  response = RecuperaUtenzeIntermediarioInvoker.invoke(req);
            }
          
             System.debug('###################  cntactsCase '+cntactsCases.size());
           
            
        } catch (Exception e) {
             returnValue.put('error',true);
                 System.debug('################ errorMessage '+e.getMessage());
                 System.debug('################ '+e.getStackTraceString());
        } 
        return returnValue;
    }
}