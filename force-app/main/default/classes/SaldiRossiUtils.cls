public class SaldiRossiUtils {
    
    public static final String ROW_TYPE_HEADER = 'TE';
    public static final String ROW_TYPE_DETAIL = 'DE';
    public static final String COMPENSATION_TYPE_EXPENSE = 'SP';
    public static final String COMPENSATION_TYPE_UNSOLVED = 'IN';
    public static final String PAYMENT_METHOD_RID = 'RI';
    public static final String PAYMENT_METHOD_BP = 'BP';
    public static final String CATEGORY_1757 = '1757';
   
    public static List<SaldiRossiWrapper> preparePVRequests(List<OCSRecuperaSaldiRossiOngoingResponse.SaldoRossoOngoingDTO> saldiRossiOngoingJson) {
        
        List<SaldiRossiWrapper> lista = new List<SaldiRossiWrapper>();
        List<OCSRecuperaSaldiRossiOngoingResponse.SaldoRossoOngoingDTO> lista2 = new List<OCSRecuperaSaldiRossiOngoingResponse.SaldoRossoOngoingDTO>();
        for (OCSRecuperaSaldiRossiOngoingResponse.SaldoRossoOngoingDTO saldoRosso : saldiRossiOngoingJson) {
            if (ROW_TYPE_DETAIL.equalsIgnoreCase(saldoRosso.tipoRecord)) {
                lista2.add(saldoRosso);
            } else {
                lista2.add(saldoRosso);
                SaldiRossiWrapper srw = new SaldiRossiWrapper();
                srw.objSaldoRossoToPV.addAll(lista2);
                lista.add(srw);
                lista2.clear();
            }
         }
        
        return lista;
    }
    
    public static List<SaldiRossiWrapper> preparePVRequests(List<OCSRecuperaSaldiRossiCarteAttiveResponse.SaldoRossoOngoingDTO> saldiRossiOngoingJson) {
        
        List<SaldiRossiWrapper> lista = new List<SaldiRossiWrapper>();
        List<OCSRecuperaSaldiRossiCarteAttiveResponse.SaldoRossoOngoingDTO> lista2 = new List<OCSRecuperaSaldiRossiCarteAttiveResponse.SaldoRossoOngoingDTO>();
        for (OCSRecuperaSaldiRossiCarteAttiveResponse.SaldoRossoOngoingDTO saldoRosso : saldiRossiOngoingJson) {
            if (ROW_TYPE_DETAIL.equalsIgnoreCase(saldoRosso.tipoRecord)) {
                lista2.add(saldoRosso);
            } else {
                lista2.add(saldoRosso);
                SaldiRossiWrapper srw = new SaldiRossiWrapper();
                srw.objSaldoRossoCAToPV.addAll(lista2);
                lista.add(srw);
                lista2.clear();
            }
         }
        
        return lista;
    }
    

}