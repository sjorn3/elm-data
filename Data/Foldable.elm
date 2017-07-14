module Data.Foldable exposing (..)

-- import Control.Applicative

import Array
import Set

type alias Foldr a b c r = 
    { r | foldr : (a -> b -> b) -> b -> c -> b } 

type alias Foldable a b c = Foldr a b c {}
    
foldable : ((a -> b -> b) -> b -> c -> b) -> Foldable a b c
foldable foldr = { foldr = foldr }

list : Foldable a b (List a)
list =
    foldable List.foldr


array : Foldable a b (Array.Array a)
array =
    foldable Array.foldr


set : Foldable comparable b (Set.Set comparable)
set =
    foldable Set.foldr


toList : { d | foldr : (a -> List a -> List a) -> List b -> c -> List b } -> c -> List b
toList { foldr } =
    foldr (::) []


sum : { b | foldr : (number -> number -> number) -> number1 -> a } -> a
sum { foldr } =
    foldr (+) 0


product : { b | foldr : (number -> number -> number) -> number1 -> a } -> a
product { foldr } =
    foldr (*) 1


any : { c | foldr : (a -> Bool -> Bool) -> Bool -> b } -> (a -> Bool) -> b
any { foldr } p =
    foldr (\a b -> b || p a) False


all : { c | foldr : (a -> Bool -> Bool) -> Bool -> b } -> (a -> Bool) -> b
all { foldr } p =
    foldr (\a b -> b && p a) True