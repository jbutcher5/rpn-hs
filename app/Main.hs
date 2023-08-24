module Main where

import System.Environment
import Data.Foldable (traverse_)
import Data.List.Extra (snoc)
import Text.Read (readMaybe)

data Token = Num Float | Add | Sub | Mul | Div
  deriving (Show, Eq)

split :: Eq a => [a] -> a -> [[a]]
split buffer delimiter = split' buffer delimiter []

split' :: Eq a => [a] -> a -> [a] -> [[a]]
split' [] _ [] = []
split' [] _ carry = [carry]
split' (x:xs) d carry | x /= d = split' xs d (snoc carry x)
                      | null carry = split' xs d []
                      | otherwise = carry : split' xs d []

toToken :: String -> Maybe Token
toToken x =
  case x of
    "+" -> return Add
    "-" -> return Sub
    "*" -> return Mul
    "/" -> return Div
    _ -> do 
      y <- readMaybe x :: Maybe Float
      return $ Num y

main :: IO ()
main = do
  args <- head <$> getArgs
  print $ traverse toToken $ split args ' '  

