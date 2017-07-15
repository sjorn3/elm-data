module Test.Data.Foldable exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, intRange)
import Test exposing (..)
import Data.Foldable exposing (..)
import Random exposing (maxInt)


suite : Test
suite =
    describe "The Data.Foldable Module"
        [ describe "all works"
          [ allWorks Fuzz.maybe "maybe" maybe
          , allWorks Fuzz.list "list" list
          , allWorks Fuzz.array "array" array
          ]
        ]


allWorks : (Fuzzer Int -> Fuzzer a) -> String -> { c | foldr : (number -> Bool -> Bool) -> Bool -> a -> Bool } -> Test
allWorks fuzzer name foldable = fuzz (fuzzer <| intRange 0 maxInt) ("for " ++ name) (isTrue << all foldable ((<=) 0))

isTrue : Bool -> Expectation
isTrue = Expect.equal True