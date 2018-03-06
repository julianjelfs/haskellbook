module Composition where

{-# LANGUAGE InstanceSigs #-}

newtype Compose f g a =
  Compose { getCompose :: f (g a) }
  deriving (Eq, Show)

instance (Functor f, Functor g) =>
         Functor (Compose f g) where
           fmap f (Compose fga) =
             Compose $ (fmap . fmap) f fga

instance (Applicative f, Applicative g) =>
          Applicative (Compose f g) where
  pure x = Compose $ pure (pure x)

  (Compose f) <*> (Compose a) = Compose $ ((<*>) <$> f) <*> a