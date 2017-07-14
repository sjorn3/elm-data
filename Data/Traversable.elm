module Data.Traversable exposing (..)

import Data.Foldable exposing (Foldr, Foldable)
import Control.Functor exposing (Map, Functor)

type alias Traverse a b c r = { r | traverse : a -> b -> c }

type alias Traversable a b c d e f g h i =
  Traverse a b c (Foldr d e f (Map g h i {}))

traversable : Functor g h i -> Foldable d e f -> (a -> b -> c) -> Traversable a b c d e f g h i
traversable {map} {foldr} traverse = {map = map, foldr = foldr, traverse = traverse}


