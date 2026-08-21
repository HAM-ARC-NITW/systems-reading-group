module Utils exposing (link)

import Html
import Html.Attributes exposing (href, target)


link : String -> String -> Html.Html msg
link label url =
    Html.a [ href url, target "_blank" ] [ Html.text label ]
