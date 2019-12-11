public class SaldiRossiWrapper {
    
    public List<OCSRecuperaSaldiRossiOngoingResponse.SaldoRossoOngoingDTO> objSaldoRossoToPV {get;set;}
    public List<OCSRecuperaSaldiRossiCarteAttiveResponse.SaldoRossoOngoingDTO> objSaldoRossoCAToPV {get;set;}
    
    public SaldiRossiWrapper() {
       objSaldoRossoToPV = new List<OCSRecuperaSaldiRossiOngoingResponse.SaldoRossoOngoingDTO>();
       objSaldoRossoCAToPV = new List<OCSRecuperaSaldiRossiCarteAttiveResponse.SaldoRossoOngoingDTO>(); 
    }

}