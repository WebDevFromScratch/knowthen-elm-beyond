module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import Login
import LeaderBoard


-- model


type alias Model =
    { page : Page
    , leaderBoard : LeaderBoard.Model
    , login : Login.Model
    }


initModel : Model
initModel =
    { page = LeaderBoardPage
    , leaderBoard = LeaderBoard.initModel
    , login = Login.initModel
    }


type Page
    = LoginPage
    | LeaderBoardPage



-- update


type Msg
    = ChangePage Page
    | LeaderBoardMsg LeaderBoard.Msg
    | LoginMsg Login.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangePage page ->
            { model | page = page }

        LeaderBoardMsg lbMsg ->
            { model | leaderBoard = LeaderBoard.update lbMsg model.leaderBoard }

        LoginMsg lgMsg ->
            { model | login = Login.update lgMsg model.login }



-- view


view : Model -> Html Msg
view model =
    let
        page =
            case model.page of
                LeaderBoardPage ->
                    -- this wouldn't be enough, it would be generating wrong Msg
                    -- (only LeaderBoard.Msg, not Main.Msg)
                    -- LeaderBoard.view model.leaderBoard - thus, we need to map it as below:
                    App.map LeaderBoardMsg (LeaderBoard.view model.leaderBoard)

                LoginPage ->
                    App.map LoginMsg (Login.view model.login)
    in
        div []
            [ div []
                [ a
                    [ href "#"
                    , onClick (ChangePage LeaderBoardPage)
                    ]
                    [ text "LeaderBoard" ]
                , span [] [ text " | " ]
                , a
                    [ href "#"
                    , onClick (ChangePage LoginPage)
                    ]
                    [ text "Login" ]
                ]
            , hr [] []
            , page
            , hr [] []
            , h4 [] [ text "App Model:" ]
            , p [] [ text <| toString model ]
            ]


main : Program Never
main =
    App.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
