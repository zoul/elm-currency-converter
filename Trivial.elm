module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)


main =
    Html.beginnerProgram { model = model, view = view, update = update }


type alias Model =
    Int


model : Model
model =
    0


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            if model > 0 then
                model - 1
            else
                model


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , button [ onClick Increment ] [ text "+" ]
        , text (String.repeat model "*")
        ]
