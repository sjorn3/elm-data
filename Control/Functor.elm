module Control.Functor exposing (..)

import List
import Maybe
import Result
import Set
import Array
import Task
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


task : Functor (a -> b) (Task.Task x a) (Task.Task x b)
task =
    Functor Task.map


set : Functor (comparable -> comparable2) (Set.Set comparable) (Set.Set comparable2)
set =
    Functor Set.map
