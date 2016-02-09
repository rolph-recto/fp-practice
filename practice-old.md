---
title: Functional Programming Practice Session
date: February 12, 2016
fontsize: 10pt
---

## Outline

We'll be covering functional programming concepts that are common to
both Haskell and OCaml (no monads or module types)

* Basic constructs: Lets, Lists and Tuples
* Functions as first class objects
* Polymorphism and higher-order functions
* Algebraic data types and pattern matching
* Functional programming idioms
* Sorting algorithms and practice problems

## What is functional programming?
* From the lambda calculus, a model of computation that is different
but equivalent to Turing machines
    * Everything is a function! (Seriously: look up Church encodings)
* "Functional" comes from mathematical functions: take some value as input and
return a new value as output
    * Not like subroutines (an isolated set of commands)
* Referential transparency: can replace function call with its body
    * Only true in general if functions have no side effects (purity)

## What is functional programming?

In OCaml:

```OCaml
let greet name = "Hey " ^ name ^ "!" ;;
like thing = "I like " ^ thing ^ "." ;;
paragraph s1 s2 = s1 ^ " " ^ s2 ;;

paragraph (greet "Bob") (like "sushi") =
paragraph "Hey Bob!" "I like sushi." =
"Hey Bob! I like sushi."
```

## What is functional programming?

In Haskell:

```Haskell
greet name = "Hey " ++ name ++ "!"
like thing = "I like " ++ thing ++ "."
paragraph s1 s2 = s1 ++ " " ++ s2

paragraph (greet "Bob") (like "sushi") =
paragraph "Hey Bob!" "I like sushi." =
"Hey Bob! I like sushi."
```

## Basic constructs: Lets, Lists and Tuples
Let: give a name (binding) to an expression

* NOT like declaring a variable; cannot be modified
(unless you're using `ref` types in OCaml)
* Can also be used to declare functions

## Basic constructs: Lets, Lists and Tuples
```Haskell
let [VAR] = [VALUE] in [EXPR]

let a = 10 in x + a = x + 10 

let add2 x = x + 2 in
let mul3 y = y * 3 in
mul3 (add2 1)
```

## Basic constructs: Lets, Lists and Tuples
Lists: no explanation needed

* Homogenous like lists in Java, can only have one type
* Usually processed from beginning to end; (try to avoid random access with indices)

## Basic constructs: Lets, Lists and Tuples
These are all equivalent!

In OCaml:

```OCaml
let add x = x + 2 in add2 5

let add2 = (fun x -> x + 2) in add2 5

(fun x -> x + 2) 5
```

## Basic constructs: Lets, Lists and Tuples
These are all equivalent!

In Haskell:

```Haskell
let add x = x + 2 in add2 5

let add2 = \x -> x + 2 in add2 5

(\x -> x + 2) 5

add2 5 where add2 x = x + 2
```

## Basic constructs: Lets, Lists and Tuples
Tuples: Bundle values together

* Pretty much like Python tuples
* Instead of indexing to access values though, there are
functions that project values packed in a tuple
* `fst` returns first value of tuple; `snd` returns second value

## Basic constructs: Lets, Lists and Tuples
In OCaml:

```OCaml
let pay p amt = (fst p, (snd p)+amt) ;;
let reportMoney p =
  (fst p) ^ " has " ^ (string_of_int (snd p)) ^ " dollars." ;;

let bob = ("Bob",0) in
let bob' = pay bob 20 in
reportMoney bob'
= "Bob has 20 dollars."
```

## Basic constructs: Lets, Lists and Tuples
In Haskell:

```Haskell
pay p amt = (fst p, (snd p)+amt)
reportMoney p =
  (fst p) ++ " has " ++ (show (snd p)) ++ " dollars."

let bob = ("Bob",0) in
let bob' = pay bob 20 in
reportMoney bob'
= "Bob has 20 dollars."
```

## Functions as first-class objects
* Functions are expressions like `1 + 1 = 2`
* Can be declared with `let`
* Can be anonymous (cf. Python and Java `lambda`s)


## Partial application / Currying


## Polymorphism
* polymorphic functions: work on *all* types
* can have *type variables* instead of actual concrete types

## Polymorphism

```Haskell
idInt :: Int -> Int
idInt x = x

idStr :: String -> String
idStr x = x

idInt 2 = 2
idStr "ok" = "ok"
```

Redundant code! Can we write `id` only once?

## Polymorphism
Haskell:

```Haskell
id :: a -> a
id x = x
```

OCaml:

```OCaml
id :: 'a -> 'a
id x = x
```

Better! Works for *any* type

## Higher-Order Functions
* higher-order functions: take other functions as arguments
* used for common computations (usu. involving lists)

## Higher-Order Functions
Some examples

* `map`: convert values in a list
* `filter`: keep only part of the list that satisfies a predicate
* `fold`: compute a value by iterating over elements of a list

## Higher-Order Functions
In OCaml:

```OCaml
map :: ('a -> 'b) -> 'a list -> 'b list
let map f l = match l with
  []    -> []
| x::xs -> (f x)::(map f xs) ;;

filter :: ('a -> bool) -> 'a list -> 'a list
let filter f l = match l with
  []    -> []
| x::xs -> if f x then x::(filter f xs) else filter f xs
```

## Higher-Order Functions
```Haskell
map :: (a -> b) -> [a] -> [b]
map f [] = []
map f (x:xs) = (f x):(map f xs)

filter :: (a -> Bool) -> [a] -> [a]
filter f [] = []
filter f (x:xs) =
	if f x then x:(filter f xs) else filter f xs
```

## Higher-Order Functions
In OCaml:
```OCaml
let add2 x = x+2 in
map add2 [1;2;3;4;5] =
[3;4;5;6;7]

filter (fun x -> x mod 2) [1;2;3;4;5;6] =
[2;4;6]
```

## Higher-Order Functions
In Haskell:
```Haskell
let add2 x = x+2 in
map add2 [1,2,3,4,5] =
[3,4,5,6,7]

filter (\x -> x `mod` 2) [1,2,3,4,5,6] =
[2,4,6]
```

## Higher-Order Functions
In OCaml:

```Ocaml
foldr :: ('a -> 'b -> 'b) -> 'b -> 'a list -> 'b
foldr f acc l = match l with
  [] -> acc
| x::xs -> f x (foldr f acc xs) ;;

foldl :: ('b -> 'a -> 'b) -> 'b -> 'a list -> 'b
foldl f acc l = match l with
  [] -> acc
| x::xs -> f (foldl f acc xs) x ;;
```

## Higher-Order Functions
In Haskell:

```Haskell 
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f acc [] = acc
foldr f acc (x:xs) = f x (foldr f acc xs)

foldl :: (b -> a -> b) -> b -> [a] -> b
foldl f acc [] = acc
foldl f acc (x:xs) = f (foldl f acc xs) x
```

## Higher-Order Functions
```Haskell 
foldr (+) 0 [1,2,3,4,5] =
(+) 1 ((+) 2 ((+) 3 ((+) 4 ((+) 5 0)))) = 
1 + (2 + (3 + (4 + (5 + 0))))


foldl (+) 0 [1,2,3,4,5] =
(+) ((+) ((+) ((+) ((+) 0 5) 4) 3) 2) 1 =
((((0 + 5) + 4) + 3) + 2) + 1
```

## Higher-Order Functions
Compare with Python:

```Python
sum = 0 # sum is the accumulator
for n in numbers:
  sum += n
```

## From nothing, fold; from fold, everything
```OCaml
let map f xs =
  foldr (fun x acc -> (f x)::acc) [] xs

let filter f xs =
  foldr (fun x acc -> if f x then x::acc else acc) [] xs

let length xs =
  foldr (fun x acc -> acc + 1) 0 xs
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

Cons (1 , Cons (2 , Cons (3, Nil))) = [1;2;3]
```

Haskell:
```Haskell
data List a = Cons a (List a) | Nil

Cons 1 (Cons 2 (Cons 3 Nil)) = [1,2,3]
```

## Pattern Matching
* Like a `switch` statement in Java or C
* Usually used to have separate cases between different constructors of
an ADT (though you can also pattern match against values also)

## Pattern Matching
OCaml:
```OCaml
sum :: int list -> int
sum l = match l with
  Nil -> 0
| Cons x tl -> x + sum tl
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

preOrder :: 'a btree -> 'a list
preOrder tree = match tree with
  NilLeaf -> []
| Leaf x -> [x]
| Node x left right ->
    [x] @ (preOrder left) @ (preOrder right)
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

In OCaml:

```OCaml
type arith =
  | Val of int
  | Add of arith * arith
  | Sub of arith * arith
  | Mul of arith * arith

eval :: arith -> int
eval a = match a with
  Val n -> n
| Add (x,y) -> (eval x) + (eval y)
| Sub (x,y) -> (eval x) - (eval y)
| Mul (x,y) -> (eval x) * (eval y)

eval (Mul (Add (Val 2, Val 3), Val 4)) = 20
```

## An Arithmetic Language
Hint: Remember this for PA5!

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

head :: 'a list -> 'a option
head l = match l with
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

# Functional Programming Idioms

## Recursion, not iteration

## Many tiny functions

## Keep track of state with parameters

# Sorting algorithms

## Insertsort
How is `insert` defined?

```Haskell
insertSort :: Ord a => [a] -> [a]
insertSort xs = foldr insert [] xs
	where insert x [] = [x]
	      insert x (y:ys) = ???
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
;;
    

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
How to implement `merge`?

```Haskell
mergeSort :: Ord a => [a] -> [a]
mergeSort [] = []
mergeSort [x] = [x]
mergeSort l = merge (mergeSort left) (mergeSort right)
  where (left, right) = splitAt (length l `div` 2) l
        merge [] [] = []
        merge xs [] = xs
        merge [] ys = ys
        merge (x:xs) (y:ys) = ???
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

```Haskell
quickSort :: Ord a => [a] -> [a]
quickSort [] = []
quickSort (x:xs) =
  (quickSort left) ++ [x] ++ (quickSort right)
  where left = ???
        right = ???
        
```

## Quicksort
```Haskell
quickSort :: Ord a => [a] -> [a]
quickSort [] = []
quickSort (x:xs) =
  (quickSort left) ++ [x] ++ (quickSort right)
  where left = filter (x >=) xs
        right = filter (x <) xs
        
```

## Quicksort with explicit partition
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
Implement `treeSum`. (Hint: Remember how `preOrder is implemented)

```Haskell
data BTree a =
    Node a (BTree a) (BTree a)
  | Leaf a
  | NilLeaf

treeSum :: BTree Int -> Int
treeSum tree = ???

treeSum (Node
          (Node (Leaf 10) NilLeaf)
          (Node (Leaf 1) (Leaf 5))) = 16
```

## Problem 1 answer
Implement `treeSum`.

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

## Problem 2
Implement `append` recursively. Don't use other functions!

```Haskell
append :: [a] -> [a] -> [a]
append xs ys = ???

append [1,2,3] [4,5,6] = [1,2,3,4,5,6]
```

## Problem 2 answer
Implement `append` recursively. Don't use other functions!

```Haskell
append :: [a] -> [a] -> [a]
append [] ys = ys
append (x:xs) ys = x:(append xs y)
```

## Problem 3
Implement `reverse` recursively. Don't use other functions!

```Haskell
reverse :: [a] -> [a]
reverse xs = ???

reverse [1,2,3,4,5] = [5,4,3,2,1]
reverse "hello world" = "dlrow olleh"
```

## Problem 3 answer
Implement `reverse` recursively. Don't use other functions!

```Haskell
reverse :: String -> String -> String
reverse [] = []
reverse (x:xs) = insertBack x (reverse xs)
  where insertBack x [] = [x]
        insertBack x (y:ys) = y:(insertBack ys)
```

## Problem 4
Implement `unzip`.

```Haskell
unzip :: [(a,b)] -> ([a], [b])
unzip tups = ???

unzip [(1,"A"), (2,"B"), (3,"C")] =
  ([1,2,3], ["A","B","C"])
```

## Problem 4 answer
Implement `unzip`.

```Haskell
unzip :: [(a,b)] -> ([a], [b])
unzip tups =
  foldr (\(x,y) (xs,ys) -> (x:xs, y:ys)) ([], []) tups
```

## Problem 5
Implement `splitAt`.

```Haskell
splitAt :: Int -> [a] -> ([a], [a])
splitAt n xs = ???

splitAt 2 [1,2,3,4] = ([1,2],[3,4])
splitAt 0 [1,2,3,4] = ([], [1,2,3,4])
splitAt 4 [1,2,3,4] = ([1,2,3,4], [])
```

## Problem 5
Implement `splitAt`.

Common technique: define an "inner" function with explicit accumulator
parameter(s), then have the "outer" function call the inner function with a
initial accumulator value(s)

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
