module Main where

import System.Environment
import Data.Foldable (traverse_)
import Data.List.Extra (snoc)
import Text.Read (readMaybe)

data Token = Num Float | Op (Float -> Float -> Float) 

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
    "+" -> return $ Op (+) 
    "-" -> return $ Op (-) 
    "*" -> return $ Op (*) 
    "/" -> return $ Op (/) 
    _ -> do 
      y <- readMaybe x :: Maybe Float
      return $ Num y

eval :: [Token] -> [Float] -> Maybe Float 
eval [Num n] [] = Just n
eval [Op f] [x,y] = Just $ f x y
eval (Op f:xs) (x:y:stack) = eval xs (f x y : stack)
eval (Num n:xs) stack = eval xs (n : stack)
eval _ _ = Nothing

main :: IO ()
main = do
  args <- head <$> getArgs
  putStrLn . (\x -> case x of
              Just n -> show n
              _ -> "Invalid input") $ do
    tokens <- traverse toToken $ split args ' '
    eval tokens []
