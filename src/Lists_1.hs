----- Problems 11 - 20: Lists, continued -----

module Lists_1 where
import Lists_0
import Data.List

----- 11: Modified run-length encoding.
-- Modify the result of problem 10 in such a way that if an element has no duplicates it is simply copied into the result list. Only elements with duplicates are transferred as (N E) lists.
-- λ> encodeModified "aaaabccaadeeee"
-- [Multiple 4 'a',Single 'b',Multiple 2 'c',
--  Multiple 2 'a',Single 'd',Multiple 4 'e']
data EncodedListItem a = Single a | Multiple Int a deriving (Show)

encodeMod :: Eq a => [a] -> [EncodedListItem a]
encodeMod = map tupleToEli . encode
    where
     tupleToEli (1, li) = Single li
     tupleToEli (n, li) = Multiple n li


----- 12: Decode a run-length encoded list.
-- Given a run-length code list generated as specified in problem 11. Construct its uncompressed version.
-- λ> decodeModified
--        [Multiple 4 'a',Single 'b',Multiple 2 'c',
--         Multiple 2 'a',Single 'd',Multiple 4 'e']
-- "aaaabccaadeeee"
decodeMod :: Eq a => [EncodedListItem a] -> [a]
decodeMod = concatMap decoder
    where
     decoder (Single a) = [a]
     decoder (Multiple n a) = replicate n a

----- 13: Run-length encoding of a list (direct solution).
-- Implement the so-called run-length encoding data compression method directly. I.e. don't explicitly create the sublists containing the duplicates, as in problem 9, but only count them. As in problem P11, simplify the result list by replacing the singleton lists (1 X) by X.
-- λ> encodeDirect "aaaabccaadeeee"
-- [Multiple 4 'a',Single 'b',Multiple 2 'c',
--  Multiple 2 'a',Single 'd',Multiple 4 'e']
encodeDirect :: Eq a => [a] -> [EncodedListItem a]
encodeDirect [] = []
encodeDirect (x:xs) = let matchLen = length (takeWhile (== x) xs)
    in toEli (matchLen + 1) x : encodeDirect (drop matchLen xs)
    where
     toEli 1 a = Single a
     toEli n a = Multiple n a

----- 14: Duplicate the elements of a list
-- λ> dupli [1, 2, 3]
-- [1,1,2,2,3,3]
dup :: [a] -> [a]
dup [] = []
dup (x:xs) = x:x:dup xs

dup' :: [a] -> [a]
dup' = foldr (\x xs -> x:x:xs) []

----- 15: Replicate the elements of a list a given number of times
-- λ> repli "abc" 3
-- "aaabbbccc"
rep :: Int -> [a] -> [a]
rep _ [] = []
rep n (x:xs) = replicate n x ++ rep n xs

rep' :: Int -> [a] -> [a]
rep' n = foldr (\x xs -> replicate n x ++ xs) []

rep'' :: Int -> [a] -> [a]
rep'' n xs = concatMap (replicate n) xs

----- 16: Drop every nth element from a list
-- λ> dropEvery "abcdefghik" 3
-- "abdeghk"
dropEvery :: [a] -> Int -> [a]
dropEvery xs n = [x | (i, x) <- zip [1..] xs, mod i n /= 0]

----- 17: Split a list into two parts given the length of the first part
-- Do not use any predefined predicates.
-- λ> split "abcdefghik" 3
-- ("abc", "defghik")
-- first one that came to mind
split :: [a] -> Int -> ([a], [a])
split xs n = ([x | (_, x) <- zip [1..n] xs], [x | (i, x) <- zip [1..] xs, i > n])

-- but, I really want to use some cleaner predicates, so defining my own
-- doesn't seem like cheating too badly
take' :: Int -> [a] -> [a]
take' 0 _ = []
take' _ [] = []
take' n (x:xs) = x : (take' (n - 1) xs)

drop' :: Int -> [a] -> [a]
drop' 0 xs = xs
drop' _ [] = []
drop' n (x:xs) = drop' (n - 1) xs

split' :: [a] -> Int -> ([a], [a])
split' xs n = (take' n xs, drop' n xs)

----- 18: Extract a slice from a list
-- Given two indices, i and k, the slice is the list containing the elements between the i'th and k'th element of the original list (both limits included). Start counting the elements with 1.
-- λ> slice ['a','b','c','d','e','f','g','h','i','k'] 3 7
-- "cdefg"
slice :: [a] -> Int -> Int -> [a]
slice (x:xs) i k
    | k >= i && i == 1 = x : slice xs 1 (k - 1)
    | k > i && i > 1 = slice xs (i - 1) (k - 1)
    | otherwise = []

slice' :: [a] -> Int -> Int -> [a]
slice' xs i k = take (k - i + 1) (drop (i - 1) xs)

----- 19: Rotate a list N places to the left
-- λ> rotate ['a','b','c','d','e','f','g','h'] 3
-- "defghabc"
-- λ> rotate ['a','b','c','d','e','f','g','h'] (-2)
-- "ghabcdef"
rotate :: [a] -> Int -> [a]
rotate xs n
    | n < 0 = rotate xs (n + length xs)
    | otherwise = let (frnt, back) = splitAt n xs in back ++ frnt

----- 20: Remove the kth element from a list
-- λ> removeAt 2 "abcd"
-- ('b',"acd")
removeAt :: Int -> [a] -> ([a], [a])
removeAt n xs = let (beg, end) = splitAt n xs
    in ([last beg], init beg ++ end)
