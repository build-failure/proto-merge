# Proto Merge
CLI utility to resolve and merge dependent `.proto` schema files based on [protoc](https://github.com/protocolbuffers/protobuf).

Produces self-contained `.proto` schema files while resolving [import definitions](https://developers.google.com/protocol-buffers/docs/proto3#importing_definitions).

## Limitations
While [protoc](https://github.com/protocolbuffers/protobuf) does the import definition resolution, [proto-merge](./) solely concatenates
dependent files stripping out conflicting keywords defined within `EXCLUDE_PATTERN` environment variable.

## Usage

    docker run -v "./test/schema:/schema" buildfailure/proto-merge:latest /schema/organization.proto

## Config

| Argument | Environment Variable  | Description | Default |
|---|---|---|---|
| --debug | DEBUG | Enables debugging messages  | `false` |
| --print_stdout  | PRINT_STDOUT  | Prints results to stdout | `true` |
| --exclude_pattern  | EXCLUDE_PATTERN  | Defines exclude regex pattern to strip conflicting schema keywords (e.g. import, syntax) | import\s*|package\s*|syntax\s*= |
| --proto_path_in  | PROTO_PATH_IN  | Defines `.proto` schema parent input dir  | `/` |
| --proto_path_out  | PROTO_PATH_OUT  | Defines `.proto` schema parent output dir  | `/tmp` |

## Example

### Given

The schema with
- [address.proto](./test/schema/address.proto)
- [employee.proto](./test/schema/employee.proto)
- [organization.proto](./test/schema/organization.proto)

and file structure

    /test/schema/
                address.proto
                employee.proto          # depends on address.proto
                organization.proto      # depends on employee.proto

### When

    docker run -v "./test/schema:/schema" buildfailure/proto-merge:latest /schema/employee.proto

### Then

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
