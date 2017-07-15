module Test.Control.Monad exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int)
import Test exposing (..)
import Control.Monad exposing (..)


suite : Test
suite =
    describe "The Control.Monad Module"
        [ describe "return a >>= f == f a"
            [ fuzz int "for maybe" (leftIdentityTest maybe)
            , fuzz int "for list" (leftIdentityTest list)
            , fuzz int "for result" (leftIdentityTest result)
            ]
        , describe "m >>= return == m"
            [ fuzz int "for maybe" (rightIdentityTest maybe)
            , fuzz int "for list" (rightIdentityTest list)
            , fuzz int "for result" (rightIdentityTest result)
            ]
        , describe "Associativity law" --"(m >>= f) >>= g == m >>= (\x -> f x >>= g)" 
            [ fuzz3 int int int "for maybe" (associativityTest maybe)
            , fuzz3 int int int "for list" (associativityTest list)
            , fuzz3 int int int "for result" (associativityTest result)
            ]
        ]


leftIdentityTest : { a | andThen : (number -> c) -> c -> c, pure : number -> c } -> number -> Expectation
leftIdentityTest monad =
    isTrue << leftIdentity monad (monad.pure << (*) 10)


leftIdentity : { d | andThen : (a -> b) -> c -> b, pure : a -> c } -> (a -> b) -> a -> Bool
leftIdentity { andThen, pure } f a =
    andThen f (pure a) == f a


rightIdentityTest : { c | andThen : (a -> b) -> b -> b, pure : a -> b } -> a -> Expectation
rightIdentityTest monad =
    isTrue << rightIdentity monad << monad.pure


rightIdentity : { c | andThen : a -> b -> b, pure : a } -> b -> Bool
rightIdentity { andThen, pure } m =
    andThen pure m == m

associativityTest monad a b = isTrue << associativity monad (monad.pure << (*) a) (monad.pure << (-) b) << monad.pure

associativity { andThen, pure } f g m = (m |> andThen f |> andThen g) == andThen (\x -> andThen g (f x)) m


isTrue : Bool -> Expectation
isTrue =
    Expect.equal True
