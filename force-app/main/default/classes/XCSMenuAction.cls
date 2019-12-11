public abstract class XCSMenuAction {
    private Account account;
    private MenuConfigMatrix__mdt metadata;
    
    public Account getAccount(){return account;}
    public void setAccount(Account account){this.account = account;}
    public MenuConfigMatrix__mdt getMetadata(){return metadata;}
    public void setMetadata(MenuConfigMatrix__mdt metadata){this.metadata = metadata;}
    
    public virtual XCSMenuActionResult preRedirect(){return null;}
}