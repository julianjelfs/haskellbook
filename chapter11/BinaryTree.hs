module BinaryTree where

data BinaryTree a
  = Leaf
  | Node (BinaryTree a)
         a
         (BinaryTree a)
  deriving (Eq, Ord, Show)

myInsert :: Ord a => a -> BinaryTree a -> BinaryTree a
myInsert b Leaf = Node Leaf b Leaf
myInsert b (Node left a right)
  | b == a = Node left a right
  | b < a = Node (myInsert b left) a right
  | b > a = Node right a (myInsert b right)

mapTree :: (a -> b) -> BinaryTree a -> BinaryTree b
mapTree _ Leaf = Leaf
mapTree fn (Node left a right) =
  Node (mapTree fn left) (fn a) (mapTree fn right)

preorder :: BinaryTree a -> [a]
preorder Leaf = []
preorder (Node left a right) = a : (inorder left) ++ (inorder right)

inorder :: BinaryTree a -> [a]
inorder Leaf = []
inorder (Node left a right) = (inorder left) ++ [a] ++ (inorder right)

postorder :: BinaryTree a -> [a]
postorder Leaf = []
postorder (Node left a right) = (inorder left) ++ (inorder right) ++ [a]

foldTree :: (a -> b -> b) -> b -> BinaryTree a -> b
foldTree _ b Leaf = b
foldTree reducer b (Node left a right) =
  let
    foldLeft = foldTree reducer (reducer a b) left
  in
    foldTree reducer foldLeft right

testTree :: BinaryTree Integer
testTree = Node (Node Leaf 1 Leaf) 2 (Node Leaf 3 Leaf)

testPreorder :: IO()
testPreorder =
  if preorder testTree == [2,1,3]
  then putStrLn "Preorder fine!"
  else putStrLn "Bad news bears."

testInorder :: IO()
testInorder =
  if inorder testTree == [1,2,3]
  then putStrLn "Inorder fine!"
  else putStrLn "Bad news bears."

testPostorder :: IO()
testPostorder =
  if postorder testTree == [1,3,2]
  then putStrLn "Postorder fine!"
  else putStrLn "Bad news bears."

testFoldTree :: IO()
testFoldTree =
  if foldTree (+) 0 testTree == 6
  then putStrLn "foldTree fine!"
  else putStrLn "Bad news bears."

