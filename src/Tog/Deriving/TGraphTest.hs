module Tog.Deriving.TGraphTest where

import qualified Data.Map            as Map

import           Tog.Deriving.Types
import           Tog.Deriving.TGraph
import           Tog.Deriving.TUtils (noSrcLoc, name_)
import           Tog.Raw.Abs         as Abs

moduleName :: String
moduleName = "MathScheme" 

data GraphState = GraphState{
  graph   :: TGraph,
  renames :: (Map.Map Name_ Rename)}

graphNodes :: GraphState -> Map.Map Name_ GTheory
graphNodes gs = nodes $ graph gs

graphEdges :: GraphState -> Map.Map Name_ GView
graphEdges gs = edges $ graph gs

initGraphState :: GraphState 
initGraphState =
  GraphState (TGraph Map.empty Map.empty) (Map.empty) 

computeGraphState :: [Abs.Language] ->  GraphState 
computeGraphState defs = 
  foldl updateState initGraphState defs

-- data LangExt = MExprC ModExpr | TheoryC Theory | RenLC RenList
updateState :: GraphState -> Abs.Language -> GraphState
updateState gstate (TheoryC name clist)  = theory  gstate name clist
updateState gstate (MappingC name vlist) = renList gstate name vlist
updateState gstate (ModExprC name mexps) = modExpr gstate name mexps

theory :: GraphState -> Name -> [Abs.Constr] -> GraphState
theory gs thryName cList =
  GraphState  
   (TGraph (Map.insert (name_ thryName) newThry $ graphNodes gs) (graphEdges gs))
   (renames gs) 
  where newThry  = (GTheory NoParams $ flds cList)
        flds [] = NoFields
        flds ls = Fields ls              

renList :: GraphState -> Name -> Rens -> GraphState 
renList gs name rens =
  GraphState (graph gs) $
    Map.insert (name_ name) (rensToRename gs rens) (renames gs)

getTheory :: Name -> GraphState -> GTheory
getTheory n gs = lookupName (name_ n) (graph gs)

modExpr :: GraphState -> Name -> Abs.ModExpr -> GraphState
modExpr gs name mexpr =
  case mexpr of
    Extend srcName clist ->
      GraphState (updateGraph (graph gs) (name_ name) $ Left $ computeExtend clist (getTheory srcName gs))
        (renames gs)
    Rename srcName rlist ->   
      GraphState
        (updateGraph (graph gs) (name_ name) $ Left $ computeRename (rensToRename gs rlist) (getTheory srcName gs))
        (renames gs)
    RenameUsing srcName mapName ->
     let mapin = (renames gs) Map.! (name_ mapName) 
     in GraphState
        (updateGraph (graph gs) (name_ name) $ Left $ computeRename mapin (getTheory srcName gs))
        (renames gs)
    CombineOver trgt1 ren1 trgt2 ren2 srcName ->
     let s = getTheory srcName gs
         gr = graph gs
         p1 = getPath gr s $ getTheory trgt1 gs
         p2 = getPath gr s $ getTheory trgt2 gs
         qpath1 = QPath p1 $ rensToRename gs ren1
         qpath2 = QPath p2 $ rensToRename gs ren2
     in GraphState
        (updateGraph gr (name_ name) $ Right $ computeCombine qpath1 qpath2)
        (renames gs)  
    Combine trgt1 trgt2 ->
      modExpr gs name $
        Abs.CombineOver trgt1 NoRens trgt2 NoRens (Name ((0,0),"Carrier"))
          -- TODO: (computeCommonSource name1 name2)
    Transport n srcName ->
     GraphState
      (updateGraph (graph gs) (name_ name) $ Left $ computeTransport (rensToRename gs n) $ getTheory srcName gs)
      (renames gs) 

rensToRename :: GraphState -> Rens -> Rename
rensToRename gs (NameRens n) = (renames gs) Map.! (name_ n)
rensToRename _  NoRens = Map.empty
rensToRename _ (Rens rlist) = Map.fromList $ map (\(RenPair x y) -> (name_ x,name_ y)) rlist

{- ------------------------------------------------------------- -} 

theoryToRecord :: Name_ -> GTheory -> Decl 
theoryToRecord thryName (GTheory ps fs) =
  Record (Name (noSrcLoc,thryName)) ps
         (RecordDeclDef (Name (noSrcLoc,"Set")) (Name (noSrcLoc,thryName++"C")) fs)  

recordToModule :: Name_ -> Decl -> Decl
recordToModule thryName record =
  Module_ $ Module (Name (noSrcLoc,thryName)) NoParams $ Decl_ [record] 

createModules :: Map.Map Name_ GTheory -> Abs.Module
createModules theories =
  let records = Map.mapWithKey theoryToRecord theories
      modules = Map.mapWithKey recordToModule records 
  in Module (Name (noSrcLoc,moduleName)) NoParams $  
       Decl_ (Map.elems $ modules) 

getLibDecls :: Abs.Module -> [Abs.Language]
getLibDecls (Abs.Module _ _ (Abs.Lang_ ls)) = ls
getLibDecls _ = error "No Module expressions" 