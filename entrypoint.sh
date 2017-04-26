#!/bin/bash
set -e

#$1 - parameter; $2 - value; $3 - default value; $4 - file;
Template() {
    [[ -z "$2" ]] &&  sed -i "s/{{ $1 }}/$3/g" $4 || sed -i "s/{{ $1 }}/$2/g" $4
}

Template data_file_size_gb "$AERO_DATA_FILE_SIZE_GB" 1 $CONF
Template data_eviction_days "$AERO_DATA_EVICTION_DAYS" 1 $CONF
Template data_memory_size_gb "$AERO_DATA_MEMORY_SIZE_GB" 2 $CONF

if [ "$1" = 'asd' ]; then
	set -- "$@" --foreground
fi

if [ -n "$SEEDER" ]; then
	exec "$@"
else
	#maybe it's working :D
	asinfo -v 'tip:host=<ADDR>;port=3002'
	#I need dockerize here
	#wait on port
	exec "$@"
fi