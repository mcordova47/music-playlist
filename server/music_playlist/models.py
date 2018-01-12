from django.db import models


class Song(models.Model):
    video = models.CharField(max_length=15)
    title = models.CharField(max_length=200)
    artist = models.CharField(max_length=200)
    year = models.IntegerField()
    album = models.CharField(max_length=200)
    notes = models.CharField(max_length=2000)

    def __unicode__(self):
        return 'Song: ' + self.title
