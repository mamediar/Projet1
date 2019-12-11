public with sharing class WebServiceInvoker {

    public static HttpResponse recuperaBlocchiCarta(String numeroCarta, String filtroBlocchi) {
        HttpResponse response;
        Credentials credentials = getCredentials('ocs.recuperaBlocchiCarta');

        if (!String.isEmpty(credentials.endPoint) && !String.isEmpty(credentials.user) && !String.isEmpty(credentials.password) && !String.isEmpty(numeroCarta)) {

            String authorization = 'BASIC ' + EncodingUtil.base64Encode(Blob.valueOf(credentials.user + ':' + credentials.password));

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(credentials.endPoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Authorization', authorization);
            request.setTimeout(120000);

            String body = JSON.serialize(new Map<String, Object>{
                    'serviceId' => 'recuperaBlocchiCarta',
                    'companyType' => new Map<String, Object>{
                            'value' => 'COMPASS'
                    },
                    'recuperaBlocchiCartaRequest' => new Map<String, Object>{
                            'numCarta' => numeroCarta,
                            'filtroBlocchi' => filtroBlocchi
                    }
            });

            request.setBody(body);
            response = http.send(request);
        }

        return response;
    }

    public static HttpResponse bloccoSbloccoCarta(String numeroCarta, String tipoOperazione, String bloccoCarta, String utente) {
        HttpResponse response;
        Credentials credentials = getCredentials('ocs.bloccoSbloccoCarta');

        if (!String.isEmpty(credentials.endPoint) && !String.isEmpty(credentials.user) && !String.isEmpty(credentials.password) && !String.isEmpty(numeroCarta) && !String.isEmpty(tipoOperazione)) {

            String authorization = 'BASIC ' + EncodingUtil.base64Encode(Blob.valueOf(credentials.user + ':' + credentials.password));

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(credentials.endPoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Authorization', authorization);
            request.setTimeout(120000);

            String body = JSON.serialize(new Map<String, Object>{
                    'serviceId' => 'bloccoSbloccoCarta',
                    'companyType' => new Map<String, Object>{
                            'value' => 'COMPASS'
                    },
                    'numeroCarta' => numeroCarta,
                    'tipoOperazione' => tipoOperazione,
                    'bloccoCarta' => bloccoCarta,
                    'utente' => utente
            });

            request.setBody(body);
            response = http.send(request);
        }

        return response;
    }

    public static HttpResponse recuperaIndirizziCliente(String codiceCliente) {
        HttpResponse response;
        Credentials credentials = getCredentials('ocs.recuperaIndirizziCliente');

        if (!String.isEmpty(credentials.endPoint) && !String.isEmpty(credentials.user) && !String.isEmpty(credentials.password) && !String.isEmpty(codiceCliente)) {

            String authorization = 'BASIC ' + EncodingUtil.base64Encode(Blob.valueOf(credentials.user + ':' + credentials.password));

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(credentials.endPoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Authorization', authorization);
            request.setTimeout(120000);

            String body = JSON.serialize(new Map<String, Object>{
                    'serviceId' => 'recuperaIndirizziCliente',
                    'companyType' => new Map<String, Object>{
                            'value' => 'COMPASS'
                    },
                    'recuperaIndirizziClienteRequest' => new Map<String, Object>{
                            'codCliente' => codiceCliente
                    }
            });

            request.setBody(body);
            response = http.send(request);
        }

        return response;
    }

    public static HttpResponse recuperaInfoCarta(String numeroCarta, String emettitore) {
        HttpResponse response;
        Credentials credentials = getCredentials('ocs.recuperaInfoCarta');

        if (!String.isEmpty(credentials.endPoint) && !String.isEmpty(credentials.user) && !String.isEmpty(credentials.password) && !String.isEmpty(numeroCarta)) {

            String authorization = 'BASIC ' + EncodingUtil.base64Encode(Blob.valueOf(credentials.user + ':' + credentials.password));

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(credentials.endPoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Authorization', authorization);
            request.setTimeout(120000);

            String body = JSON.serialize(new Map<String, Object>{
                    'serviceId' => 'recuperaInfoCarta',
                    'companyType' => new Map<String, Object>{
                            'value' => 'COMPASS'
                    },
                    'recuperaInfoCartaRequest' => new Map<String, Object>{
                            'numCarta' => numeroCarta,
                            'emettitore' => emettitore
                    }
            });

            request.setBody(body);
            response = http.send(request);
        }

        return response;
    }

    public static HttpResponse cartaDatiFinanziari(String numeroCarta) {
        HttpResponse response;
        Credentials credentials = getCredentials('ocs.cartaDatiFinanziari');

        if (!String.isEmpty(credentials.endPoint) && !String.isEmpty(credentials.user) && !String.isEmpty(credentials.password) && !String.isEmpty(numeroCarta)) {

            String authorization = 'BASIC ' + EncodingUtil.base64Encode(Blob.valueOf(credentials.user + ':' + credentials.password));

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(credentials.endPoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Authorization', authorization);
            request.setTimeout(120000);

            String body = JSON.serialize(new Map<String, Object>{
                    'serviceId' => 'cartaDatiFinanziari',
                    'companyType' => new Map<String, Object>{
                            'value' => 'COMPASS'
                    },
                    'datiCartaDatiFinanziariRequest' => new Map<String, Object>{
                            'numeroPratica' => numeroCarta
                    }
            });

            request.setBody(body);
            response = http.send(request);
        }

        return response;
    }

    public static HttpResponse recuperaDatiPostvendita(String codiceCliente) {
        HttpResponse response;
        Credentials credentials = getCredentials('ocs.recuperaDatiPostvendita');

        if (!String.isEmpty(credentials.endPoint) && !String.isEmpty(credentials.user) && !String.isEmpty(credentials.password) && !String.isEmpty(codiceCliente)) {

            String authorization = 'BASIC ' + EncodingUtil.base64Encode(Blob.valueOf(credentials.user + ':' + credentials.password));

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(credentials.endPoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Authorization', authorization);
            request.setTimeout(120000);

            String body = JSON.serialize(new Map<String, Object>{
                    'serviceId' => 'recuperaDatiPostvendita',
                    'companyType' => new Map<String, Object>{
                            'value' => 'COMPASS'
                    },
                    'codCliente' => codiceCliente
            });

            request.setBody(body);
            response = http.send(request);
        }

        return response;
    }

    public static HttpResponse azionePreFurto(String provenienza, String tipoIntermediario, String intermediario, String numeroCarta, String operazione, String modEmissione, String dataValidita, String mesiValidita, String importoCommissioni, String addebitoCommissioni, String utente) {
        HttpResponse response;
        Credentials credentials = getCredentials('ocs.azionePreFurto');

        if (!String.isEmpty(credentials.endPoint) && !String.isEmpty(credentials.user) && !String.isEmpty(credentials.password) && !String.isEmpty(numeroCarta)) {

            String authorization = 'BASIC ' + EncodingUtil.base64Encode(Blob.valueOf(credentials.user + ':' + credentials.password));

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(credentials.endPoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Authorization', authorization);
            request.setTimeout(120000);

            String body = JSON.serialize(new Map<String, Object>{
                    'serviceId' => 'azionePreFurtoFurto',
                    'companyType' => new Map<String, Object>{
                            'value' => 'COMPASS'
                    },
                    'azionePreFurtoFurtoRequest' => new Map<String, Object>{
                            'provenienza' => provenienza,
                            'tipoIntermediario' => tipoIntermediario,
                            'intermediario' => intermediario,
                            'numCarta' => numeroCarta,
                            'operazione' => operazione,
                            'modEmissione' => modEmissione,
                            'dataValidita' => dataValidita,
                            'mesiValidita' => mesiValidita,
                            'importoCommissioni' => importoCommissioni,
                            'addebitoCommissioni' => addebitoCommissioni,
                            'utente' => utente
                    }
            });

            request.setBody(body);
            response = http.send(request);
        }

        return response;
    }

    private class Credentials {
        String endPoint { get; set; }
        String user { get; set; }
        String password { get; set; }

        public Credentials(String endPoint, String user, String password){
            this.endPoint = endPoint;
            this.user = user;
            this.password = password;
        }
    }

    private static Credentials getCredentials(String name) {
        ApiRest__c apiRest = ApiRest__c.getValues(name);
        ApiUtil__c apiUtil = ApiUtil__c.getValues(apiRest.Ref__c);
        return new Credentials(apiUtil.EndPoint__c, apiUtil.User__c, apiUtil.Password__c);
    }
}