global class PostCloneSandbox implements SandboxPostCopy {
    
    global void runApexClass(SandboxContext context) {
        //System.debug('User ID: ' + context.userId());
        System.debug('Org ID: ' + context.organizationId());
        System.debug('Sandbox ID: ' + context.sandboxId());
        System.debug('Sandbox Name: ' + context.sandboxName());
        
        List<User> lst2Update=[select id,email from user ] ; //new List<User>();
        for(User u : lst2Update ){
            String mail=u.email;
            u.email=mail.replace('.invalid', '');
        }
		Database.update(lst2Update,false);
        // Insert logic here to prepare the sandbox for use.
    }


}