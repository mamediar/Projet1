public class OCSRecuperaPraticheAssicurateRequest extends OCSRequest{
    
    
    public OCSRecuperaPraticheAssicurateRequest(String numPratica, String codCliente,
                                                String cognomeCliente, String nomeCliente, String codFiscaleCliente, String dataNascitaCliente,
                                                String ragioneSociale, String pan)
    {
        serviceID = 'recuperaPraticheAssicurate';
        this.numPratica = numPratica;
        this.codCliente = codCliente;
        this.cognomeCliente = cognomeCliente;
        this.nomeCliente = nomeCliente;
        this.dataNascitaCliente = dataNascitaCliente;
        this.codFiscaleCliente = codFiscaleCliente; 
        this.ragioneSociale = ragioneSociale;
        this.pan = pan;
        
    }
    
    
    String numPratica;
    String codCliente;
    String cognomeCliente;
    String nomeCliente;
    String dataNascitaCliente;
    String codFiscaleCliente;
    String ragioneSociale;
    String pan;
    

}