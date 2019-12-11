/**
 * @File Name          : PV1763VariazioneAnagraficaInsTest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 25/10/2019, 14:43:42
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    23/10/2019   Federico Negro     Initial Version
**/
@isTest (SeeAllData=true)
public class PV1763VariazioneAnagraficaInsTest {

    static boolean truefalse;
    static String Categoria='1763';

    //ocs.recuperaSegnalazioniCliente
	static String response1='{"resultCode":0,"resultMessage":"Ok","recuperaSegnalazioniClienteResponse":{"elencoSegnalazioni":[]}}';

	//ocs.recuperaTipoControparte 
	static String response2='{"resultCode":0,"resultMessage":"Ok","recuperaTipoControparteResponse":{"tipoControparte1":"S","tipoControparte16":"S"}}';
    static String response22='{"resultCode":0,"resultMessage":"Ok","recuperaTipoControparteResponse":{"tipoControparte1":"S","tipoControparte16":"S","tipoControparte14":"S"}}';
	static String response23='{"resultCode":0,"resultMessage":"Ok","recuperaTipoControparteResponse":{"tipoControparte1":"S","tipoControparte16":"S","tipoControparte14":"S","tipoControparte2":"S"}}';

    //ocs.recuperaDatiPostvendita
    static String response3='{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"123456789","tipoPratica":"CA","codStatoPratica":"50"}],"cliente":[{"cognome":"UTMOBZE","codCliente":"123456789","nome":"LERRIO"}]}';
    
    @isTest static void testOK() {

        PVtestFactory pVtestFactory = new PVtestFactory();

        PV1763VariazioneAnagraficaInserimento.PV1763VariazioneAnagraficaForm form = new PV1763VariazioneAnagraficaInserimento.PV1763VariazioneAnagraficaForm();

        form = (PV1763VariazioneAnagraficaInserimento.PV1763VariazioneAnagraficaForm) pVtestFactory.initForm(Categoria, form);
        
        form.cliente.tipoAnagrafica='A';
        form.cliente.codCliente= '123456789';
        form.variazioni= 'Lista Variazioni:';
        form.modificheAUI= 'S';
        form.ritiroCarte= '';
        
        form.reasonMdt=new PostvenditaConfig_reason__mdt();
        form.reasonMdt.dispositionId__c = 4354;


        Map<String,List<String>> serviceIdResMap = new Map<String,List<String>>(); //mappa con i nomi dei servizi e la lista di response

            //ocs.recuperaSegnalazioniCliente
            List<String> res1=new List<String>();
                res1.add(response1); //res 1 chiamata
                res1.add(response1); //res 2 chiamata
                res1.add(response1); //res 3 chiamata

            //ocs.recuperaSegnalazioniCliente
            List<String> res2=new List<String>();
                res2.add(response2); //res 1 chiamata
                res2.add(response22); //res 2 chiamata
                res2.add(response2); //res 3 chiamata
                res2.add(response23); //res 4 chiamata

            //ocs.recuperaSegnalazioniCliente 
            List<String> res3=new List<String>();
                res3.add(response3); 

        serviceIdResMap.put('recuperaSegnalazioniCliente', res1);
        serviceIdResMap.put('recuperaTipoControparte', res2);
        serviceIdResMap.put('recuperaDatiPostvendita', res3);

        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(serviceIdResMap);
		Test.setMock(HttpCalloutMock.class,UMR);

        Test.startTest();

            PV1763VariazioneAnagraficaInserimento.AccountCheckOutput testoutput1 = PV1763VariazioneAnagraficaInserimento.doCheck(form.cliente, 'Documento Firmatario/Delegato/Rappresentante/Titolare');
            PV1763VariazioneAnagraficaInserimento.AccountCheckOutput testoutput2 = PV1763VariazioneAnagraficaInserimento.doCheck(form.cliente, 'Cliente/Coobbligato/Garante/Delegato/Altro');
            PV1763VariazioneAnagraficaInserimento.AccountCheckOutput testoutput3 = PV1763VariazioneAnagraficaInserimento.doCheck(form.cliente, 'Cliente/Coobbligato/Garante/Delegato/Altro');
            PV1763VariazioneAnagraficaInserimento.AccountCheckOutput testoutput4 = PV1763VariazioneAnagraficaInserimento.doCheck(form.cliente, 'Cliente/Coobbligato/Garante/Delegato/Altro');
            PV1763VariazioneAnagraficaInserimento.conferma(form);

        Test.stopTest();

    } 

}