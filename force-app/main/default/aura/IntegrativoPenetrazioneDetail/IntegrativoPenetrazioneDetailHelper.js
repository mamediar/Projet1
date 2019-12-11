({
    /**
     * @description : To show Toast
     * @author: Khadim Rassoul Ndeye
     * @date: 13/03/2019
     * @param message
     * @param type
     */
    showToast: function(message, type) {
      var toastEvent = $A.get("e.force:showToast");
      toastEvent.setParams({
        message: message,
        type: type
      });
      toastEvent.fire();
    },
    salvareAppuntamento: function(component) {
      var nuovaIntervista1 = component.get("v.IntervistaIntegrativo");
      var numberNonrisponde = nuovaIntervista1.COM_Num_Non_Risponde__c;
      var numberNonRichiamare = nuovaIntervista1.COM_Num_richiamare__c;
      if (isNaN(numberNonrisponde)) {
        numberNonrisponde = 1;
      } else {
        numberNonrisponde++;
      }
      component.set("v.numNonRispondeAppTelAss", numberNonrisponde);
      var intervista = component.get("v.IntervistaIntegrativo");
      intervista.Note__c = '';
      if (numberNonrisponde < 5 || numberNonrisponde == 5) {
        var now = new Date();
        now.setHours(now.getHours() + 4);
        var hourRichiamare = now;
        if (hourRichiamare.getHours() + 1 < 18) {
            var dateAppuntamento = hourRichiamare;
          } else {
            /*
             * l’ora_attuale + 4 non eccede le ore 18 allora calcolo l'ora aggiungendo 4 ore all'ora attuale, altrimenti
             * alcolo una nuova ora = 9+(ora_attuale+4-18) e aggiungo 2 gg se è sabato, 1 gg altrimenti.
             */
            var currentDate = new Date();
            var numberHours = 9 + (currentDate.getHours() + 4 - 18);
            currentDate.setHours(9 + currentDate.getHours() + 4 - 18);
            var dateAppuntamento = currentDate;
            if (dateAppuntamento.getDay() == 5 || dateAppuntamento.getDay() > 5) {
              dateAppuntamento.setDate(currentDate.getDate() + 3);
            } else {
              // Not Saturday
              dateAppuntamento.setDate(currentDate.getDate() + 2);
            }
          }
        console.log("dateAppuntamento:" + dateAppuntamento);
  
        intervista.COM_Richiamare_il__c = dateAppuntamento;
        intervista.Stato__c = "Non risponde";
        intervista.Status__c = "New";
        intervista.COM_Ultimo_Esito__c = "Non risponde";
        intervista.COM_Num_richiamare__c = numberNonRichiamare;
        intervista.COM_Num_Non_Risponde__c = numberNonrisponde;
        console.log("intervistaAppunt", JSON.stringify(intervista));
      } else if (numberNonrisponde > 5) {
        intervista.Status__c = "Archived";
        intervista.Stato__c = "Non risponde";
        intervista.COM_Ultimo_Esito__c = "Non risponde";
        intervista.COM_Num_Non_Risponde__c = numberNonrisponde;
      }
  
      var action = component.get("c.updateIntervista");
      action.setParam("param", intervista);
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          component.set("v.IntervistaIntegrativo", response.getReturnValue());
          console.log(
            "success de Non risponde al telefono",
            response.getReturnValue()
          );
          this.showToast("Appuntamento salvato con successo!", "SUCCESS");
          var eventGoIntervista = $A.get("e.c:eventNavigateToIntervistaPenetrazione");
          eventGoIntervista.setParams({intervistaPenetrazione: component.get("v.IntervistaIntegrativo")});
          eventGoIntervista.fire();
        } else {
          this.showToast("Salvataggio non effettuato!", "ERROR");
        }
      });
      $A.enqueueAction(action);
    },
    /**
     * @description : To Stato
     * @author: Khadim Rassoul Ndeye
     * @date: 13/03/2019
     * @param component
     * @param String
     */
  
    changeStato: function(component, stato) {
      var intervista = component.get("v.IntervistaIntegrativo");
      intervista.Stato__c = stato;
      intervista.COM_Data_Esito__c = new Date();
      intervista.Status__c = "Archived";
      intervista.COM_Ultimo_Esito__c = stato;
      var action = component.get("c.updateIntervista");
      action.setParam("param", intervista);
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          component.set("v.IntervistaIntegrativo", response.getReturnValue());
          //console.log("intervista après sauvegarde", response.getReturnValue());
          this.showToast("Salvataggio con successo!", "SUCCESS");
          var eventGoIntervista = $A.get("e.c:eventNavigateToIntervistaPenetrazione");
          eventGoIntervista.setParams({intervistaPenetrazione: component.get("v.IntervistaIntegrativo")});
          eventGoIntervista.fire();
          /*
                  console.log('in success',response.getReturnValue());
                  this.showToast('Stato aggiornato in '+stato+'.Salvataggio con successo', 'SUCCESS');
                  component.set('v.nonRisposta',false);*/
        } else {
          this.showToast("Salvataggio non effettuato!", "ERROR");
          console.log(response.getError()[0]);
        }
      });
      $A.enqueueAction(action);
    },
  
    /**
     * @description : List of Questions for intervista
     * @author: Khadim Rassoul Ndeye
     * @param component
     * @return Array of objects
     */
    listQuestions: function(component) {
      var IntervistaIntegrativo = component.get("v.IntervistaIntegrativo");
      var listOfStringCSERVNotExistCount = component.get(
        "v.listOfStringCSERVNotExistCount"
      );
      //if (assicurazioneCount == 1 || listOfStringCSERVNotExistCount == 1) {
  
        var assicurazioneCount = component.get("v.assicurazioneCount");
        console.log("length via assicurazioneCount >>", assicurazioneCount);
        var plurale1Q1 = "";
        var plurale1Q4 = "";
        var plurale2Q4 = "";
        var plurale1Q3 = "";
        var plurale1Q2 = "";
        var plurale2Q3 = "";
        if (assicurazioneCount == 1 || listOfStringCSERVNotExistCount == 1) {
          plurale1Q4 = "dell’ assicurazione. ";
          plurale2Q4 = "copertura";
          plurale1Q1 = "del prodotto? ";
          plurale1Q2 = " apposito modulo ";
        }
        if (assicurazioneCount > 1 || listOfStringCSERVNotExistCount > 1) {
          plurale1Q4 = "delle assicurazioni. ";
          plurale2Q4 = "coperture";
          plurale1Q1 = "dei prodotti? ";
          plurale1Q2 = " appositi moduli ";
        }
        var comodities = component.get("v.comodityCheklist");
        console.log('comodities >>>>', comodities);
        comodities = comodities.filter(row =>
          row.COM_CRMflag_prod_sani_non_conn__c == "S"
          
        );
        if(comodities.length > 1){
          plurale1Q3 = " da Lei sottoscritte, hanno ";
          plurale2Q3 = " le polizze denominate ";
        }else{
          plurale1Q3 = " da Lei sottoscritta, ha ";
          plurale2Q3 = " la polizza denominata ";
        }
        console.log('comodities 22 >>>>', comodities);
        var TipoConcat = comodities
        .map(function(element) {
              return element.COM_CRMTipo__c;
          })
        .join(", ");
        console.log('TipoConcat >>>>', TipoConcat);
        var durataSanitarie = IntervistaIntegrativo.Durata_Sanitarie__c
          ? IntervistaIntegrativo.Durata_Sanitarie__c
          : 0;
        return [
          {
            label:
              "<p>Bene, innanzitutto le “ricordo che i suoi dati personali verranno trattati conformemente a quanto previsto dalla Normativa sulla Privacy”.</p>" +
               "<p> Detto questo, insieme al finanziamento lei ha sottoscritto un'assicurazione facoltativa denominata " +
              this.getAssicurazioneTipoDefizione(component) +
              " contratta con " +
              IntervistaIntegrativo.Ragione_Sociale_Intermediario__c +
              ".</p> <p> Se ha tempo, desidera che Le riepiloghi le principali caratteristiche " +
              plurale1Q1 +
              " Ad esempio quali eventi sono coperti ? Potrebbe esserLe utile? </p>",
            num_question: 1,
            responses: [
              "SI, PERCHE' NON MI E' MOLTO CHIARO/NON HO ANCORA LETTO LE CONDIZIONI DI POLIZZA",
              "NO/NON MI SERVE",
              "NON HO SOTTOSCRITTO / NON RICORDO DI AVER SOTTOSCRITTO ALCUN PRODOTTO ASSICURATIVO"
            ],
            fieldToStore: "D2"
          },
          {
            label:
              this.getTitleAndName(component) +
              " l'assicurazione di cui parliamo è già compresa nella sua rata mensile di € " +
              IntervistaIntegrativo.Imp_Rata__c +
              ". \n " +
              " Quando si è recata per il prestito, insieme al contratto di finanziamento ha firmato "+ assicurazioneCount + plurale1Q2 + " per l'adesione all'assicurazione che copre ",
            num_question: 2,
            responses: ["Si", "No/Non ricordo/Non ho sottoscritto nulla"],
            fieldToStore: "D3"
          },
          {
            label:
            "Vedo, inoltre, che il suo finanziamento ha una durata pari a " +
            IntervistaIntegrativo.Num_Rate__c +
            " mesi; " +
            "si ricorda che "+  plurale2Q3 + TipoConcat + plurale1Q3 +
            " una durata pari a " +
            durataSanitarie +
            " mesi?",
            num_question: 3,
            responses: ["Si", "No"],
            fieldToStore: "D4"
          },
          {
            label:
              "<p> Va bene " +
              this.getTitleAndName(component) +
              " , non si preoccupi. Per prima cosa tenga presente che nei documenti che le ha " +
              " rilasciato la filiale trova sia il contratto assicurativo sia le condizioni di Polizza.</p>" +
              "<p>Poi possiamo fare così: io le faccio comunque un breve riepilogo delle caratteristiche " +
              plurale1Q4 +
              "Dopo di che le consiglio di leggere attentamente le condizioni di polizza; questo genere di " +
              plurale2Q4 +
              " le può effettivamente essere utile!</p>" +
              "<p> Se poi ha ancora qualche dubbio, la invito a recarsi in filiale per rivedere la sua pratica con i colleghi. Sapranno sicuramente trovare la miglior soluzione per le sue esigenze.</p>" +
              "<p class='text_underline'> Tenga comunque presente che lei ha la facoltà di recedere dall assicurazion entro i termini riportati sulle condizioni di Polizza in suo possesso.</p> <br><br>" +
              "<p> Se il cliente desidera fissare un appuntamento in filiale <a href='#'> FISSA APPUNTAMENTO</a> </p>" +
              "<p> Appuntamento Fissato:</p>",
            num_question: 4,
            responses: ["Si", "No"],
            fieldToStore: "D4"
          }
        ];
    },
  
    processQuestion1: function(component, responseQuestion) {
      var questions = component.get("v.questions");
      var responseSi = questions[0].responses[0];
      var responseNo = questions[0].responses[1];
      var responseNon = questions[0].responses[2];
      var newRiposte = component.get("v.newRiposte");
      newRiposte.D2__c = responseQuestion.value;
      component.set("v.newRiposte", newRiposte);
      if (responseQuestion.value == responseSi) {
        this.setComodityCheklist(component);
        var textTable =
          "Non si preoccupi " +
          this.getTitleAndName(component) +
          ", la chiamo proprio per farle un breve riepilogo delle caratteristiche " +
          this.getGender(component) +
          " che ha sottoscritto. In questo modo, saprà come comportarsi se mai dovesse averne bisogno.";
        component.set("v.textTable", textTable);
        component.set("v.showTable", true);
        component.set("v.intervistaFinita", true);
        console.log("On va à la fin de l'interview", responseSi);
      } else if (responseQuestion.value == responseNo) {
        this.archivedIntervista(component);
        /* Archiver l'intervista */
        //component.set("v.intervistaFinita", true);
        component.set("v.intervistaFinita", true);
        component.set("v.showTable", false);
      } else if (responseQuestion.value == responseNon) {
        var textLDefinizione = component.get('v.textLDefinizione');
        if(textLDefinizione == ''){
          textLDefinizione = this.getTextLDefinizione(
            component.get("v.comodityCheklist")
          );
          textLDefinizione += ". \n \n   Non ricorda di averla sottoscritta?";
          component.set('v.textLDefinizione', textLDefinizione);
          var q2 = questions[1];
          q2.label += textLDefinizione ;
        }
        component.set("v.makeInterview2", true);
        component.set("v.showTable", false);
      }
      component.set("v.makeInterview", false);
      component.set("v.startInterview", false);
    },
    processQuestion2: function(component, responseQuestion) {
      console.log('indexFlag', component.get("v.indexFlag"));
      console.log('assicurazioneCount', component.get("v.assicurazioneCount"));
      component.set("v.previousQuestion", 2);
      var questions = component.get("v.questions");
      var responseSi = questions[1].responses[0];
      var responseNo = questions[1].responses[1];
      var newRiposte = component.get("v.newRiposte");
      newRiposte.D3__c = responseQuestion.value;
      this.setComodityCheklist(component);
      if (responseQuestion.value == responseSi) {
        var textTable =
          "Perfetto " +
          this.getTitleAndName(component) +
          ", colgo allora l'occasione per farle un breve riepilogo delle caratteristiche " +
          this.getGender(component) +
          " che ha sottoscritto. In questo modo saprà come comportarsi se mai dovesse averne bisogno.";
        component.set("v.textTable", textTable);
        component.set("v.makeInterview3", false);
        component.set("v.intervistaFinita", false);
        var assicurazioneCount = component.get("v.assicurazioneCount");
        if (component.get("v.indexFlag") > 0 && assicurazioneCount > 0) {
          component.set("v.showTable", true);
          component.set("v.makeInterview3", true);
        }else{
          component.set("v.makeInterview3", false);
          component.set("v.intervistaFinita", true);
        }
      } else if (responseQuestion.value == responseNo) {
        component.set("v.textTable", "");
        component.set("v.makeInterview4", true);
        component.set("v.showTable", true);
        component.set("v.makeInterview3", false);
      }
      component.set("v.makeInterview2", false);
      component.set("v.makeInterview", false);
      component.set("v.startInterview", false);
    },
    processQuestion3: function(component, responseQuestion) {
      component.set("v.previousQuestion", 3);
      var newRiposte = component.get("v.newRiposte");
      newRiposte.D4__c = responseQuestion.value;
      this.archivedIntervista(component);
      component.set("v.startInterview", false);
      component.set("v.makeInterview", false);
      component.set("v.showTable", false);
      component.set("v.makeInterview2", false);
      component.set("v.makeInterview3", false);
      component.set("v.intervistaFinita", true);
    },
    processQuestion4: function(component, responseQuestion) {
      component.set("v.previousQuestion", 4);
      var newRiposte = component.get("v.newRiposte");
      newRiposte.D5__c = responseQuestion.value;
      this.archivedIntervista(component);
      var assicurazioneCount = component.get("v.assicurazioneCount");
      if (component.get("v.indexFlag") > 0 && assicurazioneCount > 0) {
        component.set("v.makeInterview4", false);
        component.set("v.showTable", true);
        component.set("v.makeInterview3", true);
      }else{
        component.set("v.makeInterview3", false);
        component.set("v.makeInterview4", false);
        component.set("v.showTable", false);
        /* Archiver l'intervista */
        component.set("v.intervistaFinita", true);
      }     
    },
    /**
     * @description : Archieved Intervista Integrativo
     * @author: Khadim Rassoul Ndeye
     * @date: 13/06/2019
     * @param component
     * @param String
     */
  
    archivedIntervista: function(component) {
      var intervista = component.get("v.IntervistaIntegrativo");
      intervista.COM_Data_Esito__c = new Date();
      intervista.Status__c = "Archived";
    },
    setComodityCheklist: function(component) {
      var comodityCheklist = component.get("v.comodityCheklist");
      var listOfStringCSERVNotExist = component.get(
        "v.listOfStringCSERVNotExist"
      );
      if (!comodityCheklist.length || !listOfStringCSERVNotExist.length) {
        console.log("Non comodityCheklist");
        console.log("Non listOfStringCSERVNotExist");
        var action = component.get("c.getCommodityCheck");
        var IntervistaIntegrativo = component.get("v.IntervistaIntegrativo");
        IntervistaIntegrativo.COM_Richiamare_il__c = new Date(
          IntervistaIntegrativo.COM_Richiamare_il__c
        );
        action.setParams({ interviewObj: IntervistaIntegrativo });
        action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === "SUCCESS") {
            var storeResponse = response.getReturnValue();
            console.log("getReturnValue", JSON.stringify(storeResponse));
            component.set("v.comodityCheklist", storeResponse.listCom);
            component.set(
              "v.listOfStringCSERVNotExist",
              storeResponse.listOfStringCSERVNotExist
            );
            component.set("v.indexFlag", storeResponse.index);
            var assicurazioneCount = storeResponse.assicurazioneCount;
            component.set("v.assicurazioneCount", assicurazioneCount);
            if(storeResponse.listOfStringCSERVNotExistCount > 0){
              component.set("v.comodityCheklistError", true);
  
            }else{
              component.set("v.comodityCheklistError", false);
  
            }
            component.set(
              "v.listOfStringCSERVNotExistCount",
              storeResponse.listOfStringCSERVNotExistCount
            );
            comodityCheklist = storeResponse.listCom;
            console.log("Taille assicurazioneCount >>", assicurazioneCount);
            var pluraleDomanda1 = "";
            if (assicurazioneCount == 1) {
              pluraleDomanda1 = "al pacchetto assicurativo facoltativo";
            } else if (assicurazioneCount > 1) {
              pluraleDomanda1 = "ai pacchetti assicurativi facoltativi";
            }
            component.set("v.pluraleDomanda1", pluraleDomanda1);
            component.set("v.questions", this.listQuestions(component));
          } else {
            this.showToast("Errore di caricamento dei dati!", "ERROR");
            console.log(
              "Errore di caricamento dei dati! >>>",
              response.getError()[0]
            );
          }
        });
        $A.enqueueAction(action);
      } else {
        console.log("Yes comodityCheklist");
      }
    },
    getTextLDefinizione: function(data) {
      //var data = component.get("v.comodityCheklist");
      var stringData = data
        .map(function(element) {
          return element.COM_CRMDefinizione__c;
        })
        .join(", ");
      return stringData;
      //console.log("data joined stringData", stringData);
    },
    getTitleAndName: function(component) {
      var IntervistaIntegrativo = component.get("v.IntervistaIntegrativo");
      var sexe = IntervistaIntegrativo.Ac_Sesso__c == "M" ? "Sig. " : "Sig.ra ";
      return sexe + IntervistaIntegrativo.Ac_Rag_Sociale_1__c;
    },
    setProcessing: function(component) {
      var intervista = component.get("v.IntervistaIntegrativo");
      intervista.COM_Richiamare_il__c = new Date(intervista.COM_Richiamare_il__c);
      intervista.COM_Data_Esito__c = new Date();
      intervista.Status__c = "Processing";
      intervista.COM_Intervista_Utile__c = "N";
      var action = component.get("c.updateIntervista");
      action.setParam("param", intervista);
      action.setCallback(this, function(response) {
        console.log("response setProcessing", response);
        console.log("state response setProcessing", response.getState());
        var state = response.getState();
        if (state === "SUCCESS") {
          component.set("v.IntervistaIntegrativo", response.getReturnValue());
          //this.showToast("Intervista in Processing!", "SUCCESS");
        } else {
          //this.showToast("Intervista no Processing!", "ERROR");
          console.log(response.getError()[0]);
        }
      });
      $A.enqueueAction(action);
    },
    redirect: function(component) {
      
      var eventToNavigate = $A.get("e.c:eventNavigateToIntervistaPenetrazione");
      //eventToNavigate.setParams({intervistaPenetrazione: component.get("v.IntervistaIntegrativo")});
      eventToNavigate.fire();
    },
    /**
     * @description : define gender delle/e assicurazione/i facoltativa/e
     * @author: Khadim Rassoul Ndeye
     * @date: 13/06/2019
     * @param component
     * @param String
     */
    getGender: function(component) {
      var assicurazioneCount = component.get("v.assicurazioneCount");
      var listOfStringCSERVNotExistCount = component.get(
        "v.listOfStringCSERVNotExistCount"
      );
      var a = "";
      if (assicurazioneCount == 1 || listOfStringCSERVNotExistCount == 1) {
        a = " dell'assicurazione facoltativa ";
      }
       if (assicurazioneCount > 1 || listOfStringCSERVNotExistCount > 1) {
        a = " delle assicurazioni facoltative ";
      }
      return a;
    },
    cancelQuestion1: function(component) {
      var newRiposte = component.get("v.newRiposte");
      newRiposte.D2__c = "";
      component.set("v.newRiposte", newRiposte);
      component.set("v.makeInterview", false);
      component.set("v.startInterview", true);
      component.set("v.intervistaFinita", false);
      component.set("v.showTable", false);
    },
    cancelQuestion2: function(component) {
      var newRiposte = component.get("v.newRiposte");
      newRiposte.D3__c = "";
      component.set("v.newRiposte", newRiposte);
      component.set("v.startInterview", false);
      component.set("v.makeInterview", true);
      component.set("v.makeInterview2", false);
      component.set("v.intervistaFinita", false);
      component.set("v.showTable", false);
    },
    cancelQuestion3: function(component) {
      var newRiposte = component.get("v.newRiposte");
      newRiposte.D4__c = "";
      component.set("v.newRiposte", newRiposte);
      component.set("v.startInterview", false);
      component.set("v.makeInterview", false);
      component.set("v.makeInterview2", true);
      component.set("v.makeInterview3", false);
      component.set("v.makeInterview4", false);
      component.set("v.intervistaFinita", false);
      component.set("v.showTable", false);
    },
    cancelQuestion4: function(component) {
      var newRiposte = component.get("v.newRiposte");
      newRiposte.D4__c = "";
      component.set("v.startInterview", false);
      component.set("v.makeInterview", false);
      component.set("v.makeInterview2", true);
      component.set("v.makeInterview3", false);
      component.set("v.makeInterview4", false);
      component.set("v.intervistaFinita", false);
      component.set("v.showTable", false);
    },
    cancelPreviousQuestion1: function(component) {
      component.set("v.fissareAppuntamento", false);
      component.set("v.startInterview", false);
      component.set("v.isDisponibile", true);
      component.set("v.makeInterview", false);
    },
    cancelPreviousQuestion2: function(component) {
      component.set("v.fissareAppuntamento", false);
      component.set("v.startInterview", true);
      component.set("v.makeInterview", false);
    },
  
    getFormattedDate: function(todayTime) {
      var today = new Date(todayTime);
      var dd = today.getDate();
      var mm = today.getMonth() + 1;
      //January is 0!
      var yyyy = today.getFullYear();
      if (dd < 10) {
        dd = "0" + dd;
      }
      if (mm < 10) {
        mm = "0" + mm;
      }
      return dd + "/" + mm + "/" + yyyy;
    },
    getAssicurazioneName: function(component) {
      var listOfStringCSERVNotExistCount = component.get(
        "v.listOfStringCSERVNotExistCount"
      );
      var assicurazioneCount = component.get("v.assicurazioneCount");
      var name = "";
      if (assicurazioneCount > 0) {
        name = component
          .get("v.comodityCheklist")
          .map(function(element) {
            return element.COM_CRMTipo__c;
          })
          .join(", ");
      } else if (listOfStringCSERVNotExistCount > 0) {
        name += "<b>";
        var codeAss = component
          .get("v.listOfStringCSERVNotExist")
          .map(function(element) {
            return element;
          })
          .join(", ");
        name += codeAss;
        name +=
          " (</b> <b style = 'color:red;'>L'assicurazione con il codice descrizione " +
          codeAss +
          " del cliente non è presente a sistema CRM</b>.)";
      }
      return name;
    },
    getRispostaIntervista: function(component) {
      var intervista = component.get("v.IntervistaIntegrativo");
      var action = component.get("c.getRisposta");
      action.setParam("intervistaId", intervista.Id);
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS"){
          component.set("v.risposte", response.getReturnValue().data);
        }else{
          this.showToast("Ottenere Risposta non effettuato!", "ERROR");
        }
      });
      $A.enqueueAction(action);
    },
    getAssicurazioneTipoDefizione: function(component) {
      var listOfStringCSERVNotExistCount = component.get(
        "v.listOfStringCSERVNotExistCount"
      );
      var assicurazioneCount = component.get("v.assicurazioneCount");
      var name = "";
      if (assicurazioneCount > 0) {
        name = component
          .get("v.comodityCheklist")
          .map(function(element) {
            return element.COM_CRMTipo__c +" che è una "+ element.COM_CRMDefinizione__c;
          })
          .join(", e una denominata ");
      } else if (listOfStringCSERVNotExistCount > 0) {
        name += "<b>";
        var codeAss = component
          .get("v.listOfStringCSERVNotExist")
          .map(function(element) {
            return element;
          })
          .join(", ");
        name += codeAss;
        name +=
          " (</b> <b style = 'color:red;'>L'assicurazione con il codice descrizione " +
          codeAss +
          " del cliente non è presente a sistema CRM</b>.)";
      }
      return name;
    }
  });