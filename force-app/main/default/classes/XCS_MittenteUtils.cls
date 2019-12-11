public class XCS_MittenteUtils {
    public static XCS_Mittente__c makeMittente(OCSCliente c){
        XCS_Mittente__c res=new XCS_Mittente__c();
        res.Name__c=c.nome+' '+c.cognome;
        res.Via__c=c.indirizzo;
        res.Citta__c=c.localita;
        res.Provincia__c=c.provincia;
        res.Codice_Postale__c=c.cap;
        res.Principale__c=false;
        res.Autorita__c=false;
        res.Predefinito__c=false;
        System.debug('XCS_MittenteUtils makeMittente res: '+res);
        return res;
    } 
    public static XCS_Mittente__c makeMittentePrincipale(OCSCliente c){
        XCS_Mittente__c res=new XCS_Mittente__c();
        res.Name__c=c.nome+' '+c.cognome;
        res.Via__c=c.indirizzo;
        res.Citta__c=c.localita;
        res.Provincia__c=c.provincia;
        res.Codice_Postale__c=c.cap;
        res.Principale__c=true;
        res.Autorita__c=false;
        res.Predefinito__c=false;
        System.debug('XCS_MittenteUtils makeMittente res: '+res);
        return res;
    }
    
    
    public static XCS_Mittente__c makeMittente(Boolean da, String tipo,Boolean autorita,String nomeCognomeMittente,String indirizzoMittente,String cittaMittente,String provinciaMittente,String capMittente, String saluti){
        XCS_Mittente__c res=new XCS_Mittente__c();
        res.Principale__c=da!=null?da:false;
        res.Tipologia__c=tipo;
        res.Autorita__c=autorita;
        res.Name__c=nomeCognomeMittente;
        res.Citta__c=cittaMittente;
        res.Via__c=indirizzoMittente;
        res.Provincia__c=provinciaMittente;
        res.Codice_Postale__c=capMittente;
        res.Salutation__c = saluti;
        System.debug('XCS_MittenteUtils makeMittente res: '+res);
        return res;
    }
    
    public static XCS_Mittente__c makeMittente(mittenti__mdt m){
        XCS_Mittente__c res=new XCS_Mittente__c();
        res.Name__c=m.First_Name__c+' '+m.Last_Name__c;
        res.Email__c=m.Email__c;
        res.Principale__c=false;
        res.Autorita__c=false;
        res.Predefinito__c=false;
        return res;
    }
    
    public static XCS_Mittente__c makeMittentePrincipale(mittenti__mdt m){
        XCS_Mittente__c res=new XCS_Mittente__c();
        res.Name__c=m.First_Name__c+' '+m.Last_Name__c;
        res.Email__c=m.Email__c;
        res.Principale__c=true;
        res.Autorita__c=false;
        res.Predefinito__c=false;
        return res;
    }
    
    public static XCS_Mittente__c makeMittente(indirizzi_predefiniti__mdt ip,Boolean principale){
        XCS_Mittente__c res=new XCS_Mittente__c();
        res.Tipologia__c='INDIRIZZI PREDEFINITI';
        res.Name__c=ip.Name__c;
        res.Salutation__c=ip.Saluto__c;
        res.Via__c=ip.Indirizzo__c;
        res.Principale__c=principale!=null?principale:false;
        res.Autorita__c=false;
        res.Predefinito__c=true;
        res.Citta__c=ip.Citta__c;
        res.Provincia__c=ip.Provincia__c;
        res.Codice_Postale__c=ip.Cap__c;
        return res;
    }
    
    public static XCS_Mittente__c[] makeMittenti(List<OCSCliente> data){
        List<XCS_Mittente__c> res=new List<XCS_Mittente__c>();
        for(OCSCliente c:data){
            res.add(makeMittente(c));
        }
        return res;
    }
    public static XCS_Mittente__c[] makeMittentiPR(List<OCSCliente> data){
        List<XCS_Mittente__c> res=new List<XCS_Mittente__c>();
        for(OCSCliente c:data){
            res.add(makeMittentePrincipale(c));
        }
        return res;
    }
}