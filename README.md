# music-playlist
This is a music/video playlist made as a Christmas gift.
Click through a list of songs or browse by artist in the menu.
Click the icon next to the menu to toggle autoplay mode.

## Development
The front end is written in [elm](http://elm-lang.org), with ports to JavaScript to use the youtube API to listen for video ended events.
The server is python/django, with only one endpoint for the list of songs stored in a MySQL DB currently.

### Django server
Set up virtual environment

    $ virtualenv env
    $ env/Scripts/activate
    $ pip install -r requirements.txt

Run django server

    $ python manage.py runserver

DB Migrations

    $ python manage.py makemigrations
    $ python manage.py migrate

Connect to Cloud SQL via proxy

    $ cloud_sql_proxy -instances=[INSTANCE_CONNECTION_NAME]=tcp:3306

### Webpack dev server
* Hot module reloading and elm time-travel debugger
* Redirects api calls to django server

      $ npm start

## Production
The front end is hosted on github pages

    $ npm run deploy

The server is hosted on google app engine

    $ pip install -r requirements-vendor.txt -t lib
    $ gcloud app deploy
