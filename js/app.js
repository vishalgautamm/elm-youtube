import Elm from '../src/Main.elm'
const getVideo = require('./youtube.js')


const API = "AIzaSyCLrwe0JhDlKmU-xSDmBCrRcFa5I2Jg7RQ";

const node = document.getElementById('main')
const app = Elm.Main.embed(node)

// TALKING BETWEEN ELM AND JAVASCRIPT 
app.ports.check.subscribe((word) => {
  getVideo(API, word, 20)
    .then(data => {
      console.log(data)
      return app.ports.suggestions.send({result : data })
    })
});


window.main = app
