public class XCSGestioneNoteReclamiUtils {
    public static String buildNoteInserimento(Case c){
        String res='';
        List<String> fillersList=getFillers(c);
        res=XCS_TemplateUtils.buildTemplateByName('reclamiInserimento.body',fillersList);
        System.debug('XCSGestioneNoteReclamiUtils buildNoteInserimento res: '+res);
        return res;
    }
    
    public static String buildNoteChiusura(Case c){
        String res='';
        List<String> fillersList=getFillersChiusura(c);
        res=XCS_TemplateUtils.buildTemplateByName('reclamiChiusura.body',fillersList);
        System.debug('XCSGestioneNoteReclamiUtils buildNoteChiusura res: '+res);
        return res;
    }
    
    private static List<String> getFillers(Case c){
        List<String> res=new List<String>();
        res.add(c.Numero_Reclamo__c);
        res.add(XCSGestioneNoteReclamiUtils.getCaseNumber(c));
        res.add(buildCategoriaTemplate(c.Categoria_Riferimento__c));
        res.add(CaseUtils.getOwnerName(c.Id));
        res.add(buildFooter(c));
        return res;
    }
    
    private static List<String> getFillersChiusura(Case c){
        List<String> res=new List<String>();
        res.add(c.Numero_Reclamo__c);
        res.add(XCSGestioneNoteReclamiUtils.getCaseNumber(c));
        res.add(buildCategoriaTemplate(c.Categoria_Riferimento__c));
        res.add(CaseUtils.getOwnerName(c.Id));
        res.add(buildFooterChiusura(c));
        return res;
    }
    
    private static String buildCategoriaTemplate(String categId){
        String res='';
        XCS_Categoria__c categ=[select Id,Parent__c,Name from XCS_Categoria__c where Id=:categId];
        List<XCS_Categoria__c> catList=[select Id,Parent__c,Name from XCS_Categoria__c];
        res=buildCategTemplateByParent(categ,catList);
        System.debug('XCSGestioneNoteReclamiUtils buildCategoriaTemplate res: '+res);
        return res;
    }
    
    private static String buildCategTemplateByParent(XCS_Categoria__c categ,List<XCS_Categoria__c> data){
        if(String.isNotEmpty(categ.Parent__c)){
            XCS_Categoria__c temp;
            for(XCS_Categoria__c c:data){
                if(c.Id.equals(categ.Parent__c)){
                    temp=c;
                }
            }
            return buildCategTemplateByParent(temp,data)+' - '+categ.Name;
        }
        else{
            return categ.Name; 
        }
    }
    @testVisible
    private static String buildFooter(Case c){
        String res='';
        if(!c.Is_Sconosciuto__c){ 
            if(c.Referenced_Company__c.equals(XCSCompassConstants.COMPASS)){
                res+='(Abbuono : NO, Rimborso : NO, Risarcimento : NO)';
            }
            else if(c.Referenced_Company__c.equals(XCSCompassConstants.FUTURO)){
                res+='(Abbuono : NO, Rimborso Commissioni : NO, Rimborso Provvigioni/Accessorie : NO, ';
                res+='Rimborso Premio Assicurativo : NO, Rimborso Varie : NO, Rimborso Spese Legali : NO, Risarcimento : NO)';
            }
        } 
        return res;
    }
    
    @testVisible
    private static String buildFooterChiusura(Case c){
        String res='';
        if(!c.Is_Sconosciuto__c){ 
            if(c.Referenced_Company__c.equals(XCSCompassConstants.COMPASS)){
                res +='Abbuono : ' + (c.Abbuono_Chiusura__c ?  'SI' : 'NO'); 
                res +=' , Rimborso : '+ (c.Has_Rimborso_Accordato__c ?  'SI' : 'NO');
                res +=', Risarcimento : ' + (c.Has_Risarcimento_accordato__c ? 'SI' : 'NO');
            }
            else if(c.Referenced_Company__c.equals(XCSCompassConstants.FUTURO)){
                res +='Abbuono : ' + (c.Abbuono_Chiusura__c ?  'SI' : 'NO'); 
                res +=' , Rimborso Commissioni : '+ (c.F_Has_Rimborso_Commissioni_Out__c ?  'SI' : 'NO');
                res +=', Rimborso Provvigioni/Accessorie : ' + (c.F_Has_Rimborso_Provvigioni_Out__c ? 'SI' : 'NO');
                res +='Rimborso Premio Assicurativo : ' + (c.F_Has_Rimborso_Assicurativo_Out__c ? 'SI' : 'NO'); 
                res +=' , Rimborso Varie : ' + (c.F_Has_Rimborso_Varie_Out__c  ? 'SI' : 'NO');
                res +=', Rimborso Spese Legali : ' + (c.F_Has_Rimborso_Spese_Legali_Out__c ? 'SI' : 'NO');
                res +=' , Risarcimento :' + (c.Has_Risarcimento_accordato__c ? 'SI' : 'NO');
                
            }
        } 
        return res;
    }
    
    private static String getCaseNumber(Case c) {
        String x = 'xxx';
        List<Case> cc = [SELECT CaseNumber FROM Case WHERE Id =: c.Id];        
        if(cc.size() > 0){         	 
            	x = cc[0].CaseNumber;
        }
       return x; 
    } 
}