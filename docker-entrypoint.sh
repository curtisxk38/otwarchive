#!/usr/bin/env bash

rm -f tmp/pids/server.pid

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

# Then exec the container's main process (what's set as CMD in the Dockerfile 
#  or as command in docker-compose.yml)
exec "$@"