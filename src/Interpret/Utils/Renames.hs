module Interpret.Utils.Renames where

import Tog.Raw.Abs 
import Interpret.Utils.Lenses (name)
import Interpret.Utils.TUtils (mkName,getConstrName)
import Interpret.Deriving.EqTheory
import Interpret.Flattener.Types (gmap)

import Control.Lens ((^.),over)
import qualified Data.Generics as Generics

-- renames sn to newName and adds suffix "L" to all other names. 
ren :: String -> (String,String) -> Name -> Name
ren sn (newName,suffix) n = mkName $ if (nam == sn) then newName else nam ++ suffix
  where nam = n^.name

applyRenames :: EqTheory -> (String,String) -> [Constr] 
applyRenames eq (nm,suff) =
  gmap (ren (getConstrName $ eq^.sort) (nm,suff)) $ eq^.funcTypes  

ren' :: String -> (String,String) -> Name -> Name
ren' sn (newName,suffix) n = mkName $ if (nam == sn) then newName else suffix
  where nam = n^.name

foldren :: EqTheory -> [(String,String)] -> EqTheory
foldren eq [] = eq 
foldren eq ((old,new):rens) =
  foldren (gmap (\x -> if x == old then new else x) eq) rens 

foldrenConstrs :: (Generics.Typeable a, Generics.Data a) => [(String,String)] -> a -> a
foldrenConstrs [] c = c
foldrenConstrs ((old,new):rens) c =
  foldrenConstrs rens (gmap (\x -> if x == old then new else x) c)

-- adds suffix to all elements of the theory except the carrier 
simpleRen :: String -> [Constr] -> Name -> Name
simpleRen suff as nm =
  if elem (nm^.name) ("Set": map getConstrName as)
  then nm else over name (++suff) nm
