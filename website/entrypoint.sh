#!/bin/sh

python manage.py makemigrations --no-input
python manage.py migrate --no-input
python manage.py collectstatic --no-input

echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'admin')" | python manage.py shell

gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 website.wsgi:application
