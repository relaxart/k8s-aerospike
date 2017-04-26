FROM aerospike:3.12.1

COPY aerospike.conf /etc/aerospike/aerospike.conf
COPY entrypoint.sh /entrypoint.sh

WORKDIR /opt/aerospike/bin
ENTRYPOINT ["/entrypoint.sh"]