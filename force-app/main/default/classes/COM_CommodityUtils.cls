/** Author:       Orlando S.
 *  Descrizione:  Classe di Utility: Commodity Process
 *  Scope:        Contiene tutti i metodi di Utility per le Commodity
 * 
 * */
public without sharing class COM_CommodityUtils 
{
    //Method1: Retrive RecordtypeCase
    public static Id getCaseRecordTypeId( String RecordtypeName ) 
    {
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(RecordtypeName).getRecordTypeId();
        return RecordTypeId;
    }
    //Method2: Retrive RecordtypeAccount
    public static Id getAccountRecordTypeId( String RecordtypeName )
    {
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(RecordtypeName).getRecordTypeId();
        return recordTypeId;
    }
    //Method4: Retrive RecordtypeRisposte
    public static Id getRisposteRecordTypeId( String RecordtypeName ) 
    {
        Id recordTypeId = Schema.SObjectType.Risposte__c.getRecordTypeInfosByName().get(RecordtypeName).getRecordTypeId();
        return RecordTypeId;
    }
    
    //Method3: Insert Case for Filiali
    public static void InsertCaseFiliali( String RecordTypeName , ID IDFiliale  , ID IDCliente   , ID IDIntervista , 
                                          String ActivityType   , String Status , String Step_PV , String Urgente , 
                                          String SottoCategoria , String NumeroPratica , String CodiceCliente ,
                                          String Note , ID IDCategoriaDiRiferimento , AssignmentRule AssignmentRuleIstance )
    {
           Case CaseFiliale                        = new Case();
           CaseFiliale.RecordTypeId                = getCaseRecordTypeId(RecordTypeName);
           CaseFiliale.Branch__c                   = IDFiliale;
           CaseFiliale.AccountId                   = IDCliente;
           CaseFiliale.Intervista__c               = IDIntervista;
           CaseFiliale.ActivityType__c             = ActivityType;
           CaseFiliale.Status                      = Status;
           CaseFiliale.Step_PV__c                  = Step_PV;
           CaseFiliale.Urgente__c                  = Urgente;
          //CaseFiliale.Sottocategoria__c          = SottoCategoria;
           CaseFiliale.NumeroPratica__c            = NumeroPratica;
           CaseFiliale.Codice_Cliente__c           = CodiceCliente;
           CaseFiliale.Note__c                     = Note;
           CaseFiliale.Categoria_Riferimento__c    = IDCategoriaDiRiferimento;
           if( AssignmentRuleIstance != null )
           {
               Database.DMLOptions dmlOpts                     = new Database.DMLOptions();
               dmlOpts.assignmentRuleHeader.assignmentRuleId   = AssignmentRuleIstance.Id;
               CaseFiliale.setOptions(dmlOpts);
           }
           
           INSERT CaseFiliale;
       
          
    }
    //Method4: Get picklist value for an Object
    public static List<String> getPicklistValueSObject( String objectName, String field_apiname,Boolean nullRequired )
    {
                  List<String> optionlist                    = new List<String>();
        
                  Map<String,Schema.SObjectType> gd          = Schema.getGlobalDescribe(); 
                  Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap(); 
                  List<Schema.PicklistEntry> picklistValues  = field_map.get(field_apiname).getDescribe().getPickListValues();
        
                  if( nullRequired == true ){
                       optionlist.add('--None--');
                  }
        
                  for( Schema.PicklistEntry pv : picklistValues ) 
                  {
                       optionlist.add(pv.getValue());
                  }
        
                  return optionlist;
    }
   
}