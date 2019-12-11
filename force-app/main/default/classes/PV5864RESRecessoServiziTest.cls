/**
 * @File Name          : PV5864RESRecessoServiziTest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 25/10/2019, 09:34:18
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    25/10/2019   Federico Negro     Initial Version
**/
@isTest (SeeAllData=true)
public class PV5864RESRecessoServiziTest {

    static String Categoria='5864';

    @isTest static void testOK() {

        PVtestFactory pVtestFactory = new PVtestFactory();

        PV5864RESRecessoServiziInserimento.PV5864RESRecessoServiziForm form = new PV5864RESRecessoServiziInserimento.PV5864RESRecessoServiziForm();

        form = (PV5864RESRecessoServiziInserimento.PV5864RESRecessoServiziForm) pVtestFactory.initForm(Categoria, form);
        
        form.cliente.email = 'POSTVENDITA@EMAIL.TEST';
		form.cliente.codCliente = '1';
		form.cliente.cognome = 'COGNOME';
		form.cliente.nome = 'NOME';
		form.cliente.denominazioneAzienda = 'NOME COGNOME';
		form.cliente.dataNascita = '20100101';
        
        // specifici per ogni PV
        form.pratica = new OCSPratica();
        form.pratica.tipoPratica = 'CA';
		form.pratica.numPratica = '2106662676';

        //dati specifici PV
        form.tipoSinistro = 'DC';
		form.dataSinistro = '21/03/2019';
		form.dataDefinizione = '18/06/2019';

        Test.startTest();

            PV5864RESRecessoServiziInserimento.conferma(form);

            //secondo caso con form null per testare eccezione
            try{
			
			PV5864RESRecessoServiziInserimento.conferma(null);
			
		    } catch(Exception e) {
			    System.assertNotEquals(e.getMessage(),'');
		    }
            
        Test.stopTest();

    } 

}