---
title: Functional Programming Practice Session
date: February 12, 2016
fontsize: 8pt
---

## Outline

We'll be covering functional programming concepts that are common to
both Haskell and OCaml (no monads or module types)

* Fold
* Algebraic data types and pattern matching
* Sorting algorithms and practice problems

## Fold
In OCaml:

```Ocaml
fold_right :: ('a -> 'b -> 'b) -> 'a list -> 'b -> 'b
fold_right f acc l = match l with
  [] -> acc
| x::xs -> f x (fold_right f acc xs) ;;

fold_left :: ('b -> 'a -> 'b) -> 'b -> 'a list -> 'b
fold_left f acc l = match l with
  [] -> acc
| x::xs -> f (fold_left f acc xs) x ;;
```

## Fold
In Haskell:

```Haskell 
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f acc [] = acc
foldr f acc (x:xs) = f x (foldr f acc xs)

foldl :: (b -> a -> b) -> b -> [a] -> b
foldl f acc [] = acc
foldl f acc (x:xs) = f (foldl f acc xs) x
```

## Fold
Find the sum of even numbers in a list.

In Haskell:
```Haskell
foldr (\x acc -> if x `mod` 2 == 0 then x+acc else acc) 0 [1,2,3,4,5]
```

In Python (without using `reduce`):

```Python
sum = 0 # sum is the accumulator
for n in [1,2,3,4,5]:
  if n % 2 == 0:
    sum += n
```

## Fold Right vs. Fold Left
```Haskell 
foldr (+) 0 [1,2,3,4,5] =
1 + (2 + (3 + (4 + (5 + 0))))


foldl (+) 0 [1,2,3,4,5] =
((((0 + 5) + 4) + 3) + 2) + 1
```

## Fold Right vs. Fold Left
Fold right is better to use sometimes to short-circuit evaluation; but
in general which one to use depends on the associativity of the function
you are folding. If `f` is left-associative, fold left; if right-associative,
fold right.

```Haskell
or :: Bool -> Bool -> Bool
or True _  = True
or False x = x

foldr or [True,False,False] False =
or True (foldr or [False,False] False) =
True

foldl or [True,False,False] False =
or (foldr or [False,False] False) True = 
or (or (foldr or [False] False) False) True = 
or (or (or (foldr or [] False) False) False) True = 
or (or (or False False) False) True = 
or (or False False) True = 
or False True = 
True
```

## From nothing, fold; from fold, everything
```OCaml
let map f xs =
  List.fold_right (fun x acc -> (f x)::acc) xs []

let filter f xs =
  List.fold_right (fun x acc -> if f x then x::acc else acc) xs []

let length xs =
  List.fold_right (fun x acc -> acc + 1) xs 0
```

## Algebraic Data Types
* User-defined types
* Can encode different variants ("subclasses") of a particular type
* Can compactly encode recursive data structures
* Can be parametrized with type variables (cf. Java generics)

## Algebraic Data Types (ADTs)
OCaml:
```OCaml
type typename =
  | Constructor1 of typename * typename ...
  | Constructor2 of typename * typename ...
  | Constructor3 of typename * typename ...
```

Haskell:
```Haskell
data TypeName =
    Constructor1 TypeName TypeName ...
  | Constructor2 TypeName TypeName ...
  | Constructor3 TypeName TypeName ...
```

## Lists
OCaml:
```OCaml
type 'a list =
  | Cons of 'a * ('a list)
  | Nil

Cons (1, Cons (2, Cons (3, Nil))) = [1;2;3]
```

Haskell:
```Haskell
data List a = Cons a (List a) | Nil

Cons 1 (Cons 2 (Cons 3 Nil)) = [1,2,3]
```

## Pattern Matching
* Like a `switch` statement in Java or C
* Usually used to have separate cases between different constructors of
an ADT and to have separate cases between empty/non-empty lists

## Pattern Matching
OCaml:
```OCaml
let rec sum (l:int list) : int =
  match l with
    Nil -> 0
  | Cons (x, tl) -> x + sum tl
;;
```

Haskell:
```Haskell
sum :: List Int -> Int
sum Nil = 0
sum (Cons n tl) = n + sum tl
```

## Binary Trees
In OCaml
```OCaml
type 'a btree a =
    Node of 'a * ('a btree) * ('a btree)
  | Leaf 'a
  | NilLeaf
;;
let rec preOrder (tree:'a btree) : 'a list = 
  match tree with
    NilLeaf -> []
  | Leaf x -> [x]
  | Node (x, left, right) ->
      [x] @ (preOrder left) @ (preOrder right)
;;
```

## Binary Trees
In Haskell:
```Haskell
data BTree a =
    Node a (BTree a) (BTree a)
  | Leaf a
  | NilLeaf

preOrder :: BTree a -> [a]
preOrder (Leaf x)  = [x]
preOrder (Node x left right) =
  [x] ++ (preOrder left) ++ (preOrder right)
```

## An Arithmetic Language
Hint: Remember this for PA5!

```OCaml
type arith =
  | Val of int
  | Add of arith * arith
  | Sub of arith * arith
  | Mul of arith * arith
;;
eval (a:arith) : int = match a with
  Val n -> n
| Add (x,y) -> (eval x) + (eval y)
| Sub (x,y) -> (eval x) - (eval y)
| Mul (x,y) -> (eval x) * (eval y)
;;
eval (Mul (Add (Val 2, Val 3), Val 4)) = 20 ;;
```

## An Arithmetic Language
In Haskell:

```Haskell
data Arith =
    Val Int
  | Add Arith Arith
  | Sub Arith Arith
  | Mul Arith Arith

eval :: Arith -> Int
eval (Val n)   = n
eval (Add x y) = (eval x) + (eval y)
eval (Sub x y) = (eval x) - (eval y)
eval (Mul x y) = (eval x) * (eval y)

eval (Mul (Add (Val 2) (Val 3)) (Val 4)) = 20
```

## Option Types
Useful for capturing failure in a function

OCaml:
```OCaml
type 'a option = | Some a | None ;;

head (l:'a list) : 'a option =
  match l with
    [] -> None
  | x::xs -> Some x ;;
```

Haskell:
```Haskell
data Maybe a = Just a | Nothing

head :: [a] -> Just a
head []     = Nothing
head (x:xs) = Just x
```

## Functional Programming Idioms

* Recursion, not iteration
* Many tiny functions instead of one big function
* Keep track of state with parameters (accumulators)

# Sorting algorithms

## Insertsort
How is `insert` defined?

```OCaml
let insertSort (l:int list) : int list =
  let rec insert x il = ??? in
  List.fold_right insert l []
;;
```

## Insertsort
```OCaml
let insertSort (l:int list) : int list =
  let rec insert x il = begin match il with
    [] -> [x]
  | y::ys -> if x >= y then y::(insert x ys) else x::y::ys
  end in
  List.fold_right insert l []
;;
```

## Insertsort
In Haskell:

```Haskell
insertSort :: [Int] -> [Int]
insertSort xs = foldr insert [] xs
	where insert x [] = [x]
	      insert x (y:ys) =
          if x >= y then y:(insert x ys) else x:y:ys
```

## Executing insertsort
```Haskell
insertSort [2,3,1,4]

foldr insert [] [2,3,1,4]

insert 2 (foldr insert [] [3,1,4])

insert 2 (insert 3 (foldr insert [] [1,4]))

...

insert 2 (insert 3 (insert 1 (insert 4 [])
```

## Executing insertsort
```Haskell
insert 2 (insert 3 (insert 1 (insert 4 [])

insert 2 (insert 3 (insert 1 [4]))

insert 2 (insert 3 [1,4])

insert 2 (1:(insert 3 [4]))

insert 2 (1:[3,4])

insert 2 [1,3,4]
```

## Executing insertsort
```Haskell
insert 2 [1,3,4]

1:(insert 2 [3,4])

1:[2,3,4]

[1,2,3,4]
```

## Mergesort
How to implement `merge`? (Assume `splitAt` is implemented; we'll go back to it)
```OCaml
let rec mergeSort (l:int list) : int list =
  let rec merge xxs yys = ??? in
  match l with
    [] -> []
  | [x] -> [x]
  | _ ->
    let (left, right) = splitAt (List.length l / 2) l in
    merge (mergeSort left) (mergeSort right)
;;
```

## Mergesort
```OCaml
let rec mergeSort (l:int list) : int list =
  let rec merge xxs yys = begin
    match (xxs,yys) with
      ([], []) -> []
    | (xs, []) -> xs
    | ([], ys) -> ys
    | (x::xs, y::ys) ->
        if x < y then x::(merge xs (y::ys))
                 else y::(merge (x::xs) ys)
  end in
  match l with
    [] -> []
  | [x] -> [x]
  | _ ->
    let (left, right) = splitAt (List.length l / 2) l in
    merge (mergeSort left) (mergeSort right)
;;
```

## Mergesort
```Haskell
mergeSort :: Ord a => [a] -> [a]
mergeSort [] = []
mergeSort l = merge (mergeSort left) (mergeSort right)
  where (left, right) = splitAt (length xs `div` 2) xs
        merge [] [] = []
        merge xs [] = xs
        merge [] ys = ys
        merge (x:xs) (y:ys) =
          if x < y then x:(merge xs (y:ys))
                   else y:(merge (x:xs) ys)
```

## Quicksort
How are `left` and `right` defined?

```OCaml
let rec quicksort (l:int list) : int list =
  match l with
    [] -> []
  | x::xs ->
    let left = ??? in
    let right = ??? in
    (quickSort left) @ [x] @ (quickSort right)
;;
```

## Quicksort
```OCaml
let rec quicksort (l:int list) : int list =
  match l with
    [] -> []
  | x::xs ->
    let left = List.filter (fun y -> x >= y) xs in
    let right = List.filter (fun y -> x < y) xs in
    (quickSort left) @ [x] @ (quickSort right)
;;
```

## Quicksort
In Haskell:

```Haskell
quickSort :: Ord a => [a] -> [a]
quickSort [] = []
quickSort (x:xs) =
  (quickSort left) ++ [x] ++ (quickSort right)
  where left = filter (x >=) xs
        right = filter (x <) xs
        
```

## Quicksort with explicit partition
In OCaml:
```OCaml
let rec quickSort2 (l:int list) : int list =
  match l with
    [] -> []
  | x::xs ->
    let part y (lo, hi) = if x >= y then (y::lo, hi) else (lo, y::hi) in
    let partition lp = List.fold_right part lp ([],[]) in
    let (left, right) = partition xs in
    (quickSort2 left) @ [x] @ (quickSort2 right)
;;
```

## Quicksort with explicit partition
In Haskell:
```Haskell
quickSort2 :: Ord a => [a] -> [a]
quickSort2 [] = []
quickSort2 (x:xs) =
  (quickSort2 left) ++ [x] ++ (quickSort2 right)
  where (left, right) = partition xs
        partition = foldr part ([], [])
        part y (low, hi) =
          if x >= y then (y:low, hi) else (low, y:hi)
```

Notice the partial application for `partition`!

# Practice Problems

## Problem 1
Implement `append` recursively. Don't use other functions!

```OCaml
let append (xxs:'a list) (yys:'a list) : 'a list = ??? ;;

append [1;2;3] [4;5;6] = [1;2;3;4;5;6]
```

## Problem 1 answer
Implement `append` recursively. Don't use other functions!

```OCaml
let rec append (xxs:'a list) (yys:'a list) : 'a list =
  match xxs with
    [] -> ys
  | x::xs -> x::(append xs ys)
;;
```

## Problem 1 answer
In Haskell:

```Haskell
append :: [a] -> [a] -> [a]
append [] ys = ys
append (x:xs) ys = x:(append xs ys)
```

## Problem 2
Implement `reverse` recursively. Don't use other functions!

```Haskell
let rec reverse (l:'a list) : 'a list = ??? ;;

reverse [1;2;3;4;5] = [5;4;3;2;1]
```

## Problem 2 answer
Implement `reverse` recursively. Don't use other functions!

```OCaml
let rec reverse (l:'a list) : 'a list =
  let rec insertBack y xxs = begin
    match xxs with
      [] -> [y]
      x::xs -> x::(insertBack y xs)
  end in
  match l with
    [] -> []
    x::xs -> insertBack x (reverse xs)
;;
```

## Problem 2 answer
In Haskell:

```Haskell
reverse :: [a] -> [a]
reverse [] = []
reverse (x:xs) = insertBack x (reverse xs)
  where insertBack x [] = [x]
        insertBack x (y:ys) = y:(insertBack x ys)
```

## Problem 3
Implement `treeSum`. (Hint: Remember how `preOrder` is implemented)

```OCaml
type 'a btree =
  | Node of 'a * 'a btree * 'a btree
  | Leaf of 'a
  | NilLeaf
;;

let rec treeSum (tree:int btree) : int = ??? ;;

treeSum (Node (4, Leaf 5, NilLeaf)) = 9
```

## Problem 3 answer
Implement `treeSum`.

```OCaml
type 'a btree =
  | Node of 'a * 'a btree * 'a btree
  | Leaf of 'a
  | NilLeaf
;;

let rec treeSum (tree:int btree) : int =
  match tree with
    NilLeaf -> 0
  | Leaf n -> n
  | Node (n,left,right) -> n + (treeSum left) + (treeSum right)
;;

```

## Problem 3 answer
In Haskell:

```Haskell
data BTree a =
    Node a (BTree a) (BTree a)
  | Leaf a
  | NilLeaf

treeSum :: BTree Int -> Int
treeSum NilLeaf = 0
treeSum (Leaf x) = x
treeSum (Node x left right) =
  x + (treeSum left) + (treeSum right)
```

## Problem 4
Implement `unzip`.

```OCaml
let unzip (l:('a * 'b) list) : ('a list) * ('b list) = ??? ;;

unzip [(1,"A");(2,"B");(3,"C")] = ([1;2;3], ["A";"B";"C"])
```

## Problem 4 answer
Implement `unzip`.

```OCaml
let unzip (l:('a * 'b) list) : ('a list) * ('b list) =
  List.fold_right (fun (x,y) (xs,ys) -> (x::xs, y::ys)) l ([], [])
;;
```


## Problem 4 answer
In Haskell:

```Haskell
unzip :: [(a,b)] -> ([a], [b])
unzip tups =
  foldr (\(x,y) (xs,ys) -> (x:xs, y:ys)) ([], []) tups
```

## Problem 5
Implement `splitAt`.

```OCaml
let splitAt (n:int) (l:'a list) : ('a list) * ('a list) = ??? ;;

splitAt 2 [1;2;3;4] = ([1;2],[3;4])
splitAt 0 [1;2;3;4] = ([], [1;2;3;4])
splitAt 4 [1;2;3;4] = ([1;2;3;4], [])
```

## Problem 5 answer
Implement `splitAt`.

Common technique: define an "inner" function with explicit accumulator
parameter(s), then have the "outer" function call the inner function with a
initial accumulator value(s)

```OCaml
let splitAt (n:int) (l:'a list) : ('a list) * ('a list) =
  let rec splitAt_ n2 l2 acc = begin
    match (n2,l2) with
      (0, ys) -> (acc, ys)
    | (n, []) -> (acc, [])
    | (n, y::ys) -> splitAt_ (n-1) ys (acc @ [y])
  end in
  splitAt_ n l []
;;
```

## Problem 5 answer
In Haskell:

```Haskell
splitAt :: Int -> [a] -> ([a], [a])
splitAt n xs = splitAt_ n xs []
  where splitAt_ 0 ys acc     = (acc, ys)
        splitAt_ n [] acc     = (acc, [])
        splitAt_ n (y:ys) acc =
          splitAt_ (n-1) ys (acc ++ [y])
```

## More Problems
* Implement some of the functions from the `List` module
    * Haskell: [https://hackage.haskell.org/package/base-4.8.2.0/docs/Data-List.html](https://hackage.haskell.org/package/base-4.8.2.0/docs/Data-List.html)
    * Ocaml: [http://caml.inria.fr/pub/docs/manual-ocaml/libref/List.html](http://caml.inria.fr/pub/docs/manual-ocaml/libref/List.html)
