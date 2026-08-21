module Content exposing (attributionsView, findReadingGroupHost, hostView, resourcesView, sessionsView, topicsView)

import Html
import List
import Utils


type alias Host =
    { name : String
    , site : String
    }


type alias Topic =
    { name : String
    , description : String
    }


type alias Session =
    { date : String
    , title : String
    , host : Host
    }


type alias Resource =
    { name : String
    , url : String
    }


type alias Attribution =
    { name : String
    , url : String
    , hosts : List Host
    }


readingGroupHosts : List Host
readingGroupHosts =
    [ Host "Mukesh" "https://mukesh.0xc84.fyi"
    , Host "Saket" "https://www.linkedin.com/in/saket-modi321"
    ]


topics : List Topic
topics =
    [ { name = "Programming languages"
      , description = "compilers, parsers, interpreters, type systems, developer tooling"
      }
    , { name = "Operating systems"
      , description = "kernels, schedulers, device drivers, filesystems, eBPF"
      }
    , { name = "Distributed systems"
      , description = "consensus protocols, replication, consistency models, gossip protocols"
      }
    , { name = "Databases"
      , description = "query engines, transaction processing, storage formats, indexing"
      }
    , { name = "Performance"
      , description = "SIMD, hardware acceleration, profiling, parallelism"
      }
    , { name = "Graphics programming"
      , description = "shaders, ray tracing, GPU programming, game engines"
      }
    , { name = "Virtualization"
      , description = "hypervisors, emulators, microVMs, container runtimes"
      }
    , { name = "Security"
      , description = "sandboxing, cryptographic protocols, exploit development, fuzzing"
      }
    , { name = "Machine learning systems"
      , description = "training infrastructure, inference engines, model serving"
      }
    , { name = "Bioinformatics"
      , description = "sequence alignment, genome assembly, computational biology"
      }
    ]


sessions : List Session
sessions =
    [ { date = "16th August 2026"
      , title = "An intro to emulation develoment"
      , host = findReadingGroupHost "Mukesh"
      }
    , { date = "16th August 2026"
      , title = "A deep dive into WebSocket protocol"
      , host = findReadingGroupHost "Saket"
      }
    ]


resources : List Resource
resources =
    [ { name = "Overview"
      , url = "./public/pdfs/overview.pdf"
      }
    , { name = " Making Systems Programming Accessible - Andrew Kelley"
      , url = "https://www.youtube.com/watch?v=Qncdi-Fg0-I"
      }
    ]


attributions : List Attribution
attributions =
    [ { name = "NYC Systems"
      , url = "https://nycsystems.xyz/"
      , hosts =
            [ Host "Angelo Saraceno" "https://x.com/ngeloxyz/"
            , Host "Aaron Eline" "https://aaronjeline.github.io/"
            , Host "Phil Eaton" "https://x.com/eatonphil"
            ]
      }
    , { name = "Bengaluru Systems Group"
      , url = "https://x.com/BengaluruSys"
      , hosts = []
      }
    , { name = "Ottawa Systems"
      , url = "https://ottawasystems.xyz/"
      , hosts =
            [ Host "Pawan Dubey" "https://tiny.tilde.website/@pawandubey"
            , Host "Aaron Brady" "https://tiny.tilde.website/@insom"
            ]
      }
    , { name = "Arcane Systems Reading Group"
      , url = "https://asrg-gg.github.io/"
      , hosts = [ Host "Hari Varsha" "https://www.varsha.sh/" ]
      }
    , { name = "Atlas @ Amrita Bengaluru"
      , url = "https://atlasdev.club/"
      , hosts =
            [ Host "Aditya Nair" "https://adithyanair.com/"
            , Host "Nithilan Rameshkumar" "https://nithitsuki.com/"
            , Host "Nikhil Bharadwaj" "https://heftymouse.me/"
            ]
      }
    , { name = "Systems Reading Group @ IIT Delhi"
      , url = "https://systems-rg.github.io/"
      , hosts =
            [ Host "Abhilash Jindal" "https://abhilash-jindal.com/"
            ]
      }
    ]


findReadingGroupHost : String -> Host
findReadingGroupHost name =
    readingGroupHosts
        |> List.filter (\h -> h.name == name)
        |> List.head
        |> Maybe.withDefault { name = "Unknown", site = "" }


hostView : Host -> Html.Html msg
hostView host =
    Utils.link host.name host.site


topicsView : List (Html.Html msg)
topicsView =
    topics
        |> List.map
            (\t ->
                Html.li []
                    [ Html.b [] [ Html.text t.name ]
                    , Html.text ": "
                    , Html.text t.description
                    ]
            )


sessionsView : List (Html.Html msg)
sessionsView =
    sessions
        |> List.map
            (\s ->
                Html.tr []
                    [ Html.th [] [ Html.text s.date ]
                    , Html.th [] [ Html.text s.title ]
                    , Html.th [] [ hostView s.host ]
                    ]
            )


resourcesView : List (Html.Html msg)
resourcesView =
    resources
        |> List.map (\r -> Html.li [] [ Utils.link r.name r.url ])


attributionsView : List (Html.Html msg)
attributionsView =
    attributions
        |> List.map (\a -> Html.li [] [ Utils.link a.name a.url, attributionHostsView a.hosts ])


attributionHostsView : List Host -> Html.Html msg
attributionHostsView hosts =
    if List.length hosts == 0 then
        Html.text ""

    else
        Html.span [] (Html.text " -- Managed by " :: List.intersperse (Html.text ", ") (List.map hostView hosts))
