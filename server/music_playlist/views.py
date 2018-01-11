from django.http import HttpResponse
from django.core import serializers
from .models import Song


def songs(request):
    songs = Song.objects.all()
    songs_json = serializers.serialize('json', songs)
    return HttpResponse(songs_json, content_type='application/json')
