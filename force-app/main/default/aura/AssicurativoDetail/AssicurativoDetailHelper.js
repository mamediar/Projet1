({

	/**
	 * @description : To show Toast
	 * @author: Mamadou Lamine CAMARA
	 * @date: 13/03/2019
	 * @param message
	 * @param type
	 */
	showToast: function (message, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			message: message,
			type: type
		});
		toastEvent.fire();
	},
    /**
     * @description : To convert a Date to string format after calculating the day before
     * @author: Mamadou Lamine CAMARA
     * @date: 13/03/2019
     * @param String
     * @param String
     */
	convertDateBeforeToString: function (inputFormat, numberDayBefor) {
		function pad(s) { return (s < 10) ? '0' + s : s; }
		var d = new Date(inputFormat);
		var yesterday = new Date(d.getTime());
		yesterday.setDate(d.getDate() - numberDayBefor);

		return [pad(yesterday.getDate()), pad(yesterday.getMonth() + 1), yesterday.getFullYear()].join('/');
	},
    /**
     * @description : to get the Comodity Check list
     * @author: Mamadou Lamine CAMARA
     * @date: 13/03/2019
     * @param component
     */ 
	getComodityCheck: function (component) {
		//alert('intervista: '+JSON.stringify(component.get("v.nuovaIntervista")));
		var action = component.get('c.getCommodityCheck');
		var intervista=component.get("v.nuovaIntervista");
		action.setParam('InterviewObj', component.get("v.nuovaIntervista"));
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var data = response.getReturnValue();

                if(data.error==false){
                    component.set("v.indexFlag", data.index);
					var listAssicurazione= data.listCom;
					component.set('v.comodityCheklist', listAssicurazione);
                    this.getTextListAssicurativos(component);
				}
				else {
                    component.set("v.indexFlag", data.index);
				    var StringAssicurazioneNoExiste='';
					var listOfStringCSERVNotExist= data.ListOfStringCSERVNotExist;
					var i=0;
					listOfStringCSERVNotExist.forEach(function(element) {
						if(i==0)
						StringAssicurazioneNoExiste+=''+element;
						else
						StringAssicurazioneNoExiste+=' , '+element;
						i++;
					});
					component.set('v.stringAssicurazione', StringAssicurazioneNoExiste);
                    this.getTextListAssicurativos(component);
				}
			} else {
				this.showToast('Non successo', 'ERROR');

			}
		});
		$A.enqueueAction(action);
	},
	    /**
    * @description: method for check if risponde or no and call a component corresponding
    * @date::13/03/2019
    * @author:Mamadou Lamine CAMARA
    * @params: component, event, helper
    * @return: none
    * @modification:
    */
			getIntervistaDomande: function (component,selectedRisponde) {
				//check if risponde is Si
				component.set('v.rispondeQuezione', {
						'sobjectype': 'Risposte__c',
						'D0__c': '',
						'D1__c': '',
						'D2__c': '',
						'D3__c': '',
						'D4__c': '',
						'D5__c': '',
						'D6__c': '',
						'D7__c': '',
						'D8__c': '',
						'Intervista__c': ''
				});
				if (component.get('v.risposta')) {

						var risposte = component.get('v.risposta');
				} else {

						var risposte = component.get('v.rispondeQuezione');
				}

				console.log('Disponibilite', JSON.stringify(risposte));
				risposte.D0__c = selectedRisponde;
				console.log('Disponibilite', risposte.D0__c);
				component.set('v.rispondeQuezione', risposte);
				component.set('v.risposta', risposte);
				console.log('Response', component.get('v.rispondeQuezione'));
				//-----------------------------------------------------------------------------//
				if (selectedRisponde == 'Disponibile') {
						component.set('v.disponibile', true);
						component.set('v.disponibileNonAdesso', false);
						component.set('v.isRispostaExist', false);
						component.set('v.nonRisposta', false);
						component.set('v.isrispondeSi', false);
						component.set('v.isrispondeNo', false);
						component.set('v.responde', false);
				} else if (selectedRisponde == 'NonDisponibile') {
						var intervista = component.get('v.nuovaIntervista');
                        /*
						var numberNonRichiamare = intervista.COM_count_richiamaASS__c;		
						if (isNaN(numberNonRichiamare)) {
							numberNonRichiamare = 1;
						} else {
							numberNonRichiamare++;
						}
						intervista.COM_count_richiamaASS__c=numberNonRichiamare; */							
						component.set("v.nuovaIntervista",intervista);
						var dateIlSrting = this.convertDateBeforeToString(intervista.COM_Data_Scadenza_Recesso__c, 1);
						component.set('v.quezione', 'Chiedere quando è possibile richiamare e fissare ricontatto entro il ' + dateIlSrting + ' ');
						component.set('v.responde', false);
						component.set('v.isrispondeNo', true);
						component.set('v.isrispondeSi', false)
						component.set('v.isRispostaExist', false);
						component.set('v.nonRisposta', false);
						component.set('v.disponibileNonAdesso', true);
				}
		},
		/**
    * @description: method for check if risponde is non adesso
    * @author:Mamadou Lamine CAMARA
    * @params: component, event, helper
    * @return: none
    * @modification:
    */
	 getDomandaAdessoSi: function (component) {
		//var val = component.find('idAdesso').get('v.value');
		//console.log('value',val);

		if (component.get('v.risposta')) {

				var risposte = component.get('v.risposta');
		} else {

				var risposte = component.get('v.rispondeQuezione');
		}

		console.log('Response', JSON.stringify(risposte));
		risposte.D1__c = 'Si';
		console.log('response', risposte.D1__c);
		component.set('v.rispondeQuezione', risposte);
		component.set('v.risposta', risposte);

		var intervista = component.get('v.nuovaIntervista');
		component.set('v.responde', false);
		component.set('v.disponibileNonAdesso', false);
		component.set('v.disponibile', false);
		component.set('v.disponibileSi', true);
		component.set('v.isrispondeSi', false)
		component.set('v.isRispostaExist', false);
		component.set('v.nonRisposta', false);
},
    /**
     * @description : To Stato
	 * @author: Mamadou Lamine CAMARA
     * @date: 13/03/2019
     * @param component
     * @param String
     */

	changeStato: function (component, stato) {
		var intervista = component.get('v.nuovaIntervista');
		intervista.COM_Stato_Avanzamento_IntervistaASS__c = stato;
		intervista.COM_Data_Esito_ASS__c = new Date();
		intervista.COM_Status_ASS__c = 'Archived';

		var action = component.get('c.updateIntervista');
		action.setParam('param', intervista);
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				component.set('v.nuovaIntervista', response.getReturnValue());
				var eventGoFiliali = $A.get("e.c:eventNavigationAssicurativoPratiche");
				eventGoFiliali.fire();
                /*
				console.log('in success',response.getReturnValue());
				this.showToast('Stato aggiornato in '+stato+'.Salvataggio con successo', 'SUCCESS');
				component.set('v.nonRisposta',false);*/
			} else {
				this.showToast('Salvataggio non effettuato!', 'ERROR');
			}
		});
		$A.enqueueAction(action);

	},
    /*parseToDateArrayFromMillisecond: function (data) {
    data.forEach(function (element, index) {
      if (element.COM_CRMRichiamare_il__c)
        element.COM_CRMRichiamare_il__c = new Date(element.COM_CRMRichiamare_il__c).toLocaleDateString();
      if (element.COM_CRMRichiamare_ilASS__c)
        element.COM_CRMRichiamare_ilASS__c = new Date(element.COM_CRMRichiamare_ilASS__c).toLocaleDateString();
      data[index] = element;
    });
    return data;
  },*/
	salvareAppuntamento: function (component) {
		
		var nuovaIntervista1 = component.get('v.nuovaIntervista');
		var numberNonrisponde = nuovaIntervista1.COM_count_non_rispASS__c;
		var numberNonRichiamare = nuovaIntervista1.COM_count_richiamaASS__c;
		if (isNaN(numberNonrisponde)) {
			numberNonrisponde = 1;
		}else {
			numberNonrisponde++;
		}
        /*
		if( isNaN(numberNonRichiamare) ) 
        {
            numberNonRichiamare = 1;
        }else{
            numberNonRichiamare++;
        }*/

		//var numberNonrisponde = new Number (.get('v.value'));
		//
		//alert(numberNonrisponde);
		component.set("v.numNonRispondeAppTelAss", numberNonrisponde);
		var intervista = component.get("v.nuovaIntervista");
    
        if( numberNonrisponde < 5 || numberNonrisponde == 5 )
        {
            //get time now
            var now = new Date();
            console.log('now ', now);
            var hourNow = now.getHours();
            now.setHours(now.getHours() + 4);
            var hourRichiamare = now;
            var holal = hourRichiamare.getHours();
            var	hourSet = new Date(hourRichiamare).toLocaleDateString();

            //alert('----21_06_2019 hourRichiamare:'+hourRichiamare);
            if (hourRichiamare.getHours() + 1 < 18) 
            {
                console.log('date ok :' + now);
                var dateAppuntamento = hourRichiamare;
                //alert('---dateAppuntamento:'+dateAppuntamento);

            }
            else {
                var currentDate = new Date();
                //currentDate.setDate(currentDate.getDate()+1);
                currentDate.setHours(currentDate.getHours() - 5);
                var dateAppuntamento = currentDate;
                var checkee = dateAppuntamento.getDay();
                //alert('31_05_2019 checkee->'+checkee);
                //Saturday
                if (dateAppuntamento.getDay() == 6) 
                {
                    dateAppuntamento.setDate(currentDate.getDate()+2);
                    console.log('saturday', dateAppuntamento);
                }else{
                    // Not Saturday
                    dateAppuntamento.setDate(currentDate.getDate()+1);
                }
            }

		    console.log('dateAppuntamento:' + dateAppuntamento);
		                    //alert('---dateAppuntamento:'+dateAppuntamento);

            intervista.COM_CRMRichiamare_ilASS__c = dateAppuntamento;
            intervista.COM_Stato_Avanzamento_IntervistaASS__c = "Non Risponde";
            intervista.COM_Status_ASS__c = "New";
            intervista.COM_Data_Esito_ASS__c    = new Date();
            intervista.COM_count_richiamaASS__c = numberNonRichiamare;
            intervista.COM_count_non_rispASS__c = numberNonrisponde;
            console.log('intervistaAppunt', JSON.stringify(intervista));
            
        }else if( numberNonrisponde > 5 )
        {
            intervista.COM_Status_ASS__c = "Archived";
            intervista.COM_Stato_Avanzamento_IntervistaASS__c = "Conclusa";
            intervista.COM_Data_Esito_ASS__c                      = new Date();
            intervista.COM_count_non_rispASS__c = numberNonrisponde;
        }
    
        var action = component.get('c.updateIntervista');
		action.setParam('param', intervista);
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				component.set('v.nuovaIntervista', response.getReturnValue());
				console.log('in success' + response.getReturnValue());
				this.showToast('Salvataggio con successo!', 'SUCCESS');
                var eventGoAssicurativo = $A.get("e.c:eventNavigateToAssicurativo");
        		eventGoAssicurativo.fire();
				/* var eventRefreshIntervista = $A.get("e.c:eventGetIntervista");
				 eventRefreshIntervista.fire();*/
			} else {
				console.log('');
				this.showToast('Salvataggio non effettuato!', 'ERROR');
			}
		});
		$A.enqueueAction(action);
	},
	getTextListAssicurativos: function(component){
		var data=component.get("v.comodityCheklist");
		var i=0;
		//alert("taille du tableau: "+data.length)
		if(data.length>0){
		//var stringData=''+data[0].COM_CRMTipo__c;
		var stringData=''+data[0].COM_CRMTipo__c+' che è un/una '+data[0].COM_CRMDefinizione__c;
		if(data.length>1){
		data.forEach(function(element) {
			console.log(element);
			if(i>0)
			//stringData=stringData+', '+ element.COM_CRMTipo__c;
			stringData=stringData+', '+ element.COM_CRMTipo__c+' che è un/una '+element.COM_CRMDefinizione__c;
			i++;
		  });
		}
		//alert(stringData);
		component.set("v.TextListAssicuratico",stringData);
		}
	}
})