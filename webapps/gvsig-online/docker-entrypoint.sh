#!/bin/bash

python /srv/gvsig-online-deploy/gvsig-online/gvsigol/manage.py compilemessages -l es --settings=tourism.settings
python /srv/gvsig-online-deploy/gvsig-online/gvsigol/manage.py migrate --settings=tourism.settings                 # Apply database migrations
python /srv/gvsig-online-deploy/gvsig-online/gvsigol/manage.py collectstatic --noinput --settings=tourism.settings  # Collect static files

#Prepare log files and start outputting logs to stdout
touch /srv/gvsig-online-deploy/gvsig-online/gvsigol/logs/gunicorn.log
touch /srv/gvsig-online-deploy/gvsig-online/gvsigol/logs/access.log
tail -n 0 -f /srv/gvsig-online-deploy/gvsig-online/gvsigol/logs/*.log &

# Start Gunicorn processes
echo Starting Gunicorn.

exec gunicorn gvsigol.wsgi:application \
    --env DJANGO_SETTINGS_MODULE=gvsigol.settings \
    --name gvSIG-deploy-diegoasencio96 \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --timeout 3600 \
    --log-level=info \
    --log-file=/srv/gvsig-online-deploy/gvsig-online/gvsigol/logs/gunicorn.log \
    --access-logfile=/srv/gvsig-online-deploy/gvsig-online/gvsigol/logs/access.log \
"$@"