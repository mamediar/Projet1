({
	readFile: function (component, file, helper) {
		if (!file) return;
		console.log('file' + file.name);
		if (!file.name.match(/\.(csv||CSV)$/)) {
			return console.log('only support csv files');
		} else {

			reader = new FileReader();
			reader.onerror = function errorHandler(evt) {
				switch (evt.target.error.code) {
					case evt.target.error.NOT_FOUND_ERR:
						console.log('File Not Found!');
						break;
					case evt.target.error.NOT_READABLE_ERR:
						console.log('File is not readable');
						break;
					case evt.target.error.ABORT_ERR:
						break; // noop
					default:
						console.log('An error occurred reading this file.');
				};
			}
			//reader.onprogress = updateProgress;
			reader.onabort = function (e) {
				console.log('File read cancelled');
			};
			reader.onloadstart = function (e) {

				var output = '<ui type=\"disc\"><li><strong>' + file.name + '</strong> ' + file.size + 'bytes</li></ui>';
				component.set("v.filename", file.name);
				component.set("v.TargetFileName", output);
				component.set('v.cancelUploadFile', false);
				component.set('v.showcConfirm', true);

			};
			reader.onload = function (e) {
				var data = e.target.result;
				var headersList = component.get('v.headerList');
				component.set("v.fileContentData", data);
				console.log("file data" + JSON.stringify(data));
				var allTextLines = data.split(/\r\n|\n/);
				var dataRows = allTextLines.length - 1;
				var headers = allTextLines[0].split(';');
				console.log("header length : " + JSON.stringify(headers.length));
				console.log("Rows length::" + dataRows);
				var numOfRows = component.get("v.NumOfRecords");
				console.log("numOfRows::" + numOfRows);
				if (dataRows > numOfRows + 1 || dataRows == 1 || dataRows == 0) {

					console.log("File Rows between 1 to " + numOfRows + " .");
					// component.set("v.showMain",false);

				}
				else {
					// component.set("v.showMain",true);                   
				}
				if (headers.length > 0 && headersList.length > 0) {
					var result = helper.verify2HeadersisEquals(headersList, headers);
					if (result == false) {
						component.set('v.errorMsg', 'Il file inserito non è corretto');
						component.set('v.showcConfirm', false);
					}
					else {
						helper.checkRecords(component,data);
						component.set('v.errorMsg', '');
					}

				}

			}
			reader.readAsText(file);

		}
		var reader = new FileReader();
		reader.onloadend = function () {

		};
		reader.readAsDataURL(file);
	},
	verify2HeadersisEquals: function (headerList1, headerList2) {
		headerList1 = this.deleteSpaceList(headerList1);
		headerList2 = this.deleteSpaceList(headerList2);
		console.log('headerList1 length:' + headerList1.length);
		console.log('headerList2 length :' + headerList2.length);
		console.log('headerList1 :' + headerList1);
		console.log('headerList2 :' + headerList2);
		var tmp = true;
		if (headerList1.length == headerList2.length) {
			for (var i = 0; i < headerList1.length; i++) {
				var regex = new RegExp("\"","g");
				headerList1[i] = headerList1[i].replace(regex , "");
				headerList2[i]= headerList2[i].replace(regex, "");
				console.log(headerList1[i] + ' / ' + headerList2[i]);

				if (headerList1[i] != headerList2[i]) {
					//tmp = false;
				}
			}
		} else {
			tmp = false;
		}
		console.log('tmp ' + tmp);
		return tmp;
	},
	deleteSpaceList: function (headerList) {
		var headerListString = JSON.stringify(headerList);
		headerListString = headerListString.replace(/ /g, "");
		headerList = headerListString.split(',');
		return headerList;
	},
	checkRecords : function(component,dataFile){
        var action = component.get("c.checkRecordsCSV");
		console.log('selectTipoFile:'+component.get('v.selectTipoFile'));
		console.log('prodotto:'+component.get('v.selectProdotto'));
        action.setParams({ fileData : dataFile,
						  prodotto: component.get('v.selectProdotto'),
                          tipoFile: component.get('v.selectTipoFile'),
                        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var errorsRec = response.getReturnValue();
                console.log('errorsRec: '+errorsRec);
				component.set('v.errorsRecords', errorsRec);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
                        
        });
        $A.enqueueAction(action);
	},
	confirmUpload: function (component, file, helper) {
		console.log('ready to load file:'+file);
	},


})