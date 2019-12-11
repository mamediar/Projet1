({
	 handleOutgoingCalls : function(cmp) {
        /*var listener = function(payload) {
            sforce.opencti.setSoftphonePanelVisibility({
                visible : true,
                callback : function() {
                    if (cmp.isValid() && cmp.get('v.presence') != 'Unavailable') {
                        var attributes = {
                            'state' : 'Dialing',
                            'recordName' : payload.recordName,
                            'phone' : payload.number,
                            'title' : '',
                            'account' : '',
                            'presence' : cmp.get('v.presence')
                        };
                        cmp.getEvent('renderPanel').setParams({
                            type : 'c:callInitiatedPanel',
                            attributes : attributes
                        }).fire();
                    }
                }
            });
        };
        sforce.opencti.onClickToDial({
            listener : listener
        });*/
    }
})