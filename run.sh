#!/bin/bash

if [ "$1" == "tests-local" ]; then
  echo "Running tests locally"
  python manage.py test

elif [ "$1" == "tests-docker" ]; then
  echo "Running tests in docker"
  docker-compose stop -t 1  # -t=timeout (shutdown timeout in seconds)
  docker-compose pull
  docker-compose up db_tasker -d
  echo "waiting 60s for db to start"
  sleep 60
  docker-compose run --rm web python manage.py test
                  # -rm=remove - Remove container after run. Ignored in detached mode.
  docker-compose stop -t 1  # -t=timeout (shutdown timeout in seconds)

elif [ "$1" == "make-migrations-local" ]; then
  echo "Making migrations locally"
  python manage.py makemigrations

elif [ "$1" == "migrate-local" ]; then
  echo "Running migrations locally"
  python manage.py migrate

elif [ "$1" == "migrate-docker" ]; then
  echo "Running migrations in docker"
  docker-compose stop -t 1  # -t=timeout (shutdown timeout in seconds)
  docker-compose pull
  docker-compose up db_tasker -d
  echo "waiting 60s for db to start"
  sleep 60
  docker-compose run --rm web python manage.py migrate
                  # -rm=remove - Remove container after run. Ignored in detached mode.
  docker-compose stop -t 1  # -t=timeout (shutdown timeout in seconds)

elif [ "$1" == "run-local" ]; then
  echo "Running Tasker locally"
  python manage.py runserver

elif [ "$1" == "run-docker" ]; then
  echo "Running Tasker in docker"
  docker-compose stop -t 1  # -t=timeout (shutdown timeout in seconds)
  docker-compose pull
  docker-compose up --build
  docker-compose stop -t 1  # -t=timeout (shutdown timeout in seconds)

elif [ "$1" == "stop-docker" ]; then
  echo "Stopping running docker containers"
  docker-compose stop -t 1  # -t=timeout (shutdown timeout in seconds)

elif [ "$1" == "build-docker" ]; then
  echo "Building docker images and pruning dangling ones"
  docker-compose down
  docker-compose build
  docker image prune -f  # -f=force (does not prompt for confirmation)

elif [ "$1" == "destroy-docker" ]; then
  echo "Destroying docker containers and volumes"
  docker-compose down -v # -v=volume - deletes also volumes

elif [ "$1" == "rebuild-all-docker" ]; then
  echo "Destroying docker containers and volumes"
  docker-compose down -v # -v=volume - deletes also volumes
  docker system prune --volumes -f
  docker-compose pull
  docker-compose build

elif [ "$1" == "first-run-docker" ]; then

  echo "Running Tasker in docker"
  docker-compose up --build -d
  echo "waiting 60s for db to start"
  sleep 60
  docker-compose down
  echo "waiting 10s for containers to stop"
  sleep 10
  echo "Running migrations in docker"
  docker-compose up db_tasker -d
  echo "waiting 60s for db to start"
  sleep 60
  docker-compose run --rm web python manage.py migrate
                  # -rm=remove - Remove container after run. Ignored in detached mode.
  docker-compose stop -t 1  # -t=timeout (shutdown timeout in seconds)

fi
