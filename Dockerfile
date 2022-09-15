FROM namely/protoc:latest

COPY docker-entrypoint.sh /docker-entrypoint.sh

COPY proto-merge.sh /proto-merge.sh

RUN chmod +x /proto-merge.sh /docker-entrypoint.sh

ENV PROTO_PATH_OUT="/tmp/"

ENV PROTO_PATH_IN="/"

ENV EXCLUDE_PATTERN="import\s*|package\s*|syntax\s*="

ENV PRINT_STDOUT=true

ENV DEBUG=false

ENTRYPOINT ["/docker-entrypoint.sh"]
