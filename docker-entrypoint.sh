#!/usr/bin/env bash
set -e

rm -f tmp/pids/server.pid

################# 
# Wait for mysql server to respond to netcat ping before running rake commands
################# 

export SLEEP_TIME=5

export TIME_OUT=90s

wait_for()
{
    while :
    do
        nc -z db 3306
        WAITFORIT_result=$?
        if [[ $WAITFORIT_result -eq 0 ]]; then
            echo "mysql is ready"
            break
        fi
        echo "mysql not ready, sleeping"
        sleep $SLEEP_TIME
    done
    return $WAITFORIT_result
}

export -f wait_for

trap 'kill -INT -$pid' INT
timeout $TIME_OUT bash -c wait_for &
pid=$!
wait $pid

TO_result=$?

if [[ $TO_result -eq 124 ]]; then
	echo "Failed to connect after $TIME_OUT"
	exit $TO_result
fi

##################################

rake db:create
rake db:schema:load
rake db:migrate
rake db:otwseed

rake work:missing_stat_counters
rake skins:load_site_skins

rake search:index_tags
rake search:index_works
rake search:index_pseuds
rake search:index_bookmarks

sleep 60

# Then exec the container's main process (what's set as CMD in the Dockerfile 
#  or as command in docker-compose.yml)
exec "$@"