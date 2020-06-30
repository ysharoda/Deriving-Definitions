module Tog.Deriving.Main
  ( processDefs
  , declRecords 
  ) where

import qualified Data.Map              as Map
import           Control.Lens (view)

import           Tog.Raw.Abs           as Abs
import qualified Tog.Deriving.EqTheory as Eq
import           Tog.Deriving.Hom
import           Tog.Deriving.TermLang
import           Tog.Deriving.TGraphTest 
import           Tog.Deriving.ProductTheory
import           Tog.Deriving.Signature 
import           Tog.Deriving.TypeConversions
import           Tog.Deriving.Types
import           Tog.Deriving.TUtils  (mkName, setType,strToDecl)
import           Tog.Deriving.RelationalInterp
import           Tog.Deriving.OpenTermLang
import           Tog.Deriving.Evaluator
import           Tog.Deriving.OpenTermEvaluator
import           Tog.Deriving.TogPrelude (prelude)
import           Tog.Deriving.Simplifier 

processDefs :: [Language] -> Module
processDefs = processModule . defsToModule

defsToModule :: [Language] -> Module
defsToModule = createModules . view (graph . nodes) . computeGraph

processModule :: Module -> Module
processModule (Module n p (Decl_ decls)) =
   Module n p $ Decl_ $
     (prodType : map strToDecl prelude) -- choice, code, comp, staged]) 
      ++ map genEverything decls   
processModule _ = error $ "Unparsed theory expressions exists" 

leverageThry :: Eq.EqTheory -> [Decl]
leverageThry thry =
 let sigs = (sigToDecl . signature_) thry
     prodthry = (prodTheoryToDecl . productThry) thry
     hom = homomorphism thry
     relInterp = relationalInterp thry
     trmlang = termLang thry
     openTrmLang = openTermLang thry
     evalTrmLang = evalFunc thry
     evalOpenTrmLang = openEvalFunc thry 
     simplifier = simplifyFunc thry 
 in [sigs, prodthry, hom, relInterp] ++ 
    [trmlang, openTrmLang] ++ evalTrmLang ++ evalOpenTrmLang ++ simplifier 

genEverything :: InnerModule -> InnerModule
genEverything m@(Module_ (Module n p (Decl_ decls))) =
  Module_ (Module n p (Decl_ $
    -- [strToDecl "open NatNum ; open Prelude ; "] ++ 
    decls ++
    (concatMap leverageThry $ getEqTheories m)))
genEverything x = x  

{- ------- Filtering the EqTheories ------------ -} 

type InnerModule = Decl

getEqTheories :: InnerModule -> [Eq.EqTheory]
getEqTheories (Module_ (Module _ _ (Decl_ decls))) =
  map recordToEqTheory $ 
    filter (not . isEmptyTheory) $ concatMap declRecords decls
getEqTheories x = map recordToEqTheory $ declRecords x

declRecords :: Decl -> [TRecord]
declRecords (Record n p r) = [TRecord n p r]
declRecords (Module_ (Module _ _ (Decl_ decls))) = concatMap declRecords decls 
declRecords _ = []

isEmptyTheory :: TRecord -> Bool 
isEmptyTheory (TRecord _ NoParams (RecordDecl _)) = True
isEmptyTheory (TRecord _ NoParams (RecordDef  _ NoFields)) = True
isEmptyTheory (TRecord _ NoParams (RecordDeclDef _ _ NoFields)) = True
isEmptyTheory _ = False

{- ------------------------------------------------------------- -} 

mathscheme :: Name
mathscheme = mkName "MathScheme" 

theoryToRecord :: Name_ -> GTheory -> Decl 
theoryToRecord n (GTheory ps fs) =
  Record (mkName n) ps (RecordDeclDef setType (mkName $ n++"C") fs)  

recordToModule :: Name_ -> Decl -> Decl
recordToModule n record =
  Module_ $ Module (mkName n) NoParams $ Decl_ [record] 

createModules :: Map.Map Name_ GTheory -> Abs.Module
createModules theories =
  let records = Map.mapWithKey theoryToRecord theories
      modules = Map.mapWithKey recordToModule records 
  in Module mathscheme NoParams $ Decl_ $ Map.elems modules 
