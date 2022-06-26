import ballerina/lang.value;
import ballerina/http;
import ballerina/uuid;


service /ride on new http:Listener(9000) {

    resource function post addRide(@http:Payload json payload) returns json {
        return {
            status: "successful",
            rideId: uuid:createType1AsString()
            };
    }

    resource function get calculateCost(int? distance, int? waitingTimeInMin) returns json {
        float cost = 0;
        if distance is int {
            if distance < 1000 {
                cost = 4.5;
            } else {
                cost = 4.5 + 3.5 * (<float>(distance - 1000)/1000);
            }

            if waitingTimeInMin is int {
                cost += <float> (1 * waitingTimeInMin);
            }
            return {cost : cost};
        }   
        return {cost : 0};
    }

    resource function get rideDetails/[string rideId] () returns json {
        if rideId == "1" {
            return { 
                rideId : rideId,
                passengerId : "passengerId1",
                driverId : "driverId1",
                distance: 10000,
                cost: 35,
                status: "completed"
                };
        } else if rideId == "2" {
            return { 
                rideId : rideId,
                passengerId : "passengerId2",
                driverId : "driverId2",
                distance: 0,
                cost: 0,
                status: "scheduled"
                };
        }
        return { 
                rideId : "",
                passengerId : "<empty>",
                driverId : "<empty>",
                distance: 0,
                cost: 0,
                status: "unavailable"
                };
    }

    resource function post rideDetails/[string rideId] (@http:Payload json payload) returns json {
        any|error status = value:ensureType(payload.status, string);
        any|error distance = value:ensureType(payload.distance, int);
        any|error cost = value:ensureType(payload.distance, float);
        
        string finalStatus = "";
        int finalDistance = 0;
        float finalCost = 0;

        if status is string {
            finalStatus = status;
        }
        if distance is int {
            finalDistance = distance;
        }
        if cost is float {
            finalCost = cost;
        }
        return 
            { 
            rideId : rideId,
            distance: finalDistance,
            cost: finalCost,
            status: finalStatus
            };
    }   

    resource function get rideDetailsSummary () returns json[] {
      return [
        {
            rideId : "1",
            status: "completed"
        }, 
        {
            rideId : "2",
            status: "scheduled"
        }
      ];
    }

    
}

service /probes on new http:Listener(9091) {
    resource function get healthz () returns string {
      return "healthy";
    }

    resource function get readyz () returns string {
      return "ready";
    }
}