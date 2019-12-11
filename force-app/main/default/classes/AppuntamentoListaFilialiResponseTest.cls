/**
*@author 		Mame bousso kane
*created 		19/09/2019
*descripttion 	test of the AppuntamentoListaFilialiResponse class
*/
@isTest
public class AppuntamentoListaFilialiResponseTest {
    @isTest
    static void test(){
        Test.startTest();
        AppuntamentoListaFilialiResponse.PuntoRicercatoOCS punto= new AppuntamentoListaFilialiResponse.PuntoRicercatoOCS();
        punto.coordinates='';
        punto.postalCodeNumber='';
        punto.addressGeoCode='';
        AppuntamentoListaFilialiResponse.FilialeOCS filiali =  new AppuntamentoListaFilialiResponse.FilialeOCS();
        List<AppuntamentoListaFilialiResponse.FilialeOCS> listfili = new List<AppuntamentoListaFilialiResponse.FilialeOCS>();
        listfili.add(filiali);
        listfili[0].id='';
        listfili[0].idL='';
        listfili[0].idMappa ='';
        listfili[0].pV ='';
        listfili[0].indirizzo='';
        listfili[0].citta ='';
        listfili[0].provincia ='';
        listfili[0].cap ='';
        listfili[0].email ='';
        listfili[0].area ='';
        listfili[0].manager ='';
        listfili[0].tel ='';
        listfili[0].longitudine ='';
        listfili[0].latitudine ='';
        listfili[0].dst ='';
        listfili[0].occupazione ='';
        listfili[0].ele_text ='';

   		AppuntamentoListaFilialiResponse response = new AppuntamentoListaFilialiResponse();
        AppuntamentoListaFilialiResponse.Result result= new AppuntamentoListaFilialiResponse.Result();
        result.Filiali=listfili;
        result.puntoRicercato=punto; 
   		Test.stopTest();
    }
}