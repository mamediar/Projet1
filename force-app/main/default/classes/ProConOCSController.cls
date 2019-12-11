public class ProConOCSController 
{
    @invocableMethod
	public static list<OcsSearchResult> ricercaStatoPratica (String[] Barcode)
    {         
       	OcsSearchResult res = new OcsSearchResult();
        system.debug(Barcode);
        String numPratica =  Barcode[0].substring(2) ;
        while(numPratica.substring(0,1) == '0')
        {
        	numPratica = numPratica.substring(1);
		}
        OCSRicercaStatoPraticaResponse pratica = OCSRicercaStatoPraticaInvoker.ricercaStatoPratica(numPratica);
        system.debug(pratica);
        res.isOK = pratica.isOK();
        res.isPraticaFound = pratica.isFound();
        res.message = pratica.resultMessage;
       	list<OcsSearchResult> reslist = new list<OcsSearchResult>();
        reslist.add(res);
        return reslist;
    }
	
    public class OcsSearchResult{
        @invocablevariable
        public boolean isOk;
        @invocablevariable
        public String message;
        @invocablevariable
        public boolean isPraticaFound;
	}
}