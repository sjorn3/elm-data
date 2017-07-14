module Control.Applicative exposing (..)

import Control.Functor as Functor exposing (Functor)
import Data.Proxy exposing (Proxy(..))
import Task


type alias AndMappable a b c d e r =
    { r | andMap : a -> b -> c, pure : d -> e }


type alias Applicative a b c d e f g h =
    AndMappable a b c d e (Functor f g h)

-- applicative : { b | map : a } -> c -> d -> e -> { andMap : c, ap_proxy : e, map : a, pure : d }
applicative : (Functor f g h) -> (a -> b -> c) -> (d -> e) -> Applicative a b c d e f g h
applicative functor andMap pure =
    { map = functor.map, andMap = andMap, pure = pure }


-- list : { andMap : List (c -> d) -> List c -> List d, ap_proxy : Proxy a, map : (a1 -> b) -> List a1 -> List b, pure : a2 -> List a2 }
-- list : Applicative (List (a -> c)) (List a) (List c) a c (a -> c) (List a) (List c)

-- addFunctor : AndMappable e f g h r -> (a -> b -> c) -> (d -> b) -> Applicative a b c d h f g
-- addFunctor : { i | andMap : e -> e -> g, pure : h -> e } -> (a -> b -> c) -> (d -> b) -> Applicative a b c d h e g

-- addFunctor { andMap, pure } f a b = andMap (pure f) a b--andMap --applicative { map = (\f a b -> andMap (pure f) a b)}

maybeMap maybe f a = maybe.andMap (maybe.pure f) a


ziplist : Applicative (List (c -> d)) (List c) (List d) a (List a) (a1 -> b) (List a1) (List b)
ziplist =
    applicative Functor.list (List.map2 (<|)) (List.singleton) 

maybe : Applicative (Maybe (c -> d)) (Maybe c) (Maybe d) a (Maybe a) (a1 -> b) (Maybe a1) (Maybe b)
maybe =
    applicative Functor.maybe (Maybe.map2 (<|)) Maybe.Just


-- task : { andMap : Task.Task x (c -> d) -> Task.Task x c -> Task.Task x d, ap_proxy : Proxy a, map : (a1 -> b) -> Task.Task x1 a1 -> Task.Task x1 b, pure : a2 -> Task.Task x2 a2 }
-- task =
--     applicative Functor.task (Task.map2 (<|)) Task.succeed Proxy


-- result : { andMap : Result x (b -> c) -> Result x b -> Result x c, ap_proxy : Proxy a, map : (a1 -> value) -> Result x1 a1 -> Result x1 value, pure : value1 -> Result error value1 }
-- result =
--     applicative Functor.result (Result.map2 (<|)) Result.Ok Proxy
