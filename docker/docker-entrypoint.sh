#!/bin/bash

cd /srv/onadata

# ensure annoying git-cloned reqs. are present
if [[ ! -d src ]]; then
    cat requirements/docker-env.pip | grep "^git+" > /tmp/git-requirements.txt
    pip install -r /tmp/git-requirements.txt
fi

python manage.py migrate --noinput --run-syncdb
cd docs && make html && cd ..
python manage.py collectstatic --noinput

python manage.py shell << EOF
from os import environ
from django.contrib.auth.models import User
if environ.get('DEV_LOGIN_USERNAME') and environ.get('DEV_LOGIN_PASSWORD'):
    username = environ.get('DEV_LOGIN_USERNAME')
    password = environ.get('DEV_LOGIN_PASSWORD')
    email = environ.get('DEV_LOGIN_PASSWORD')
    #User.objects.filter(username=username).delete()
    #User.objects.create_superuser(username, email, password)
    if not User.objects.filter(username=username).exists():
        User.objects.create_superuser(username, email, password)
EOF

python manage.py runserver 0.0.0.0:8000
