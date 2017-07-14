module Data.Proxy exposing (..)

type Proxy a = Proxy

reproxy : Proxy a -> Proxy b
reproxy Proxy = Proxy