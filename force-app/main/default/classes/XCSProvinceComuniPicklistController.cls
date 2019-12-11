public class XCSProvinceComuniPicklistController {
    

    @AuraEnabled
    public static String getProvinciaByAccountContact(Id recordId) { //, Boolean isDatiNascita
        String objName=recordId.getSobjectType().getDescribe().getName();
        String s='';
        //if(!isDatiNascita){
            if(objName=='Account'){
                Account acc=[SELECT Id, ShippingState, ShippingCity from Account where id=:recordId];
                s=JSON.Serialize(acc); 
            } else if(objName=='Contact'){
                Contact co=[SELECT Id, MailingState, MailingCity from Contact where id=:recordId];
                s=JSON.Serialize(co);            
            }
        /*} else {
            if(objName=='Account'){
                Account acc=[SELECT Id, Birthprovince__c, Birthcity__c from Account where id=:recordId];
                s=JSON.Serialize(acc); 
            } else if(objName=='Contact'){
                Contact co=[SELECT Id, Luogo_Nascita__c, Provincia_Nascita__c from Contact where id=:recordId];
                s=JSON.Serialize(co);            
            }            
        }*/
        System.debug(s);
        return s;
        //List<aggregateresult> province = [select Provincia__c,Provincia_Desc__c from XCS_Town__c group by Provincia__c,Provincia_Desc__c  ORDER BY Provincia_Desc__c];
    }
    
    //Boris Inizio
    @AuraEnabled
    public static String getProvinceCitta() {
        List<aggregateresult> province = [select Provincia__c,Provincia_Desc__c from XCS_Town__c WHERE Catastale__c!=null AND IsSelectable__c=true group by Provincia__c,Provincia_Desc__c  ORDER BY Provincia_Desc__c];
		List<ProvinciaCitta> listaPC = new List<ProvinciaCitta>();
        for(integer i=0; i<province.size();i++){
            ProvinciaCitta pc = new ProvinciaCitta(province[i].get('Provincia__c')+'', province[i].get('Provincia_Desc__c')+'', null);
       		listaPc.add(pc);
        }
        return  Json.serialize(listaPC);
    } 
    
    @AuraEnabled
    public static String getCittaFromEvent(String provincia){ //I campi della query non li ho modificati, se occorre, aggiungere o togliere        
        XCS_Town__c[] towns = [SELECT Id,Comune__c, CAP__c FROM XCS_Town__c WHERE Catastale__c!=null AND IsSelectable__c=true AND Provincia__c=:provincia  ORDER BY Comune__c]; 
        return Json.serialize(towns);
    }
    //Fine Boris
    
	
    //Inner Class //Boris
    public class ProvinciaCitta implements Comparable{
        public String identificativo{public get; public set;}
        public String provincia{public get; public set;}
        public List<XCS_Town__c> citta{public get; public set;}
        
        public ProvinciaCitta(){
            identificativo = '';
            provincia = '';
            citta= new List<XCS_Town__c>();
        }
        
        public ProvinciaCitta(String identificativo, String provincia, List<XCS_Town__c> citta){
           this.identificativo = identificativo;
           this.provincia = provincia;
           this.citta = citta == null ? new List<XCS_Town__c>() : citta;
         
        }
        
        public Integer compareTo(Object obj){
            ProvinciaCitta temp = (ProvinciaCitta) obj;
            return this.provincia.compareTo(provincia);
        }
    }
    
}