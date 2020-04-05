module Tog.Deriving.TGraphTest
  ( computeGraph 
  , graphNodes
  ) where

import qualified Data.Map            as Map
import           Control.Lens ((^.))

import           Tog.Deriving.Lenses (name)
import           Tog.Deriving.TUtils (mkName)
import           Tog.Deriving.Types
import           Tog.Deriving.TGraph
import           Tog.Raw.Abs         as Abs

data Graph = Graph {
  graph   :: TGraph,
  renames :: Map.Map Name_ Rename }

graphNodes :: Graph -> Map.Map Name_ GTheory
graphNodes = nodes . graph

graphEdges :: Graph -> Map.Map Name_ GView
graphEdges = edges . graph

initGraph :: Graph 
initGraph = Graph (TGraph Map.empty Map.empty) (Map.empty) 

computeGraph :: [Abs.Language] ->  Graph 
computeGraph = foldl add initGraph

add :: Graph -> Abs.Language -> Graph
add g (TheoryC nm clist)  = theory  g nm clist
add g (MappingC nm vlist) = renList g nm vlist
add g (ModExprC nm mexps) = modExpr g nm mexps

theory :: Graph -> Name -> [Abs.Constr] -> Graph
theory gs thryName cList =
  Graph  
   (TGraph (Map.insert (thryName ^. name) newThry $ graphNodes gs) (graphEdges gs))
   (renames gs) 
  where newThry  = (GTheory NoParams $ flds cList)
        flds [] = NoFields
        flds ls = Fields ls              

renList :: Graph -> Name -> Rens -> Graph 
renList gs nm rens =
  gs { renames = Map.insert (nm^.name) (rensToRename gs rens) (renames gs) }

getTheory :: Name -> Graph -> GTheory
getTheory n gs = lookupName (n^.name) (graph gs)

modExpr :: Graph -> Name -> Abs.ModExpr -> Graph
modExpr gs nam mexpr =
  let n = nam^.name in
  case mexpr of
    Extend srcName clist ->
      Graph (updateGraph (graph gs) n $ Left $ computeExtend clist (getTheory srcName gs))
        (renames gs)
    Rename srcName rlist ->   
      Graph
        (updateGraph (graph gs) n $ Left $ computeRename (rensToRename gs rlist) (getTheory srcName gs))
        (renames gs)
    RenameUsing srcName nm ->
     let mapin = (renames gs) Map.! (nm^.name) 
     in Graph
        (updateGraph (graph gs) n $ Left $ computeRename mapin (getTheory srcName gs))
        (renames gs)
    CombineOver trgt1 ren1 trgt2 ren2 srcName ->
     let s = getTheory srcName gs
         gr = graph gs
         p1 = getPath gr s $ getTheory trgt1 gs
         p2 = getPath gr s $ getTheory trgt2 gs
         qpath1 = QPath p1 $ rensToRename gs ren1
         qpath2 = QPath p2 $ rensToRename gs ren2
     in Graph
        (updateGraph gr n $ Right $ computeCombine qpath1 qpath2)
        (renames gs)  
    Combine trgt1 trgt2 ->
      modExpr gs nam $
        Abs.CombineOver trgt1 NoRens trgt2 NoRens (mkName "Carrier")
          -- TODO: (computeCommonSource name1 name2)
    Transport nn srcName ->
     Graph
      (updateGraph (graph gs) n $ Left $ computeTransport (rensToRename gs nn) $ getTheory srcName gs)
      (renames gs) 

rensToRename :: Graph -> Rens -> Rename
rensToRename gs (NameRens n) = (renames gs) Map.! (n^.name)
rensToRename _  NoRens = Map.empty
rensToRename _ (Rens rlist) = Map.fromList $ map (\(RenPair x y) -> (x^.name,y^.name)) rlist

