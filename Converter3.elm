module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Dict exposing (Dict)
import Json.Decode as Decode
import Http


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }



-- MODEL


type alias UserInput =
    String


type alias ConvertedOutput =
    String


type alias Rates =
    Dict String Float


type Model
    = LoadingRates
    | Error String
    | Loaded Rates UserInput ConvertedOutput


init : ( Model, Cmd Msg )
init =
    let
        ratesURL =
            "http://api.fixer.io/latest?base=EUR"

        initialRequest =
            Http.send ReceiveRates (Http.get ratesURL decodeRates)
    in
        ( LoadingRates, initialRequest )


decodeRates : Decode.Decoder (Dict String Float)
decodeRates =
    Decode.at [ "rates" ] (Decode.dict Decode.float)


convertRate : Rates -> Float -> String -> Maybe Float
convertRate rates amount targetCurrency =
    case (Dict.get targetCurrency rates) of
        Just rate ->
            Just (amount * rate)

        Nothing ->
            Nothing



-- UPDATE


type Msg
    = UpdateUserInput UserInput
    | ReceiveRates (Result Http.Error Rates)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( ReceiveRates rates, LoadingRates ) ->
            case rates of
                Ok rates ->
                    ( Loaded rates "" "", Cmd.none )

                Err e ->
                    ( Error (toString e), Cmd.none )

        ( UpdateUserInput newInput, Loaded rates input output ) ->
            case (String.toFloat newInput) of
                Ok value ->
                    case (convertRate rates value "USD") of
                        Just output ->
                            ( Loaded rates newInput (toString output), Cmd.none )

                        Nothing ->
                            ( Loaded rates newInput "conversion error", Cmd.none )

                Err _ ->
                    ( Loaded rates newInput "input error", Cmd.none )

        _ ->
            ( Error "Invalid state", Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        LoadingRates ->
            text "Loading…"

        Error e ->
            text ("Error: " ++ e)

        Loaded rates userInput convertedOutput ->
            div []
                [ input [ onInput UpdateUserInput, value userInput ] []
                , text " EUR"
                , br [] []
                , input [ disabled True, value convertedOutput ] []
                , text " USD"
                ]
