var querystring = require('querystring')
var axios = require('axios')

const SEARCH_URL = 'https://www.googleapis.com/youtube/v3/search'
const api = "AIzaSyCLrwe0JhDlKmU-xSDmBCrRcFa5I2Jg7RQ";


// Function getVideo :: apiKey(String) ->  query(String) -> maximumResult (Int, default=20) ->  Object
var videoSearch = (key, q, res) => {
  const params = {
    part: 'snippet',
    type: 'video',
    maxResults: res,
    key: key,
    q: q
  }

  return axios(`${SEARCH_URL}?${querystring.stringify(params)}`)
    .then(video => video.data)
}

// Function youtubeEmbedder :: String -> String
const youtubeEmbedder = id => `https://www.youtube.com/embed/${id}`

// getVideo :: String -> String -> Number -> Youtube Object
const getVideo = (API, query, res) => videoSearch(API, query, res)
  .then(data => data.items)
  .then(datas => datas
    .map(({ id, snippet }) => ({
      id: id.videoId,
      video: youtubeEmbedder(id.videoId),
      channelTitle: snippet.channelTitle,
      title: snippet.title,
      description: snippet.description,
      thumbnail: snippet.thumbnails.default.url,
      datePublished: snippet.publishedAt
    })))
  .then(data => data)
  .catch(err => err)


module.exports = getVideo

