/**
 * @File Name          : GUA_GestioneContactCnt.cls
 * @Description        : 
 * @Author             : Mame Bousso kane
 * @CreatedDate        : 20/09/2019
 */
public with sharing class GUA_GestioneContactCnt {
    
    @AuraEnabled
    public static Map<String ,Object> getContactCaseByQueue(Group grp,String pageSize, String pageNumber){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           List<Case> contactsCase = Gua_ManageUnitaAffariQuery.getContactsCaseByQueue(grp,pageSize,pageNumber);
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
        List<UtenZaDealer> utenzaWrappers = new List<UtenZaDealer>();
        Set<String> codiceOcsSet = new Set<String>();
      
        System.debug('##################  codiceOcs '+codiceOcs);
        try {
            if(String.isNotEmpty(codiceOcs) || String.isNotEmpty(nome) ){
                  System.debug('############################# No utenze');
                  //cntactsCases = Gua_ManageUnitaAffariQuery.filterCaseByCodiceOcsNome(codiceOcs,  nome, utenzoCF, pageSize, pageNumber);
               /*   for(Case c : cntactsCases){
                       utenzaWrappers.add(new UtenZaDealer(c.Id, c.Dealer__r.RagioneSociale__pc, c.CodiceDealer__c, 'tipo', 'stato', 'cf') );
                  }  */
                   returnValue.put('cntactsCases', cntactsCases);
            }
            else{
                System.debug('#############################  utenze');
                RecuperaUtenzeIntermediarioInvoker.RecuperaUtenzeIntermediarioRequestDTO req = new   RecuperaUtenzeIntermediarioInvoker.RecuperaUtenzeIntermediarioRequestDTO();
                req.codiceIntermediario = utenzoCF;
                req.codiceUtenza = utenzoCF;
                RecuperaUtenzeIntermediarioInvoker.Response  response = RecuperaUtenzeIntermediarioInvoker.invoke(req);
                System.debug('############## response '+response);
                if(RecuperaUtenzeIntermediarioInvoker.validateResponse(response)){
                    for( RecuperaUtenzeIntermediarioInvoker.UtenzaIntermediarioDTO dto:  response.recuperaUtenzeIntermediarioResponse.utenze){
                        // utenzaWrappers.add(new UtenZaDealer(dto.Id, dto.ragSocIntermediario, dto.codiceIntermediario, dto.tipo, dto.statoDealer, dto.codiceFiscale, dto.localitaNascita, dto.provinciaNascita) );
                        codiceOcsSet.add(dto.codiceIntermediario);
                    }
                 if(codiceOcsSet.size() > 0){
                     //cntactsCases = Gua_ManageUnitaAffariQuery.getCasesByCodiceOcs(codiceOcsSet, pageSize, pageNumber );
                     returnValue.put('cntactsCases', cntactsCases);
                 }
                    
                }

            }

             System.debug('###################  cntactsCase '+cntactsCases.size());
            System.debug('##################  utf'+cntactsCases[0].UAF_DatiAggiuntiviFile__c);
            
        } catch (Exception e) {
             returnValue.put('error',true);
                 System.debug('################ errorMessage '+e.getMessage());
                 System.debug('################ '+e.getStackTraceString());
        } 
        return returnValue;
    }

    @AuraEnabled
    public static Map<String ,Object>  getInformazioniDealerByCodeOCS(String codiceOCS){
        Map<String,Object> returnValue = new  Map<String,Object>();
         returnValue.put('error', false);
        try {
         
                Account account = Gua_ManageUnitaAffariQuery.getDealerByCodiceOCS(codiceOCS);
                returnValue.put('dealer', account);
        } catch (Exception e) {
                returnValue.put('error', true);
                System.debug('############### errorMessage '+e.getMessage());
                System.debug('################# err '+e.getStackTraceString());
        }
        return returnValue;
    }
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

    public class UtenZaDealer {
        @AuraEnabled public Id idCase {get;set;}
        @AuraEnabled public String regionSociale {get;set;}
        @AuraEnabled public String codiceOcs {get;set;}
        @AuraEnabled public String tipo {get;set;}
        @AuraEnabled public String stato {get;set;}
        @AuraEnabled public String codiceFiscale {get;set;}
        @AuraEnabled public String comune {get;set;}
        @AuraEnabled public String province {get;set;}

        public UtenZaDealer(Id idCase, String regionSociale, String codiceOcs,String tipo, String stato,String codiceFiscale, String comune, String province  ){
                           this.idCase = idCase;
                           this.regionSociale = regionSociale;
                           this.codiceOcs = codiceOcs;
                           this.tipo = tipo;
                           this.stato = stato;
                           this.codiceFiscale = codiceFiscale;
                           this.comune = comune;
                           this.province = province; 
                           

        }

    }
}