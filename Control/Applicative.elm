module Control.Applicative exposing (..)

import Control.Functor as Functor exposing (Functor)
import Data.Proxy exposing (Proxy(..))
import Task


type alias AndMappable f a b c d r =
    { r | andMap : f -> a -> b, pure : c -> a, ap_proxy : Proxy d }


type alias Applicative a b c d e f g h =
    AndMappable a b c d e (Functor f g h)

-- applicative : { b | map : a } -> c -> d -> e -> { andMap : c, ap_proxy : e, map : a, pure : d }
applicative : (Functor f g h) -> (a -> b -> c) -> (d -> b) -> Proxy e -> Applicative a b c d e f g h
applicative functor andMap pure ap_proxy =
    { map = functor.map, andMap = andMap, pure = pure, ap_proxy = ap_proxy }


-- list : { andMap : List (c -> d) -> List c -> List d, ap_proxy : Proxy a, map : (a1 -> b) -> List a1 -> List b, pure : a2 -> List a2 }
list : Applicative (List (a -> c)) (List a) (List c) a c (a -> c) (List a) (List c)
list =
    applicative Functor.list (List.map2 (<|)) (List.singleton) Proxy


-- maybe : { andMap : Maybe (c -> d) -> Maybe c -> Maybe d, ap_proxy : Proxy a, map : (a1 -> b) -> Maybe a1 -> Maybe b, pure : a2 -> Maybe a2 }
-- maybe =
--     applicative Functor.maybe (Maybe.map2 (<|)) Maybe.Just Proxy


-- task : { andMap : Task.Task x (c -> d) -> Task.Task x c -> Task.Task x d, ap_proxy : Proxy a, map : (a1 -> b) -> Task.Task x1 a1 -> Task.Task x1 b, pure : a2 -> Task.Task x2 a2 }
-- task =
--     applicative Functor.task (Task.map2 (<|)) Task.succeed Proxy


-- result : { andMap : Result x (b -> c) -> Result x b -> Result x c, ap_proxy : Proxy a, map : (a1 -> value) -> Result x1 a1 -> Result x1 value, pure : value1 -> Result error value1 }
-- result =
--     applicative Functor.result (Result.map2 (<|)) Result.Ok Proxy
