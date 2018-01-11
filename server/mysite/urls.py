from django.conf.urls import include, url
from django.contrib import admin

from music_playlist.views import songs

urlpatterns = [
    url(r'^api/songs/$', songs),
    url(r'^admin/', include(admin.site.urls)),
]
