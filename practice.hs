{-# LANGUAGE NoImplicitPrelude #-}
-- the language pragma above allows us to redefine functions
-- that are already defined in prelude
--
import Prelude (
  Ord, Show, Bool, Int, String,
  (<), (>=), (+), (-), (*), div, (++))
import Data.List (sort)

map :: (a -> b) -> [a] -> [b]
map f [] = []
map f (x:xs) = (f x):(map f xs)

filter :: (a -> Bool) -> [a] -> [a]
filter f [] = []
filter f (x:xs) =
  if f x then x:(filter f xs) else filter f xs

foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f acc [] = acc
foldr f acc (x:xs) = f x (foldr f acc xs)

foldl :: (b -> a -> b) -> b -> [a] -> b
foldl f acc [] = acc
foldl f acc (x:xs) = f (foldl f acc xs) x

mapF :: (a -> b) -> [a] -> [b]
mapF f xs =
  foldr (\x acc -> (f x):acc) [] xs

filterF :: (a -> Bool) -> [a] -> [a]
filterF f xs =
  foldr (\x acc -> if f x then x:acc else acc) [] xs

length :: [a] -> Int
length xs =
  foldr (\x acc -> acc + 1) 0 xs

insertSort :: Ord a => [a] -> [a]
insertSort xs = foldr insert [] xs
  where insert x [] = [x]
        insert x (y:ys) = if x >= y then y:(insert x ys) else x:y:ys

mergeSort :: Ord a => [a] -> [a]
mergeSort [] = []
mergeSort l = merge (mergeSort left) (mergeSort right)
  where (left, right) = splitAt ((length l) `div` 2) l
        merge [] [] = []
        merge xs [] = xs
        merge [] ys = ys
        merge (x:xs) (y:ys) =
          if x < y then x:(merge xs (y:ys))
                   else y:(merge (x:xs) ys)

quickSort :: Ord a => [a] -> [a]
quickSort [] = []
quickSort (x:xs) =
  (quickSort left) ++ [x] ++ (quickSort right)
  where left = filter (x >=) xs
        right = filter (x <) xs

quickSort2 :: Ord a => [a] -> [a]
quickSort2 [] = []
quickSort2 (x:xs) =
  (quickSort2 left) ++ [x] ++ (quickSort2 right)
  where (left, right) = partition xs
        partition = foldr part ([], [])
        part y (low, hi) =
          if x >= y then (y:low, hi) else (low, y:hi)

data BTree a =
    Node a (BTree a) (BTree a)
  | Leaf a
  | NilLeaf

preOrder :: BTree a -> [a]
preOrder NilLeaf  = []
preOrder (Leaf x) = [x]
preOrder (Node x left right) =
  [x] ++ (preOrder left) ++ (preOrder right)

treeSum :: BTree Int -> Int
treeSum NilLeaf = 0
treeSum (Leaf x) = x
treeSum (Node x left right) =
  x + (treeSum left) + (treeSum right)

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

append :: String -> String -> String
append [] ys = ys
append (x:xs) ys = x:(append xs ys)

reverse :: [a] -> [a]
reverse [] = []
reverse (x:xs) = insertBack x (reverse xs)
  where insertBack x [] = [x]
        insertBack x (y:ys) = y:(insertBack x ys)

unzip :: [(a,b)] -> ([a], [b])
unzip tups =
  foldr (\(x,y) (xs,ys) -> (x:xs, y:ys)) ([], []) tups

splitAt2 :: Int -> [a] -> ([a], [a])
splitAt2 n xs = splitAt_ n xs []
  where splitAt_ 0 ys acc     = (acc, ys)
        splitAt_ n [] acc     = (acc, [])
        splitAt_ n (y:ys) acc = splitAt_ (n-1) ys (acc ++ [y])

toposort :: ([String], [(String,String)]) -> Maybe [String]
toposort ([], edges)    = []
toposort g@(nodes, edges) =
  let candidates = zeroIndegreeNodes g in
  if length candidates == 0
  then Nothing -- cycle!
  else do
    let chosen = chooseNode candidates
    let g' = removeNode chosen
    tl <- toposort g'
    return (chosenNode : tl)

zeroIndegreeNodes (nodes,edges) = filter noIncoming nodes
  where noIncoming node = not (any (\(src,dest) -> dest == node) edges)

chooseNode nodes = head (sort nodes)

removeNode node (nodes,edges) = (nodes', edges')
  where nodes' = filter (not . (node ==)) nodes
        edges' = filter (not . (node ==) . fst) edges
