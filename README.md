# music-playlist
This is a music/video playlist made as a Christmas gift.
Click through a list of songs or browse by artist in the menu.
Click the icon next to the menu to toggle autoplay mode.

## Development
The front end is written in [elm](http://elm-lang.org), with ports to JavaScript to use the youtube API to listen for video ended events.
The server is python/django, with only one endpoint for the list of songs stored in a MySQL DB currently.

### Django server
    $ cd server
    $ env/Scripts/activate
    $ pip install -r requirements.txt
    $ python manage.py runserver

### Webpack dev server
* Hot module reloading and elm time-travel debugger
* Redirects api calls to django server

      $ npm start
