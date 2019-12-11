public class TriggerData {

    public static Boolean isData(final TriggerData triggerData) {
        if (triggerData == null) return false;
        if (triggerData.itemList == null) return false;
        return triggerData.itemList.size() > 0;
    }

    public TriggerData(final List<sObject> itemList, final Map<Id, sObject> oldMap, final Map<Id, sObject> newMap) {
        this.itemList = itemList;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public List<sObject> itemList;
    public Map<Id, sObject> oldMap;
    public Map<Id, sObject> newMap;
}