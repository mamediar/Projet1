public class XCSReclamiRulesCodeUtils {
    public static final List<String> RULES_NAMES=new List<String>{'1','2','3','4a','4b','5','6','7','8','9a','9b','10','11a','11b'};
    
    public static final Map<String,Map<String,Map<String,List<String>>>> RULES=new Map<String,Map<String,Map<String,List<String>>>>
    {
        'Compass'=>new Map<String,Map<String,List<String>>>
        {
            '2'=>new Map<String,List<String>>
            {
                'only'=>new List<String>{'DN_53'}
            },
            '3'=>new Map<String,List<String>>
            {
                'only'=>new List<String>{'DN_53','DN_52'}
            },
            '4a'=>new Map<String,List<String>>
            {
                'only'=>new List<String>{'DN_52','DN_53','DN_57'}
            },
            '4b'=>new Map<String,List<String>>
            {
                'only'=>new List<String>{'DN_53','DN_57'}
            },
            '5'=>new Map<String,List<String>>
            {
                'only'=>new List<String>{'DN_52'}
            },
            '6'=>new Map<String,List<String>>
            {
                'add'=>new List<String>{'DN_52','DN_57'}
            },
            '7'=>new Map<String,List<String>>
            {
                'hide'=>new List<String>{'DN_53'}
            },
            '8'=>new Map<String,List<String>>
            {
                'add'=>new List<String>{'DN_52'}
            },
            '9b'=>new Map<String,List<String>>
            {
                'all'=>new List<String>()
            },
            '10'=>new Map<String,List<String>>
            {
                'case'=>new List<String>{'DN_112'}
            },
            '11b'=>new Map<String,List<String>>
            {
                'hide'=>new List<String>{'DN_53'}
            }
        },
        'Futuro'=>new Map<String,Map<String,List<String>>>
        {
            '11b'=>new Map<String,List<String>>
            {
                'hide'=>new List<String>{'DN_298'}
            }
        },
        'MBCredit Solutions'=>new Map<String,Map<String,List<String>>>
        {
            '11b'=>new Map<String,List<String>>
            {
                'hide'=>new List<String>{'DN_342'}
            }
        }
    };
        
    public static Map<String,Boolean> applyRule(String societa,String ruleName,Map<String,Boolean> mapToFilter,Boolean check){
        if(RULES.get(societa).containsKey(ruleName)){
            System.debug('XCSReclamiRulesCodeUtils applyRule applico regola '+ruleName);
            mapToFilter=
                (
                    RULES.get(societa).get(ruleName).containsKey('only')?
                    showOnlyQueues(mapToFilter,RULES.get(societa).get(ruleName).get('only')):
                    RULES.get(societa).get(ruleName).containsKey('add')?
                    showQueues(mapToFilter,RULES.get(societa).get(ruleName).get('add')):
                    RULES.get(societa).get(ruleName).containsKey('hide')?
                    hideQueues(mapToFilter,RULES.get(societa).get(ruleName).get('hide')):
                    RULES.get(societa).get(ruleName).containsKey('all') && check?
                    hideAll(mapToFilter):
                    RULES.get(societa).get(ruleName).containsKey('all') && !check?
                    showAll(mapToFilter):
                    RULES.get(societa).get(ruleName).containsKey('case') && check?
                    hideQueues(mapToFilter,RULES.get(societa).get(ruleName).get('case')):
                    RULES.get(societa).get(ruleName).containsKey('case') && !check?
                    showQueues(mapToFilter,RULES.get(societa).get(ruleName).get('case')):
                    mapToFilter
                );
        }
        System.debug('XCSReclamiRulesCodeUtils applyRule res: '+mapToFilter);
        return mapToFilter;
    }
    
    private static Map<String,Boolean> hideAll(Map<String,Boolean> mapToFilter){
        System.debug('XCSReclamiRulesCodeUtils hideAll ');
        for(String k:mapToFilter.keySet()){
            mapToFilter.put(k,false);
        }
        return mapToFilter;
    }
    
    private static Map<String,Boolean> showAll(Map<String,Boolean> mapToFilter){
        System.debug('XCSReclamiRulesCodeUtils showAll ');
        for(String k:mapToFilter.keySet()){
            mapToFilter.put(k,true);
        }
        return mapToFilter;
    }
    
    private static Map<String,Boolean> showQueues(Map<String,Boolean> mapToFilter,List<String> filter){
        System.debug('XCSReclamiRulesCodeUtils showQueues '+filter);
        for(String k:mapToFilter.keySet()){
            if(filter.contains(k)){
                mapToFilter.put(k,true);
            }
        }
        return mapToFilter;
    }
    
    private static Map<String,Boolean> hideQueues(Map<String,Boolean> mapToFilter,List<String> filter){
        System.debug('XCSReclamiRulesCodeUtils hideQueues '+filter);
        for(String k:mapToFilter.keySet()){
            if(filter.contains(k)){
                mapToFilter.put(k,false);
            }
        }
        return mapToFilter;
    }
    
    private static Map<String,Boolean> showOnlyQueues(Map<String,Boolean> mapToFilter,List<String> filter){
        System.debug('XCSReclamiRulesCodeUtils showOnlyQueues '+filter);
        for(String k:mapToFilter.keySet()){
            if(filter.contains(k)){
                mapToFilter.put(k,true);
            }
            else{
                mapToFilter.put(k,false);
            }
        }
        return mapToFilter;
    }
}