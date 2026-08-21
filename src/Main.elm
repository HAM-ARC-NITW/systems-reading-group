module Main exposing (main)

import Content
import Html
import Utils


main : Html.Html msg
main =
    Html.main_ [] [ header, body ]


header : Html.Html msg
header =
    Html.h1 [] [ Html.text "Systems Reading Group" ]


body : Html.Html msg
body =
    Html.div [] [ description, topics, schedule, resources, attributions ]



-- description section


description : Html.Html msg
description =
    Html.div []
        [ Html.p [] aboutParagraph
        , Html.p []
            [ Html.text "Not sure what systems engineering or reading are? Check "
            , Utils.link "overview" "./public/pdfs/overview.pdf"
            , Html.text " document."
            , Html.br [] []
            , Html.text "Sounds interesting? Join us on "
            , Utils.link "WhatsApp" "https://chat.whatsapp.com/HQYSDQBsCEr160LrH9Qb2b?s=cl&p=a&ilr=4"
            , Html.text ", where most of our discussions take place apart from the IRL sessions which happen at NIT Warangal campus."
            ]
        , quote
        ]


aboutParagraph : List (Html.Html msg)
aboutParagraph =
    [ Html.text
        ("A biweekly reading group focused on the internals of computer systems"
            ++ " -- operating systems, databases, compilers, distributed systems, performance, optimization techniques and everything in between."
            ++ " Each session someone presents a paper, a project, or about a conference talk."
            ++ " Open to everyone, regardless of experience."
            ++ " Managed by "
        )
    , Content.hostView (Content.findReadingGroupHost "Mukesh")
    , Html.text ", "
    , Content.hostView (Content.findReadingGroupHost "Saket")
    , Html.text " and folks at "
    , Utils.link "HAM ARC @ NIT Warangal" "https://github.com/ham-arc-nitw"
    , Html.text "."
    ]


quote : Html.Html msg
quote =
    Html.blockquote []
        [ Html.text "Systems programming is a way of modelling software development."
        , Html.br [] []
        , Html.text "It's not about a category of what you are working on, it's a way of looking at the problem."
        , Html.br [] []
        , Html.text "An excellent systems programmer fully understands the systems involved."
        , Html.br [] []
        , Html.text "-- "
        , Html.cite [] [ Utils.link "Andrew Kelley" "https://www.youtube.com/watch?v=Qncdi-Fg0-I" ]
        ]



-- topics section


topics : Html.Html msg
topics =
    Html.div []
        [ Html.h2 [] [ Html.text "What we explore" ]
        , Html.ul []
            Content.topicsView
        ]



-- schedule section


schedule : Html.Html msg
schedule =
    Html.div []
        [ Html.h2 [] [ Html.text "Schedule" ]
        , Html.table []
            [ Html.thead []
                [ Html.tr []
                    [ Html.th [] [ Html.text "Date" ]
                    , Html.th [] [ Html.text "Topic" ]
                    , Html.th [] [ Html.text "Hosted by" ]
                    ]
                ]
            , Html.tbody [] Content.sessionsView
            ]
        ]



-- resources section


resources : Html.Html msg
resources =
    Html.div []
        [ Html.h2 [] [ Html.text "Resources" ]
        , Html.ul [] Content.resourcesView
        ]



-- attribution section


attributions : Html.Html msg
attributions =
    Html.div []
        [ Html.h2 [] [ Html.text "Attributions" ]
        , Html.p [] [ Html.text "This reading group draws inspiration from the following communities, and we're grateful to them: " ]
        , Html.ul [] Content.attributionsView
        ]
