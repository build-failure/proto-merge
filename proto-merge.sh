#!/bin/bash

function proto_merge() {
    local proto_file="$1"
    local proto_file_name=$(basename "$proto_file")
    local proto_file_out="$PROTO_PATH_OUT/$proto_file_name"

    protoc --descriptor_set_out=/merged_schema.pb \
    --proto_path="$PROTO_PATH_IN" \
    --dependency_out=/dev/stdout \
    --include_imports "$proto_file" \
    2>/dev/null \
        | awk "1" RS=".\n" \
        | xargs cat \
        | grep -vwE "$EXCLUDE_PATTERN" > "$proto_file_out"
}

for i in "$@"; do
  case $i in
    -e=*|--exclude_pattern=*)
      EXCLUDE_PATTERN="${i#*=}"
      shift # past argument=value
      ;;
    -i=*|--proto_path_in=*)
      PROTO_PATH_IN="${i#*=}"
      shift # past argument=value
      ;;
    -o=*|--proto_path_out=*)
      PROTO_PATH_OUT="${i#*=}"
      shift # past argument with no value
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

echo "EXCLUDE_PATTERN $EXCLUDE_PATTERN"
echo "PROTO_PATH_IN $PROTO_PATH_IN"
echo "files: ${PROTO_FILES[*]}"

for proto_file in "${PROTO_FILES[@]}"
do
    proto_merge "$proto_file"
done

