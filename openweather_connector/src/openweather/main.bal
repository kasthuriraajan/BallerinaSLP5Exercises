import ballerina/http;

public client class OpenWeatherClient{

    private string apiKey;
    private string baseUrl = "https://api.openweathermap.org/data/2.5/weather";
    private http:Client basicClient;

    public function init(string apiKey) {
        self.apiKey  = apiKey;

        self.basicClient = new (self.baseUrl, {
            secureSocket: {
                trustStore: {
                    path: "/usr/lib/ballerina/distributions/ballerina-slp5/bre/security/ballerinaTruststore.p12",
                    password: "ballerina"
                }
            }
        });
    }

    public remote function getByCityName(string cityName, string? stateCode, string? countryCode) returns @tainted json|error {

        http:Response? result = new;

        if stateCode is string && countryCode is string {

            result = <http:Response>self.basicClient->get(string `?q=${cityName},${stateCode},${countryCode}&appid=${self.apiKey}`);

        }else if stateCode is string {

            result = <http:Response>self.basicClient->get(string `?q=${cityName},${stateCode}&appid=${self.apiKey}`);

        }else {
        
            result = <http:Response>self.basicClient->get(string `?q=${cityName}&appid=${self.apiKey}`);
        }
        
        if result is http:Response{
            if (result.statusCode == http:STATUS_OK) {
                return result.getJsonPayload();

            } else {

                error err = error("error occurred while sending GET request");
                return err;
            }
        }else{

            error err = error("couldn't fetch data");
            return err;
        }        
    }

    public remote function getByCityId(string cityId) returns @tainted json|error{

        var result = self.basicClient->get(string `?q=${cityId}&appid=${self.apiKey}`);

        http:Response response = <http:Response>result;
        if (response.statusCode == http:STATUS_OK) {

            return response.getJsonPayload();
        } else {
            
            error err = error("error occurred while sending GET request");
            return err;
        }                
    }
 
    public remote function getByCoord(string lat, string lon) returns @tainted json|error{

        var response = self.basicClient->get(string `?lat=${lat}&lon=${lon}&appid=${self.apiKey}`);

        http:Response coordresponse = <http:Response>response;
        if (coordresponse.statusCode == http:STATUS_OK) {
            
            return coordresponse.getJsonPayload();

        } else {

            error err = error("error occurred while sending GET request");
            return err;
        }
    }

    public remote function getByZipCode(string zipCode, string countryCode="lk") returns @tainted json|error{

        var response = self.basicClient->get(string `?zip=${zipCode},${countryCode}&appid=${self.apiKey}`);

        http:Response zipresponse = <http:Response>response;
        if (zipresponse.statusCode == http:STATUS_OK) {
            
            return zipresponse.getJsonPayload();

        } else {

            error err = error("error occurred while sending GET request");
            return err;
        }
    }

    
}
