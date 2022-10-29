FROM couchbase:latest

COPY configure-server.sh /opt/couchbase
RUN chmod +x /opt/couchbase/configure-server.sh
HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:8091/pools || exit 1

CMD ["/opt/couchbase/configure-server.sh"]