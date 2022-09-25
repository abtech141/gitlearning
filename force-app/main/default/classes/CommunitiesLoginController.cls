/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class CommunitiesLoginController {

    global CommunitiesLoginController () {}
    
    // Code we will invoke on page load.
    global PageReference forwardToAuthPage() {
    	String startUrl = System.currentPageReference().getParameters().get('startURL');
    	String displayType = System.currentPageReference().getParameters().get('display');
        return Network.forwardToAuthPage(startUrl, displayType);
    }
    
    global PageReference forwardToCustomAuthPage() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
         String exid = System.currentPageReference().getParameters().get('expid_demomusab');
        if(exid == '1234')
        return new PageReference(Site.getPathPrefix() + '/testsignin?startURL=' + EncodingUtil.urlEncode(startURL, 'UTF-8'));
    else return null;
        
    }
}