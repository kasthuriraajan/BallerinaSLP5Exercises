import ballerina/http;
import ballerina/log;
import ballerina/oauth2;

oauth2:OutboundOAuth2Provider oauth2Provider = new ({
    accessToken: "<Access token from Fb API>",
    refreshConfig: {
        clientId: "<Client ID from FB Apps>",
        clientSecret:"<Client Secret from FB Apps>",
        refreshToken: "<Refresh token>",
        refreshUrl: "https://graph.facebook.com/oauth/access_token>",
        clientConfig: {
            secureSocket: {
                trustStore: {
                    path: "/usr/lib/ballerina/distributions/ballerina-slp5/bre/security/ballerinaTruststore.p12",
                    password: "ballerina"
                }
            }
        }
    }
});

http:BearerAuthHandler oauth2Handler = new (oauth2Provider);

http:Client clientEP = new ("https://graph.facebook.com", {
    auth: {
        authHandler: oauth2Handler
    },
    secureSocket: {
        trustStore: {
            path: "/usr/lib/ballerina/distributions/ballerina-slp5/bre/security/ballerinaTruststore.p12",
            password: "ballerina"
        }
    }
});
public function main() {

    var response = clientEP->get("/me");
    if (response is http:Response) {
        json|error result = response.getJsonPayload();
        if(result is json){
            map<json> details= <map<json>> result;
            log:printInfo(details["name"]);
        }
        
        log:printInfo(
                    (result is error) ? "Failed to retrieve payload." : result);
                    
    } else {
        log:printError("Failed to call the endpoint.");
    }
}