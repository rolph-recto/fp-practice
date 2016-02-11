{-# LANGUAGE NoImplicitPrelude #-}
-- the language pragma above allows us to redefine functions
-- that are already defined in prelude

import Prelude (
  Ord, Show, Bool, Int, String, show,
  (<), (>=), (+), (-), (*), div, (++))
import Data.List (sort)

foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f acc [] = acc
foldr f acc (x:xs) = f x (foldr f acc xs)

foldl :: (b -> a -> b) -> b -> [a] -> b
foldl f acc [] = acc
foldl f acc (x:xs) = foldl f (f acc x) xs

map :: (a -> b) -> [a] -> [b]
map f xs = foldr (\x acc -> (f x):acc) [] xs

filter :: (a -> Bool) -> [a] -> [a]
filter f xs = foldr (\x acc -> if f x then x:acc else acc) [] xs

length :: [a] -> Int
length xs = foldr (\x acc -> acc + 1) 0 xs

reverse' :: [a] -> [a]
reverse' xs = foldl (\acc x -> x:acc) [] xs

data List a = Cons a (List a) | Nil

sum :: List Int -> Int
sum Nil = 0
sum (Cons n tl) = n + sum tl

data BTree a =
    Node a (BTree a) (BTree a)
  | Leaf a
  | NilLeaf

preOrder :: BTree a -> [a]
preOrder (Leaf x)  = [x]
preOrder (Node x left right) =
  [x] ++ (preOrder left) ++ (preOrder right)

data Arith =
    Val Int
  | Add Arith Arith
  | Sub Arith Arith
  | Mul Arith Arith

serializeArith :: Arith -> String
serializeArith (Val n) = "int\n" ++ show n
serializeArith (Add x y) = "add\n" ++ serializeArith x ++ serializeArith y
serializeArith (Sub x y) = "sub\n" ++ serializeArith x ++ serializeArith y
serializeArith (Mul x y) = "mul\n" ++ serializeArith x ++ serializeArith y

eval :: Arith -> Int
eval (Val n)   = n
eval (Add x y) = (eval x) + (eval y)
eval (Sub x y) = (eval x) - (eval y)
eval (Mul x y) = (eval x) * (eval y)

data Maybe a = Just a | Nothing

head :: [a] -> Maybe a
head []     = Nothing
head (x:xs) = Just x

insertSort :: Ord a => [a] -> [a]
-- add elements one by one to acc, which is kept sorted
insertSort xs = foldr insert [] xs
        -- insert at the end of sorted sublist
	where insert x [] = [x]
        -- insert at current position or recurse to rest of list
	      insert x (y:ys) = if x >= y then y:(insert x ys) else x:y:ys

mergeSort :: Ord a => [a] -> [a]
mergeSort [] = []
mergeSort [x] = [x]
mergeSort l =
  -- merge sorted sublists
  merge (mergeSort left) (mergeSort right)
        -- split into two sublists
  where (left, right) = splitAt (length l `div` 2) l
        merge [] [] = []
        -- right list is empty; rest of left is end of sorted list
        merge xs [] = xs
        -- left list is empty; rest of right is end of sorted list
        merge [] ys = ys
        -- pick lower head and recurse on the rest
        merge (x:xs) (y:ys) =
          if x < y then x:(merge xs (y:ys))
                   else y:(merge (x:xs) ys)

quickSort :: Ord a => [a] -> [a]
quickSort [] = []
quickSort (x:xs) =
  -- append into complete sorted list
  (quickSort left) ++ [x] ++ (quickSort right)
  where left = filter (x >=) xs -- get lower/eq sublist
        right = filter (x <) xs -- get higher sublist

quickSort2 :: Ord a => [a] -> [a]
quickSort2 [] = []
quickSort2 (x:xs) =
  -- append into complete sorted list
  (quickSort2 left) ++ [x] ++ (quickSort2 right)
  where (left, right) = partition xs -- create partition
        -- repeated put list elems into right sublist
        partition = foldr part ([], [])
        -- put element in the right sublist
        part y (low, hi) =
          if x >= y then (y:low, hi) else (low, y:hi)

append :: [a] -> [a] -> [a]
append [] ys = ys
append (x:xs) ys = x:(append xs ys)

reverse :: [a] -> [a]
reverse [] = []
reverse (x:xs) = insertBack x (reverse xs)
  where insertBack x [] = [x]
        insertBack x (y:ys) = y:(insertBack x ys)

treeSum :: BTree Int -> Int
treeSum NilLeaf = 0
treeSum (Leaf x) = x
treeSum (Node x left right) =
  x + (treeSum left) + (treeSum right)

unzip :: [(a,b)] -> ([a], [b])
unzip tups =
  foldr (\(x,y) (xs,ys) -> (x:xs, y:ys)) ([], []) tups

splitAt :: Int -> [a] -> ([a], [a])
splitAt n xs = splitAt_ n xs []
  where splitAt_ 0 ys acc     = (acc, ys)
        splitAt_ n [] acc     = (acc, [])
        splitAt_ n (y:ys) acc =
          splitAt_ (n-1) ys (acc ++ [y])
