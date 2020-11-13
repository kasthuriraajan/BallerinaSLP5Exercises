import ballerina/log;
import ballerina/sql;
import ballerina/java.jdbc;

public type Customer record {
        readonly int id;
        string firstname;
        string lastname;
        string email;
        int phone;
    };

public client class Client{



    private jdbc:Client dbClient;

    public function init(string url, string username, string password) returns error? {
        self.dbClient = check new (url, username, password);
    }

    public remote function getCustomer(int id) returns @tainted json|error?{

        stream<record{}, error> resultStream = self.dbClient->query(`SELECT * FROM Customers WHERE customerId = ${<@untainted>id}`);
        record {|record {} value;|}? entry = check resultStream.next();
        json|error customerInfo = ();

        if entry is record {|record {} value;|}{
            customerInfo = entry.value.cloneWithType(json);
            return customerInfo;
        }
    
    }

    public remote function postCustomer(Customer customer) returns string|error?{

        var exec =  self.dbClient->execute(`INSERT INTO Customers(customerId, firstName, lastName, phone, email) VALUES(${<@untainted>customer.id},${<@untainted>customer.firstname}, ${<@untainted>customer.lastname},${<@untainted>customer.phone},${<@untainted>customer.email})`);

        if exec is sql:ExecutionResult{
            return "Customer "+<@untainted> customer.firstname+" is added successfully!";              
        }
        else{
            log:printError(exec.toString());
            return exec.toString();
        }
   
    }

    public remote function putCustomer(Customer customer) returns string|error?{
        
        var exec =  self.dbClient->execute(`UPDATE Customers SET firstName = ${<@untainted>customer.firstname}, lastName= ${<@untainted>customer.lastname}, phone= ${<@untainted>customer.phone}, email= ${<@untainted>customer.email} WHERE customerId = ${<@untainted>customer.id};`);

        if exec is sql:ExecutionResult{
            log:printInfo(customer);
            return "Customer "+<@untainted> customer.firstname+" is updated successfully!";
        }
        else{
            var exececute =  self.dbClient->execute(`INSERT INTO Customers(customerId, firstName, lastName, phone, email) VALUES(${<@untainted>customer.id},${<@untainted>customer.firstname}, ${<@untainted>customer.lastname},${<@untainted>customer.phone},${<@untainted>customer.email})`);

            if exececute is sql:ExecutionResult{
                log:printInfo(customer);
                return "Customer "+<@untainted> customer.firstname+" is added successfully!";                
            }
            else{
                log:printError(exececute.toString());
                return exececute.toString();
            }
        }        
    }
    
    public remote function deleteCustomer(int id) returns string|error?{

        var exececute =  self.dbClient->execute(`DELETE FROM Customers WHERE customerId = ${<@untainted>id}`);
        if exececute is sql:ExecutionResult{
                return "Customer is deleted successfully!";              
            }
            else{
                log:printError(exececute.toString());
                return exececute.toString();
            }
    
    }    
}