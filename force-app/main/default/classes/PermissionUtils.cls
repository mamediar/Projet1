public class PermissionUtils {
    public static final String BRANCH_EMPLOYEE='Branch Employee';
    public static final String BRANCH_MANAGER='Branch Manager';
    
    public static String getPermissionName(){
        String res = '';
        try{
            PermissionSet ps = [SELECT Id, Name 
                                FROM PermissionSet 
                                WHERE id In (SELECT PermissionSetId 
                                             FROM PermissionSetAssignment                                                                      
                                             WHERE AssigneeId =: UserInfo.getUserId())
                                AND Name In : CompassParametersUtils.getListValues('venditaAssicurazioni.cc.list')];
            res = ps.Name;
        } catch(Exception e){System.debug('ERRORE nel metodo PermissionUtils.getPermissionName(), Nessun PermissionSet trovato.');}
        return res;
    }   
    
    public static Boolean isAbilitatoVendita(){
        return FeatureManagement.checkPermission('ABILITAZIONE_VENDITA');
    } 
    
    public static Boolean isNET(){
        return FeatureManagement.checkPermission('NET');
    } 
    
    public static Boolean isCallCenterInterno(){
        return FeatureManagement.checkPermission('Call_Center_Interno');
    } 
    
    public static Boolean isVisiant(){
        return FeatureManagement.checkPermission('Visiant');
    }    
    
    public static Boolean isNumBlu(){
        return FeatureManagement.checkPermission('Num_Blu');
    }    
    
    public static Boolean isGDV(){
        return FeatureManagement.checkPermission('GDV');
    }

    public static Boolean isAV(){
        return FeatureManagement.checkPermission('DCR_AV');
    }

    public static Boolean isBranchEmployee(Id userId){
        //return FeatureManagement.checkPermission('ABILITAZIONE_VENDITA');        
        return  [select id,name,profile.name from User where id=:userId and profile.name=:BRANCH_EMPLOYEE].size()>0;        
    }

    public static Boolean isBranchManager(Id userId){
        //return FeatureManagement.checkPermission('ABILITAZIONE_VENDITA');
        return [select id,name,profile.name from User where id=:userId and profile.name=:BRANCH_MANAGER].size()>0;        
    }

    public static Boolean isBranch(Id userId){
        //return FeatureManagement.checkPermission('ABILITAZIONE_VENDITA');
        return  [select id,name,profile.name,UserRole.Name from User where id=:userId and profile.name in (:BRANCH_MANAGER, :BRANCH_EMPLOYEE)].size()>0;
    }

    public static Boolean isCoordinatore(){
        //return FeatureManagement.checkPermission('ABILITAZIONE_VENDITA');
        return true;
    }
}