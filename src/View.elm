module View exposing (view)

import Html exposing (Html, div, text, p, input, button, ul, h3, img, iframe, span)
import Html.Attributes exposing (src, class, attribute, property, width, height, classList)
import Html.Events exposing (onClick, onInput)
import Model exposing (Model, Youtube)
import Update exposing (Msg(..), onKeyDown)
import List
import Array


initialView : Model -> Html Msg
initialView model =
    let
        selectedArr =
            Array.fromList model.videos

        video =
            Array.get 0 selectedArr
    in
        case video of
            Just video ->
                div [ class "main-video" ]
                    [ iframe
                        [ src video.video
                        , attribute "frameborder" "0"
                        , attribute "allowfullscreen" "true"
                        , class "video-main"
                        ]
                        []
                    , h3 []
                        [ text video.title ]
                    , p [] [ text video.description ]
                    ]

            Nothing ->
                div [] [ text "Nothing here yet" ]


viewVideo : String -> Model -> Html Msg
viewVideo selectedVideo model =
    let
        selectedVid =
            List.filter (\model -> selectedVideo == model.video) model.videos

        selectedArr =
            Array.fromList selectedVid

        video =
            Array.get 0 selectedArr
    in
        case video of
            Just video ->
                div [ class "main-video" ]
                    [ iframe
                        [ src video.video
                        , attribute "frameborder" "0"
                        , attribute "allowfullscreen" "true"
                        , class "video-main"
                        ]
                        []
                    , h3 []
                        [ text video.title ]
                    , p [] [ text video.description ]
                    ]

            Nothing ->
                initialView model


viewThumbnail : String -> Youtube -> Html Msg
viewThumbnail selectedVideo video =
    div
        [ class "video-thumbnail"
        , classList [ ( "selected", selectedVideo == video.video ) ]
        , onClick (SelectedVideo video.video)
        ]
        [ img
            [ src video.thumbnail
            , class "thumbnail-img"
            ]
            []
        , div []
            [ p [ class "thumbnail-title" ] [ text video.title ]
            , p [ class "thumbnail-channel" ] [ text video.channelTitle ]
            ]
        ]


viewThumbnails : Model -> Html Msg
viewThumbnails model =
    div [ class "video-thumbnails" ]
        (List.map (viewThumbnail model.selectedVideo) model.videos)


viewVideos : Model -> Html Msg
viewVideos model =
    div [ class "Videos" ]
        [ viewVideo model.selectedVideo model
        , viewThumbnails model
        ]


viewSearchbar : Html Msg
viewSearchbar =
    div [ class "search-bar-wrapper" ]
        [ div [ class "search-bar" ]
            [ div [ class "logo" ]
                [ span [ class "logo-elm" ] [ text "Elm" ]
                , span [ class "logo-red" ] [ text "Tube" ]
                ]
            , div [ class "searchh" ]
                [ input [ onKeyDown KeyDown, onInput Change, class "inputVal" ] []
                , button [ onClick Check, class "input-button" ] [ text "Search" ]
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    div [ class "app" ]
        [ viewSearchbar
        , viewVideos model
        ]
