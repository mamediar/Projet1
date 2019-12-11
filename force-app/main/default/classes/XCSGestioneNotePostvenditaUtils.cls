public class XCSGestioneNotePostvenditaUtils {
    // METODI POST
    
    public static String buildNoteVariazioneAnagrafica(String caseId,String note){
        String noteOCS=buildHeadAndFoot(buildBodyVariazioneAnagrafica(caseId,note),caseId);
        System.debug('XCSGestioneNotePostvenditaUtils buildNoteVariazioneAnagrafica res: '+noteOCS);
        return noteOCS;
    }
    //METODI UTILITY
    private static String buildHeadAndFoot(String template,String caseId){
        return buildHeader(caseId)+template+buildFooter(caseId);
    }
    
    private static String buildHeader(String caseId){
        return XCS_TemplateUtils.buildTemplateByName('postvendita.header',getHeadFootFillersVariazioneAnagrafica(caseId));
    }
    
    private static String buildFooter(String caseId){
        return XCS_TemplateUtils.buildTemplateByName('postvendita.footer',getHeadFootFillersVariazioneAnagrafica(caseId));
    }
    
    private static String buildBodyVariazioneAnagrafica(String caseId,String note){
        return XCS_TemplateUtils.buildTemplateByName('variazioneAnagrafica.body',getBodyFillersVariazioneAnagrafica(caseId,note));
    }
    
    private static List<String> getHeadFootFillersVariazioneAnagrafica(String caseId){
        List<String> res=new List<String>();
        res.add([select CaseNumber from Case where Id=:caseId].CaseNumber);
        System.debug('XCSGestioneNotePostvenditaUtils getHeadFootFillersVA res: '+res);
        return res;
    }
    
    private static List<String> getBodyFillersVariazioneAnagrafica(String caseId,String note){
        List<String> res=new List<String>();
        List<UserRole> roles=[select Name from UserRole where Id=:UserInfo.getUserRoleId()];
        String role='[Null Role]';
        if(roles.size()>0){role=roles[0].Name;}
        res.add(role);
        res.add([select Alias from User where Id=:UserInfo.getUserId()].Alias);
        res.add(CaseUtils.getEsito(caseId));
        res.add(note);
        System.debug('XCSGestioneNotePostvenditaUtils getBodyFillersVA res: '+res);
        return res;
    }

}