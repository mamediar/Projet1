public class BarraTelefonicaPrintParameter {
    public Map<String,String> mapParameters {get;set;}
    
    public BarraTelefonicaPrintParameter(){
        mapParameters=ApexPages.currentPage().getParameters();

        //PARAMETRI DI RILIEVO
        //CTI_ANI 
        //CTI_CODICECLIENTE 
        //CTI_CODA  
        
        
        
    }
    public void printParameter(){
        
    }
    public Pagereference createCase(){
        final String categoriaExternal = '1035';
        //get coda parameter
        String queue=mapParameters.get('cti_CODA');
        String entita=mapParameters.get('cti_ENTITA');
        if(queue==null || queue.indexOf('AFFARI')<0) { // CASO EASYCM
            //creo case e dirigo all'easyCM
            Map<String,String> mapCTI=new Map<String,String> ();
            String codCliente=mapParameters.get('cti_CODICECLIENTE');
            if(codCliente!=null && codCliente!='' ){
                String toTransformCliente=String.valueOf(Integer.valueOf(codCliente)); //'000000000'+codCliente;                
                //mapCTI.put('ocsCode',toTransformCliente.substring(toTransformCliente.length()-9));
                mapCTI.put('ocsCode',toTransformCliente);
            }
            mapCTI.put('telephoneNumber',mapParameters.get('cti_ANI'));
            Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Inbound_Call').getRecordTypeId();
            List<XCS_Categoria__c> categorie = [SELECT ID FROM XCS_Categoria__c where External_Id__c = :categoriaExternal];
            Case theCase2 = new Case(
                //Subject = 'IO',
                //Esito__c = 'TEST',
                //Description = '{"ocsCode" : "229370","telephoneNumber" : "334 3355026","esitoSurvey" : "ok"}',
                Description=JSON.serialize(mapCTI),
                RecordTypeId = recordTypeId,
                Categoria_Riferimento__c = categorie.size()>0? categorie[0].ID : null,
                Subject = 'Acquisizione Inbound'
            );
            insert theCase2;
            //sforce.one.navigateToSObject(theCase2.id,);
            PageReference pg = new PageReference('/lightning/r/Case/'+theCase2.Id+'/view');
            pg.setRedirect(true);
            return pg;
        }
        else if(queue.toUpperCase()=='AFFARI-ECOMMERCE'){
            String codCliente=mapParameters.get('cti_CODICECLIENTE'); //case number mi aspetto idIncident da CTI
            Case theCase2=[select id from case where CaseNumber=:codCliente];           
            PageReference pg = new PageReference('/lightning/r/Case/'+theCase2.Id+'/view');
            pg.setRedirect(true);
            return pg;
        }
        else if(queue.indexOf('AFFARI')>=0 && entita.toUpperCase()=='AFFARIHDFILIALI'){ // AFFARI
            String codCliente='F'+mapParameters.get('cti_CODICECLIENTE'); //identificativo filiale
            Case theCase2=[select id from case where recordtype.developername='GUA_Contact' and status='Ricevuto' and branch__r.OCS_External_Id__c=:codCliente LIMIT 1];           
            PageReference pg = new PageReference('/lightning/r/Case/'+theCase2.Id+'/view');
            pg.setRedirect(true);
            return pg;
        }
        else if(queue.indexOf('AFFARI')>=0 && entita.toUpperCase()!='AFFARIHDFILIALI'){
            String codCliente='D'+mapParameters.get('cti_CODICECLIENTE'); //identificativo filiale
            Case theCase2=[select id from case where recordtype.developername='GUA_Contact' and status='Ricevuto' and Account.OCS_External_Id__c=:codCliente LIMIT 1];           
            PageReference pg = new PageReference('/lightning/r/Case/'+theCase2.Id+'/view');
            pg.setRedirect(true);
            return pg;
        }
        return null;
    }
}