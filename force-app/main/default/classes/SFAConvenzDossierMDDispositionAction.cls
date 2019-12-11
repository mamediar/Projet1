public class SFAConvenzDossierMDDispositionAction extends XCSDispositionAction
{

    public override XCSDispositionResult execute()
    {
        Case c = (Case)getSObject();
        XCS_Disposition__c disposition = (XCS_Disposition__c)getDisposition();

        if(disposition.External_Id__c==XCS_DispositionUtils.DOSSIER_COMPLETO_INSPEDIZIONE){
            //vedere a chi assegnare il case e che altre azioni eseguire
        } else if(disposition.External_Id__c==XCS_DispositionUtils.DOSSIER_DISPONIBILE){
            //vedere a chi assegnare il case e che altre azioni eseguire
        }
        
        
        XCSDispositionResult response = new XCSDispositionResult();
        //response.result = ;
        //response.messagge = ;
        system.debug(response);
        return response;
    }
}