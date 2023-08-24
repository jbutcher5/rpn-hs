module Main where

import System.Environment
import Data.Foldable (traverse_)
import Data.List.Extra (snoc)

data Token = Num Int | Add | Sub | Mul | Div

split :: Eq a => [a] -> a -> [[a]]
split buffer delimiter = split' buffer delimiter []

split' :: Eq a => [a] -> a -> [a] -> [[a]]
split' [] _ [] = []
split' [] _ carry = [carry]
split' (x:xs) d carry | x /= d = split' xs d (snoc carry x)
                      | null carry = split' xs d []
                      | otherwise = carry : split' xs d []

main :: IO ()
main = do
  --args <- head <$> getArgs
  putStrLn $ show $ split "test a  b " ' '  

