public class PermissionSetTestController{
	@AuraEnabled
    public static Boolean hasPermission(String permissionName){
        System.debug('PermissionSetTestController hasPermission permissionName: '+permissionName);
        System.debug('PermissionSetTestController hasPermission user: '+Userinfo.getFirstName());
        System.debug('PermissionSetTestController hasPermission res: '+FeatureManagement.checkPermission(permissionName));
        return (FeatureManagement.checkPermission(permissionName));
    }
}