/**
 * @File Name          : SystemUtils.cls
 * @Description        :
 * @Author             : Andrea Vanelli
 * @Group              :
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 2019-7-1 16:27:04
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-7-1 16:19:31   Andrea Vanelli     Initial Version
 **/
public class SystemUtils {
	@AuraEnabled
	public static Boolean isSandbox() {
		return [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
	}
}