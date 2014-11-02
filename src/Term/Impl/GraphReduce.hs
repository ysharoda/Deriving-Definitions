module Term.Impl.GraphReduce (GraphReduce) where

import           Data.IORef                       (IORef, readIORef, writeIORef, newIORef)
import           System.IO.Unsafe                 (unsafePerformIO)

import           Term
import qualified Term.Signature                   as Sig
import           Term.Impl.Common
import           Prelude.Extended

-- Base terms
------------------------------------------------------------------------

newtype GraphReduce = GR {unGR :: IORef (TermView GraphReduce)}
  deriving (Typeable)

instance Show GraphReduce where
  show _ = "<<ref>>"

instance MetaVars GraphReduce GraphReduce where
  metaVars = genericMetaVars

instance Nf GraphReduce GraphReduce where
  nf t = do
    t' <- genericNf t
    tView <- liftIO $ readIORef $ unGR t'
    liftIO $ writeIORef (unGR t) (tView)
    return t

instance PrettyM GraphReduce GraphReduce where
  prettyPrecM = genericPrettyPrecM

instance Subst GraphReduce GraphReduce where
  applySubst = genericApplySubst

instance SynEq GraphReduce GraphReduce where
  synEq (GR tRef1) (GR tRef2) | tRef1 == tRef2 = return True
  synEq t1 t2 = genericSynEq t1 t2

instance IsTerm GraphReduce where
  whnf t = do
    blockedT <- genericWhnf t
    tView <- liftIO . readIORef . unGR =<< ignoreBlocking blockedT
    liftIO $ writeIORef (unGR t) (tView)
    return $ blockedT

  view = liftIO . readIORef . unGR
  unview tView = GR <$> liftIO (newIORef tView)

  set = setGR
  refl = reflGR
  typeOfJ = typeOfJGR

  canStrengthen = genericCanStrengthen

{-# NOINLINE setGR #-}
setGR :: GraphReduce
setGR = unsafePerformIO $ GR <$> newIORef Set

{-# NOINLINE reflGR #-}
reflGR :: GraphReduce
reflGR = unsafePerformIO $ GR <$> newIORef Refl

{-# NOINLINE typeOfJGR #-}
typeOfJGR :: GraphReduce
typeOfJGR = unsafePerformIO $ runTermM Sig.empty genericTypeOfJ
