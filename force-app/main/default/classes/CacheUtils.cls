public class CacheUtils {
    
    private static CacheUtils INSTANCE;
    private static Map<String, Object> cacheMap = new Map<String, Object>();
    
    private static String TOWN_CACHE_KEY = 'towns';
    private static String TOWN_GROUP_KEY = 'towns.group';
	
    private CacheUtils()
    {
        
    }
    
    public Object getObject( String key )
    {
        return cacheMap.get( key );
    }
    
    public void putObject( String key, Object obj )
    {
        cacheMap.put(key, obj);
    }
    
    public static CacheUtils getInstance()
    {
        system.debug('CacheUtils instance: ' + INSTANCE );
        if ( INSTANCE == null )
    		INSTANCE = new CacheUtils();
        
        return INSTANCE;

	}
    
    public XCS_Town__c[] getProvince()
    {
        if( getObject( TOWN_CACHE_KEY )  == null )
        	putObject( TOWN_CACHE_KEY, [SELECT Id,Provincia__c,Comune__c,CAP__c,Soppresso__c,Provincia_Desc__c,Catastale__c FROM XCS_Town__c] ); 
        
        return (XCS_Town__c[]) getObject( TOWN_CACHE_KEY );
    }


        
    @InvocableMethod
    public static void manageCache(String[] lst){
        
    }
    
    public static void ricercaClienteCache(){
        
    }


}