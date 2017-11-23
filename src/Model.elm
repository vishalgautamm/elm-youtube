module Model exposing (Model, Youtube, init)


type alias Youtube =
    { id : String
    , video : String
    , channelTitle : String
    , title : String
    , description : String
    , thumbnail : String
    , datePublished : String
    }


type alias Model =
    { word : String
    , videos : List Youtube
    , selectedVideo : String
    }


init : Model
init =
    Model "elm" [] ""
