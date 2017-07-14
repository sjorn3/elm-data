module Control.Monad exposing (..)

import Control.Functor exposing (Functor)
import Control.Applicative as Applicative exposing (AndMappable, Applicative)
import Task


type alias AndThenable a b c d r =
    { r | andThen : (a -> b) -> c -> d }


type alias Monad a b c d e f g h i j k l =
    AndThenable a b c d (AndMappable e f g h i (Functor j k l))


monad : Applicative e f g h i j k l -> ((a -> b) -> c -> d) -> Monad a b c d e f g h i j k l
monad { map, andMap, pure } andThen =
    { map = map, andMap = andMap, pure = pure, andThen = andThen }


list : Monad a (List b) (List a) (List b) (List (a1 -> b1)) (List a1) (List b1) a1_1 (List a1_1) (a2 -> b1_1) (List a2) (List b1_1)
list =
    monad Applicative.list List.concatMap


maybe : Monad a (Maybe b) (Maybe a) (Maybe b) (Maybe (c -> d)) (Maybe c) (Maybe d) a1 (Maybe a1) (a1_1 -> b1) (Maybe a1_1) (Maybe b1)
maybe =
    monad Applicative.maybe Maybe.andThen


result : Monad a (Result x b) (Result x a) (Result x b) (Result x1 (b1 -> c)) (Result x1 b1) (Result x1 c) value (Result error value) (a1 -> value1) (Result x1_1 a1) (Result x1_1 value1)
result =
    monad Applicative.result Result.andThen


task : Monad a (Task.Task x b) (Task.Task x a) (Task.Task x b) (Task.Task x1 (c -> d)) (Task.Task x1 c) (Task.Task x1 d) a1 (Task.Task x1_1 a1) (a1_1 -> b1) (Task.Task x2 a1_1) (Task.Task x2 b1)
task =
    monad Applicative.task Task.andThen
