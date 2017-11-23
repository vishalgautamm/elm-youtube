port module Update exposing (update, Msg(..), subscriptions, check, onKeyDown)

import Html exposing (Attribute)
import Html.Events exposing (on, keyCode)
import Json.Decode as Decode exposing (Decoder, field, string)
import Json.Decode as Json
import Model exposing (Model, Youtube)


-- UPDATE


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)


type Msg
    = Change String
    | KeyDown Int
    | Check
    | Suggest (Result String (List Youtube))
    | SelectedVideo String


port check : String -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newWord ->
            ( { model | word = newWord }, Cmd.none )

        KeyDown key ->
            if key == 13 then
                ( model, check model.word )
            else
                ( model, Cmd.none )

        Check ->
            ( model, check model.word )

        Suggest (Ok newVideos) ->
            ( Model model.word newVideos "", Cmd.none )

        Suggest (Err _) ->
            ( model, Cmd.none )

        SelectedVideo video ->
            { model | selectedVideo = video } ! []



-- PORTS


port suggestions : (Decode.Value -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    suggestions (decodeSuggestions >> Suggest)



-- DECODERS


decodeSuggestions : Decode.Value -> Result String (List Youtube)
decodeSuggestions =
    Decode.decodeValue
        (Decode.field "result" youbeListDecoder)


youbeListDecoder : Decoder (List Youtube)
youbeListDecoder =
    Decode.list youtubeDecoder


youtubeDecoder : Decoder Youtube
youtubeDecoder =
    Decode.map7 Youtube
        (field "id" string)
        (field "video" string)
        (field "channelTitle" string)
        (field "title" string)
        (field "description" string)
        (field "thumbnail" string)
        (field "datePublished" string)
