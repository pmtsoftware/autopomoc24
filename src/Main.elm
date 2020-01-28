module Main exposing ( main )

import Browser
import Browser.Dom exposing 
    ( getViewport 
    , Viewport 
    )
import Browser.Events exposing 
    ( onResize 
    )
import Html exposing
    ( Html
    )
import Task as Task
import Element exposing 
    ( Element
    , el 
    , text
    , link
    , column 
    , row
    , width 
    , height
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

type alias Device = Element.Device

type alias Model = Maybe Device 

type Msg 
    = GotViewport Viewport
    | Resized Int Int 

init : () -> ( Model, Cmd Msg )
init _ = 
    let askForViewport = Task.perform GotViewport getViewport
    in ( Nothing, askForViewport )

subs : Model -> Sub Msg
subs _ = onResize Resized

classify : Viewport -> Device 
classify v = 
    let x = truncate v.viewport.width
        y = truncate v.viewport.height
    in Element.classifyDevice 
        { width = x 
        , height = y 
        }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        GotViewport viewport -> ( Just <| classify viewport, Cmd.none )
        Resized x y -> ( Just <| Element.classifyDevice { width = x, height = y }, Cmd.none )

type Color = Primary | Text | Bg

theme : Color -> Element.Color
theme color =
    case color of
        Primary -> Element.rgb255 229 57 53
        Text -> Element.rgb255 66 66 66
        Bg -> Element.rgb255 245 245 245

header : Element Msg
header = 
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

mainElement : Element Msg
mainElement = 
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
                , padding 32
                , spacing 64
                ]
                [ header 
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
        , Font.color <| theme Bg
        , Border.solid
        , Border.rounded 8
        , padding 32
        , Bg.color <| theme Primary
        ] <|
        link []
            { url = "tel:+48531787317"
            , label = 
                row  [ spacing 50 ]
                    [ el [] <| text "\u{260E}"
                    , el [ Font.bold ] <| text "+48 531 787 317"
                    ]
            }

headerMobile : Element Msg
headerMobile = 
    let title = 
            el 
                [ centerX
                , Font.size 96 
                , Font.heavy
                ] <| text "pomoc drogowa 24h"
        subtitle = 
            el 
                [ centerX
                , Font.size 48 
                , Font.light
                ] <| text "dzia\u{0142}amy na terenie Wroc\u{0142}awia i okolic"
    in column 
        [ width fill
        , padding 128
        , spacing 32 
        ] 
        [ title
        , subtitle 
        ]

phoneMobile : Element Msg
phoneMobile = 
    el 
        [ centerX
        , Font.size 64
        , Font.color <| theme Bg
        , Border.rounded 8
        , Bg.color <| theme Primary
        , padding 32
        ] <|
        link []
            { url = "tel:+48531787317"
            , label = 
                row  [ spacing 50 ]
                    [ el [] <| text "\u{260E}"
                    , el [ Font.bold ] <| text "+48 531 787 317"
                    ]
            }

mainMobile : Element Msg 
mainMobile = 
    let fontFamily = Font.family [ Font.typeface "Roboto", Font.sansSerif ]
    in el 
        [ width fill
        , height fill
        , Bg.color <| theme Bg
        ] <| column 
                [ fontFamily
                , Font.color <| theme Text
                , Bg.color <| theme Bg
                , width fill
                , padding 0
                , spacing 128
                ]
                [ headerMobile
                , img
                , phoneMobile
                ]

view : Model -> Html Msg
view model = Element.layout [] <| 
    case model of 
        Just device -> 
            case device.orientation of 
                Element.Portrait ->  mainMobile
                Element.Landscape -> mainElement 
        Nothing -> Element.none

main : Program () Model Msg
main = Browser.element
    { init = init 
    , update = update
    , view = view
    , subscriptions = subs
    }
