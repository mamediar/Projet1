/**
    *@author Mame bousso    
    *@date 2019/08/19
    *@description the query of Appuntamento lista filiale
    */
public class AppuntamentoListaFilialiQuery {
    
     public static list<Account> getLisFiliale(){
         //accnt.,accnt.,accnt.,accnt.,accnt.FirstName,accnt.Provincia_Nascita__pc,accnt.Phone));
     	list<Account> accounts= [select Id, LastName, FirstName, BillingStreet, PersonMailingCity, Codice_Fiscale__c, Luogo_Nascita__pc,  
                                 			Address_Abbr_Sms__c, Provincia_Nascita__pc, Phone from Account where RecordType.Name='Branch'];
     	return accounts;
     }
}