import init.data.nat.basic
import init.data.fin.basic
import data.vector
import .Prelude
open Staged
open nat
open fin
open vector
section AssociativeLeftRingoid   
  structure AssociativeLeftRingoid  (A : Type) : Type := 
       (times : (A → (A → A)))
       (associative_times : (∀ {x y z : A} , (times (times x y) z) = (times x (times y z))))
       (plus : (A → (A → A)))
       (leftDistributive_times_plus : (∀ {x y z : A} , (times x (plus y z)) = (plus (times x y) (times x z)))) 
  
  open AssociativeLeftRingoid
  structure Sig  (AS : Type) : Type := 
       (timesS : (AS → (AS → AS)))
       (plusS : (AS → (AS → AS))) 
  
  structure Product  (A : Type) : Type := 
       (timesP : ((Prod A A) → ((Prod A A) → (Prod A A))))
       (plusP : ((Prod A A) → ((Prod A A) → (Prod A A))))
       (associative_timesP : (∀ {xP yP zP : (Prod A A)} , (timesP (timesP xP yP) zP) = (timesP xP (timesP yP zP))))
       (leftDistributive_times_plusP : (∀ {xP yP zP : (Prod A A)} , (timesP xP (plusP yP zP)) = (plusP (timesP xP yP) (timesP xP zP)))) 
  
  structure Hom  {A1 : Type} {A2 : Type} (As1 : (AssociativeLeftRingoid A1)) (As2 : (AssociativeLeftRingoid A2)) : Type := 
       (hom : (A1 → A2))
       (pres_times : (∀ {x1 x2 : A1} , (hom ((times As1) x1 x2)) = ((times As2) (hom x1) (hom x2))))
       (pres_plus : (∀ {x1 x2 : A1} , (hom ((plus As1) x1 x2)) = ((plus As2) (hom x1) (hom x2)))) 
  
  structure RelInterp  {A1 : Type} {A2 : Type} (As1 : (AssociativeLeftRingoid A1)) (As2 : (AssociativeLeftRingoid A2)) : Type 1 := 
       (interp : (A1 → (A2 → Type)))
       (interp_times : (∀ {x1 x2 : A1} {y1 y2 : A2} , ((interp x1 y1) → ((interp x2 y2) → (interp ((times As1) x1 x2) ((times As2) y1 y2))))))
       (interp_plus : (∀ {x1 x2 : A1} {y1 y2 : A2} , ((interp x1 y1) → ((interp x2 y2) → (interp ((plus As1) x1 x2) ((plus As2) y1 y2)))))) 
  
  inductive AssociativeLeftRingoidTerm   : Type  
     | timesL : (AssociativeLeftRingoidTerm → (AssociativeLeftRingoidTerm → AssociativeLeftRingoidTerm)) 
     | plusL : (AssociativeLeftRingoidTerm → (AssociativeLeftRingoidTerm → AssociativeLeftRingoidTerm))  
      open AssociativeLeftRingoidTerm 
  
  inductive ClAssociativeLeftRingoidTerm  (A : Type) : Type  
     | sing : (A → ClAssociativeLeftRingoidTerm) 
     | timesCl : (ClAssociativeLeftRingoidTerm → (ClAssociativeLeftRingoidTerm → ClAssociativeLeftRingoidTerm)) 
     | plusCl : (ClAssociativeLeftRingoidTerm → (ClAssociativeLeftRingoidTerm → ClAssociativeLeftRingoidTerm))  
      open ClAssociativeLeftRingoidTerm 
  
  inductive OpAssociativeLeftRingoidTerm  (n : ℕ) : Type  
     | v : ((fin n) → OpAssociativeLeftRingoidTerm) 
     | timesOL : (OpAssociativeLeftRingoidTerm → (OpAssociativeLeftRingoidTerm → OpAssociativeLeftRingoidTerm)) 
     | plusOL : (OpAssociativeLeftRingoidTerm → (OpAssociativeLeftRingoidTerm → OpAssociativeLeftRingoidTerm))  
      open OpAssociativeLeftRingoidTerm 
  
  inductive OpAssociativeLeftRingoidTerm2  (n : ℕ) (A : Type) : Type  
     | v2 : ((fin n) → OpAssociativeLeftRingoidTerm2) 
     | sing2 : (A → OpAssociativeLeftRingoidTerm2) 
     | timesOL2 : (OpAssociativeLeftRingoidTerm2 → (OpAssociativeLeftRingoidTerm2 → OpAssociativeLeftRingoidTerm2)) 
     | plusOL2 : (OpAssociativeLeftRingoidTerm2 → (OpAssociativeLeftRingoidTerm2 → OpAssociativeLeftRingoidTerm2))  
      open OpAssociativeLeftRingoidTerm2 
  
  def simplifyCl   {A : Type}  : ((ClAssociativeLeftRingoidTerm A) → (ClAssociativeLeftRingoidTerm A)) 
  | (timesCl x1 x2) := (timesCl (simplifyCl x1) (simplifyCl x2))  
  | (plusCl x1 x2) := (plusCl (simplifyCl x1) (simplifyCl x2))  
  | (sing x1) := (sing x1)  
  def simplifyOpB   {n : ℕ}  : ((OpAssociativeLeftRingoidTerm n) → (OpAssociativeLeftRingoidTerm n)) 
  | (timesOL x1 x2) := (timesOL (simplifyOpB x1) (simplifyOpB x2))  
  | (plusOL x1 x2) := (plusOL (simplifyOpB x1) (simplifyOpB x2))  
  | (v x1) := (v x1)  
  def simplifyOp   {n : ℕ} {A : Type}  : ((OpAssociativeLeftRingoidTerm2 n A) → (OpAssociativeLeftRingoidTerm2 n A)) 
  | (timesOL2 x1 x2) := (timesOL2 (simplifyOp x1) (simplifyOp x2))  
  | (plusOL2 x1 x2) := (plusOL2 (simplifyOp x1) (simplifyOp x2))  
  | (v2 x1) := (v2 x1)  
  | (sing2 x1) := (sing2 x1)  
  def evalB   {A : Type}  : ((AssociativeLeftRingoid A) → (AssociativeLeftRingoidTerm → A)) 
  | As (timesL x1 x2) := ((times As) (evalB As x1) (evalB As x2))  
  | As (plusL x1 x2) := ((plus As) (evalB As x1) (evalB As x2))  
  def evalCl   {A : Type}  : ((AssociativeLeftRingoid A) → ((ClAssociativeLeftRingoidTerm A) → A)) 
  | As (sing x1) := x1  
  | As (timesCl x1 x2) := ((times As) (evalCl As x1) (evalCl As x2))  
  | As (plusCl x1 x2) := ((plus As) (evalCl As x1) (evalCl As x2))  
  def evalOpB   {A : Type} {n : ℕ}  : ((AssociativeLeftRingoid A) → ((vector A n) → ((OpAssociativeLeftRingoidTerm n) → A))) 
  | As vars (v x1) := (nth vars x1)  
  | As vars (timesOL x1 x2) := ((times As) (evalOpB As vars x1) (evalOpB As vars x2))  
  | As vars (plusOL x1 x2) := ((plus As) (evalOpB As vars x1) (evalOpB As vars x2))  
  def evalOp   {A : Type} {n : ℕ}  : ((AssociativeLeftRingoid A) → ((vector A n) → ((OpAssociativeLeftRingoidTerm2 n A) → A))) 
  | As vars (v2 x1) := (nth vars x1)  
  | As vars (sing2 x1) := x1  
  | As vars (timesOL2 x1 x2) := ((times As) (evalOp As vars x1) (evalOp As vars x2))  
  | As vars (plusOL2 x1 x2) := ((plus As) (evalOp As vars x1) (evalOp As vars x2))  
  def inductionB   {P : (AssociativeLeftRingoidTerm → Type)}  : ((∀ (x1 x2 : AssociativeLeftRingoidTerm) , ((P x1) → ((P x2) → (P (timesL x1 x2))))) → ((∀ (x1 x2 : AssociativeLeftRingoidTerm) , ((P x1) → ((P x2) → (P (plusL x1 x2))))) → (∀ (x : AssociativeLeftRingoidTerm) , (P x)))) 
  | ptimesl pplusl (timesL x1 x2) := (ptimesl _ _ (inductionB ptimesl pplusl x1) (inductionB ptimesl pplusl x2))  
  | ptimesl pplusl (plusL x1 x2) := (pplusl _ _ (inductionB ptimesl pplusl x1) (inductionB ptimesl pplusl x2))  
  def inductionCl   {A : Type} {P : ((ClAssociativeLeftRingoidTerm A) → Type)}  : ((∀ (x1 : A) , (P (sing x1))) → ((∀ (x1 x2 : (ClAssociativeLeftRingoidTerm A)) , ((P x1) → ((P x2) → (P (timesCl x1 x2))))) → ((∀ (x1 x2 : (ClAssociativeLeftRingoidTerm A)) , ((P x1) → ((P x2) → (P (plusCl x1 x2))))) → (∀ (x : (ClAssociativeLeftRingoidTerm A)) , (P x))))) 
  | psing ptimescl ppluscl (sing x1) := (psing x1)  
  | psing ptimescl ppluscl (timesCl x1 x2) := (ptimescl _ _ (inductionCl psing ptimescl ppluscl x1) (inductionCl psing ptimescl ppluscl x2))  
  | psing ptimescl ppluscl (plusCl x1 x2) := (ppluscl _ _ (inductionCl psing ptimescl ppluscl x1) (inductionCl psing ptimescl ppluscl x2))  
  def inductionOpB   {n : ℕ} {P : ((OpAssociativeLeftRingoidTerm n) → Type)}  : ((∀ (fin : (fin n)) , (P (v fin))) → ((∀ (x1 x2 : (OpAssociativeLeftRingoidTerm n)) , ((P x1) → ((P x2) → (P (timesOL x1 x2))))) → ((∀ (x1 x2 : (OpAssociativeLeftRingoidTerm n)) , ((P x1) → ((P x2) → (P (plusOL x1 x2))))) → (∀ (x : (OpAssociativeLeftRingoidTerm n)) , (P x))))) 
  | pv ptimesol pplusol (v x1) := (pv x1)  
  | pv ptimesol pplusol (timesOL x1 x2) := (ptimesol _ _ (inductionOpB pv ptimesol pplusol x1) (inductionOpB pv ptimesol pplusol x2))  
  | pv ptimesol pplusol (plusOL x1 x2) := (pplusol _ _ (inductionOpB pv ptimesol pplusol x1) (inductionOpB pv ptimesol pplusol x2))  
  def inductionOp   {n : ℕ} {A : Type} {P : ((OpAssociativeLeftRingoidTerm2 n A) → Type)}  : ((∀ (fin : (fin n)) , (P (v2 fin))) → ((∀ (x1 : A) , (P (sing2 x1))) → ((∀ (x1 x2 : (OpAssociativeLeftRingoidTerm2 n A)) , ((P x1) → ((P x2) → (P (timesOL2 x1 x2))))) → ((∀ (x1 x2 : (OpAssociativeLeftRingoidTerm2 n A)) , ((P x1) → ((P x2) → (P (plusOL2 x1 x2))))) → (∀ (x : (OpAssociativeLeftRingoidTerm2 n A)) , (P x)))))) 
  | pv2 psing2 ptimesol2 pplusol2 (v2 x1) := (pv2 x1)  
  | pv2 psing2 ptimesol2 pplusol2 (sing2 x1) := (psing2 x1)  
  | pv2 psing2 ptimesol2 pplusol2 (timesOL2 x1 x2) := (ptimesol2 _ _ (inductionOp pv2 psing2 ptimesol2 pplusol2 x1) (inductionOp pv2 psing2 ptimesol2 pplusol2 x2))  
  | pv2 psing2 ptimesol2 pplusol2 (plusOL2 x1 x2) := (pplusol2 _ _ (inductionOp pv2 psing2 ptimesol2 pplusol2 x1) (inductionOp pv2 psing2 ptimesol2 pplusol2 x2))  
  def stageB  : (AssociativeLeftRingoidTerm → (Staged AssociativeLeftRingoidTerm))
  | (timesL x1 x2) := (stage2 timesL (codeLift2 timesL) (stageB x1) (stageB x2))  
  | (plusL x1 x2) := (stage2 plusL (codeLift2 plusL) (stageB x1) (stageB x2))  
  def stageCl   {A : Type}  : ((ClAssociativeLeftRingoidTerm A) → (Staged (ClAssociativeLeftRingoidTerm A))) 
  | (sing x1) := (Now (sing x1))  
  | (timesCl x1 x2) := (stage2 timesCl (codeLift2 timesCl) (stageCl x1) (stageCl x2))  
  | (plusCl x1 x2) := (stage2 plusCl (codeLift2 plusCl) (stageCl x1) (stageCl x2))  
  def stageOpB   {n : ℕ}  : ((OpAssociativeLeftRingoidTerm n) → (Staged (OpAssociativeLeftRingoidTerm n))) 
  | (v x1) := (const (code (v x1)))  
  | (timesOL x1 x2) := (stage2 timesOL (codeLift2 timesOL) (stageOpB x1) (stageOpB x2))  
  | (plusOL x1 x2) := (stage2 plusOL (codeLift2 plusOL) (stageOpB x1) (stageOpB x2))  
  def stageOp   {n : ℕ} {A : Type}  : ((OpAssociativeLeftRingoidTerm2 n A) → (Staged (OpAssociativeLeftRingoidTerm2 n A))) 
  | (sing2 x1) := (Now (sing2 x1))  
  | (v2 x1) := (const (code (v2 x1)))  
  | (timesOL2 x1 x2) := (stage2 timesOL2 (codeLift2 timesOL2) (stageOp x1) (stageOp x2))  
  | (plusOL2 x1 x2) := (stage2 plusOL2 (codeLift2 plusOL2) (stageOp x1) (stageOp x2))  
  structure StagedRepr  (A : Type) (Repr : (Type → Type)) : Type := 
       (timesT : ((Repr A) → ((Repr A) → (Repr A))))
       (plusT : ((Repr A) → ((Repr A) → (Repr A)))) 
  
end AssociativeLeftRingoid