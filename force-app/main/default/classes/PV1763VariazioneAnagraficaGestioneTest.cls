/**
 * @File Name          : PV1763VariazioneAnagraficaGestioneTest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 28/10/2019, 09:04:11
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/10/2019   Federico Negro     Initial Version
**/

@isTest (SeeAllData=true)
private class PV1763VariazioneAnagraficaGestioneTest {

    static String Categoria='1763';

    //ocs.recuperaDatiPostvendita
    static String response1='{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"32134009083","codCliente":"9099297","tipoPratica":"CA","codStatoPratica":"20","statoPratica":"20XU"}],"cliente":[{"cognome":"SAEOBZA","codCliente":"9099297","nome":"HISAYUKI"}]}';
	
    //ocs.recuperaTipoControparte 
	static String response2='{"resultCode":0,"resultMessage":"Ok","recuperaTipoControparteResponse":{"tipoControparte1":"S","tipoControparte16":"S","tipoControparte14":"S"}}';

	@isTest static void testOK() {

        PVtestFactory pVtestFactory = new PVtestFactory();

        PV1763VariazioneAnagraficaGestione.PV1763VariazioneAnagraficaForm form = new PV1763VariazioneAnagraficaGestione.PV1763VariazioneAnagraficaForm();

        form = (PV1763VariazioneAnagraficaGestione.PV1763VariazioneAnagraficaForm) pVtestFactory.initForm(Categoria, form);
        form.note = 'test';
        form.carteDaRitirare='a';
        form.praticheRetrocesse='b';
        form.cliente.codCliente='9099297';

        PV1763VariazioneAnagraficaGestione varAnagraficaGestione = new PV1763VariazioneAnagraficaGestione();

        // preparo un case
		Case caseObj = new Case(
			Categoria_Riferimento__c =  form.categoriaPV.Id,
			Step_PV__c = '2',
			Status = CaseUtils.APERTO,
            Id= '5005E000005q0EIQAY'
			);


        Map<String,List<String>> serviceIdResMap = new Map<String,List<String>>(); //mappa con i nomi dei servizi e la lista di response

            //ocs.recuperaDatiPV
            List<String> res1=new List<String>();
                res1.add(response1); //res 1 chiamata

            //ocs.recuperaTipoControparte
            List<String> res2=new List<String>();
                res2.add(response2); //res 1 chiamata

        serviceIdResMap.put('recuperaDatiPostvendita', res1);
        serviceIdResMap.put('recuperaTipoControparte', res2);

        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(serviceIdResMap);
		Test.setMock(HttpCalloutMock.class,UMR);


		Test.startTest();

        PV1763VariazioneAnagraficaGestione.init(caseObj, form.userData.user.Branch_Or_Office__c);
        PV1763VariazioneAnagraficaGestione.saveCase(form, caseObj);

        // secondo caso con caseId null e che manda in erorre
        try{
            caseObj.Id=null;
            PV1763VariazioneAnagraficaGestione.init(caseObj, form.userData.user.Branch_Or_Office__c);
		}
		catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}

        // terzo caso con form null e che manda in erorre
        try{
		    PV1763VariazioneAnagraficaGestione.saveCase( null ,  caseObj);
		}
		catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}

		Test.stopTest();
	}

}