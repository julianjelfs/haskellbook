module HuttonsRazor where

data Expr
  = Lit Integer
  | Add Expr
        Expr

testExpr = (Add (Add (Lit 10) (Lit 20)) (Add (Lit 50) (Lit 1000)))

eval :: Expr -> Integer
eval (Lit n)   = n
eval (Add l r) = eval l + eval r

printExpr :: Expr -> String
printExpr (Lit n)   = show n
printExpr (Add l r) = printExpr l ++ " + " ++ printExpr r
