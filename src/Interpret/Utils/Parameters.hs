-- The Parameters of the hom record 
module Interpret.Utils.Parameters where 

import Control.Lens ((^.))

import Tog.Raw.Abs 
import Interpret.Utils.TUtils
import Interpret.Utils.Lenses   (name)
import Interpret.Deriving.EqTheory 

-- the hidden params for Hom and RelationalInterp 
recordParams :: ([Arg] -> Expr -> Binding) -> Constr -> Binding
recordParams bind (Constr nm typ) =
  let n = nm^.name in bind [mkArg' n 1, mkArg' n 2] typ

genOneBinding :: ([Arg] -> Expr -> Binding) -> Constr -> Binding
genOneBinding bind (Constr nm typ) =
  let n = nm^.name in bind [mkArg n] typ

-- two instances of the EqTheory record 
createThryInsts :: EqTheory -> ((Binding, Name_), (Binding, Name_))
createThryInsts t =
  let nam = t ^. thyName
      (n1, n2) = (twoCharName nam 1, twoCharName nam 2)
  in ((Bind [mkArg n1] (declTheory nam (args t) 1), n1) ,
      (Bind [mkArg n2] (declTheory nam (args t) 2), n2))
