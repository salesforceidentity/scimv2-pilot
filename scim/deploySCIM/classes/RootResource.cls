@RestResource(urlMapping='/scim/v2/*')
global class RootResource {
    
    @HttpGet
    global static void doGet() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        res.statusCode = 200; 
        res.responseBody = serializeConfigs(req.headers.containsKey('X-Prettyprint'));
        
    }  
    
    private static Boolean isIndividualEnabled(){
        Integer indCount = [select count() FROM EntityDefinition WHERE DeveloperName = 'Individual' ];
        if (indCount == 1) {
            return true;
        } else return false;

    }

    private static Blob serializeConfigs(boolean prettyPrint) {
        JSONGenerator gen = JSON.createGenerator(prettyPrint);
        gen.writeStartObject();
            gen.writeStringField('Users', '/services/apexrest/scim/v2/Users');
            gen.writeStringField('Groups', '/services/apexrest/scim/v2/Groups');
            gen.writeStringField('Roles', '/services/apexrest/scim/v2/Roles');        
            gen.writeStringField('Entitlements', '/services/apexrest/scim/v2/Entitlements');
            gen.writeStringField('ResourceTypes', '/services/apexrest/scim/v2/ResourceTypes');
            gen.writeStringField('ServiceProviderConfig', '/services/apexrest/scim/v2/ServiceProviderConfig');
            gen.writeStringField('Schemas', '/services/apexrest/scim/v2/Schemas');
            if (isIndividualEnabled()) gen.writeStringField('Individual', '/services/apexrest/scim/v2/Individuals');
        gen.writeEndObject();
        return Blob.valueOf(gen.getAsString());
    }
}