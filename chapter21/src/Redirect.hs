module Redirect where

type Url = String

type RedirectRule = Url -> Url

data RedirectionError
  = TooManyRedirects
  | RedirectCycleDetected
  deriving Show

maxIterations = 20

applyRules :: Url -> [RedirectRule] -> Url
applyRules url rules =
  foldl (\u r ->
    if u /= url
      then u
      else r u
  ) url rules

redirect :: Url -> [RedirectRule] -> Either RedirectionError Url
redirect url rules = go [] url rules 0
  where
    go :: [Url] -> Url -> [RedirectRule] -> Int -> Either RedirectionError Url
    go prev url rules iterations
      | iterations > maxIterations = Left TooManyRedirects
      | elem url prev = Left RedirectCycleDetected
      | otherwise =
          let u = applyRules url rules
          in
            if u == url
              then (Right url)
              else go (url:prev) u rules (iterations + 1)

