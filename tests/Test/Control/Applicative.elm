module Test.Control.Applicative exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int)
import Test exposing (..)
import Control.Applicative exposing (..)


suite : Test
suite =
    describe "The Control.Applicative Module"
        [ describe "pure id <*> v == v"
            [ fuzz (Fuzz.maybe int) "for maybe" (identityTest maybe)
            , fuzz (Fuzz.list int) "for list" (identityTest list)
            -- , fuzz (Fuzz.list int) "for ziplist" (identityTest ziplist)
            , fuzz (Fuzz.result int int) "for result" (identityTest result)
            ]
        -- TODO: add the other laws
        ]


identityTest : { d | andMap : b -> c -> c, pure : (a -> a) -> b } -> c -> Expectation
identityTest ap a =
    isTrue <| apIdentity ap a


apIdentity : { d | andMap : b -> c -> c, pure : (a -> a) -> b } -> c -> Bool
apIdentity { andMap, pure } a =
    andMap (pure identity) a == a

isTrue : Bool -> Expectation
isTrue =
    Expect.equal True
