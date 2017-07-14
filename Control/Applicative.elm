module Control.Applicative exposing (..)

import Control.Functor as Functor exposing (Functor)
import Task


type alias AndMappable a b c d e r =
    { r | andMap : a -> b -> c, pure : d -> e }


type alias Applicative a b c d e f g h =
    AndMappable a b c d e (Functor f g h)


applicative : Functor f g h -> (a -> b -> c) -> (d -> e) -> Applicative a b c d e f g h
applicative functor andMap pure =
    { map = functor.map, andMap = andMap, pure = pure }


addFunctor : { e | andMap : d -> b -> c, pure : a -> d } -> Applicative d b c a d a b c
addFunctor rec =
    applicative (functor rec) rec.andMap rec.pure


functor : { e | andMap : a -> b -> c, pure : d -> a } -> Functor d b c
functor { andMap, pure } =
    Functor.functor (\f -> andMap (pure f))

list : Applicative (List (a -> b)) (List a) (List b) a1 (List a1) (a2 -> b1) (List a2) (List b1)
list =
    let
        andMap fs xs =
            case fs of
                [] ->
                    []

                f :: fs ->
                    List.map f xs ++ andMap fs xs
    in
        applicative Functor.list andMap List.singleton


ziplist : Applicative (List (c -> d)) (List c) (List d) a (List a) (a1 -> b) (List a1) (List b)
ziplist =
    applicative Functor.list (List.map2 (<|)) (List.singleton)


maybe : Applicative (Maybe (c -> d)) (Maybe c) (Maybe d) a (Maybe a) (a1 -> b) (Maybe a1) (Maybe b)
maybe =
    applicative Functor.maybe (Maybe.map2 (<|)) Maybe.Just


task : Applicative (Task.Task x (c -> d)) (Task.Task x c) (Task.Task x d) a (Task.Task x1 a) (a1 -> b) (Task.Task x2 a1) (Task.Task x2 b)
task =
    applicative Functor.task (Task.map2 (<|)) Task.succeed


result : Applicative (Result x (b -> c)) (Result x b) (Result x c) value (Result error value) (a -> value1) (Result x1 a) (Result x1 value1)
result =
    applicative Functor.result (Result.map2 (<|)) Result.Ok
