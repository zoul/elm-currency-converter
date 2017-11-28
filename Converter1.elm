module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias UserInput =
    String


type alias ConvertedOutput =
    String


type alias Model =
    ( UserInput, ConvertedOutput )


model : Model
model =
    ( "", "" )



-- UPDATE


type Msg
    = UpdateUserInput UserInput


update : Msg -> Model -> Model
update (UpdateUserInput newInput) ( _, output ) =
    case String.toFloat newInput of
        Ok parsedNumber ->
            ( newInput, toString (parsedNumber * 1.2) )

        Err e ->
            ( newInput, e )



-- VIEW


view : Model -> Html Msg
view ( input, output ) =
    div []
        [ Html.input [ onInput UpdateUserInput, value input ] []
        , text " EUR"
        , br [] []
        , Html.input [ disabled True, value output ] []
        , text " USD"
        ]
