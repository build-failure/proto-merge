# Proto Merge
CLI utility to resolve and merge dependent `.proto` schema files based on [protoc](https://github.com/protocolbuffers/protobuf).

Produces self-contained `.proto` schema files while resolving [import definitions](https://developers.google.com/protocol-buffers/docs/proto3#importing_definitions).

## Limitations
While [protoc](https://github.com/protocolbuffers/protobuf) does the import definition resolution, it solely concatenates
dependent files stripping out conflicting keywords defined within `EXCLUDE_PATTERN` environment variable.

## Usage

    docker run -v "./test/schema:/schema" buildfailure/proto-merge:latest /schema/organization.proto

## Config

| Argument | Environment Variable  | Description | Default |
|---|---|---|---|
| --debug | DEBUG | Enables debugging messages  | `false` |
| --print_stdout  | PRINT_STDOUT  | Prints results to stdout | `true` |
| --exclude_pattern  | EXCLUDE_PATTERN  | Defines exclude regex pattern to strip conflicting schema keywords (e.g. import, syntax) | 'import\s*|package\s*|syntax\s*=" |
| --proto_path_in  | PROTO_PATH_IN  | Defines `.proto` schema parent input dir  | `/` |
| --proto_path_out  | PROTO_PATH_OUT  | Defines `.proto` schema parent output dir  | `/tmp` |

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
