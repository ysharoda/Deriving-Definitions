import init.data.nat.basic
import init.data.fin.basic
import data.vector
import .Prelude
open Staged
open nat
open fin
open vector
section LeftBiMagma   
  structure LeftBiMagma  (A : Type) : Type := 
       (op : (A → (A → A)))
       (linv : (A → (A → A))) 
  
  open LeftBiMagma
  structure Sig  (AS : Type) : Type := 
       (opS : (AS → (AS → AS)))
       (linvS : (AS → (AS → AS))) 
  
  structure Product  (A : Type) : Type := 
       (opP : ((Prod A A) → ((Prod A A) → (Prod A A))))
       (linvP : ((Prod A A) → ((Prod A A) → (Prod A A)))) 
  
  structure Hom  {A1 : Type} {A2 : Type} (Le1 : (LeftBiMagma A1)) (Le2 : (LeftBiMagma A2)) : Type := 
       (hom : (A1 → A2))
       (pres_op : (∀ {x1 x2 : A1} , (hom ((op Le1) x1 x2)) = ((op Le2) (hom x1) (hom x2))))
       (pres_linv : (∀ {x1 x2 : A1} , (hom ((linv Le1) x1 x2)) = ((linv Le2) (hom x1) (hom x2)))) 
  
  structure RelInterp  {A1 : Type} {A2 : Type} (Le1 : (LeftBiMagma A1)) (Le2 : (LeftBiMagma A2)) : Type 1 := 
       (interp : (A1 → (A2 → Type)))
       (interp_op : (∀ {x1 x2 : A1} {y1 y2 : A2} , ((interp x1 y1) → ((interp x2 y2) → (interp ((op Le1) x1 x2) ((op Le2) y1 y2))))))
       (interp_linv : (∀ {x1 x2 : A1} {y1 y2 : A2} , ((interp x1 y1) → ((interp x2 y2) → (interp ((linv Le1) x1 x2) ((linv Le2) y1 y2)))))) 
  
  inductive LeftBiMagmaTerm   : Type  
     | opL : (LeftBiMagmaTerm → (LeftBiMagmaTerm → LeftBiMagmaTerm)) 
     | linvL : (LeftBiMagmaTerm → (LeftBiMagmaTerm → LeftBiMagmaTerm))  
      open LeftBiMagmaTerm 
  
  inductive ClLeftBiMagmaTerm  (A : Type) : Type  
     | sing : (A → ClLeftBiMagmaTerm) 
     | opCl : (ClLeftBiMagmaTerm → (ClLeftBiMagmaTerm → ClLeftBiMagmaTerm)) 
     | linvCl : (ClLeftBiMagmaTerm → (ClLeftBiMagmaTerm → ClLeftBiMagmaTerm))  
      open ClLeftBiMagmaTerm 
  
  inductive OpLeftBiMagmaTerm  (n : ℕ) : Type  
     | v : ((fin n) → OpLeftBiMagmaTerm) 
     | opOL : (OpLeftBiMagmaTerm → (OpLeftBiMagmaTerm → OpLeftBiMagmaTerm)) 
     | linvOL : (OpLeftBiMagmaTerm → (OpLeftBiMagmaTerm → OpLeftBiMagmaTerm))  
      open OpLeftBiMagmaTerm 
  
  inductive OpLeftBiMagmaTerm2  (n : ℕ) (A : Type) : Type  
     | v2 : ((fin n) → OpLeftBiMagmaTerm2) 
     | sing2 : (A → OpLeftBiMagmaTerm2) 
     | opOL2 : (OpLeftBiMagmaTerm2 → (OpLeftBiMagmaTerm2 → OpLeftBiMagmaTerm2)) 
     | linvOL2 : (OpLeftBiMagmaTerm2 → (OpLeftBiMagmaTerm2 → OpLeftBiMagmaTerm2))  
      open OpLeftBiMagmaTerm2 
  
  def simplifyCl   {A : Type}  : ((ClLeftBiMagmaTerm A) → (ClLeftBiMagmaTerm A)) 
  | (opCl x1 x2) := (opCl (simplifyCl x1) (simplifyCl x2))  
  | (linvCl x1 x2) := (linvCl (simplifyCl x1) (simplifyCl x2))  
  | (sing x1) := (sing x1)  
  def simplifyOpB   {n : ℕ}  : ((OpLeftBiMagmaTerm n) → (OpLeftBiMagmaTerm n)) 
  | (opOL x1 x2) := (opOL (simplifyOpB x1) (simplifyOpB x2))  
  | (linvOL x1 x2) := (linvOL (simplifyOpB x1) (simplifyOpB x2))  
  | (v x1) := (v x1)  
  def simplifyOp   {n : ℕ} {A : Type}  : ((OpLeftBiMagmaTerm2 n A) → (OpLeftBiMagmaTerm2 n A)) 
  | (opOL2 x1 x2) := (opOL2 (simplifyOp x1) (simplifyOp x2))  
  | (linvOL2 x1 x2) := (linvOL2 (simplifyOp x1) (simplifyOp x2))  
  | (v2 x1) := (v2 x1)  
  | (sing2 x1) := (sing2 x1)  
  def evalB   {A : Type}  : ((LeftBiMagma A) → (LeftBiMagmaTerm → A)) 
  | Le (opL x1 x2) := ((op Le) (evalB Le x1) (evalB Le x2))  
  | Le (linvL x1 x2) := ((linv Le) (evalB Le x1) (evalB Le x2))  
  def evalCl   {A : Type}  : ((LeftBiMagma A) → ((ClLeftBiMagmaTerm A) → A)) 
  | Le (sing x1) := x1  
  | Le (opCl x1 x2) := ((op Le) (evalCl Le x1) (evalCl Le x2))  
  | Le (linvCl x1 x2) := ((linv Le) (evalCl Le x1) (evalCl Le x2))  
  def evalOpB   {A : Type} {n : ℕ}  : ((LeftBiMagma A) → ((vector A n) → ((OpLeftBiMagmaTerm n) → A))) 
  | Le vars (v x1) := (nth vars x1)  
  | Le vars (opOL x1 x2) := ((op Le) (evalOpB Le vars x1) (evalOpB Le vars x2))  
  | Le vars (linvOL x1 x2) := ((linv Le) (evalOpB Le vars x1) (evalOpB Le vars x2))  
  def evalOp   {A : Type} {n : ℕ}  : ((LeftBiMagma A) → ((vector A n) → ((OpLeftBiMagmaTerm2 n A) → A))) 
  | Le vars (v2 x1) := (nth vars x1)  
  | Le vars (sing2 x1) := x1  
  | Le vars (opOL2 x1 x2) := ((op Le) (evalOp Le vars x1) (evalOp Le vars x2))  
  | Le vars (linvOL2 x1 x2) := ((linv Le) (evalOp Le vars x1) (evalOp Le vars x2))  
  def inductionB   {P : (LeftBiMagmaTerm → Type)}  : ((∀ (x1 x2 : LeftBiMagmaTerm) , ((P x1) → ((P x2) → (P (opL x1 x2))))) → ((∀ (x1 x2 : LeftBiMagmaTerm) , ((P x1) → ((P x2) → (P (linvL x1 x2))))) → (∀ (x : LeftBiMagmaTerm) , (P x)))) 
  | popl plinvl (opL x1 x2) := (popl _ _ (inductionB popl plinvl x1) (inductionB popl plinvl x2))  
  | popl plinvl (linvL x1 x2) := (plinvl _ _ (inductionB popl plinvl x1) (inductionB popl plinvl x2))  
  def inductionCl   {A : Type} {P : ((ClLeftBiMagmaTerm A) → Type)}  : ((∀ (x1 : A) , (P (sing x1))) → ((∀ (x1 x2 : (ClLeftBiMagmaTerm A)) , ((P x1) → ((P x2) → (P (opCl x1 x2))))) → ((∀ (x1 x2 : (ClLeftBiMagmaTerm A)) , ((P x1) → ((P x2) → (P (linvCl x1 x2))))) → (∀ (x : (ClLeftBiMagmaTerm A)) , (P x))))) 
  | psing popcl plinvcl (sing x1) := (psing x1)  
  | psing popcl plinvcl (opCl x1 x2) := (popcl _ _ (inductionCl psing popcl plinvcl x1) (inductionCl psing popcl plinvcl x2))  
  | psing popcl plinvcl (linvCl x1 x2) := (plinvcl _ _ (inductionCl psing popcl plinvcl x1) (inductionCl psing popcl plinvcl x2))  
  def inductionOpB   {n : ℕ} {P : ((OpLeftBiMagmaTerm n) → Type)}  : ((∀ (fin : (fin n)) , (P (v fin))) → ((∀ (x1 x2 : (OpLeftBiMagmaTerm n)) , ((P x1) → ((P x2) → (P (opOL x1 x2))))) → ((∀ (x1 x2 : (OpLeftBiMagmaTerm n)) , ((P x1) → ((P x2) → (P (linvOL x1 x2))))) → (∀ (x : (OpLeftBiMagmaTerm n)) , (P x))))) 
  | pv popol plinvol (v x1) := (pv x1)  
  | pv popol plinvol (opOL x1 x2) := (popol _ _ (inductionOpB pv popol plinvol x1) (inductionOpB pv popol plinvol x2))  
  | pv popol plinvol (linvOL x1 x2) := (plinvol _ _ (inductionOpB pv popol plinvol x1) (inductionOpB pv popol plinvol x2))  
  def inductionOp   {n : ℕ} {A : Type} {P : ((OpLeftBiMagmaTerm2 n A) → Type)}  : ((∀ (fin : (fin n)) , (P (v2 fin))) → ((∀ (x1 : A) , (P (sing2 x1))) → ((∀ (x1 x2 : (OpLeftBiMagmaTerm2 n A)) , ((P x1) → ((P x2) → (P (opOL2 x1 x2))))) → ((∀ (x1 x2 : (OpLeftBiMagmaTerm2 n A)) , ((P x1) → ((P x2) → (P (linvOL2 x1 x2))))) → (∀ (x : (OpLeftBiMagmaTerm2 n A)) , (P x)))))) 
  | pv2 psing2 popol2 plinvol2 (v2 x1) := (pv2 x1)  
  | pv2 psing2 popol2 plinvol2 (sing2 x1) := (psing2 x1)  
  | pv2 psing2 popol2 plinvol2 (opOL2 x1 x2) := (popol2 _ _ (inductionOp pv2 psing2 popol2 plinvol2 x1) (inductionOp pv2 psing2 popol2 plinvol2 x2))  
  | pv2 psing2 popol2 plinvol2 (linvOL2 x1 x2) := (plinvol2 _ _ (inductionOp pv2 psing2 popol2 plinvol2 x1) (inductionOp pv2 psing2 popol2 plinvol2 x2))  
  def stageB  : (LeftBiMagmaTerm → (Staged LeftBiMagmaTerm))
  | (opL x1 x2) := (stage2 opL (codeLift2 opL) (stageB x1) (stageB x2))  
  | (linvL x1 x2) := (stage2 linvL (codeLift2 linvL) (stageB x1) (stageB x2))  
  def stageCl   {A : Type}  : ((ClLeftBiMagmaTerm A) → (Staged (ClLeftBiMagmaTerm A))) 
  | (sing x1) := (Now (sing x1))  
  | (opCl x1 x2) := (stage2 opCl (codeLift2 opCl) (stageCl x1) (stageCl x2))  
  | (linvCl x1 x2) := (stage2 linvCl (codeLift2 linvCl) (stageCl x1) (stageCl x2))  
  def stageOpB   {n : ℕ}  : ((OpLeftBiMagmaTerm n) → (Staged (OpLeftBiMagmaTerm n))) 
  | (v x1) := (const (code (v x1)))  
  | (opOL x1 x2) := (stage2 opOL (codeLift2 opOL) (stageOpB x1) (stageOpB x2))  
  | (linvOL x1 x2) := (stage2 linvOL (codeLift2 linvOL) (stageOpB x1) (stageOpB x2))  
  def stageOp   {n : ℕ} {A : Type}  : ((OpLeftBiMagmaTerm2 n A) → (Staged (OpLeftBiMagmaTerm2 n A))) 
  | (sing2 x1) := (Now (sing2 x1))  
  | (v2 x1) := (const (code (v2 x1)))  
  | (opOL2 x1 x2) := (stage2 opOL2 (codeLift2 opOL2) (stageOp x1) (stageOp x2))  
  | (linvOL2 x1 x2) := (stage2 linvOL2 (codeLift2 linvOL2) (stageOp x1) (stageOp x2))  
  structure StagedRepr  (A : Type) (Repr : (Type → Type)) : Type := 
       (opT : ((Repr A) → ((Repr A) → (Repr A))))
       (linvT : ((Repr A) → ((Repr A) → (Repr A)))) 
  
end LeftBiMagma