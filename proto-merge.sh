#!/bin/bash

function proto_merge() {
    local proto_file="$1"
    local proto_file_name=$(basename "$proto_file")
    local proto_file_out="$PROTO_PATH_OUT/$proto_file_name"
    local redirect_std_err

    if [ "$DEBUG" = "false" ]; then
        protoc --descriptor_set_out=/merged_schema.pb \
            --proto_path="$PROTO_PATH_IN" \
            --dependency_out=/dev/stdout \
            --include_imports "$proto_file" \
            2>/dev/null \
                | awk "1" RS=".\n" \
                | xargs cat \
                | grep -vwE "$EXCLUDE_PATTERN" > "$proto_file_out"
    else
        protoc --descriptor_set_out=/merged_schema.pb \
            --proto_path="$PROTO_PATH_IN" \
            --dependency_out=/dev/stdout \
            --include_imports "$proto_file" \
                | awk "1" RS=".\n" \
                | xargs cat \
                | grep -vwE "$EXCLUDE_PATTERN" > "$proto_file_out"
    fi

    if [ "$PRINT_STDOUT" = "true" ]; then
        cat "$proto_file_out"
    fi
}

for i in "$@"; do
  case $i in
    -e=*|--exclude_pattern=*)
      EXCLUDE_PATTERN="${i#*=}"
      shift
      ;;
    -i=*|--proto_path_in=*)
      PROTO_PATH_IN="${i#*=}"
      shift
      ;;
    -o=*|--proto_path_out=*)
      PROTO_PATH_OUT="${i#*=}"
      shift
      ;;
    -d|--print_stdout)
      PRINT_STDOUT=true
      shift
      ;;
    -*|--*)
      echo "Unknown option $i"
      exit 1
      ;;
    *)
      PROTO_FILES+=("$1")
      shift
      ;;
  esac
done

for proto_file in "${PROTO_FILES[@]}"
do
    proto_merge "$proto_file"
done

