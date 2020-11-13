import ballerina/log;
import ballerina/http;
import ballerina/sql;
import ballerina/java.jdbc;

jdbc:Client dbClient=   check new ("jdbc:mysql://localhost:3306/customer?serverTimezone=UTC","root","");

type Customer record {
        readonly int id;
        string firstname;
        string lastname;
        string email;
        int phone;
    };

@http:ServiceConfig {
    basePath:"/"
}

service customerService on new http:Listener(9090) {    

    @http:ResourceConfig {
        methods:["GET"],
        path:"/customer/{id}"
    }
    resource function getCustomer(http:Caller caller, http:Request req, int id) returns @tainted error?{

        stream<record{}, error> resultStream = dbClient->query(`SELECT * FROM Customers WHERE customerId = ${<@untainted>id}`);
        record {|record {} value;|}? entry = check resultStream.next();

        if entry is record {|record {} value;|}{
            json|error customerInfo = entry.value.cloneWithType(json);
            check caller->respond(check <@untainted>customerInfo);
        }
        else{
            check caller->notFound("Customer is not found.");
        }
    
    }

    @http:ResourceConfig {
        methods:["POST"],
        path:"/customer",
        body:"customer"
    }
    resource function postCustomer(http:Caller caller, http:Request req,Customer customer) returns error?{

        var exec =  dbClient->execute(`INSERT INTO Customers(customerId, firstName, lastName, phone, email) VALUES(${<@untainted>customer.id},${<@untainted>customer.firstname}, ${<@untainted>customer.lastname},${<@untainted>customer.phone},${<@untainted>customer.email})`);

        if exec is sql:ExecutionResult{
            log:printInfo(customer);
            check caller-> ok("Customer "+<@untainted> customer.firstname+" is added successfully!");              
        }
        else{
            log:printError(exec.toString());
            check caller-> internalServerError(exec.toString());
        }
   
    }

    @http:ResourceConfig {
        methods:["PUT"],
        path:"/customer",
        body:"customer"
    }
    resource function putCustomer(http:Caller caller, http:Request req, Customer customer) returns error?{
        
        var exec =  dbClient->execute(`UPDATE Customers SET firstName = ${<@untainted>customer.firstname}, lastName= ${<@untainted>customer.lastname}, phone= ${<@untainted>customer.phone}, email= ${<@untainted>customer.email} WHERE customerId = ${<@untainted>customer.id};`);

        if exec is sql:ExecutionResult{
            log:printInfo(customer);
            check caller-> ok("Customer "+<@untainted> customer.firstname+" is updated successfully!");              
        }
        else{
            var exececute =  dbClient->execute(`INSERT INTO Customers(customerId, firstName, lastName, phone, email) VALUES(${<@untainted>customer.id},${<@untainted>customer.firstname}, ${<@untainted>customer.lastname},${<@untainted>customer.phone},${<@untainted>customer.email})`);

            if exececute is sql:ExecutionResult{
                log:printInfo(customer);
                check caller-> ok("Customer "+<@untainted> customer.firstname+" is added successfully!");              
            }
            else{
                log:printError(exececute.toString());
                check caller-> internalServerError(exececute.toString());
            }
        }        
    }
    
    @http:ResourceConfig {
        methods:["DELETE"],
        path:"/customer/{id}"
    }
    resource function deleteCustomer(http:Caller caller, http:Request req, int id) returns @tainted error?{

        var exececute =  dbClient->execute(`DELETE FROM Customers WHERE customerId = ${<@untainted>id}`);
        if exececute is sql:ExecutionResult{
                check caller-> ok("Customer is deleted successfully!");              
            }
            else{
                log:printError(exececute.toString());
                check caller-> internalServerError(exececute.toString());
            }
    
    }    
}