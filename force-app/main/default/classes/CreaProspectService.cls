/**
*@Author Madicke BALDE
*@description class service for CreaProspect
*@version 1.0
*@uses
*@code
 */
public  class CreaProspectService {

  public static  Map<String, Object> returnValueMap = new Map<String, Object>();
    /*
    *@Auhtor Madicke BALDE  
    *@description 
    *@param Case : c
    *@param Account acc
    *@param Products
     */
    public static void gestatoRequestOnline(Case c, Account acc, Product2 p, String idCRM){
      System.debug('############ subject'+c.Subject);
        Case cp = new Case();
        try {
              createCaseDs(c, p, acc, idCRM);
              createCaseDSP( c,p,acc);
              createCaseEcom(c,p,acc);
              System.debug('************** returnValueMap '+returnValueMap);
        } catch (Exception e) {
              System.debug(' ***************** error'+e.getCause());
              System.debug(' ***************** error'+e.getStackTraceString());
        }
    }
    /*
    *@Author Madicke BALDE 
    *@description create case whith product type DS
    *@param Case c
    *@param Product2 p
    @return void
    */
    public static void createCaseDs(Case c, Product2 p, Account acc, String idCRM){
          Case cp = new Case(); 
          System.debug('cId '+c.Id + 'p.Id'+p.Id +' p.Family'+ p.Family);

          if(c.Id != null && p.Family =='PP_ONLINE_COMPASS_DS' )  {
              Case cold = [SELECT Id, Status FROM Case WHERE Id=:c.Id];
              System.debug('################# status '+c.Status);
              System.debug('**************** Update DS Case ******************* ');
               System.debug('**************** Update DS Case  AccountId ******************* '+c.AccountId);
              if(cold.Status == 'Closed' && String.isNotEmpty(idCRM)){
                  System.debug('################## re Open Case');
                  Group gr = [ select Id  from Group  where Type = 'Queue' AND DeveloperName = 'Q525'   ];
                  if(gr.Id != null){
                       c.OwnerId = gr.Id;
                  }
                  c.Status = 'Ricevuto';
                  CaseService.caseToUpdate(c, p);
                  returnValueMap.put('case', c);
          } 
          else if(c.Status == 'Closed' && String.isEmpty(idCRM)){
            System.debug('########### creating new Case ');
                c.Id= null;
                c.Status = 'Ricevuto';
               // c.CaseNumber = null;
                saveCase(c,p);
                returnValueMap.put('case', c);
          }
          else {
                CaseService.caseToUpdate(c, p);
                returnValueMap.put('case', c);
          }

            return;
          }
          if(c.Id != null || p.Id == null || p.Family != 'PP_ONLINE_COMPASS_DS'){
              System.debug('No DS');
              return;
          }
          cp =  controleCase(p.Id, acc.Codice_Cliente__c, acc.Codice_Fiscale__c);
          System.debug('********** cp '+cp);
          System.debug(' *********** cp.Id'+cp.Id);
          if(cp.id != null) {
          Map<String,Object> returnValue  =  search_Link_Boza(cp);
          System.debug(' ************* returnValue '+returnValue);
          for(String key : returnValue.keySet()){
          returnValueMap.put(key, returnValue.get(key));
          }
          } 
          else {
          saveCase(c,p);
          System.debug('************** save Case '+ c);
          returnValueMap.put('case', c);
          }
    } 
    /*
    *@Author Madicke BALDE 
    *@description create case whith product type DSP
    *@param Case c
    *@param Product2 p
    @return void
    */
     public static void createCaseDSP(Case c, Product2 p, Account acc){
        Case cp = new Case();
        if(c.Id != null && p.Family == 'PP_ONLINE_PARTNER_DS')  {
          System.debug('**************** Update DSP Case ******************* ');
                         
                           CaseService.caseToUpdate(c, p);          
                           returnValueMap.put('case', c);
                           return;
              }
        if(c.Id != null || p.Id == null || p.Family != 'PP_ONLINE_PARTNER_DS'){
            System.debug('No DSP');
            return;
        }
        cp =  controleCase(p.Id, acc.Codice_Cliente__c, acc.Codice_Fiscale__c);
        System.debug('###################### cp found '+cp);
        if(cp.id != null) {
          Map<String,Object> returnValue  =  search_Link_Boza(cp);
          System.debug(' ************* returnValue DSP '+returnValue);
          for(String key : returnValue.keySet()){
              returnValueMap.put(key, returnValue.get(key));
          }
        } 
       else {
            saveCase(c,p);
            System.debug('************** save Case '+ c);
            returnValueMap.put('case', c);
          }
    }
    /*
    *@Author Madicke BALDE 
    *@description create case whith product type ECOM
    *@param Case c
    *@param Product2 p
    @return void
    */
     public static void createCaseEcom(Case c, Product2 p, Account acc){
       if(c.Id != null && p.Family == 'PF_ECOMMERCE_STANDARD')  {
          System.debug('**************** Update ECOM Case ******************* ');
                          // CaseService.UpdateCase(c);
                           CaseService.caseToUpdate(c, p);
                          // CaseService.UpdateCase(c);
                           returnValueMap.put('case', c);
                           return;
              }

        if(c.Id != null || p.Id == null || p.Family != 'PF_ECOMMERCE_STANDARD'){
            System.debug('No Ecom');
            return;
        }
     
      saveCase(c,p);
      returnValueMap.put('case', c);
    }
     /**
     *@Author Madicke BALDE 
     *@description 
     *@param productId : Id product2
     @param codiceCliente : codice client
     @param codiceFiscale : codice fiscale
     @return Case
     */
     public static Case controleCase(ID productId, String codiceCliente, String codiceFiscale){
       System.debug('****************  productId '+productId + ' codiceCliente '+codiceCliente +' codiceFiscale '+codiceFiscale);
            Case c = new Case();
        try {
        
           List<Case> casesList = CaseService.getCaseByCCCF(codiceCliente, codiceFiscale);
           System.debug(' ************* '+casesList.size());
            if( casesList.size() > 0){
                 for(Case ca: casesList){
                            Integer numberOfDay = (system.today()).daysBetween(Date.valueOf(ca.CreatedDate));
                            if(numberOfDay < 30 && ca.Status != 'chiuso' && ca.Product__c == productId){
                                        System.debug('test serarchRichieste');
                                      c = ca;
                                      break;
                             }
                             
                    }   
            } 
          
        } catch (Exception e) {
            System.debug(' ************** **** preventiveControle '+e.getMessage());
            System.debug(' ************** **** preventiveControle '+e.getStackTraceString());
        }
        return c;

    }
  /**
  *@Author Madicke BALDE 
  *@description search link bozza in Case
  @param Link bozza in Case
  */
  public static Map<String,Object> search_Link_Boza(Case c){
      System.debug('*************** search_Link_Boza');
      ResponseWrapper res = new ResponseWrapper();
      Map<String, Object> returnValue = new Map<String, Object>();
      System.debug('################ Link '+c.RO_Link_Bozza__c);
       if(String.isNotEmpty(c.RO_Link_Bozza__c) ){
            returnValue.put('codiceCliente', c.Codice_Cliente__c);
            returnValue.put('codeErreur', 9);
        }
        else {
          returnValue.put('caseId', c);
         // res.caseId = c.Id;
        }
       System.debug('**************** test *********************' + returnValue);
       return returnValue; 
  }
  /*
  *@Author Madicke BALDE
  *@description 
  *@param Case 
  *@param p : Product2
  */
	public static void saveCase(Case c, Product2 p){
    System.debug('********************* saveCase');
          Group g = CaseService.getQueue('Q525');
           try {
               if(g.Id !=null){
             System.debug('********************* Group '+g);
                        c.OwnerId = g.Id;
                        c = CaseService.createCase(c);
              }
               RO_CRMRich_online_steplog__c log = RichOnlineSteplogService.createCrmOnlineStepLog(c);
               if(p.Family == 'PP_ONLINE_COMPASS_DS')
               RO_CRMRich_online_prescoring__c logprescoring = RichOnlinePrescoringService.createCrmOnlinePrescoring(c); 
            
           } catch (Exception e) {
             System.debug('************ saveCase Error'+e.getMessage());
             System.debug('************ saveCase '+e.getStackTraceString());
           }
        
            
          }  

public class ResponseWrapper {
 public String codiceCliente;
 public Integer codeErreur;
 public Id caseId;

}

	

/**	private Case controleCase(Object Id, Object Codice_Cliente__c, Object Codice_Fiscale__c){
		return null;
	}  */
}