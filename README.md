# Proto Merge
CLI utility to resolve and merge dependent `.proto` schema files based on [protoc](https://github.com/protocolbuffers/protobuf).

## Usage
TDB.

## Example

### Input
/address.proto

    package com.test;

    message Address {

        required string city = 1;

        required string zip = 2;

        required string country = 3;

        required string street = 4;
    }
/employee.proto

    package com.test;

    import "schema/address.proto";

    message Employee {

        required string first_name = 1;

        required Address address = 2;
    }
/organization.proto

    package com.test;

    import "schema/employee";

    message Organization {

        required string name = 1;

        repeated Employee employees = 2;
    }
### Output
/organization.proto

    message Address {

        required string city = 1;

        required string zip = 2;

        required string country = 3;

        required string street = 4;
    }

    message Employee {

        required string first_name = 1;

        required Address address = 2;
    }
    
    message Organization {

        required string name = 1;

        repeated Employee employees = 2;
    }
