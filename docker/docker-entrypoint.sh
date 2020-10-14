#!/bin/bash

# sleep 20

virtualenv -p `which $SELECTED_PYTHON` /srv/onadata/.virtualenv/${SELECTED_PYTHON}
. /srv/onadata/.virtualenv/${SELECTED_PYTHON}/bin/activate

cd /srv/onadata
pip install --upgrade pip
yes w | pip install -r requirements/base.pip

python manage.py migrate --noinput --run-syncdb
cd docs && make html && cd ..

## create django admin user
python manage.py shell << EOF
from os import environ
import logging
from django.contrib.auth.models import User
if environ.get('DEV_LOGIN_USERNAME') and environ.get('DEV_LOGIN_PASSWORD'):
    username = environ.get('DEV_LOGIN_USERNAME')
    password = environ.get('DEV_LOGIN_PASSWORD')
    email = environ.get('DEV_LOGIN_PASSWORD')
    #User.objects.filter(username=username).delete()
    if not User.objects.filter(username=username).exists():
        logging.info("user '{}' doesn't exist, creating one".format(username))
        User.objects.create_superuser(username, email, password)
    else:
        logging.info("user: '{}' already exists!".format(username))
EOF

python manage.py collectstatic --noinput
python manage.py runserver 0.0.0.0:8000
