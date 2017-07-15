module Test.Data.Traversable exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, intRange)
import Test exposing (..)
import Data.Traversable as Traversable exposing (..)
import Control.Applicative as Applicative
import Test.Data.Foldable exposing (..)

suite : Test
suite =
    describe "The Data.Traversable Module"
        [ describe "all works"
            [ allWorks Fuzz.maybe "maybe" maybe
            , allWorks Fuzz.list "list" list
            ]
        , describe "foldM test"
            [ test "List with a 0 gives Error" 
                (\_ -> Expect.equal (foldDiv 10 [1,2,3,4,5,0,2,32,3]) (Err "Division by zero"))
            , test "Positive List is fine" 
                (\_ -> Expect.equal (foldDiv 40 [4,5]) (Ok 2))
            ]
        , describe "sequence works" 
            [ test "Sequence maybe works"
                (\_ -> Expect.equal (sequence Traversable.list Applicative.maybe [Just 4, Just 10]) (Just [4,10]))
            , test "Sequence maybe wrong works"
                (\_ -> Expect.equal (sequence Traversable.list Applicative.maybe [Just 4, Nothing]) (Nothing))
            , test "Sequence result wrong works"
                (\_ -> Expect.equal (sequence Traversable.list Applicative.result [Ok 3, Err "Oh dear", Ok 20]) (Err "Oh dear"))
            , test "Sequence result works"
                (\_ -> Expect.equal (sequence Traversable.list Applicative.result [Ok 3, Ok 40]) (Ok [3, 40]))
            ]
        ]

