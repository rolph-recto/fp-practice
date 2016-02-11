(*
 * practice.ml
 * code from functional programming practice session
 *)

let rec fold_right (f:'a -> 'b -> 'b) (l:'a list) (acc:'b) : 'b =
  match l with
    [] -> acc
  | x::xs -> f x (fold_right f xs acc)
;;

let rec fold_left (f:'b -> 'a -> 'b) (acc:'b) (l:'a list) : 'b =
  match l with
    [] -> acc
  | x::xs -> fold_left f (f acc x) xs
;;

let map (f:'a -> 'b) (xs:'a list) : 'b list =
  List.fold_right (fun x acc -> (f x)::acc) xs [] ;;

let filter (f:'a -> bool) (xs:'a list) : 'a list =
  List.fold_right (fun x acc -> if f x then x::acc else acc) xs [] ;;

let length (xs:'a list) : int =
  List.fold_right (fun x acc -> acc + 1) xs 0 ;;

let reverse (xs:'a list) : 'a list =
  List.fold_left (fun acc x -> x::acc) [] xs ;;

type 'a list2 =
  | Cons of 'a * ('a list2)
  | Nil
;;

let rec sum (l:int list2) : int =
  match l with
    Nil -> 0
  | Cons (x, tl) -> x + sum tl
;;

type 'a btree =
    Node of 'a * ('a btree) * ('a btree)
  | Leaf of 'a
  | NilLeaf
;;

let rec preOrder (tree:'a btree) : 'a list = 
  match tree with
    NilLeaf -> []
  | Leaf x -> [x]
  | Node (x, left, right) ->
      [x] @ (preOrder left) @ (preOrder right)
;;

type arith =
  | Val of int
  | Add of arith * arith
  | Sub of arith * arith
  | Mul of arith * arith
;;

let rec serializeArith (ast:arith) : string =
  match ast with
    Val n -> "int\n" ^ (string_of_int n) ^ "\n"
  | Add (x,y) -> "add\n" ^ serializeArith x ^ serializeArith y
  | Sub (x,y) -> "sub\n" ^ serializeArith x ^ serializeArith y
  | Mul (x,y) -> "mul\n" ^ serializeArith x ^ serializeArith y
;;

let rec eval (a:arith) : int =
  match a with
    Val n -> n
  | Add (x,y) -> (eval x) + (eval y)
  | Sub (x,y) -> (eval x) - (eval y)
  | Mul (x,y) -> (eval x) * (eval y)
;;

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

type 'a option =
  | Some of 'a
  | None
;;

let head (l:'a list) : 'a option =
  match l with
    [] -> None
  | x::xs -> Some x
;;

let insertSort (l:int list) : int list =
  let rec insert x il = begin
    match il with
    (* insert at the end of sorted sublist *)
      [] -> [x]
    (* insert at current position or recurse to rest of list *)
    | y::ys -> if x >= y then y::(insert x ys) else x::y::ys
  end in
  (* add elements one by one to acc, which is kept sorted *)
  List.fold_right insert l []
;;

let rec mergeSort (l:int list) : int list =
  let rec merge xxs yys = begin
    match (xxs,yys) with
      ([], []) -> []
    (* right list is empty; rest of left is end of sorted list *)
    | (xs, []) -> xs
    (* left list is empty; rest of right is end of sorted list *)
    | ([], ys) -> ys
    (* pick lower head and recurse on the rest *)
    | (x::xs, y::ys) ->
        if x < y then x::(merge xs (y::ys))
                 else y::(merge (x::xs) ys)
  end in
  match l with
    [] -> []
  | [x] -> [x]
  | _ ->
    (* split into two sublists *)
    let (left, right) = splitAt (List.length l / 2) l in
    (* merge sorted sublists *)
    merge (mergeSort left) (mergeSort right)
;;

let rec quickSort (l:int list) : int list =
  match l with
    [] -> []
  | x::xs ->
    (* get lower/eq sublist *)
    let left = List.filter (fun y -> x >= y) xs in
    (* get higher sublist *)
    let right = List.filter (fun y -> x < y) xs in
    (* append into complete sorted list *)
    (quickSort left) @ [x] @ (quickSort right)
;;

let rec quickSort2 (l:int list) : int list =
  match l with
    [] -> []
  | x::xs ->
    (* put element in the right sublist *)
    let part y (lo, hi) = if x >= y then (y::lo, hi) else (lo, y::hi) in
    (* repeated put list elems into right sublist *)
    let partition lp = List.fold_right part lp ([],[]) in
    (* create partition *)
    let (left, right) = partition xs in
    (* append into complete sorted list *)
    (quickSort2 left) @ [x] @ (quickSort2 right)
;;

let rec append (xxs:'a list) (yys:'a list) : 'a list =
  match xxs with
    [] -> yys
  | x::xs -> x::(append xs yys)
;;

let rec reverse (l:'a list) : 'a list =
  let rec insertBack y xxs = begin
    match xxs with
      [] -> [y]
    | x::xs -> x::(insertBack y xs)
  end in
  match l with
    [] -> []
  | x::xs -> insertBack x (reverse xs)
;;

let rec treeSum (tree:int btree) : int =
  match tree with
    NilLeaf -> 0
  | Leaf n -> n
  | Node (n,left,right) -> n + (treeSum left) + (treeSum right)
;;

let unzip (l:('a * 'b) list) : ('a list) * ('b list) =
  List.fold_right (fun (x,y) (xs,ys) -> (x::xs, y::ys)) l ([], []) ;;

let splitAt (n:int) (l:'a list) : ('a list) * ('a list) =
  let rec splitAt_ n2 l2 acc = begin
    match (n2,l2) with
      (0, ys) -> (acc, ys)
    | (n, []) -> (acc, [])
    | (n, y::ys) -> splitAt_ (n-1) ys (acc @ [y])
  end in
  splitAt_ n l []
;;
