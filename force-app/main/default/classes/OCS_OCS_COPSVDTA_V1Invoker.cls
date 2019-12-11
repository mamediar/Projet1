public class OCS_OCS_COPSVDTA_V1Invoker {
    public static OCS_OCS_COPSVDTA_V1Response callAggiornaDati(OCS_OCS_COPSVDTA_V1Request request){
        return (OCS_OCS_COPSVDTA_V1Response)ApiUtils.callApi('ocs.OCS_COPSVDTA_V1',request,OCS_OCS_COPSVDTA_V1Response.class);
    }
    
    public static OCS_OCS_COPSVDTA_V1Response callAggiornaDati(Integer numeroPratica, String targa, String telaio, String marca, String modello, Integer cilindrata, String dataImmatricolazione){
        OCS_OCS_COPSVDTA_V1Request request=new OCS_OCS_COPSVDTA_V1Request();
		request.copsvdtarequest.mftcopsdta_PRATICA = numeroPratica;
		request.copsvdtarequest.mftcopsdta_TARGA = targa;
		request.copsvdtarequest.mftcopsdta_TELAIO = telaio;
		request.copsvdtarequest.mftcopsdta_MARCA = marca;	
		request.copsvdtarequest.mftcopsdta_MODELLO = modello;
		request.copsvdtarequest.mftcopsdta_CILINDRATA = cilindrata;
		request.copsvdtarequest.mftcopsdta_DATA_IMMATRIC = dataImmatricolazione;
        return(callAggiornaDati(request));
    }
}