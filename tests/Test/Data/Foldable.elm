module Test.Data.Foldable exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, intRange)
import Test exposing (..)
import Data.Foldable exposing (..)
import Random exposing (maxInt)
import Control.Monad as M

suite : Test
suite =
    describe "The Data.Foldable Module"
        [ describe "all works"
            [ allWorks Fuzz.maybe "maybe" maybe
            , allWorks Fuzz.list "list" list
            , allWorks Fuzz.array "array" array
            ]
        , describe "foldM test"
            [ test "List with a 0 gives Error" 
                (\_ -> Expect.equal (foldDiv 10 [1,2,3,4,5,0,2,32,3]) (Err "Division by zero"))
            , test "Positive List is fine" 
                (\_ -> Expect.equal (foldDiv 40 [4,5]) (Ok 2))
            ]
        ]


allWorks : (Fuzzer Int -> Fuzzer a) -> String -> { c | foldr : (number -> Bool -> Bool) -> Bool -> a -> Bool } -> Test
allWorks fuzzer name foldable =
    fuzz (fuzzer <| intRange 0 maxInt) ("for " ++ name) (isTrue << all foldable ((<=) 0))


isTrue : Bool -> Expectation
isTrue =
    Expect.equal True

foldDiv : Float -> List number -> Result String Float
foldDiv n = M.foldM list M.result resDiv n

resDiv : Float -> number -> Result String Float
resDiv a b =
    case b of
        0 ->
            Err "Division by zero"

        b ->
            Ok (a / b)
