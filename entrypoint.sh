#!/bin/bash

echo '--- executing entrypoint ---'

set -e # Exit immediately if a command exits with a non-zero status.
rm -rfv tmp/pids/server.pid
rake db:create && rake db:migrate

echo "executing command: $@"
exec "$@"

echo '--- bye ---'
