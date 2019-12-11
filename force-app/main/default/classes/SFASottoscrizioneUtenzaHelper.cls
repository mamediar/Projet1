public class SFASottoscrizioneUtenzaHelper {
 
    private final static String templateAddendumProposta = 'add_intese_prop';
    private final static String templateAddendumAccettazione = 'add_intese';

    private final static Map<String, String> nomiPDF = new Map<String, String>{templateAddendumProposta => 'Addendum Proposta GDO',templateAddendumAccettazione => 'Addendum Accettazione GDO'};

    public SFASottoscrizioneUtenzaHelper() {

    }

    public class PDF {
        @AuraEnabled
        public String base64;
        @AuraEnabled
        public String name;
        public PDF(){}
    }


    private static PDF getPDF(String template, ParamFiller filler) {
        PDF pdf = new PDF();
        pdf.name = nomiPDF.get(template);       
        OCSDcCreaDocumentoResponse response = OCSDcCreaDocumentoInvoker.callDcCreaDocumento(template, filler);
        if(response.isOK()){
            if(response.dcCreaDocumentoResponse.documentoGenerato!=null){
               pdf.base64 = response.dcCreaDocumentoResponse.documentoGenerato[0].stream;
            } else {
                pdf.base64 = ''; //nel caso il base64 non sia stato recuperato, restituisco il nome dell'intesa con il base64 a vuoto
            }
        } else {
             pdf.base64 = ''; //nel caso di errore del servizio, restituisco il nome dell'intesa con il base64 a vuoto
        }  
        return pdf;     
    }



     private class SottoscrizioneUtenzaFiller extends ParamFiller{
        Account acc;
        
        public SottoscrizioneUtenzaFiller( Account acc )
        { 
            this.acc = acc;
        }
        
        public override List<Parametro> getParams(){
            
            List<Parametro> paramsList =new List<Parametro>();
            
            //citta residenza convenzionato:
            Parametro param1=new Parametro();
            param1.valore=acc.ShippingCity;
            param1.variabile='$citta_conv';
            paramsList.add(param1);

            //Data Convenzionamento:
            DateTime now = DateTime.now();
            String dataAttuale = DateUtils.formatDateDDslashMMslashYYYY(now);
            Parametro param2=new Parametro();
            param2.valore=dataAttuale;
            param2.variabile='$data_conv';
            paramsList.add(param2);
                                        
            //codice OCS Convenzionato:
            Parametro param3=new Parametro();
            String paramOcsExt = (acc.OCS_External_Id__c!=null && acc.OCS_External_Id__c.length()>0) ? acc.OCS_External_Id__c.Substring(0) : '';
            param3.valore=paramOcsExt;
            param3.variabile='$cod_ocs_conv';
            paramsList.add(param3);
            
            //Ragione sociale Convenzionato:
            Parametro param4=new Parametro();
            param4.valore=acc.Name;
            param4.variabile='$nome_conv';
            paramsList.add(param4);
            
            //Indirizzo:
            Parametro param5=new Parametro();
            String street = acc.BillingStreet==null?'':acc.BillingStreet;
            String postacode = acc.ShippingPostalCode==null?'':acc.ShippingPostalCode;
            String city = acc.ShippingCity==null?'':acc.ShippingCity;
            String state = acc.BillingState==null?'':acc.BillingState;
            param5.valore=street  + ' - ' + postacode + ' - ' + city + ' - ' + state;
            param5.variabile='$ind_conv';
            paramsList.add(param5);

            String nomeAbbreviato = '';

            if (acc.CodiceAgente__c != null) {
                List<SFA_Convenzionam_CanaleAgenti__mdt> lstCanaleAgenti = 
                    [SELECT Id, DeveloperName, Language, Canale__c, tipo_quest__c, nome_abbr__c, Codice_agente__c, Label 
                    FROM SFA_Convenzionam_CanaleAgenti__mdt
                    WHERE Codice_agente__c = :acc.CodiceAgente__c];
                
                if (lstCanaleAgenti.size() > 0) {
                    nomeAbbreviato = lstCanaleAgenti[0].nome_abbr__c;
                }
            }

            //Nome abbreviato:
            Parametro param6=new Parametro();
            param6.valore=nomeAbbreviato;
            param6.variabile='$nome_abb_conv';
            paramsList.add(param6);
            
            return paramsList;
        }   
    }


    @AuraEnabled
    public static PDF getPDFAddendumPropostaGDO(String delearId) {
        Account acc = [SELECT ID,ShippingCity,OCS_External_Id__c,Name, ShippingPostalCode,ShippingStreet,ShippingState,CodiceAgente__c,BillingStreet,BillingState FROM Account WHERE Id =:delearId];
        SottoscrizioneUtenzaFiller filler = new SottoscrizioneUtenzaFiller(acc);
        PDF pdf = getPDF(templateAddendumProposta,filler);
        return pdf;
    }

    @AuraEnabled
    public static PDF getPDFAddendumAccettazioneGDO(String delearId) {
        Account acc = [SELECT ID,ShippingCity,OCS_External_Id__c,Name, ShippingPostalCode,ShippingStreet,ShippingState,CodiceAgente__c,BillingStreet,BillingState FROM Account WHERE Id =:delearId];
        SottoscrizioneUtenzaFiller filler = new SottoscrizioneUtenzaFiller(acc);
        PDF pdf = getPDF(templateAddendumAccettazione,filler);
        return pdf;
    }

    @AuraEnabled
    public static String getBase64PDFElencoIncaricati(String IdCase) {

        String bodyBase64 = '';
     	PageReference pdf = Page.SFAElencoIncaricatiPDF;
   		pdf.getParameters().put('IdCase', idCase);
    	pdf.setRedirect(true);
        if (!test.isRunningTest()){
  		    Blob pageContent = pdf.getContent();         
            System.debug('body:'+pageContent);
            bodyBase64 = EncodingUtil.base64Encode(pageContent);
        }
        return bodyBase64;
            
    }
    

}