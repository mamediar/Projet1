public class ProVerificaLotto 
{
  	@invocableMethod
	public static list<OcsSearchResult> ricercaPresenzaLotto (String[] Barcode)
    {         
       	OcsSearchResult res = new OcsSearchResult() ;
        System.debug('HOLA' + Barcode);
        String numPratica =  Barcode[0].substring(2) ;
        String procedura = Barcode[0].substring(0,2) ;
        System.debug(numPratica);
        System.debug(procedura);
        while(numPratica.substring(0,1) == '0')
        {
        	numPratica = numPratica.substring(1);
		}
        OCSRicercaPresenzaLottoResponse pratica = OCSRicercaPresenzaLottoInvoker.ricercaPresenzaLotto(numPratica,procedura);
     	res.isOk = pratica.isOK() ;
        res.isLottoFound = pratica.isFound() ;
        list<OcsSearchResult> lRes = new list<OcsSearchResult>();
        lRes.add(res);
        return lRes ;
    }
     public class OcsSearchResult
     {
        @invocablevariable
        public boolean isOk;
        @invocablevariable
        public String message;
        @invocablevariable
        public boolean isLottoFound;
	}
}