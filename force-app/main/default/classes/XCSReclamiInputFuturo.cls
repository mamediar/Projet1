public class XCSReclamiInputFuturo extends XCSReclamiInput{
    @AuraEnabled
    public OCSPraticaFuturo praticaSelezionataContainer;
    
    public OCSPraticaFuturo getPratica(){
        return this.praticaSelezionataContainer;
    }
    
    public List<Map<String,String>> getPacchettiAssicurativi(){
        return null;
    }
    
    public OCSCliente getCliente(){ 
        return this.clienteSelezionatoContainer;
    }
    
    public XCSReclamiDettagliOutputDTO getDettagliOutput(){
        return this.dettagliOutputObj; 
    }
    
    public List<XCS_Mittente__c> getMittenti(){
        return this.mittentiList;
    }
    
    public List<Attachment> getFiles(){
        return this.fileList;
    }
     
   public Boolean isSconosciuto(){
        return this.isSconosciuto != null ? Boolean.valueOf(this.isSconosciuto) : false ;
    }

}