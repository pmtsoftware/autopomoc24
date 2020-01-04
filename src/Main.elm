module Main exposing ( main )

import Browser
import Html exposing
    ( Html
    )
import Element exposing 
    ( Element
    , el 
    , text
    , link
    , column 
    , row
    , width 
    , px 
    , fill
    , centerX 
    , padding
    , spacing 
    )
import Element.Font as Font
import Element.Border as Border
import Element.Background as Bg

-- UNICODE polish characters
-- #104	A
-- #106 Ć
-- #118 Ę
-- #141 Ł
-- #143 Ń
-- #D3  Ó
-- #15A Ś
-- #179 Ź
-- #17B Ż
-- #105 ą
-- #107 ć
-- #119 ę
-- #142 ł
-- #144 ń
-- #F3  ó
-- #15B ś
-- #17A ź
-- #17C ż

type alias Model = ()

type alias Msg = ()

init : () -> ( Model, Cmd Msg )
init _ = ( (), Cmd.none )

subs : Model -> Sub Msg
subs _ = Sub.none

update : Msg -> Model -> ( Model, Cmd Msg )
update _ model = ( model, Cmd.none )

type Color = Primary | Text | Bg

theme : Color -> Element.Color
theme color =
    case color of
        Primary -> Element.rgb255 229 57 53
        Text -> Element.rgb255 66 66 66
        Bg -> Element.rgb255 245 245 245

header : Model -> Element Msg
header _ = 
    let title = 
            el 
                [ centerX
                , Font.size 64 
                , Font.heavy
                ] <| text "pomoc drogowa 24h"
        subtitle = 
            el 
                [ centerX
                , Font.size 32 
                , Font.light
                ] <| text "dzia\u{0142}amy na terenie Wroc\u{0142}awia i okolic"
    in column 
        [ width fill
        , spacing 16 
        ] 
        [ title
        , subtitle 
        ]

mainElement : Model -> Element Msg
mainElement model = 
    let fontFamily = Font.family [ Font.typeface "Roboto", Font.sansSerif ]
    in el 
        [ width fill
        , Element.height fill
        , Bg.color <| theme Bg
        ] <| column 
                [ fontFamily
                , Font.color <| theme Text
                , Bg.color <| theme Bg
                , width <| px 960
                , centerX 
                , padding 16
                , spacing 96
                ]
                [ header model
                , img 
                , phone 
                ]

img : Element Msg
img = el [] <|
    Element.image [ width fill ] 
        { src = "assets/images/img.jpg"
        , description = "Decoration mid image"
        }

phone : Element Msg
phone = 
    el 
        [ centerX
        , Font.size 64
        , Border.solid
        , Border.rounded 64
        , Border.color <| theme Primary
        , Border.width 4
        , padding 32
        ] <|
        link []
            { url = "tel:+48728725796"
            , label = 
                row  [ spacing 50 ]
                    [ el [] <| text "\u{260E}"
                    , el [ Font.bold ] <| text "+48 728 725 796"
                    ]
            }

view : Model -> Html Msg
view model = Element.layout [] <| mainElement model

main : Program () Model Msg
main = Browser.element
    { init = init 
    , update = update
    , view = view
    , subscriptions = subs
    }
