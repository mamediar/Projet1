public class OCSCreaProspectInvoker {
    public static OCSCreaProspectResponse callRecDati(final OCSCreaProspectRequest request){
        return (OCSCreaProspectResponse) ApiUtils.callApi('ocs.creaProspect', request, OCSCreaProspectResponse.class);
    }

    public static OCSCreaProspectResponse callRecDati(final Account account){
        final Map<String, String> data = new Map<String, String>();
        data.put('ragioneSociale', String.isNotEmpty(account.RagioneSociale__pc) ? account.RagioneSociale__pc : account.FirstName + ' ' + account.LastName);
        data.put('nome', account.Name);
        data.put('cognome', account.LastName);
        data.put('codiceFiscale', account.Codice_Fiscale__pc);
        data.put('sesso', account.Sesso__pc);
        data.put('dataNascita', String.isNotEmpty(account.RagioneSociale__pc) ? DateUtils.formatDateYYYYMMDD(account.PersonBirthdate) : null);
        data.put('localitaNascita', account.Birthcity__c);
        data.put('provinciaNascita', account.Birthprovince__c);
        data.put('telefono', account.Phone);
        data.put('telefonoCellulare', account.PersonMobilePhone);
        data.put('email', account.PersonEmail);
        //data.put('codiceNDG2', account.LastName);
        data.put('modalitaAggiornamento', ' ');
        data.put('tipoAnagrafica', 'A');
        data.put('istruttPratiche', 'N');
        data.put('rilevaQualita', Boolean.valueOf(account.Qualitydetectionflag__pc) ? 'S' : 'N');
        data.put('offCommInterne', Boolean.valueOf(account.Interncommoffer__pc) ? 'S' : 'N');
        data.put('offCommEsterne', Boolean.valueOf(account.Extcommoffer__pc) ? 'S' : 'N');
        data.put('serviziAltri', Boolean.valueOf(account.OtherService__pc) ? 'S' : 'N');
        data.put('datiSensibili', 'N');
        data.put('tipoSegnalazione', 'CPO');
        return callRecDati(data);
    }

    public static OCSCreaProspectResponse callRecDati(final Map<String, String> data){
        System.debug('OCSCreaProspectInvoker callRecDati(Map) data: ' + data);
        
        for (String key : data.keySet()) {
            System.debug('OCSCreaProspectInvoker callRecDati(Map) data: ' + data.get(key));
        }

        final OCSCreaProspectRequest request = new OCSCreaProspectRequest();
        request.datiProspect.ragioneSociale= data.keySet().contains('ragioneSociale') ? data.get('ragioneSociale') : null;
        request.datiProspect.nome= data.keySet().contains('nome') ? data.get('nome') : null;
        request.datiProspect.cognome= data.keySet().contains('cognome') ? data.get('cognome') : null;
        request.datiProspect.codiceFiscale= data.keySet().contains('codiceFiscale') ? data.get('codiceFiscale') : null;
        request.datiProspect.sesso= data.keySet().contains('sesso') ? data.get('sesso') : null;
        request.datiProspect.dataNascita= data.keySet().contains('dataNascita') ? data.get('dataNascita') : null;
        request.datiProspect.localitaNascita= data.keySet().contains('localitaNascita') ? data.get('localitaNascita') : null;
        request.datiProspect.provinciaNascita= data.keySet().contains('provinciaNascita') ? data.get('provinciaNascita') : null;
        request.datiProspect.telefono= data.keySet().contains('telefono') ? data.get('telefono') : null;
        request.datiProspect.telefonoCellulare= data.keySet().contains('telefonoCellulare') ? data.get('telefonoCellulare') : null;
        request.datiProspect.email= data.keySet().contains('email') ? data.get('email') : null;
        request.datiProspect.codiceNDG2= data.keySet().contains('codiceNDG2') ? data.get('codiceNDG2') : null;
        request.datiProspect.modalitaAggiornamento= data.keySet().contains('modalitaAggiornamento') ? data.get('modalitaAggiornamento') : null;
        request.datiProspect.tipoAnagrafica= data.keySet().contains('tipoAnagrafica') ? data.get('tipoAnagrafica') : null;
        request.datiProspect.istruttPratiche= data.keySet().contains('istruttPratiche') ? data.get('istruttPratiche') : null;
        request.datiProspect.rilevaQualita= data.keySet().contains('rilevaQualita') ? data.get('rilevaQualita') : null;
        request.datiProspect.offCommInterne= data.keySet().contains('offCommInterne') ? data.get('offCommInterne') : null;
        request.datiProspect.offCommEsterne= data.keySet().contains('offCommEsterne') ? data.get('offCommEsterne') : null;
        request.datiProspect.serviziAltri= data.keySet().contains('serviziAltri') ? data.get('serviziAltri') : null;
        request.datiProspect.datiSensibili= data.keySet().contains('datiSensibili') ? data.get('datiSensibili') : null;
        request.datiProspect.tipoSegnalazione= data.keySet().contains('tipoSegnalazione') ? data.get('tipoSegnalazione') : null;

        System.debug('OCSCreaProspectInvoker callRecDati(Map) request: ' + request);
        
        OCSCreaProspectResponse res = callRecDati(request);
        System.debug('OCSCreaProspectInvoker callRecDati(Map) res: ' + res);
        return res;
    }
}