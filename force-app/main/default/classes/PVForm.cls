/**
 * @File Name          : PVForm.cls
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 22/10/2019, 18:42:53
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    4/7/2019, 09:17:03   Andrea Vanelli     Initial Version
**/
public abstract class PVForm {
    

    public class UserData {
        @AuraEnabled
        public User user{get; set;}
        @AuraEnabled
        public Account accountOffice{get; set;}
        @AuraEnabled
        public String codiceFiliale{get; set;}
        @AuraEnabled
        public Boolean isAbilitatoGestione{get; set;}


    }
	@AuraEnabled
    public UserData userData{get; set;}
    
    @AuraEnabled
    public String note{get;set;}
    @AuraEnabled
    public String urgente{get;set;}
    @AuraEnabled    
    public String motivazione{get;set;} // reason testo libero
    
    @AuraEnabled public OCSCliente cliente {get;set;}
    @AuraEnabled public OCSPratica pratica {get; set;}
    
    @AuraEnabled public XCS_Categoria__c categoriaPV{get;set;}
    @AuraEnabled public PostvenditaConfig_subtype__mdt sottotipologiaMdt{get;set;}
    @AuraEnabled public PostvenditaConfig_reason__mdt reasonMdt{get;set;}    
    @AuraEnabled
    public List<Attachment> attachmentList{get;set;}
    @AuraEnabled
    public List<Id> attachmentsIDs{get;set;}
    @AuraEnabled
    public Id parentId{get;set;}
    @AuraEnabled public Boolean isCheckFax{get;set;}
    
    // solo per la gestione
    @AuraEnabled
    public String newStatus{get;set;}

}