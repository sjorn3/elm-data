# elm-data: Experimental implementation of generic operations for elm.

Provides means for defining resusable code that can be applied to a `List`, a
`Maybe`, or any other data structure you provide the base functions for.

This library is experimental in nature. Whilst it should be fairly safe to use,
I can only really recomend using this library for trying out some of the
operations in `elm-repl` and saying "huh", or maybe smaller projects. I made it
to try and test what's possible with restrictions present in elm, and the answer
is rather a lot.

An overview of the main restriction is a little jargony and included at the end
of this page.

# Overview of operations

This library provides the data modules `Foldable`, `Functor` and `Traversable`,
and the control modules `Applicative` and `Monad`. A bunch of default
definitions for `List`, `Maybe`, `Result` and other types are provided.

If you don't know what one of the later modules is, I'd recommend learning about
it elsewhere, but an overview of what's possible in each module is provided
below.

## Folding things

Folding a list to get the total sum of elements is very convenient.
```elm
List.sum [1,2,3,4] == 10
```
But what if you could define this same sum function once and apply it to arrays,
sets, results,..? With this library, you can do exactly that:
```elm
sum list [1,2,3,4] == 10
sum maybe (Just 10) == 10
sum array (fromList [1,2,9]) == 12
```
Thus a type can belong to a class of types that are suitable for a given
operation. In this case things of type `List Int` or `Array Int` are perfectly
valid arguments to `sum`, as well as anything else you can reasonably define
`foldr` for.
```elm
sum { foldr } = foldr (+) 0
```
This is saying "Give me a record containing the function `foldr` for a
container, and I'll show you how to add it up." This is the basis for the entire
library.

Notice that the function doesn't take a complicated union type or anything.
That's because this library strives for convenience, and being able to define
functions that only use exactly the operations they need helps with this
immensely.

## Mapping

Another convenient operation on lists is mapping.
```elm
List.map ((+) 2) [10,9,8,7] == [12,11,10,9]
```
A structure that can be mapped over like this can be called a `functor`.
So the following `map` operation works for any given `functor`.
```elm
.map list ((+) 2) [10,9,8,7] == [12,11,10,9]
.map maybe ((*) 345) Nothing == Nothing
```
The dot `.` in `.map` is necessary because this is actually just a field in a
record. This hints at how the instance is defined, which is something like this:
```elm
list = { map = List.map }
```
**DISCLAIMER: The explanations will be less explanatory from here, this library
shouldn't be your first intro to these topics.**

## Applicative

An `Applicative` is like a functor but the function to apply can itself be
inside a structure.

```elm
.andMap list [((*) 2), ((/) 4)] [4,5,10] == [8,10,20,1,0.8,0.4]
.andMap ziplist [((*) 2), ((/) 4)] [4,5,10] == [8,0.8] 
```
A cool feature of this is that you can change the semantics by simply changing
the definitions in the record, as evidenced by the `ziplist` example.

## Traversable

Traversing is very useful, it allows you to take a container of effects and
collect them together. This is much better explained by examples:

```elm
sequence Traversable.list Applicative.maybe [Just 4, Just 10] == Just [4,10]
sequence Traversable.list Applicative.maybe [Just 4, Nothing] == Nothing

.traverse Traversable.list Applicative.maybe List.head [[]] == Nothing

sequence Traversable.list Applicative.list [[1,2,3],[4,5,6]] ==
[[1,4],[1,5],[1,6],[2,4],[2,5],[2,6],[3,4],[3,5],[3,6]]

```
We start needing to be more explicit about which definitions of things we want
here, but it makes things more readable for the person trying to understand it
at least.

I think the best example of this is with `Result`.

```elm
sequence Traversable.list Applicative.result [Ok 3, Err "Oh dear", Ok 20] == Err "Oh dear"
sequence Traversable.list Applicative.result [Ok 3, Ok 40] == Ok [3, 40]
```

If you have some function that applies across a list of values and may fail,
it's a great time to `traverse` with that function. You'll either get back
a list containing your succesful results, or a single error message.

## Monads

I've been avoiding types up to here, because they are not as pretty as the code.
However, I'll assume that if you got this far you already have some understanding 
of the underlying topics, so I'll show you what the story is like on the type level.

I don't know what the hell this is, but it's certainly not a monad:

```elm
type alias Monad a b c d e f g h i j k l =
    AndThenable a b c d (AndMappable e f g h i (Mappable j k l {}))
```

But it, save the restriction below, it *works*. The code itself can still be
very neat and readable.

Here is a definition of `join`. That is, `concat` but for an arbitrary `monad`.

```elm
join : { d | andThen : (a -> a) -> b -> c } -> b -> c
join { andThen } m = m |> andThen identity

join list [[1,2],[4,5,6]] == [1,2,4,5,6]
join maybe (Just Nothing) == Nothing
```
It's clear here that the type is too general for it's own good, but there's not
much that can be done about it. As soon as you apply it to a record though,
you get something which starts to look more reasonable. 
``` elm
> join list
<function> : List (List b) -> List b
```

Although this is of course dependent on how well the `andThen` function is
defined. The `Monad` alias (along with the other aliases) help to aleviate this
somewhat, but ultimately there is a greater risk of problems and bad definitions
than there would be if the type came out like this:
```elm
join : { d | andThen : (a -> m b) -> m a -> m b } -> m (m a) -> m a
```
Hence the inclusion of unit tests.

# Main restriction

**Jargon warning**

Due to the way that type inference works, these classes do not have their full
power that they might have in a higher kinded language with rank 2 polymorphism.

This is a complicated way of saying that when the function is passed in,
the types are locked with no way of saying that they can alter, and so this
will fail to compile:
```elm
compute { andThen, pure } a = pure a |> andThen (List.head) |> andThen (pure << ((*) 2))
```
Whereas a version that explicitly uses maybe will work out just fine:
```elm
compute a = Maybe.Just a |> Maybe.andThen (List.head) |> Maybe.andThen (Maybe.Just << ((*) 2))
```

Note that this would occur even if there were higher kinds, so it's actually
not as big of a draw back as it may appear. There is an issue pertaining to
this if you want more information about it here:
https://github.com/elm-lang/elm-compiler/issues/238

However, just because you can't perform chaining like this doesn't mean that
you can't define some very neat and powerful abstractions! For example,
`foldM` is definable as it does not require chaining `andThen`, and is
defined in `Control.Monad`.

## Why did you make this?

Mostly for the "Is that possible?" factor, but also because I find that
operations like these can reduce code duplication immensely. Hopefully one
day `elm` will support something more robust natively, but for the time being
this is the best alternative I have found.