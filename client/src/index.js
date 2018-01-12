'use strict'

require('./css/index.scss')

const Elm = require('./Main.elm')
const mountNode = document.getElementById('main')

const app = Elm.Main.embed(mountNode, {
  dev: TARGET_ENV === 'development'
})

window.onYouTubePlayerAPIReady = createVideoPlayer

function createVideoPlayer() {
  new YT.Player('video-player', {
    events: {
      onStateChange(e) {
        app.ports.youtubeStateChange.send(e.data)
      }
    }
  })
}

function checkIframeStateLoop(prevState) {
  const iframe = document.querySelector('iframe')
  const src = (iframe && iframe.src) || ''
  if (prevState.src !== src) {
    if (!document.getElementById('youtube-api-script')) {
      var tag = document.createElement('script')
      tag.src = 'https://www.youtube.com/player_api'
      tag.id = 'youtube-api-script'
      var firstScriptTag = document.getElementsByTagName('script')[0]
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag)
    } else {
      createVideoPlayer()
    }
    requestAnimationFrame(() => checkIframeStateLoop({ src }))
  } else {
    requestAnimationFrame(() => checkIframeStateLoop({ src }))
  }
}

requestAnimationFrame(() => checkIframeStateLoop({ src: '' }))
