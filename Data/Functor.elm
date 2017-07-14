module Data.Functor exposing (..)

import List
import Maybe
import Result
import Array
import Platform.Cmd
import Platform.Sub


type alias Functor a b c =
    { map : a -> b -> c }


list : Functor (a -> b) (List a) (List b)
list =
    Functor List.map


maybe : Functor (a -> b) (Maybe a) (Maybe b)
maybe =
    Functor Maybe.map


result : Functor (a -> value) (Result x a) (Result x value)
result =
    Functor Result.map


array : Functor (a -> b) (Array.Array a) (Array.Array b)
array =
    Functor Array.map


cmd : Functor (a -> msg) (Cmd a) (Cmd msg)
cmd =
    Functor Cmd.map


sub : Functor (a -> msg) (Sub a) (Sub msg)
sub =
    Functor Sub.map
