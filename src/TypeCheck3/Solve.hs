{-# LANGUAGE TemplateHaskell #-}
module TypeCheck3.Solve
  ( SolveState
  , initSolveState
  , solve
  ) where

import           Control.Monad.State              (get, put)

import           Conf
import           Prelude.Extended
import           Term
import           TypeCheck3.Monad
import           TypeCheck3.Common
import qualified TypeCheck3.Solve.Simple          as Simple
import qualified TypeCheck3.Solve.TwoContexts     as TwoContexts

data SolveState t = forall solveState. (PrettyM solveState) => SolveState
  { sState :: solveState t
  , sSolve :: Constraint t -> TC t (solveState t) ()
  }

initSolveState :: (IsTerm t) => IO (SolveState t)
initSolveState = do
  solver <- confSolver <$> readConf
  case solver of
    "Simple" ->
      return $ SolveState{ sState = Simple.initSolveState
                         , sSolve = Simple.solve
                         }
    "TwoContexts" ->
      return $ SolveState{ sState = TwoContexts.initSolveState
                         , sSolve = TwoContexts.solve
                         }

    _ ->
      error $ "Unsupported solver " ++ solver

solve :: (IsTerm t) => Constraint t -> TC t (SolveState t) ()
solve c = do
  SolveState ss solve' <- get
  ((), ss') <- nestTC ss $ solve' c
  put $ SolveState ss' solve'

instance PrettyM SolveState where
  prettyM (SolveState ss _) = prettyM ss