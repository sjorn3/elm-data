module Test.Data.Functor exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int)
import Test exposing (..)
import Data.Functor exposing (..)


suite : Test
suite =
    describe "The Data.Functor Module"
        [ describe "fmap id  ==  id"
            [ fuzz (Fuzz.maybe int) "for maybe" (Expect.equal True << (structureLaw maybe))
            , fuzz (Fuzz.list int) "for list" (Expect.equal True << (structureLaw list))
            , fuzz (Fuzz.array int) "for array" (Expect.equal True << (structureLaw array))
            , fuzz (Fuzz.result int int) "for result" (Expect.equal True << (structureLaw result))
            ]
        , describe "fmap (f . g)  ==  fmap f . fmap g"
            [ fuzz3 int int (Fuzz.maybe int) "for maybe" (composeLaw_ maybe)
            , fuzz3 int int (Fuzz.list int) "for list" (composeLaw_ list)
            , fuzz3 int int (Fuzz.array int) "for array" (composeLaw_ array)
            , fuzz3 int int (Fuzz.result int int) "for result" (composeLaw_ result)
            ]
        ]


structureLaw : { c | map : (a -> a) -> b -> b } -> b -> Bool
structureLaw { map } f =
    (map identity f) == (identity f)
    
composeLaw_ : { c | map : (number -> number) -> a -> a } -> number -> number -> a -> Expectation
composeLaw_ functor a b = Expect.equal True << composeLaw functor ((+) a) ((*) b)

composeLaw : { c | map : (b -> b) -> a -> a } -> (b -> b) -> (b -> b) -> a -> Bool
composeLaw { map } f g a =
    map (f << g) a == (map f << map g <| a)
