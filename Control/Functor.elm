module Control.Functor exposing (..)

import Set
import Array
import Task
import Platform.Cmd
import Platform.Sub


type alias Map a b c r =
    { r | map : a -> b -> c }


type alias Functor a b c =
    Map a b c {}


functor : (a -> b -> c) -> Functor a b c
functor map =
    { map = map }


list : Functor (a -> b) (List a) (List b)
list =
    functor List.map


maybe : Functor (a -> b) (Maybe a) (Maybe b)
maybe =
    functor Maybe.map


result : Functor (a -> value) (Result x a) (Result x value)
result =
    functor Result.map


array : Functor (a -> b) (Array.Array a) (Array.Array b)
array =
    functor Array.map


cmd : Functor (a -> msg) (Cmd a) (Cmd msg)
cmd =
    functor Cmd.map


sub : Functor (a -> msg) (Sub a) (Sub msg)
sub =
    functor Sub.map


task : Functor (a -> b) (Task.Task x a) (Task.Task x b)
task =
    functor Task.map


set : Functor (comparable -> comparable2) (Set.Set comparable) (Set.Set comparable2)
set =
    functor Set.map
