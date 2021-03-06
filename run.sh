#!/bin/bash
set -e

#$1 - parameter; $2 - value; $3 - default value; $4 - file;
Template() {
    [[ -z "$2" ]] &&  sed -i "s/{{ $1 }}/$3/g" $4 || sed -i "s/{{ $1 }}/$2/g" $4
}

CONF="/etc/aerospike/aerospike.conf"

Template data_file_size_gb "$AERO_DATA_FILE_SIZE_GB" 1 $CONF
Template data_eviction_days "$AERO_DATA_EVICTION_DAYS" 1 $CONF
Template data_memory_size_gb "$AERO_DATA_MEMORY_SIZE_GB" 2 $CONF

if [ -n "$AERO_MASTER" ]; then
	Assign() {
		dockerize -wait tcp://127.0.0.1:3002	
		dockerize -wait tcp://127.0.0.1:3000	
		IFS=',' read -ra NODES <<< "$AERO_NODES"
		for NODE in ${NODES[@]}
		do
			dockerize -wait tcp://$NODE:3002
			asinfo -v "tip:host=$NODE;port=3002"
		done
	}
	Assign & asd --foreground
else
	asd --foreground
fi
