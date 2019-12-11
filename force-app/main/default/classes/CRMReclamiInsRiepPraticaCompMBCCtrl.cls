public class CRMReclamiInsRiepPraticaCompMBCCtrl {
	@AuraEnabled
    public static Account getConvenzionato(String codCliente){
        codCliente='D'+codCliente;
        Account[] resList=[select Name,ShippingStreet, ShippingCity, ShippingPostalCode, ShippingCountry,OCS_External_Id__c
                          from Account
                          where RecordType.Name='dealer' and OCS_External_Id__c=:codCliente];
        System.debug('CRMReclamiInsRiepPraticaCompMBCCtrl  getConvenzionato resList '+ resList );
        return resList.size()>0?resList[0]:new Account();
    }
    
   @AuraEnabled 
   public static String GetNomeFiliale (String filiale)
   {
       String FName ='';
       if(filiale!='' && filiale!=null)
       {    
      	 	Integer num_filiale = Integer.valueOf(filiale);
            String filialeDN = 'F'+num_filiale ;
       		FName = [Select Name from Account where OCS_External_id__c = :filialeDN].Name;
       }
       system.debug('NOMEFILIALE::: '+FName);
       return FName;
   }
}