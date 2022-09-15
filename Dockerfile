FROM namely/protoc:latest

COPY docker-entrypoint.sh /docker-entrypoint.sh

COPY proto-merge.sh /proto-merge.sh

RUN chmod +x /proto-merge.sh /docker-entrypoint.sh

ENV EXCLUDE_PATTERN="import\s*|package\s*|syntax\s*="

ENTRYPOINT ["/docker-entrypoint.sh"]
