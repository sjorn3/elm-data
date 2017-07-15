module Data.Traversable exposing (..)

import Data.Foldable as Foldable exposing (Foldr, Foldable)
import Data.Functor as Functor exposing (Map, Functor)


type alias Traverse ap a b c d r =
    { r | traverse : ap -> (a -> b) -> c -> d }


type alias Traversable ap a b c d e f g h i j =
    Traverse ap a b c d (Foldr e f g (Map h i j {}))


traversable : Functor h i j -> Foldable e f g -> (ap -> (a -> b) -> c -> d) -> Traversable ap a b c d e f g h i j
traversable { map } { foldr } traverse =
    { map = map, foldr = foldr, traverse = traverse }


list : Traversable { h | andMap : c -> d -> d, map : (e -> List e -> List e) -> f -> c, pure : List g -> d } i f (List i) d a b (List a) (a1 -> b1) (List a1) (List b1)
list =
    let
        traverse { pure, map, andMap } f =
            List.foldr (\x ys -> andMap (map (::) <| f x) ys) (pure [])
    in
        traversable Functor.list Foldable.list traverse


maybe : Traversable { e | map : (a -> Maybe a) -> c -> d, pure : Maybe a1 -> d } a2 b (Maybe c) d a3 b1 (Maybe a3) (a4 -> b2) (Maybe a4) (Maybe b2)
maybe =
    let
        traverse { pure, map } f m =
            case m of
                Nothing ->
                    pure Nothing

                Just x ->
                    map Just x
    in
        traversable Functor.maybe Foldable.maybe traverse

sequence : { d | traverse : b -> (a -> a) -> c } -> b -> c
sequence a b = .traverse a b identity