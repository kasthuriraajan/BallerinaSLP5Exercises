import ballerina/io;
import ballerina/test;

string apiKey = "<your API key here";

@test:Config{}
function testGetByCityName(){

    OpenWeatherClient openWeatherClient = new(apiKey);

    io:println("\n ---------------------------------------------------------------------------");

    json|error result = openWeatherClient->getByCityName("Colombo",(),("lk"));

    if result is json{
        io:println(result);

    }else{
        test:assertFail(result.message());
    }
}

@test:Config{}
function testGetByCityId(){

    OpenWeatherClient openWeatherClient = new(apiKey);

    io:println("\n ---------------------------------------------------------------------------");

    json|error result = openWeatherClient->getByCityId("80000");

    if result is json{
        io:println(result);

    }else{
        test:assertFail(result.message());
    }
}

@test:Config{}
function testGetByCoord(){

    OpenWeatherClient openWeatherClient = new(apiKey);

    io:println("\n ---------------------------------------------------------------------------");

    json|error result = openWeatherClient->getByCoord("51","51");

    if result is json{
        io:println(result);

    }else{
        test:assertFail(result.message());
    }
}

@test:Config{}
function testGetByZipCode(){

    OpenWeatherClient openWeatherClient = new(apiKey);

    io:println("\n ---------------------------------------------------------------------------");

    json|error result = openWeatherClient->getByZipCode("40000");

    if result is json{
        io:println(result);

    }else{
        test:assertFail(result.message());
    }
}
