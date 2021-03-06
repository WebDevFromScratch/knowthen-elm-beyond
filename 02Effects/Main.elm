module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Http
import Task


-- model


type alias Model =
    String


initModel : Model
initModel =
    "Finding a joke..."


init : ( Model, Cmd Msg )
init =
    ( initModel, randomJoke )


randomJoke : Cmd Msg
randomJoke =
    let
        url =
            "http://api.icndb.com/jokes/random"

        task =
            Http.getString url

        cmd =
            Task.perform Fail Joke task
    in
        cmd



-- update


type Msg
    = Joke String
    | Fail Http.Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Joke joke ->
            ( joke, Cmd.none )

        Fail error ->
            ( (toString error), Cmd.none )



-- view


view : Model -> Html Msg
view model =
    div [] [ text model ]



-- subscription


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- main : Program Never
-- main =
--App.beginnerProgram
--    { model = initModel
--    , update = update
--    , view = view
--    }


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
