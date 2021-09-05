module Cards.Main exposing (..)

import Browser exposing (..)
import Cards.SampleResponse exposing (json)
import Html exposing (Html)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, onInput)
import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline
import Http
import Task
import Html.Attributes exposing (style)
import Html exposing (text)

token : String
token = "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"

searchResultsDecoder : Decode.Decoder Card
searchResultsDecoder =
  Decode.succeed Card
    |> Pipeline.required "node_id" Decode.string
    |> Pipeline.required "sha" Decode.string
    |> Pipeline.hardcoded 800


responseDecoder : Decode.Decoder (List Card) 
responseDecoder =
  Decode.succeed identity
    |> Pipeline.required "items" (Decode.list searchResultsDecoder)

decodeResults : String -> List Card
decodeResults json =
  case Decode.decodeString responseDecoder json of
    Ok searchResults -> searchResults
    Err _ -> []

searchFeed : String -> Cmd Message
searchFeed query =
  let
    url = "https://api.github.com/search/commits?access_token"
      ++ token
      ++ "&q="
      ++ query

  in
    Http.request
      { url = url
      , method = "GET"
      , headers = [ Http.header "Accept" "application/vnd.github.cloak-preview" ]
      , expect = Http.expectJson FetchedCards responseDecoder
      , body = Http.emptyBody
      , timeout = Maybe.Nothing
      , tracker = Maybe.Nothing
      }

type alias Card =
  { id : String
  , title : String
  , width : Int
  }


type Message
  = ChangeUrl String
  | AddCard String
  | DeleteCard
  | UpdateCardProperty
  | Search
  | FetchedCards (Result Http.Error (List Card))


type alias Model =
  { cards : List Card
  , name : String
  , errorMessage: Maybe String
  }


init : () -> ( Model, Cmd Message )
init _ = (
  { name = "" , cards = decodeResults json, errorMessage = Nothing }
  , Cmd.none)

viewCard : Card -> Html Message
viewCard card =
  Html.div []
    [ Html.h3 [] [ Html.text card.title ]
    , Html.p [] [ Html.text "Here will be window" ]
    ]

viewErrorMessage error =
  case error of
    Just message ->
      Html.h2 [ style "color" "red" ] [ Html.text message ]
    Nothing -> text ""


view : Model -> Html Message
view model =
  Html.div [ class "container" ]
    [ Html.header []
      [ Html.h1 [] [ Html.text "Cards" ]
      , Html.input
          [ onInput ChangeUrl ]
          []
      , Html.button
          [ onClick Search ]
          [ Html.text "Add random card" ]
      ]
    , Html.main_ []
        [ viewErrorMessage model.errorMessage
        , Html.p [] [ Html.text "Display cards below" ]
        , Html.div [] (List.map viewCard model.cards)
        ]
    ]


update : Message -> Model -> (Model, Cmd Message)
update message model =
  case message of
    Search ->
      ( model, searchFeed model.name )

    FetchedCards result ->
      case result of
        Ok cards -> ({ model | cards = cards }, Cmd.none)
        Err error ->
          let
            errorMessagee = case error of
              Http.NetworkError -> "Server is down"
              Http.Timeout -> "Network timeout error"
              Http.BadStatus _ -> "Failed with some status code"
              Http.BadBody _ -> "Decoding response body failed"
              Http.BadUrl _ -> "Not a valid url"
          in
            ({ model | errorMessage = Just errorMessagee }, Cmd.none)

    ChangeUrl name -> ({ model | name = name }, Cmd.none)

    AddCard name ->
      ({ model | cards = List.append model.cards [ { id = "something", title = name, width = 800 } ] }, Cmd.none)

    _ -> (model, Cmd.none)


main : Program () Model Message
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }
