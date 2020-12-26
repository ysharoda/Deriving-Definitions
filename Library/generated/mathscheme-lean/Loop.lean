import init.data.nat.basic
import init.data.fin.basic
import data.vector
import .Prelude
open Staged
open nat
open fin
open vector
section Loop   
  structure Loop  (A : Type) : Type := 
       (op : (A → (A → A)))
       (e : A)
       (lunit_e : (∀ {x : A} , (op e x) = x))
       (runit_e : (∀ {x : A} , (op x e) = x))
       (linv : (A → (A → A)))
       (leftCancel : (∀ {x y : A} , (op x (linv x y)) = y))
       (lefCancelOp : (∀ {x y : A} , (linv x (op x y)) = y))
       (rinv : (A → (A → A)))
       (rightCancel : (∀ {x y : A} , (op (rinv y x) x) = y))
       (rightCancelOp : (∀ {x y : A} , (rinv (op y x) x) = y)) 
  
  open Loop
  structure Sig  (AS : Type) : Type := 
       (opS : (AS → (AS → AS)))
       (eS : AS)
       (linvS : (AS → (AS → AS)))
       (rinvS : (AS → (AS → AS))) 
  
  structure Product  (A : Type) : Type := 
       (opP : ((Prod A A) → ((Prod A A) → (Prod A A))))
       (eP : (Prod A A))
       (linvP : ((Prod A A) → ((Prod A A) → (Prod A A))))
       (rinvP : ((Prod A A) → ((Prod A A) → (Prod A A))))
       (lunit_eP : (∀ {xP : (Prod A A)} , (opP eP xP) = xP))
       (runit_eP : (∀ {xP : (Prod A A)} , (opP xP eP) = xP))
       (leftCancelP : (∀ {xP yP : (Prod A A)} , (opP xP (linvP xP yP)) = yP))
       (lefCancelOpP : (∀ {xP yP : (Prod A A)} , (linvP xP (opP xP yP)) = yP))
       (rightCancelP : (∀ {xP yP : (Prod A A)} , (opP (rinvP yP xP) xP) = yP))
       (rightCancelOpP : (∀ {xP yP : (Prod A A)} , (rinvP (opP yP xP) xP) = yP)) 
  
  structure Hom  {A1 : Type} {A2 : Type} (Lo1 : (Loop A1)) (Lo2 : (Loop A2)) : Type := 
       (hom : (A1 → A2))
       (pres_op : (∀ {x1 x2 : A1} , (hom ((op Lo1) x1 x2)) = ((op Lo2) (hom x1) (hom x2))))
       (pres_e : (hom (e Lo1)) = (e Lo2))
       (pres_linv : (∀ {x1 x2 : A1} , (hom ((linv Lo1) x1 x2)) = ((linv Lo2) (hom x1) (hom x2))))
       (pres_rinv : (∀ {x1 x2 : A1} , (hom ((rinv Lo1) x1 x2)) = ((rinv Lo2) (hom x1) (hom x2)))) 
  
  structure RelInterp  {A1 : Type} {A2 : Type} (Lo1 : (Loop A1)) (Lo2 : (Loop A2)) : Type 1 := 
       (interp : (A1 → (A2 → Type)))
       (interp_op : (∀ {x1 x2 : A1} {y1 y2 : A2} , ((interp x1 y1) → ((interp x2 y2) → (interp ((op Lo1) x1 x2) ((op Lo2) y1 y2))))))
       (interp_e : (interp (e Lo1) (e Lo2)))
       (interp_linv : (∀ {x1 x2 : A1} {y1 y2 : A2} , ((interp x1 y1) → ((interp x2 y2) → (interp ((linv Lo1) x1 x2) ((linv Lo2) y1 y2))))))
       (interp_rinv : (∀ {x1 x2 : A1} {y1 y2 : A2} , ((interp x1 y1) → ((interp x2 y2) → (interp ((rinv Lo1) x1 x2) ((rinv Lo2) y1 y2)))))) 
  
  inductive LoopLTerm   : Type  
     | opL : (LoopLTerm → (LoopLTerm → LoopLTerm)) 
     | eL : LoopLTerm 
     | linvL : (LoopLTerm → (LoopLTerm → LoopLTerm)) 
     | rinvL : (LoopLTerm → (LoopLTerm → LoopLTerm))  
      open LoopLTerm 
  
  inductive ClLoopClTerm  (A : Type) : Type  
     | sing : (A → ClLoopClTerm) 
     | opCl : (ClLoopClTerm → (ClLoopClTerm → ClLoopClTerm)) 
     | eCl : ClLoopClTerm 
     | linvCl : (ClLoopClTerm → (ClLoopClTerm → ClLoopClTerm)) 
     | rinvCl : (ClLoopClTerm → (ClLoopClTerm → ClLoopClTerm))  
      open ClLoopClTerm 
  
  inductive OpLoopOLTerm  (n : ℕ) : Type  
     | v : ((fin n) → OpLoopOLTerm) 
     | opOL : (OpLoopOLTerm → (OpLoopOLTerm → OpLoopOLTerm)) 
     | eOL : OpLoopOLTerm 
     | linvOL : (OpLoopOLTerm → (OpLoopOLTerm → OpLoopOLTerm)) 
     | rinvOL : (OpLoopOLTerm → (OpLoopOLTerm → OpLoopOLTerm))  
      open OpLoopOLTerm 
  
  inductive OpLoopOL2Term2  (n : ℕ) (A : Type) : Type  
     | v2 : ((fin n) → OpLoopOL2Term2) 
     | sing2 : (A → OpLoopOL2Term2) 
     | opOL2 : (OpLoopOL2Term2 → (OpLoopOL2Term2 → OpLoopOL2Term2)) 
     | eOL2 : OpLoopOL2Term2 
     | linvOL2 : (OpLoopOL2Term2 → (OpLoopOL2Term2 → OpLoopOL2Term2)) 
     | rinvOL2 : (OpLoopOL2Term2 → (OpLoopOL2Term2 → OpLoopOL2Term2))  
      open OpLoopOL2Term2 
  
  def simplifyCl   (A : Type)  : ((ClLoopClTerm A) → (ClLoopClTerm A)) 
  | (opCl eCl x) := x  
  | (opCl x eCl) := x  
  | (opCl x1 x2) := (opCl (simplifyCl x1) (simplifyCl x2))  
  | eCl := eCl  
  | (linvCl x1 x2) := (linvCl (simplifyCl x1) (simplifyCl x2))  
  | (rinvCl x1 x2) := (rinvCl (simplifyCl x1) (simplifyCl x2))  
  | (sing x1) := (sing x1)  
  def simplifyOpB   (n : ℕ)  : ((OpLoopOLTerm n) → (OpLoopOLTerm n)) 
  | (opOL eOL x) := x  
  | (opOL x eOL) := x  
  | (opOL x1 x2) := (opOL (simplifyOpB x1) (simplifyOpB x2))  
  | eOL := eOL  
  | (linvOL x1 x2) := (linvOL (simplifyOpB x1) (simplifyOpB x2))  
  | (rinvOL x1 x2) := (rinvOL (simplifyOpB x1) (simplifyOpB x2))  
  | (v x1) := (v x1)  
  def simplifyOp   (n : ℕ) (A : Type)  : ((OpLoopOL2Term2 n A) → (OpLoopOL2Term2 n A)) 
  | (opOL2 eOL2 x) := x  
  | (opOL2 x eOL2) := x  
  | (opOL2 x1 x2) := (opOL2 (simplifyOp x1) (simplifyOp x2))  
  | eOL2 := eOL2  
  | (linvOL2 x1 x2) := (linvOL2 (simplifyOp x1) (simplifyOp x2))  
  | (rinvOL2 x1 x2) := (rinvOL2 (simplifyOp x1) (simplifyOp x2))  
  | (v2 x1) := (v2 x1)  
  | (sing2 x1) := (sing2 x1)  
  def evalB   {A : Type}  : ((Loop A) → (LoopLTerm → A)) 
  | Lo (opL x1 x2) := ((op Lo) (evalB Lo x1) (evalB Lo x2))  
  | Lo eL := (e Lo)  
  | Lo (linvL x1 x2) := ((linv Lo) (evalB Lo x1) (evalB Lo x2))  
  | Lo (rinvL x1 x2) := ((rinv Lo) (evalB Lo x1) (evalB Lo x2))  
  def evalCl   {A : Type}  : ((Loop A) → ((ClLoopClTerm A) → A)) 
  | Lo (sing x1) := x1  
  | Lo (opCl x1 x2) := ((op Lo) (evalCl Lo x1) (evalCl Lo x2))  
  | Lo eCl := (e Lo)  
  | Lo (linvCl x1 x2) := ((linv Lo) (evalCl Lo x1) (evalCl Lo x2))  
  | Lo (rinvCl x1 x2) := ((rinv Lo) (evalCl Lo x1) (evalCl Lo x2))  
  def evalOpB   {A : Type} (n : ℕ)  : ((Loop A) → ((vector A n) → ((OpLoopOLTerm n) → A))) 
  | Lo vars (v x1) := (nth vars x1)  
  | Lo vars (opOL x1 x2) := ((op Lo) (evalOpB Lo vars x1) (evalOpB Lo vars x2))  
  | Lo vars eOL := (e Lo)  
  | Lo vars (linvOL x1 x2) := ((linv Lo) (evalOpB Lo vars x1) (evalOpB Lo vars x2))  
  | Lo vars (rinvOL x1 x2) := ((rinv Lo) (evalOpB Lo vars x1) (evalOpB Lo vars x2))  
  def evalOp   {A : Type} (n : ℕ)  : ((Loop A) → ((vector A n) → ((OpLoopOL2Term2 n A) → A))) 
  | Lo vars (v2 x1) := (nth vars x1)  
  | Lo vars (sing2 x1) := x1  
  | Lo vars (opOL2 x1 x2) := ((op Lo) (evalOp Lo vars x1) (evalOp Lo vars x2))  
  | Lo vars eOL2 := (e Lo)  
  | Lo vars (linvOL2 x1 x2) := ((linv Lo) (evalOp Lo vars x1) (evalOp Lo vars x2))  
  | Lo vars (rinvOL2 x1 x2) := ((rinv Lo) (evalOp Lo vars x1) (evalOp Lo vars x2))  
  def inductionB   (P : (LoopLTerm → Type))  : ((∀ (x1 x2 : LoopLTerm) , ((P x1) → ((P x2) → (P (opL x1 x2))))) → ((P eL) → ((∀ (x1 x2 : LoopLTerm) , ((P x1) → ((P x2) → (P (linvL x1 x2))))) → ((∀ (x1 x2 : LoopLTerm) , ((P x1) → ((P x2) → (P (rinvL x1 x2))))) → (∀ (x : LoopLTerm) , (P x)))))) 
  | popl pel plinvl prinvl (opL x1 x2) := (popl _ _ (inductionB popl pel plinvl prinvl x1) (inductionB popl pel plinvl prinvl x2))  
  | popl pel plinvl prinvl eL := pel  
  | popl pel plinvl prinvl (linvL x1 x2) := (plinvl _ _ (inductionB popl pel plinvl prinvl x1) (inductionB popl pel plinvl prinvl x2))  
  | popl pel plinvl prinvl (rinvL x1 x2) := (prinvl _ _ (inductionB popl pel plinvl prinvl x1) (inductionB popl pel plinvl prinvl x2))  
  def inductionCl   (A : Type) (P : ((ClLoopClTerm A) → Type))  : ((∀ (x1 : A) , (P (sing x1))) → ((∀ (x1 x2 : (ClLoopClTerm A)) , ((P x1) → ((P x2) → (P (opCl x1 x2))))) → ((P eCl) → ((∀ (x1 x2 : (ClLoopClTerm A)) , ((P x1) → ((P x2) → (P (linvCl x1 x2))))) → ((∀ (x1 x2 : (ClLoopClTerm A)) , ((P x1) → ((P x2) → (P (rinvCl x1 x2))))) → (∀ (x : (ClLoopClTerm A)) , (P x))))))) 
  | psing popcl pecl plinvcl prinvcl (sing x1) := (psing x1)  
  | psing popcl pecl plinvcl prinvcl (opCl x1 x2) := (popcl _ _ (inductionCl psing popcl pecl plinvcl prinvcl x1) (inductionCl psing popcl pecl plinvcl prinvcl x2))  
  | psing popcl pecl plinvcl prinvcl eCl := pecl  
  | psing popcl pecl plinvcl prinvcl (linvCl x1 x2) := (plinvcl _ _ (inductionCl psing popcl pecl plinvcl prinvcl x1) (inductionCl psing popcl pecl plinvcl prinvcl x2))  
  | psing popcl pecl plinvcl prinvcl (rinvCl x1 x2) := (prinvcl _ _ (inductionCl psing popcl pecl plinvcl prinvcl x1) (inductionCl psing popcl pecl plinvcl prinvcl x2))  
  def inductionOpB   (n : ℕ) (P : ((OpLoopOLTerm n) → Type))  : ((∀ (fin : (fin n)) , (P (v fin))) → ((∀ (x1 x2 : (OpLoopOLTerm n)) , ((P x1) → ((P x2) → (P (opOL x1 x2))))) → ((P eOL) → ((∀ (x1 x2 : (OpLoopOLTerm n)) , ((P x1) → ((P x2) → (P (linvOL x1 x2))))) → ((∀ (x1 x2 : (OpLoopOLTerm n)) , ((P x1) → ((P x2) → (P (rinvOL x1 x2))))) → (∀ (x : (OpLoopOLTerm n)) , (P x))))))) 
  | pv popol peol plinvol prinvol (v x1) := (pv x1)  
  | pv popol peol plinvol prinvol (opOL x1 x2) := (popol _ _ (inductionOpB pv popol peol plinvol prinvol x1) (inductionOpB pv popol peol plinvol prinvol x2))  
  | pv popol peol plinvol prinvol eOL := peol  
  | pv popol peol plinvol prinvol (linvOL x1 x2) := (plinvol _ _ (inductionOpB pv popol peol plinvol prinvol x1) (inductionOpB pv popol peol plinvol prinvol x2))  
  | pv popol peol plinvol prinvol (rinvOL x1 x2) := (prinvol _ _ (inductionOpB pv popol peol plinvol prinvol x1) (inductionOpB pv popol peol plinvol prinvol x2))  
  def inductionOp   (n : ℕ) (A : Type) (P : ((OpLoopOL2Term2 n A) → Type))  : ((∀ (fin : (fin n)) , (P (v2 fin))) → ((∀ (x1 : A) , (P (sing2 x1))) → ((∀ (x1 x2 : (OpLoopOL2Term2 n A)) , ((P x1) → ((P x2) → (P (opOL2 x1 x2))))) → ((P eOL2) → ((∀ (x1 x2 : (OpLoopOL2Term2 n A)) , ((P x1) → ((P x2) → (P (linvOL2 x1 x2))))) → ((∀ (x1 x2 : (OpLoopOL2Term2 n A)) , ((P x1) → ((P x2) → (P (rinvOL2 x1 x2))))) → (∀ (x : (OpLoopOL2Term2 n A)) , (P x)))))))) 
  | pv2 psing2 popol2 peol2 plinvol2 prinvol2 (v2 x1) := (pv2 x1)  
  | pv2 psing2 popol2 peol2 plinvol2 prinvol2 (sing2 x1) := (psing2 x1)  
  | pv2 psing2 popol2 peol2 plinvol2 prinvol2 (opOL2 x1 x2) := (popol2 _ _ (inductionOp pv2 psing2 popol2 peol2 plinvol2 prinvol2 x1) (inductionOp pv2 psing2 popol2 peol2 plinvol2 prinvol2 x2))  
  | pv2 psing2 popol2 peol2 plinvol2 prinvol2 eOL2 := peol2  
  | pv2 psing2 popol2 peol2 plinvol2 prinvol2 (linvOL2 x1 x2) := (plinvol2 _ _ (inductionOp pv2 psing2 popol2 peol2 plinvol2 prinvol2 x1) (inductionOp pv2 psing2 popol2 peol2 plinvol2 prinvol2 x2))  
  | pv2 psing2 popol2 peol2 plinvol2 prinvol2 (rinvOL2 x1 x2) := (prinvol2 _ _ (inductionOp pv2 psing2 popol2 peol2 plinvol2 prinvol2 x1) (inductionOp pv2 psing2 popol2 peol2 plinvol2 prinvol2 x2))  
  def stageB  : (LoopLTerm → (Staged LoopLTerm))
  | (opL x1 x2) := (stage2 opL (codeLift2 opL) (stageB x1) (stageB x2))  
  | eL := (Now eL)  
  | (linvL x1 x2) := (stage2 linvL (codeLift2 linvL) (stageB x1) (stageB x2))  
  | (rinvL x1 x2) := (stage2 rinvL (codeLift2 rinvL) (stageB x1) (stageB x2))  
  def stageCl   (A : Type)  : ((ClLoopClTerm A) → (Staged (ClLoopClTerm A))) 
  | (sing x1) := (Now (sing x1))  
  | (opCl x1 x2) := (stage2 opCl (codeLift2 opCl) (stageCl x1) (stageCl x2))  
  | eCl := (Now eCl)  
  | (linvCl x1 x2) := (stage2 linvCl (codeLift2 linvCl) (stageCl x1) (stageCl x2))  
  | (rinvCl x1 x2) := (stage2 rinvCl (codeLift2 rinvCl) (stageCl x1) (stageCl x2))  
  def stageOpB   (n : ℕ)  : ((OpLoopOLTerm n) → (Staged (OpLoopOLTerm n))) 
  | (v x1) := (const (code (v x1)))  
  | (opOL x1 x2) := (stage2 opOL (codeLift2 opOL) (stageOpB x1) (stageOpB x2))  
  | eOL := (Now eOL)  
  | (linvOL x1 x2) := (stage2 linvOL (codeLift2 linvOL) (stageOpB x1) (stageOpB x2))  
  | (rinvOL x1 x2) := (stage2 rinvOL (codeLift2 rinvOL) (stageOpB x1) (stageOpB x2))  
  def stageOp   (n : ℕ) (A : Type)  : ((OpLoopOL2Term2 n A) → (Staged (OpLoopOL2Term2 n A))) 
  | (sing2 x1) := (Now (sing2 x1))  
  | (v2 x1) := (const (code (v2 x1)))  
  | (opOL2 x1 x2) := (stage2 opOL2 (codeLift2 opOL2) (stageOp x1) (stageOp x2))  
  | eOL2 := (Now eOL2)  
  | (linvOL2 x1 x2) := (stage2 linvOL2 (codeLift2 linvOL2) (stageOp x1) (stageOp x2))  
  | (rinvOL2 x1 x2) := (stage2 rinvOL2 (codeLift2 rinvOL2) (stageOp x1) (stageOp x2))  
  structure StagedRepr  (A : Type) (Repr : (Type → Type)) : Type := 
       (opT : ((Repr A) → ((Repr A) → (Repr A))))
       (eT : (Repr A))
       (linvT : ((Repr A) → ((Repr A) → (Repr A))))
       (rinvT : ((Repr A) → ((Repr A) → (Repr A)))) 
  
end Loop