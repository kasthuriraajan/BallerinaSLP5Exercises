import ballerina/log;
import ballerina/http;

type Customer record {
        readonly int id;
        string firstname;
        string lastname;
        string email;
        int phone;
    };

type CustomerTable table<Customer>key(id);
CustomerTable customerTable = table [];

@http:ServiceConfig {
    basePath:"/"
}

service customerService on new http:Listener(9090) {
    

    @http:ResourceConfig {
        methods:["GET"],
        path:"/customer/{id}"
    }
    resource function getCustomer(http:Caller caller, http:Request req, int id) returns error? {

        json|error customerInfo = customerTable[id].cloneWithType(json);

        check caller->respond(check customerInfo);
    }

    @http:ResourceConfig {
        methods:["POST"],
        path:"/customer",
        body:"customer"
    }

    resource function postCustomer(http:Caller caller, http:Request req,Customer customer) returns error?{
        log:printInfo(customer);
        customerTable.add(customer);
        check caller-> ok("Customer "+<@untainted> customer.firstname+" is added successfully!");     
    }

    @http:ResourceConfig {
        methods:["PUT"],
        path:"/customer",
        body:"customer"
    }

    resource function putCustomer(http:Caller caller, http:Request req, Customer customer) returns error?{
        log:printInfo(customer);
        customerTable.put(customer);
        check caller-> ok("Customer "+<@untainted> customer.firstname+" is updated successfully!");        
    }    
}