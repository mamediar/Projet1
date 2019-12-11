//----------------------------------------------------------------------
//-- - Class Name   : OCSVariazioneDatiPagamentoInvoker
//-- - Autor        : Fabio Giuliani (LYNX)
//-- - Date         : 12/07/2019
//-- - Description  : 
//-- - Version      : 1.0
//----------------------------------------------------------------------
public class OCSVariazioneDatiPagamentoInvoker {

    
    public static OCSVariazioneDatiPagamentoResponse callVariazioneDatiPagamento(OCSVariazioneDatiPagamentoRequest req){
        return (OCSVariazioneDatiPagamentoResponse)ApiUtils.callApi('ocs.variazioneDatiPagamento',req,OCSVariazioneDatiPagamentoResponse.class);
    }
    
    public static OCSVariazioneDatiPagamentoResponse callVariazioneDatiPagamento(String provenienza, String tipoIntermediario, String intermediario,
                                                                String procedura, String numPratica, String pagForma, String ecFrequenza, String abi, 
                                                                String cab, String cc, String cinBban, String cinIban, String paeseIban, String iban,
                                                                String intCc, String intestConto, String codiceRid, String firmaSuRid, String bancaInterna, 
                                                                String pagGGValuta, String lettera, String tipoContatto, String ammin, String dataIniziale,
                                                                String variazScadRata, String speseIncasso, String speseIncFlg, String codiceRifExt2,
                                                                String utente, String pan, String lunghezzaPan, String dataScadenza){

        OCSVariazioneDatiPagamentoRequest req=new OCSVariazioneDatiPagamentoRequest();
        req.variazioneDatiPagamentoRequest.provenienza=provenienza;
        req.variazioneDatiPagamentoRequest.tipoIntermediario=tipoIntermediario;
        req.variazioneDatiPagamentoRequest.intermediario=intermediario;
        req.variazioneDatiPagamentoRequest.procedura=procedura;
        req.variazioneDatiPagamentoRequest.numPratica=numPratica;
        req.variazioneDatiPagamentoRequest.pagForma=pagForma;
        req.variazioneDatiPagamentoRequest.ecFrequenza=ecFrequenza;
        req.variazioneDatiPagamentoRequest.abi=abi;
        req.variazioneDatiPagamentoRequest.cab=cab;
        req.variazioneDatiPagamentoRequest.cc=cc;
        req.variazioneDatiPagamentoRequest.cinBban=cinBban;
        req.variazioneDatiPagamentoRequest.cinIban=cinIban;
        req.variazioneDatiPagamentoRequest.paeseIban=paeseIban;
        req.variazioneDatiPagamentoRequest.iban=iban;
        req.variazioneDatiPagamentoRequest.intCc=intCc;
        req.variazioneDatiPagamentoRequest.intestConto=intestConto;
        req.variazioneDatiPagamentoRequest.codiceRid=codiceRid;
        req.variazioneDatiPagamentoRequest.firmaSuRid=firmaSuRid;
        req.variazioneDatiPagamentoRequest.bancaInterna=bancaInterna;
        req.variazioneDatiPagamentoRequest.pagGGValuta=pagGGValuta;
        req.variazioneDatiPagamentoRequest.lettera=lettera;
        req.variazioneDatiPagamentoRequest.tipoContatto=tipoContatto;
        req.variazioneDatiPagamentoRequest.ammin=ammin;
        req.variazioneDatiPagamentoRequest.dataIniziale=dataIniziale;
        req.variazioneDatiPagamentoRequest.variazScadRata=variazScadRata;
        req.variazioneDatiPagamentoRequest.speseIncasso=speseIncasso;
        req.variazioneDatiPagamentoRequest.speseIncFlg=speseIncFlg;
        req.variazioneDatiPagamentoRequest.codiceRifExt2=codiceRifExt2;
        req.variazioneDatiPagamentoRequest.utente=utente;
        req.variazioneDatiPagamentoRequest.pan=pan;
        req.variazioneDatiPagamentoRequest.lunghezzaPan=lunghezzaPan;
        req.variazioneDatiPagamentoRequest.dataScadenza=dataScadenza;
        
        OCSVariazioneDatiPagamentoResponse res=callVariazioneDatiPagamento(req);
      	System.debug(res);
        return res;
    }
}