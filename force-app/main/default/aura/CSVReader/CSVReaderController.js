({
    handleUpload : function(cmp, evt, helper){
        helper.readCSV(cmp);
    },
    handleSave : function(cmp, evt, helper){
        helper.saveEscluso(cmp);
    },
})