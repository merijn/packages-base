{-# LANGUAGE DataKinds #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# OPTIONS_GHC -XNoImplicitPrelude #-}
{-| This module is an internal GHC module.  It declares the constants used
in the implementation of type-level natural numbers.  The programmer interface
for workin with type-level naturals should be defined in a separate library. -}

module GHC.TypeNats
  ( -- * Basic Types
    Nat
  , NatS(..)
  , NatI(..)
  , (:<=), (:+), (:*), (:^)
  ) where

import GHC.Word(Word)

-- | This is the *kind* of type-level natural numbers.
data Nat

-- | Comparsion of type-level naturals.
class (m :: Nat) :<= (n :: Nat)

-- | Addition of type-level naturals.
type family (m :: Nat) :+ (n :: Nat) :: Nat

-- | Multiplication of type-level naturals.
type family (m :: Nat) :* (n :: Nat) :: Nat

-- | Exponentiation of type-level naturals.
type family (m :: Nat) :^ (n :: Nat) :: Nat


-- | The type @NatS n@ is m \"singleton\" type containing only the value @n@.
-- (Technically, there is also a bottom element).
-- This type relates type-level naturals to run-time values.
-- NOTE: For the moment we support only singleton types that can fit in
-- a 'Word'.
newtype NatS (n :: Nat) = NatS Word

-- | The class 'NatI' provides a \"smart\" constructor for values
-- of type @Nat n@.  There are built-in instances for all natural numbers
-- that fit in a 'Word'.  The 'Word' restriction can be lifted but that
-- would require a bunch of code in "deSugar/DsBinds" to be monadified,
-- because making integer expression is a monadic operation.  Not hard,
-- but not yet done.
--
-- NOTE: The instances for 'NatI' are provided directly by GHC.
-- The built-in instances use the number corresponding to the instance
-- as evidence.  This works because of the following two details about GHC:
--   * The "dictionary" for classes with a single method is the method itself,
--     so GHC simply coerces the dictionary into the value, and
--   * Newtype use the same representation as their definition types.
-- (This is a bit of a hack but it seems to work pretty well.
--  It is also possible to implement the same API in a different way.)

class NatI (n :: Nat) where

  -- | The only defined element of type @Nat n@.
  natS :: NatS n


