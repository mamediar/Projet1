({
    initHelper:function(component){
        
        var action=component.get('c.getInitValues');
        action.setParam('societa',component.get('v.aziendaSelezionata'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                component.set('v.destinatari',resp.getReturnValue());
                component.set('v.destinatariFiltrati',resp.getReturnValue());
                component.set('v.isTableLoading',false);

                var x = component.get('v.destinatari');
            }
            this.setColumns(component);
        });
        $A.enqueueAction(action);
    },
    
    setColumns : function(cmp){
        cmp.set('v.columns',[
            {label:'Destinatario',fieldName:'Name__c',type:"text"},
            {label:'Email',fieldName:'Email__c',type:"text"}
        ]);
    },
    
    addAddressHelper : function(cmp,label){
        var dests=cmp.find('table').getSelectedRows();
        if(dests.length>0){
            var emails=this.buildEmailsString(cmp,dests,label);
           
            if(label.includes('A:')){
                var a=cmp.get('v.aa');
                console.log("Destin "+a);
                cmp.set('v.aa',emails);
                //cmp.set('v.aaPills',pills);
            }
            else if(label.includes('BCC:')){
                var bcc=cmp.get('v.bcc');
                cmp.set('v.bcc',emails);
                //cmp.set('v.bccPills',pills);
            }
                else{
                    var cc=cmp.get('v.cc');
                    cmp.set('v.cc',emails);
                    //cmp.set('v.ccPills',pills);
                }
        }
    },
    
    buildEmailsString : function(cmp,dests,label){
        var attrName = label.includes('A:') ? 'aa' : label.includes('BCC:') ? 'bcc' : 'cc';
        var pills=cmp.get('v.'+attrName+'Pills') ? cmp.get('v.'+attrName+'Pills') : [];
        var emails = cmp.get('v.'+attrName);
        emails = emails ? emails : '';
        var changed=false;
        dests.forEach(function(temp){
            if(!emails.includes(temp['Email__c'])){
                if(emails!='' && !changed){
                    emails+=';'+temp['Email__c']+';';
                }
                else{
                    emails+=temp['Email__c']+';';
                }
                changed=true;
            }
        });
        return emails=='' || !changed ? emails : emails.substring(0,emails.length-1);
    },
    
    buildEmailPills : function(cmp,dests,label){
        var attrName=label.includes('A:') ? 'aa' : label.includes('BCC:') ? 'bcc' : 'cc';
        var pills=cmp.get('v.'+attrName+'Pills') ? cmp.get('v.'+attrName+'Pills') : [];
        dests.forEach(function(temp){
            var isOk=true;
            pills.forEach(function(pill){
                if(pill['label']==temp['Email__c']){
                    isOk=false;
                    return;
                }
            });
            if(isOk){
                pills.push({
                    'label':temp['Email__c']
                });
            }
        });
        return pills;
    },
    
    addAddressFromInput : function(cmp,label){
        var emails = cmp.get('v.'+label).split(';');
        //Aspettiamo riscontri
    },
    
    doRicercaHelper : function(cmp){
        var text=cmp.get('v.ricercaText');
        var res=[];
        if(text && text!=''){
            cmp.get('v.destinatari').forEach(function(temp){
                var name=temp['Name__c'].toUpperCase();
                if(name.includes(text.toUpperCase())){
                    res.push(temp);
                }
            });
            cmp.set('v.destinatariFiltrati',res);
        }
        else{
            cmp.set('v.destinatariFiltrati',cmp.get('v.destinatari'));
        }
    },
    
    checkAllegati:function(cmp,allegati){
        /*var res=true;
        if(allegati && allegati.length>0){
            if(!cmp.get('v.areAllegatiChecked'))
                res=false;
        }
        return res;*/
        if(allegati.length>0){
            return true;
        }else return false;

    },
    
    checkDestinatari:function(cmp){
        var res=true;
        if (!cmp.get('v.aa')) {
            res=false;
        }
        return res;
    },
    
    inviaRispostaHelper : function(cmp,allegati){
        var action=cmp.get('c.inviaRispostaApex');
        cmp.set('v.showSpinner', true);

        var mailText = cmp.get('v.mailText');
        if(mailText==null || mailText=='' || mailText==undefined || mailText=='undefined'){
            cmp.set('v.showSpinner', false);
            this.showToast(cmp, 'Errore', 'error', 'Inserire il testo della mail.');
            return;
        }
        
        action.setParams({
            'a': cmp.get('v.aa'),
            'cc':cmp.get('v.cc'),
            'bcc':cmp.get('v.bcc'),
            'body':cmp.get('v.mailText'),
            'listaAllegati':allegati,
            'campiCase':cmp.get('v.campiCase'),
            'clienteSelezionato':cmp.get('v.clienteSelezionato'),
            'praticaSelezionata':JSON.stringify(cmp.get('v.praticaSelezionata'))
        });
        action.setCallback(this,function(resp){

            if(resp.getState()=='SUCCESS') {
                
                if(resp.getReturnValue()){

                    this.showToast(cmp, 'Successo', 'success', 'Email Inviata');
                    //let button = cmp.find("btn-InviaEmail");
                    //button.set('v.disabled',true);
                    this.reset(cmp, event);
                }else{
                    this.showToast(cmp, 'Errore', 'error', 'Non è stato possibile inviare la mail');
                }
                
            } else {
                this.showToast(cmp, 'Errore', 'error', 'Non è stato possibile inviare la mail');
            }
            cmp.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
        
    },
    
    reset: function(component, event){
        component.set('v.aa',null);
        component.set('v.bcc',null);
        component.set('v.cc',null);
        component.set('v.mailText', null);
        var cmpInserimentoAllegati = component.find('inserimentoAllegati');
        cmpInserimentoAllegati.set('v.allegatiSelezionati', null);
        component.set('v.valuecheckallegati',false);
        component.set('v.ricercaText',null);
        component.set('v.selectedRows',[]);
       

    },
    
     showToast : function(component, title, type, message ) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":type
            
        });
        toastEvent.fire();
    }
   
})