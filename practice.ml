open Printf

let insertSort (l:int list) : int list =
  let rec insert x il = begin
    match il with
      [] -> [x]
    | y::ys -> if x >= y then y::(insert x ys) else x::y::ys
  end in
  List.fold_right insert l []
;;

let splitAt (n:int) (l:'a list) : 'a list * 'a list =
  let rec splitAt_ n2 l2 acc = begin
    match (n2,l2) with
      (0, ys) -> (acc, ys)
    | (n, []) -> (acc, [])
    | (n, y::ys) -> splitAt_ (n-1) ys (acc @ [y])
  end in
  splitAt_ n l []
;;

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

let rec quickSort (l:int list) : int list =
  match l with
    [] -> []
  | x::xs ->
    let left = List.filter (fun y -> x >= y) xs in
    let right = List.filter (fun y -> x < y) xs in
    (quickSort left) @ [x] @ (quickSort right)
;;

let rec quickSort2 (l:int list) : int list =
  match l with
    [] -> []
  | x::xs ->
    let part y (lo, hi) = if x >= y then (y::lo, hi) else (lo, y::hi) in
    let partition lp = List.fold_right part lp ([],[]) in
    let (left, right) = partition xs in
    (quickSort2 left) @ [x] @ (quickSort2 right)
;;

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

let unzip (l : ('a * 'b) list) : ('a list) * ('b list) =
  List.fold_right (fun (x,y) (xs,ys) -> (x::xs, y::ys)) l ([], [])
;;
    
List.iter (printf "%d ") (quickSort2 [1;10;2;8;9;4;7;5]) ;;
