/**
*@author 		Mame bousso kane
*created 		19/09/2019
*descripttion 	test of the AppuntamentoCercaResponse class
*/
@isTest
public class AppuntamentoCercaResponseTest {
    
    @isTest
    static void test(){
        Test.startTest();
            AppuntamentoCercaResponse.ListaApp lista = new AppuntamentoCercaResponse.ListaApp();
        	lista.codFiliale='';
        	lista.data='';
        	lista.nomeFiliale='';
        	lista.oppID='';
        	lista.ora='';
        	lista.titolo='';
 			AppuntamentoCercaResponse.Cliente cliente = new AppuntamentoCercaResponse.Cliente();
        	cliente.capResidenza='';
        	cliente.cellulare='';
        	cliente.codiceFiscale='';
        	cliente.cognome='';
        	cliente.contactID='';
        	cliente.dataNascita=Date.newInstance(2019, 09, 20);
        	cliente.email='';
        	cliente.indirizzoResidenza='';
        	cliente.localitaNascita='';
        	cliente.localitaResidenza='';
        	cliente.nome='';
        	cliente.privacyExtcommoffer='';
        	cliente.privacyInterncommoffer='';
        	cliente.privacyOtherservice='';
        	cliente.privacyProfilazione='';
        	cliente.provinciaNascita='';
        	cliente.sesso='';
        	cliente.siglaProvinciaResidenza='';
        	cliente.tipoOccupazione='';
 			AppuntamentoCercaResponse.AppuntamentoCercaReturn appReturn = new AppuntamentoCercaResponse.AppuntamentoCercaReturn();
        	appReturn.cliente=cliente;
            appReturn.codRes='';
            appReturn.desRes='';
   		Test.stopTest();
    }
}