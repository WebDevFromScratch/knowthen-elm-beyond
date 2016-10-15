module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.App as App
import Http
import Task
import Json.Decode exposing (..)


type alias Response =
    { id : Int
    , joke : String
    , categories : List String
    }


responseDecoder : Decoder Response
responseDecoder =
    object3 Response
        ("id" := int)
        ("joke" := string)
        ("categories" := list string)
        |> at [ "value" ]


randomJoke : Cmd Msg
randomJoke =
    let
        url =
            "http://api.icndb.com/jokes/random"

        task =
            -- Http.getString url
            -- Http.get (at [ "value", "joke" ] string) url
            Http.get responseDecoder url

        cmd =
            Task.perform Fail Joke task
    in
        cmd



-- model


type alias Model =
    String


initModel : Model
initModel =
    "Finding a joke..."


init : ( Model, Cmd Msg )
init =
    ( initModel, randomJoke )



-- update


type Msg
    = Joke Response
    | Fail Http.Error
    | NewJoke


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Joke response ->
            -- this satisfies the type, but at the same time doesn't actually
            -- initiate any more actions (since we don't want any here)
            ( toString (response.id) ++ " " ++ response.joke, Cmd.none )

        Fail error ->
            ( (toString error), Cmd.none )

        NewJoke ->
            ( "fetching a joke...", randomJoke )



-- view


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text model ]
        , br [] []
        , button
            [ onClick NewJoke ]
            [ text "New joke" ]
        ]



-- subscription


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- main : Program Never
-- main =
--     App.beginnerProgram
--         { model = initModel
--         , view = view
--         , update = update
--         }


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
