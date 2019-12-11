public class OCSInviaSMSInvoker {
    
    /*public static OCSInviaSMSResponse inviaSMS (String tipo,string numero,string emettitore,string pan,string testo)
{        
OCSInviaSMSRequest req = new OCSInviaSMSRequest();
req.serviceId = 'inviaSMS';
req.inviaSMSRequest.tipo = tipo;
req.inviaSMSRequest.numero = numero ;
req.inviaSMSRequest.emettitore = emettitore ;
req.inviaSMSRequest.pan = pan;
req.inviaSMSRequest.testo = testo;


return (OCSInviaSMSResponse)ApiUtils.callApi
('ocs.inviaSMS',req, OCSInviaSMSResponse.class );

}

*/
    
    public static void inviaSMS (String tipo,string numero,string emettitore,string pan,string testo)
    {        
        //ID rt = [Select id from RecordType where DeveloperName = 'SMS' and SobjectType = 'XCS_Messaggio__c' ].id;      
        tipo = (tipo == null || ''.equals(tipo) ? 'WEB2' : '');
        ID rt = RecordtypeUtil.getRecordType(RecordtypeUtil.XCSMESSAGGIO,RecordtypeUtil.SMS);
        XCS_Messaggio__c m = new XCS_Messaggio__c();
        m.Testo__c = testo;
        m.CompanyType__c = 'COMPASS';
        m.Pan__c = pan; 
        m.Emettitore__c = emettitore;
        m.Numero__c = numero;
        m.Tipo__c = tipo;
        m.RecordTypeid = rt;
        
        insert m;   
    }
    
    public static XCS_Messaggio__c createSMSMessage(String strCellPhone, String strBody) {
        
        final String TIPO_WEB2 = 'WEB2';
        final String EMPTY_STRING = '';       
        ID recordTypeID = RecordtypeUtil.getRecordType(RecordtypeUtil.XCSMESSAGGIO,RecordtypeUtil.SMS);
        
        XCS_Messaggio__c objSMS = new XCS_Messaggio__c();
        objSMS.Testo__c = strBody;
        objSMS.CompanyType__c = 'COMPASS';
        objSMS.Pan__c = EMPTY_STRING; 
        objSMS.Emettitore__c = EMPTY_STRING;
        objSMS.Numero__c = strCellPhone;
        objSMS.Tipo__c = TIPO_WEB2;
        objSMS.RecordTypeid = recordTypeID;
        
        return objSMS;
        
    }

        public static void inviaSMS (String tipo,String numero,String testo, String codCliente)
    {        
        //ID rt = [Select id from RecordType where DeveloperName = 'SMS' and SobjectType = 'XCS_Messaggio__c' ].id;      
        tipo = (tipo == null || ''.equals(tipo) ? 'WEB2' : '');
        ID rt = RecordtypeUtil.getRecordType(RecordtypeUtil.XCSMESSAGGIO,RecordtypeUtil.SMS);
        XCS_Messaggio__c m = new XCS_Messaggio__c();
        m.Testo__c = testo;
        m.CompanyType__c = 'COMPASS';
        numero = numero.replaceAll('\\s','');
        m.Numero__c = numero;
        m.Tipo__c = tipo;
        m.RecordTypeid = rt;
        m.CodCliente__c = codCliente;
        
        insert m;
    }
    
}