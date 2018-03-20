#!/bin/bash

psql -h db -U postgres -c "CREATE ROLE onadata WITH LOGIN PASSWORD 'onadata';"
psql -h db -U postgres -c "CREATE DATABASE onadata OWNER onadata;"
psql -h db -U postgres onadata -c "CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology;"

#. /srv/.virtualenv/bin/activate

cd /srv/onadata
python manage.py migrate --noinput --run-syncdb
cd docs && make html && cd ..
python manage.py collectstatic --noinput

# create superuser
#python manage.py createsuperuser
echo "from django.contrib.auth.models import User; User.objects.filter(email='admin@localhost.local').delete(); User.objects.create_superuser('admin', 'admin@localhost.local', 'admin')" | python manage.py shell


python manage.py runserver 0.0.0.0:8000
