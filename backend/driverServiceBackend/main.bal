import ballerina/http;
import ballerina/uuid;


service /driver on new http:Listener(9000) {

    resource function post addDriver(@http:Payload json payload) returns json {
        return {
            status: "successful",
            rideId: uuid:createType1AsString()
            };
    }

    resource function get drivers() returns json[] {
      return [
        {
            driverId : "1",
            status: "available"
        }, 
        {
            driverId : "2",
            status: "unavailable"
        }
      ];
    }

    resource function get driver/[string driverId] () returns json {
        if driverId == "1" {
            return {
                driverId: driverId,
                status: "available",
                vehicleNo: "KX-1111",
                category: "economy"
            };
        } else if driverId == "2" {
            return {
                driverId: driverId,
                status: "unavailable",
                vehicleNo: "CAR-2222",
                category: "luxury"
            };
        }
        return {
                driverId: "unavailable",
                status: "",
                vehicleNo: "",
                category: ""
            };
    }

    resource function post driver/[string driverId] () returns json {
        return {
                driverId: driverId,
                status: "unavailable",
                vehicleNo: "KX-1111",
                category: "economy"
            };
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