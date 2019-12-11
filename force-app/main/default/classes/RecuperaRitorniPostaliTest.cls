@IsTest
public class RecuperaRitorniPostaliTest {
    
    @isTest
    public static void wsRecuperaRitorniPostali() {
        
        Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        ApiRest__c apiRest1 = new ApiRest__c (
            Name = 'ocs.recuperaRitorniPostali',
            EndPoint__c = 'ocs.recuperaRitorniPostali',
            Test_Response__c = '',
            Method__c = 'POST', 
            Mock__c = false, 
            Password__c = 'P00FLSDC',
            Ref__c = 'CompassInternal', 
            User__c = 'CDSLF00'
        );
        insert apiRest1;
        
        List<String> responses = new List<String>();
        responses.add('{"resultCode":0,"resultMessage":"Ok","ritorniPostali":[{"cognome":"MAIOHSAU","codCliente":"11006529","nome":"ROMEA","dataNascita":"19430406","luogoNascita":"ROMA","provNascita":"RM","sesso":"F","codFiscale":"MHSRMO43D46H501O","piva":"","indirizzo":"VIA ROMA 3","cap":"00166","localita":"ROMA","provincia":"RM","paeseEstero":"086","email":"","tipoDocumento":"PAT","numDocumento":"743761RM2Z","ufficioRilascio":"PRE","luogoRilascio":"ROMA","provRilascio":"RM","dataRilascio":"20021207","denominazioneAzienda":"MAIOHSAU ROMEA","formaGiuridica":"","tipoAnagrafica":"P","dataScadenza":"20991231","telefonoCasa":"","telCellulare":"331 9261732","tipoRapporto":"","dataDepennamento":null,"ndg":null,"dataRegistrazione":null,"dataVariazioneIndirizzo":null,"dataInvio":"20180929","dataRitorno":"20190514","tipoLettera":"WEL","codLettera":"KC26","procedura":"CA","numPratica":"15110147108","progressivoPostel":"515859504","causaleRitorno":"ALT","codFiliale":"71","flagContatto":"N","flagResoMacero":"M","flagRiproduzione":"M","tipoPagamento":"BP","indirizzoInvio":"","capInvio":"","localitaInvio":"","provinciaInvio":"","dataEC":"0","flagFornitore":"N"},{"cognome":"EAMOIGLU","codCliente":"12273983","nome":"BRULINDA","dataNascita":"19680406","luogoNascita":"PALERMO","provNascita":"PA","sesso":"F","codFiscale":"MGLBLN68D46G273Q","piva":"","indirizzo":"VIA ROSSI 2","cap":"90135","localita":"PALERMO","provincia":"PA","paeseEstero":"086","email":"","tipoDocumento":"CAR","numDocumento":"693665AO7","ufficioRilascio":"COM","luogoRilascio":"PALERMO","provRilascio":"PA","dataRilascio":"20080123","denominazioneAzienda":"EAMOIGLU BRULINDA","formaGiuridica":"","tipoAnagrafica":"P","dataScadenza":"20180122","telefonoCasa":"","telCellulare":"329 6988235","tipoRapporto":"","dataDepennamento":null,"ndg":null,"dataRegistrazione":null,"dataVariazioneIndirizzo":null,"dataInvio":"20181031","dataRitorno":"20190201","tipoLettera":"WEL","codLettera":"KC26","procedura":"CA","numPratica":"44188081349","progressivoPostel":"521402705","causaleRitorno":"ALT","codFiliale":"102","flagContatto":"N","flagResoMacero":"M","flagRiproduzione":"M","tipoPagamento":"BP","indirizzoInvio":"","capInvio":"","localitaInvio":"","provinciaInvio":"","dataEC":"0","flagFornitore":"N"},{"cognome":"CORDIISI","codCliente":"4330927","nome":"OUARDA","dataNascita":"19740514","luogoNascita":"PALERMO","provNascita":"PA","sesso":"F","codFiscale":"CRDRDO74E54G273G","piva":"","indirizzo":"VIA ROMA 1","cap":"90131","localita":"PALERMO","provincia":"PA","paeseEstero":"086","email":"CORDIISI.OUARDA@provider.com","tipoDocumento":"CAR","numDocumento":"509592AS1","ufficioRilascio":"COM","luogoRilascio":"PALERMO","provRilascio":"PA","dataRilascio":"20110711","denominazioneAzienda":"CORDIISI OUARDA","formaGiuridica":"","tipoAnagrafica":"P","dataScadenza":"20210710","telefonoCasa":"","telCellulare":"328 2214412","tipoRapporto":"","dataDepennamento":null,"ndg":null,"dataRegistrazione":null,"dataVariazioneIndirizzo":null,"dataInvio":"20181031","dataRitorno":"20190201","tipoLettera":"WEL","codLettera":"KC26","procedura":"CA","numPratica":"66124305118","progressivoPostel":"521402796","causaleRitorno":"ALT","codFiliale":"200","flagContatto":"N","flagResoMacero":"M","flagRiproduzione":"M","tipoPagamento":"BP","indirizzoInvio":"","capInvio":"","localitaInvio":"","provinciaInvio":"","dataEC":"0","flagFornitore":"N"},{"cognome":"RUORBEELR","codCliente":"8310708","nome":"BERTHOLD","dataNascita":"19660730","luogoNascita":"ROMA","provNascita":"RM","sesso":"M","codFiscale":"RRBBTH66L30H501S","piva":"","indirizzo":"VIA ROMA 4","cap":"00132","localita":"ROMA","provincia":"RM","paeseEstero":"086","email":"RUORBEELR.BERTHOLD@provider.com","tipoDocumento":"CAR","numDocumento":"604139AX9","ufficioRilascio":"COM","luogoRilascio":"ROMA","provRilascio":"RM","dataRilascio":"20160417","denominazioneAzienda":"RUORBEELR BERTHOLD","formaGiuridica":"","tipoAnagrafica":"P","dataScadenza":"20260907","telefonoCasa":"","telCellulare":"320 5979505","tipoRapporto":"","dataDepennamento":null,"ndg":null,"dataRegistrazione":null,"dataVariazioneIndirizzo":null,"dataInvio":"20181031","dataRitorno":"20190201","tipoLettera":"WEL","codLettera":"KC26","procedura":"CA","numPratica":"74145933410","progressivoPostel":"521402809","causaleRitorno":"ALT","codFiliale":"800","flagContatto":"N","flagResoMacero":"M","flagRiproduzione":"M","tipoPagamento":"BP","indirizzoInvio":"","capInvio":"","localitaInvio":"","provinciaInvio":"","dataEC":"0","flagFornitore":"N"},{"cognome":"SHUASZA","codCliente":"18686750","nome":"MIHAELL","dataNascita":"19720918","luogoNascita":"GALATINA","provNascita":"LE","sesso":"M","codFiscale":"SHSMLL72P18D862D","piva":"04816690756","indirizzo":"VIA ROMA 2","cap":"73013","localita":"GALATINA","provincia":"LE","paeseEstero":"086","email":"","tipoDocumento":"CAR","numDocumento":"075790AX2","ufficioRilascio":"COM","luogoRilascio":"GALATINA","provRilascio":"LE","dataRilascio":"20160908","denominazioneAzienda":"SHUASZA MIHAELL","formaGiuridica":"DIN","tipoAnagrafica":"F","dataScadenza":"20261027","telefonoCasa":"","telCellulare":"328 6688738","tipoRapporto":"","dataDepennamento":null,"ndg":null,"dataRegistrazione":null,"dataVariazioneIndirizzo":null,"dataInvio":"20181119","dataRitorno":"20190201","tipoLettera":"WEL","codLettera":"SEP1","procedura":"CA","numPratica":"100149300321","progressivoPostel":"525569320","causaleRitorno":"INC","codFiliale":"240","flagContatto":"S","flagResoMacero":"R","flagRiproduzione":"N","tipoPagamento":"RI","indirizzoInvio":"","capInvio":"","localitaInvio":"","provinciaInvio":"","dataEC":"0","flagFornitore":"N"}]}');
        serviceIdResponseMap.put('recuperaRitorniPostali', responses);
        
         ApiUtil__c apiUti = new ApiUtil__c(
            Name = 'CompassInternal', 
            EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute', 
            Password__c = 'P00FLSDC', 
            Ref__c = 'CompassInternal', 
            User__c = 'CDSLF00'
        );
        insert apiUti;
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        test.startTest();
        RecuperaRitorniPostali recRitorniPostali = new RecuperaRitorniPostali();
        recRitorniPostali.execute(null);
        test.stopTest();
    }

}