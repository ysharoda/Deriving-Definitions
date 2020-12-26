
module DualDeMorgan   where
  open import Prelude
  open import Agda.Builtin.Equality
  open import Agda.Builtin.Nat
  open import Data.Fin
  open import Data.Vec
  record IsDualDeMorgan  (A : Set) (* : (A → (A → A))) (+ : (A → (A → A))) (prim : (A → A)) : Set where 
     field  
      andDeMorgan_*_+_prim : ( {x y z : A} → (prim (* x y)) ≡ (+ (prim x) (prim y))) 
      orDeMorgan_+_*_prim : ( {x y z : A} → (prim (+ x y)) ≡ (* (prim x) (prim y)))  
  
  record DualDeMorgan  (A : Set) : Set where 
     field  
      * : (A → (A → A)) 
      + : (A → (A → A)) 
      prim : (A → A) 
      isDualDeMorgan : (IsDualDeMorgan A (*) (+) prim)  
  
  open DualDeMorgan
  record Sig  (AS : Set) : Set where 
     field  
      *S : (AS → (AS → AS)) 
      +S : (AS → (AS → AS)) 
      primS : (AS → AS)  
  
  record Product  (A : Set) : Set where 
     field  
      *P : ((Prod A A) → ((Prod A A) → (Prod A A))) 
      +P : ((Prod A A) → ((Prod A A) → (Prod A A))) 
      primP : ((Prod A A) → (Prod A A)) 
      andDeMorgan_*_+_primP : ( {xP yP zP : (Prod A A)} → (primP (*P xP yP)) ≡ (+P (primP xP) (primP yP))) 
      orDeMorgan_+_*_primP : ( {xP yP zP : (Prod A A)} → (primP (+P xP yP)) ≡ (*P (primP xP) (primP yP)))  
  
  record Hom  {A1 : Set} {A2 : Set} (Du1 : (DualDeMorgan A1)) (Du2 : (DualDeMorgan A2)) : Set where 
     field  
      hom : (A1 → A2) 
      pres-* : ( {x1 x2 : A1} → (hom ((* Du1) x1 x2)) ≡ ((* Du2) (hom x1) (hom x2))) 
      pres-+ : ( {x1 x2 : A1} → (hom ((+ Du1) x1 x2)) ≡ ((+ Du2) (hom x1) (hom x2))) 
      pres-prim : ( {x1 : A1} → (hom ((prim Du1) x1)) ≡ ((prim Du2) (hom x1)))  
  
  record RelInterp  {A1 : Set} {A2 : Set} (Du1 : (DualDeMorgan A1)) (Du2 : (DualDeMorgan A2)) : Set₁ where 
     field  
      interp : (A1 → (A2 → Set)) 
      interp-* : ( {x1 x2 : A1} {y1 y2 : A2} → ((interp x1 y1) → ((interp x2 y2) → (interp ((* Du1) x1 x2) ((* Du2) y1 y2))))) 
      interp-+ : ( {x1 x2 : A1} {y1 y2 : A2} → ((interp x1 y1) → ((interp x2 y2) → (interp ((+ Du1) x1 x2) ((+ Du2) y1 y2))))) 
      interp-prim : ( {x1 : A1} {y1 : A2} → ((interp x1 y1) → (interp ((prim Du1) x1) ((prim Du2) y1))))  
  
  data DualDeMorganTerm   : Set where 
      *L : (DualDeMorganTerm → (DualDeMorganTerm → DualDeMorganTerm)) 
      +L : (DualDeMorganTerm → (DualDeMorganTerm → DualDeMorganTerm)) 
      primL : (DualDeMorganTerm → DualDeMorganTerm)  
      
  data ClDualDeMorganTerm  (A : Set) : Set where 
      sing : (A → (ClDualDeMorganTerm A)) 
      *Cl : ((ClDualDeMorganTerm A) → ((ClDualDeMorganTerm A) → (ClDualDeMorganTerm A))) 
      +Cl : ((ClDualDeMorganTerm A) → ((ClDualDeMorganTerm A) → (ClDualDeMorganTerm A))) 
      primCl : ((ClDualDeMorganTerm A) → (ClDualDeMorganTerm A))  
      
  data OpDualDeMorganTerm  (n : Nat) : Set where 
      v : ((Fin n) → (OpDualDeMorganTerm n)) 
      *OL : ((OpDualDeMorganTerm n) → ((OpDualDeMorganTerm n) → (OpDualDeMorganTerm n))) 
      +OL : ((OpDualDeMorganTerm n) → ((OpDualDeMorganTerm n) → (OpDualDeMorganTerm n))) 
      primOL : ((OpDualDeMorganTerm n) → (OpDualDeMorganTerm n))  
      
  data OpDualDeMorganTerm2  (n : Nat) (A : Set) : Set where 
      v2 : ((Fin n) → (OpDualDeMorganTerm2 n A)) 
      sing2 : (A → (OpDualDeMorganTerm2 n A)) 
      *OL2 : ((OpDualDeMorganTerm2 n A) → ((OpDualDeMorganTerm2 n A) → (OpDualDeMorganTerm2 n A))) 
      +OL2 : ((OpDualDeMorganTerm2 n A) → ((OpDualDeMorganTerm2 n A) → (OpDualDeMorganTerm2 n A))) 
      primOL2 : ((OpDualDeMorganTerm2 n A) → (OpDualDeMorganTerm2 n A))  
      
  simplifyCl :  (A : Set) →  ((ClDualDeMorganTerm A) → (ClDualDeMorganTerm A)) 
  simplifyCl _ (*Cl x1 x2) = (*Cl (simplifyCl _ x1) (simplifyCl _ x2))  
  simplifyCl _ (+Cl x1 x2) = (+Cl (simplifyCl _ x1) (simplifyCl _ x2))  
  simplifyCl _ (primCl x1) = (primCl (simplifyCl _ x1))  
  simplifyCl _ (sing x1) = (sing x1)  
  simplifyOpB :  (n : Nat) →  ((OpDualDeMorganTerm n) → (OpDualDeMorganTerm n)) 
  simplifyOpB _ (*OL x1 x2) = (*OL (simplifyOpB _ x1) (simplifyOpB _ x2))  
  simplifyOpB _ (+OL x1 x2) = (+OL (simplifyOpB _ x1) (simplifyOpB _ x2))  
  simplifyOpB _ (primOL x1) = (primOL (simplifyOpB _ x1))  
  simplifyOpB _ (v x1) = (v x1)  
  simplifyOp :  (n : Nat) (A : Set) →  ((OpDualDeMorganTerm2 n A) → (OpDualDeMorganTerm2 n A)) 
  simplifyOp _ _ (*OL2 x1 x2) = (*OL2 (simplifyOp _ _ x1) (simplifyOp _ _ x2))  
  simplifyOp _ _ (+OL2 x1 x2) = (+OL2 (simplifyOp _ _ x1) (simplifyOp _ _ x2))  
  simplifyOp _ _ (primOL2 x1) = (primOL2 (simplifyOp _ _ x1))  
  simplifyOp _ _ (v2 x1) = (v2 x1)  
  simplifyOp _ _ (sing2 x1) = (sing2 x1)  
  evalB :  {A : Set} →  ((DualDeMorgan A) → (DualDeMorganTerm → A)) 
  evalB Du (*L x1 x2) = ((* Du) (evalB Du x1) (evalB Du x2))  
  evalB Du (+L x1 x2) = ((+ Du) (evalB Du x1) (evalB Du x2))  
  evalB Du (primL x1) = ((prim Du) (evalB Du x1))  
  evalCl :  {A : Set} →  ((DualDeMorgan A) → ((ClDualDeMorganTerm A) → A)) 
  evalCl Du (sing x1) = x1  
  evalCl Du (*Cl x1 x2) = ((* Du) (evalCl Du x1) (evalCl Du x2))  
  evalCl Du (+Cl x1 x2) = ((+ Du) (evalCl Du x1) (evalCl Du x2))  
  evalCl Du (primCl x1) = ((prim Du) (evalCl Du x1))  
  evalOpB :  {A : Set} (n : Nat) →  ((DualDeMorgan A) → ((Vec A n) → ((OpDualDeMorganTerm n) → A))) 
  evalOpB n Du vars (v x1) = (lookup vars x1)  
  evalOpB n Du vars (*OL x1 x2) = ((* Du) (evalOpB n Du vars x1) (evalOpB n Du vars x2))  
  evalOpB n Du vars (+OL x1 x2) = ((+ Du) (evalOpB n Du vars x1) (evalOpB n Du vars x2))  
  evalOpB n Du vars (primOL x1) = ((prim Du) (evalOpB n Du vars x1))  
  evalOp :  {A : Set} (n : Nat) →  ((DualDeMorgan A) → ((Vec A n) → ((OpDualDeMorganTerm2 n A) → A))) 
  evalOp n Du vars (v2 x1) = (lookup vars x1)  
  evalOp n Du vars (sing2 x1) = x1  
  evalOp n Du vars (*OL2 x1 x2) = ((* Du) (evalOp n Du vars x1) (evalOp n Du vars x2))  
  evalOp n Du vars (+OL2 x1 x2) = ((+ Du) (evalOp n Du vars x1) (evalOp n Du vars x2))  
  evalOp n Du vars (primOL2 x1) = ((prim Du) (evalOp n Du vars x1))  
  inductionB :  (P : (DualDeMorganTerm → Set)) →  (( (x1 x2 : DualDeMorganTerm) → ((P x1) → ((P x2) → (P (*L x1 x2))))) → (( (x1 x2 : DualDeMorganTerm) → ((P x1) → ((P x2) → (P (+L x1 x2))))) → (( (x1 : DualDeMorganTerm) → ((P x1) → (P (primL x1)))) → ( (x : DualDeMorganTerm) → (P x))))) 
  inductionB p p*l p+l ppriml (*L x1 x2) = (p*l _ _ (inductionB p p*l p+l ppriml x1) (inductionB p p*l p+l ppriml x2))  
  inductionB p p*l p+l ppriml (+L x1 x2) = (p+l _ _ (inductionB p p*l p+l ppriml x1) (inductionB p p*l p+l ppriml x2))  
  inductionB p p*l p+l ppriml (primL x1) = (ppriml _ (inductionB p p*l p+l ppriml x1))  
  inductionCl :  (A : Set) (P : ((ClDualDeMorganTerm A) → Set)) →  (( (x1 : A) → (P (sing x1))) → (( (x1 x2 : (ClDualDeMorganTerm A)) → ((P x1) → ((P x2) → (P (*Cl x1 x2))))) → (( (x1 x2 : (ClDualDeMorganTerm A)) → ((P x1) → ((P x2) → (P (+Cl x1 x2))))) → (( (x1 : (ClDualDeMorganTerm A)) → ((P x1) → (P (primCl x1)))) → ( (x : (ClDualDeMorganTerm A)) → (P x)))))) 
  inductionCl _ p psing p*cl p+cl pprimcl (sing x1) = (psing x1)  
  inductionCl _ p psing p*cl p+cl pprimcl (*Cl x1 x2) = (p*cl _ _ (inductionCl _ p psing p*cl p+cl pprimcl x1) (inductionCl _ p psing p*cl p+cl pprimcl x2))  
  inductionCl _ p psing p*cl p+cl pprimcl (+Cl x1 x2) = (p+cl _ _ (inductionCl _ p psing p*cl p+cl pprimcl x1) (inductionCl _ p psing p*cl p+cl pprimcl x2))  
  inductionCl _ p psing p*cl p+cl pprimcl (primCl x1) = (pprimcl _ (inductionCl _ p psing p*cl p+cl pprimcl x1))  
  inductionOpB :  (n : Nat) (P : ((OpDualDeMorganTerm n) → Set)) →  (( (fin : (Fin n)) → (P (v fin))) → (( (x1 x2 : (OpDualDeMorganTerm n)) → ((P x1) → ((P x2) → (P (*OL x1 x2))))) → (( (x1 x2 : (OpDualDeMorganTerm n)) → ((P x1) → ((P x2) → (P (+OL x1 x2))))) → (( (x1 : (OpDualDeMorganTerm n)) → ((P x1) → (P (primOL x1)))) → ( (x : (OpDualDeMorganTerm n)) → (P x)))))) 
  inductionOpB _ p pv p*ol p+ol pprimol (v x1) = (pv x1)  
  inductionOpB _ p pv p*ol p+ol pprimol (*OL x1 x2) = (p*ol _ _ (inductionOpB _ p pv p*ol p+ol pprimol x1) (inductionOpB _ p pv p*ol p+ol pprimol x2))  
  inductionOpB _ p pv p*ol p+ol pprimol (+OL x1 x2) = (p+ol _ _ (inductionOpB _ p pv p*ol p+ol pprimol x1) (inductionOpB _ p pv p*ol p+ol pprimol x2))  
  inductionOpB _ p pv p*ol p+ol pprimol (primOL x1) = (pprimol _ (inductionOpB _ p pv p*ol p+ol pprimol x1))  
  inductionOp :  (n : Nat) (A : Set) (P : ((OpDualDeMorganTerm2 n A) → Set)) →  (( (fin : (Fin n)) → (P (v2 fin))) → (( (x1 : A) → (P (sing2 x1))) → (( (x1 x2 : (OpDualDeMorganTerm2 n A)) → ((P x1) → ((P x2) → (P (*OL2 x1 x2))))) → (( (x1 x2 : (OpDualDeMorganTerm2 n A)) → ((P x1) → ((P x2) → (P (+OL2 x1 x2))))) → (( (x1 : (OpDualDeMorganTerm2 n A)) → ((P x1) → (P (primOL2 x1)))) → ( (x : (OpDualDeMorganTerm2 n A)) → (P x))))))) 
  inductionOp _ _ p pv2 psing2 p*ol2 p+ol2 pprimol2 (v2 x1) = (pv2 x1)  
  inductionOp _ _ p pv2 psing2 p*ol2 p+ol2 pprimol2 (sing2 x1) = (psing2 x1)  
  inductionOp _ _ p pv2 psing2 p*ol2 p+ol2 pprimol2 (*OL2 x1 x2) = (p*ol2 _ _ (inductionOp _ _ p pv2 psing2 p*ol2 p+ol2 pprimol2 x1) (inductionOp _ _ p pv2 psing2 p*ol2 p+ol2 pprimol2 x2))  
  inductionOp _ _ p pv2 psing2 p*ol2 p+ol2 pprimol2 (+OL2 x1 x2) = (p+ol2 _ _ (inductionOp _ _ p pv2 psing2 p*ol2 p+ol2 pprimol2 x1) (inductionOp _ _ p pv2 psing2 p*ol2 p+ol2 pprimol2 x2))  
  inductionOp _ _ p pv2 psing2 p*ol2 p+ol2 pprimol2 (primOL2 x1) = (pprimol2 _ (inductionOp _ _ p pv2 psing2 p*ol2 p+ol2 pprimol2 x1))  
  stageB :  (DualDeMorganTerm → (Staged DualDeMorganTerm))
  stageB (*L x1 x2) = (stage2 *L (codeLift2 *L) (stageB x1) (stageB x2))  
  stageB (+L x1 x2) = (stage2 +L (codeLift2 +L) (stageB x1) (stageB x2))  
  stageB (primL x1) = (stage1 primL (codeLift1 primL) (stageB x1))  
  stageCl :  (A : Set) →  ((ClDualDeMorganTerm A) → (Staged (ClDualDeMorganTerm A))) 
  stageCl _ (sing x1) = (Now (sing x1))  
  stageCl _ (*Cl x1 x2) = (stage2 *Cl (codeLift2 *Cl) (stageCl _ x1) (stageCl _ x2))  
  stageCl _ (+Cl x1 x2) = (stage2 +Cl (codeLift2 +Cl) (stageCl _ x1) (stageCl _ x2))  
  stageCl _ (primCl x1) = (stage1 primCl (codeLift1 primCl) (stageCl _ x1))  
  stageOpB :  (n : Nat) →  ((OpDualDeMorganTerm n) → (Staged (OpDualDeMorganTerm n))) 
  stageOpB _ (v x1) = (const (code (v x1)))  
  stageOpB _ (*OL x1 x2) = (stage2 *OL (codeLift2 *OL) (stageOpB _ x1) (stageOpB _ x2))  
  stageOpB _ (+OL x1 x2) = (stage2 +OL (codeLift2 +OL) (stageOpB _ x1) (stageOpB _ x2))  
  stageOpB _ (primOL x1) = (stage1 primOL (codeLift1 primOL) (stageOpB _ x1))  
  stageOp :  (n : Nat) (A : Set) →  ((OpDualDeMorganTerm2 n A) → (Staged (OpDualDeMorganTerm2 n A))) 
  stageOp _ _ (sing2 x1) = (Now (sing2 x1))  
  stageOp _ _ (v2 x1) = (const (code (v2 x1)))  
  stageOp _ _ (*OL2 x1 x2) = (stage2 *OL2 (codeLift2 *OL2) (stageOp _ _ x1) (stageOp _ _ x2))  
  stageOp _ _ (+OL2 x1 x2) = (stage2 +OL2 (codeLift2 +OL2) (stageOp _ _ x1) (stageOp _ _ x2))  
  stageOp _ _ (primOL2 x1) = (stage1 primOL2 (codeLift1 primOL2) (stageOp _ _ x1))  
  record StagedRepr  (A : Set) (Repr : (Set → Set)) : Set where 
     field  
      *T : ((Repr A) → ((Repr A) → (Repr A))) 
      +T : ((Repr A) → ((Repr A) → (Repr A))) 
      primT : ((Repr A) → (Repr A))  
  
 