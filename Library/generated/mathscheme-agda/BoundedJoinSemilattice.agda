
module BoundedJoinSemilattice   where
  open import Prelude
  open import Agda.Builtin.Equality
  open import Agda.Builtin.Nat
  open import Data.Fin
  open import Data.Vec
  record BoundedJoinSemilattice  (A : Set) : Set where 
     field  
      + : (A → (A → A)) 
      commutative_+ : ( {x y : A} → (+ x y) ≡ (+ y x)) 
      associative_+ : ( {x y z : A} → (+ (+ x y) z) ≡ (+ x (+ y z))) 
      0ᵢ : A 
      lunit_0ᵢ : ( {x : A} → (+ 0ᵢ x) ≡ x) 
      runit_0ᵢ : ( {x : A} → (+ x 0ᵢ) ≡ x) 
      idempotent_+ : ( {x : A} → (+ x x) ≡ x)  
  
  open BoundedJoinSemilattice
  record Sig  (AS : Set) : Set where 
     field  
      +S : (AS → (AS → AS)) 
      0S : AS  
  
  record Product  (A : Set) : Set where 
     field  
      +P : ((Prod A A) → ((Prod A A) → (Prod A A))) 
      0P : (Prod A A) 
      commutative_+P : ( {xP yP : (Prod A A)} → (+P xP yP) ≡ (+P yP xP)) 
      associative_+P : ( {xP yP zP : (Prod A A)} → (+P (+P xP yP) zP) ≡ (+P xP (+P yP zP))) 
      lunit_0P : ( {xP : (Prod A A)} → (+P 0P xP) ≡ xP) 
      runit_0P : ( {xP : (Prod A A)} → (+P xP 0P) ≡ xP) 
      idempotent_+P : ( {xP : (Prod A A)} → (+P xP xP) ≡ xP)  
  
  record Hom  {A1 : Set} {A2 : Set} (Bo1 : (BoundedJoinSemilattice A1)) (Bo2 : (BoundedJoinSemilattice A2)) : Set where 
     field  
      hom : (A1 → A2) 
      pres-+ : ( {x1 x2 : A1} → (hom ((+ Bo1) x1 x2)) ≡ ((+ Bo2) (hom x1) (hom x2))) 
      pres-0 : (hom (0ᵢ Bo1)) ≡ (0ᵢ Bo2)  
  
  record RelInterp  {A1 : Set} {A2 : Set} (Bo1 : (BoundedJoinSemilattice A1)) (Bo2 : (BoundedJoinSemilattice A2)) : Set₁ where 
     field  
      interp : (A1 → (A2 → Set)) 
      interp-+ : ( {x1 x2 : A1} {y1 y2 : A2} → ((interp x1 y1) → ((interp x2 y2) → (interp ((+ Bo1) x1 x2) ((+ Bo2) y1 y2))))) 
      interp-0 : (interp (0ᵢ Bo1) (0ᵢ Bo2))  
  
  data BoundedJoinSemilatticeTerm   : Set where 
      +L : (BoundedJoinSemilatticeTerm → (BoundedJoinSemilatticeTerm → BoundedJoinSemilatticeTerm)) 
      0L : BoundedJoinSemilatticeTerm  
      
  data ClBoundedJoinSemilatticeTerm  (A : Set) : Set where 
      sing : (A → (ClBoundedJoinSemilatticeTerm A)) 
      +Cl : ((ClBoundedJoinSemilatticeTerm A) → ((ClBoundedJoinSemilatticeTerm A) → (ClBoundedJoinSemilatticeTerm A))) 
      0Cl : (ClBoundedJoinSemilatticeTerm A)  
      
  data OpBoundedJoinSemilatticeTerm  (n : Nat) : Set where 
      v : ((Fin n) → (OpBoundedJoinSemilatticeTerm n)) 
      +OL : ((OpBoundedJoinSemilatticeTerm n) → ((OpBoundedJoinSemilatticeTerm n) → (OpBoundedJoinSemilatticeTerm n))) 
      0OL : (OpBoundedJoinSemilatticeTerm n)  
      
  data OpBoundedJoinSemilatticeTerm2  (n : Nat) (A : Set) : Set where 
      v2 : ((Fin n) → (OpBoundedJoinSemilatticeTerm2 n A)) 
      sing2 : (A → (OpBoundedJoinSemilatticeTerm2 n A)) 
      +OL2 : ((OpBoundedJoinSemilatticeTerm2 n A) → ((OpBoundedJoinSemilatticeTerm2 n A) → (OpBoundedJoinSemilatticeTerm2 n A))) 
      0OL2 : (OpBoundedJoinSemilatticeTerm2 n A)  
      
  simplifyCl :  {A : Set} →  ((ClBoundedJoinSemilatticeTerm A) → (ClBoundedJoinSemilatticeTerm A)) 
  simplifyCl (+Cl 0Cl x) = x  
  simplifyCl (+Cl x 0Cl) = x  
  simplifyCl (+Cl x1 x2) = (+Cl (simplifyCl x1) (simplifyCl x2))  
  simplifyCl 0Cl = 0Cl  
  simplifyCl (sing x1) = (sing x1)  
  simplifyOpB :  {n : Nat} →  ((OpBoundedJoinSemilatticeTerm n) → (OpBoundedJoinSemilatticeTerm n)) 
  simplifyOpB (+OL 0OL x) = x  
  simplifyOpB (+OL x 0OL) = x  
  simplifyOpB (+OL x1 x2) = (+OL (simplifyOpB x1) (simplifyOpB x2))  
  simplifyOpB 0OL = 0OL  
  simplifyOpB (v x1) = (v x1)  
  simplifyOp :  {n : Nat} {A : Set} →  ((OpBoundedJoinSemilatticeTerm2 n A) → (OpBoundedJoinSemilatticeTerm2 n A)) 
  simplifyOp (+OL2 0OL2 x) = x  
  simplifyOp (+OL2 x 0OL2) = x  
  simplifyOp (+OL2 x1 x2) = (+OL2 (simplifyOp x1) (simplifyOp x2))  
  simplifyOp 0OL2 = 0OL2  
  simplifyOp (v2 x1) = (v2 x1)  
  simplifyOp (sing2 x1) = (sing2 x1)  
  evalB :  {A : Set} →  ((BoundedJoinSemilattice A) → (BoundedJoinSemilatticeTerm → A)) 
  evalB Bo (+L x1 x2) = ((+ Bo) (evalB Bo x1) (evalB Bo x2))  
  evalB Bo 0L = (0ᵢ Bo)  
  evalCl :  {A : Set} →  ((BoundedJoinSemilattice A) → ((ClBoundedJoinSemilatticeTerm A) → A)) 
  evalCl Bo (sing x1) = x1  
  evalCl Bo (+Cl x1 x2) = ((+ Bo) (evalCl Bo x1) (evalCl Bo x2))  
  evalCl Bo 0Cl = (0ᵢ Bo)  
  evalOpB :  {A : Set} {n : Nat} →  ((BoundedJoinSemilattice A) → ((Vec A n) → ((OpBoundedJoinSemilatticeTerm n) → A))) 
  evalOpB Bo vars (v x1) = (lookup vars x1)  
  evalOpB Bo vars (+OL x1 x2) = ((+ Bo) (evalOpB Bo vars x1) (evalOpB Bo vars x2))  
  evalOpB Bo vars 0OL = (0ᵢ Bo)  
  evalOp :  {A : Set} {n : Nat} →  ((BoundedJoinSemilattice A) → ((Vec A n) → ((OpBoundedJoinSemilatticeTerm2 n A) → A))) 
  evalOp Bo vars (v2 x1) = (lookup vars x1)  
  evalOp Bo vars (sing2 x1) = x1  
  evalOp Bo vars (+OL2 x1 x2) = ((+ Bo) (evalOp Bo vars x1) (evalOp Bo vars x2))  
  evalOp Bo vars 0OL2 = (0ᵢ Bo)  
  inductionB :  {P : (BoundedJoinSemilatticeTerm → Set)} →  (( (x1 x2 : BoundedJoinSemilatticeTerm) → ((P x1) → ((P x2) → (P (+L x1 x2))))) → ((P 0L) → ( (x : BoundedJoinSemilatticeTerm) → (P x)))) 
  inductionB p+l p0l (+L x1 x2) = (p+l _ _ (inductionB p+l p0l x1) (inductionB p+l p0l x2))  
  inductionB p+l p0l 0L = p0l  
  inductionCl :  {A : Set} {P : ((ClBoundedJoinSemilatticeTerm A) → Set)} →  (( (x1 : A) → (P (sing x1))) → (( (x1 x2 : (ClBoundedJoinSemilatticeTerm A)) → ((P x1) → ((P x2) → (P (+Cl x1 x2))))) → ((P 0Cl) → ( (x : (ClBoundedJoinSemilatticeTerm A)) → (P x))))) 
  inductionCl psing p+cl p0cl (sing x1) = (psing x1)  
  inductionCl psing p+cl p0cl (+Cl x1 x2) = (p+cl _ _ (inductionCl psing p+cl p0cl x1) (inductionCl psing p+cl p0cl x2))  
  inductionCl psing p+cl p0cl 0Cl = p0cl  
  inductionOpB :  {n : Nat} {P : ((OpBoundedJoinSemilatticeTerm n) → Set)} →  (( (fin : (Fin n)) → (P (v fin))) → (( (x1 x2 : (OpBoundedJoinSemilatticeTerm n)) → ((P x1) → ((P x2) → (P (+OL x1 x2))))) → ((P 0OL) → ( (x : (OpBoundedJoinSemilatticeTerm n)) → (P x))))) 
  inductionOpB pv p+ol p0ol (v x1) = (pv x1)  
  inductionOpB pv p+ol p0ol (+OL x1 x2) = (p+ol _ _ (inductionOpB pv p+ol p0ol x1) (inductionOpB pv p+ol p0ol x2))  
  inductionOpB pv p+ol p0ol 0OL = p0ol  
  inductionOp :  {n : Nat} {A : Set} {P : ((OpBoundedJoinSemilatticeTerm2 n A) → Set)} →  (( (fin : (Fin n)) → (P (v2 fin))) → (( (x1 : A) → (P (sing2 x1))) → (( (x1 x2 : (OpBoundedJoinSemilatticeTerm2 n A)) → ((P x1) → ((P x2) → (P (+OL2 x1 x2))))) → ((P 0OL2) → ( (x : (OpBoundedJoinSemilatticeTerm2 n A)) → (P x)))))) 
  inductionOp pv2 psing2 p+ol2 p0ol2 (v2 x1) = (pv2 x1)  
  inductionOp pv2 psing2 p+ol2 p0ol2 (sing2 x1) = (psing2 x1)  
  inductionOp pv2 psing2 p+ol2 p0ol2 (+OL2 x1 x2) = (p+ol2 _ _ (inductionOp pv2 psing2 p+ol2 p0ol2 x1) (inductionOp pv2 psing2 p+ol2 p0ol2 x2))  
  inductionOp pv2 psing2 p+ol2 p0ol2 0OL2 = p0ol2  
  stageB :  (BoundedJoinSemilatticeTerm → (Staged BoundedJoinSemilatticeTerm))
  stageB (+L x1 x2) = (stage2 +L (codeLift2 +L) (stageB x1) (stageB x2))  
  stageB 0L = (Now 0L)  
  stageCl :  {A : Set} →  ((ClBoundedJoinSemilatticeTerm A) → (Staged (ClBoundedJoinSemilatticeTerm A))) 
  stageCl (sing x1) = (Now (sing x1))  
  stageCl (+Cl x1 x2) = (stage2 +Cl (codeLift2 +Cl) (stageCl x1) (stageCl x2))  
  stageCl 0Cl = (Now 0Cl)  
  stageOpB :  {n : Nat} →  ((OpBoundedJoinSemilatticeTerm n) → (Staged (OpBoundedJoinSemilatticeTerm n))) 
  stageOpB (v x1) = (const (code (v x1)))  
  stageOpB (+OL x1 x2) = (stage2 +OL (codeLift2 +OL) (stageOpB x1) (stageOpB x2))  
  stageOpB 0OL = (Now 0OL)  
  stageOp :  {n : Nat} {A : Set} →  ((OpBoundedJoinSemilatticeTerm2 n A) → (Staged (OpBoundedJoinSemilatticeTerm2 n A))) 
  stageOp (sing2 x1) = (Now (sing2 x1))  
  stageOp (v2 x1) = (const (code (v2 x1)))  
  stageOp (+OL2 x1 x2) = (stage2 +OL2 (codeLift2 +OL2) (stageOp x1) (stageOp x2))  
  stageOp 0OL2 = (Now 0OL2)  
  record StagedRepr  (A : Set) (Repr : (Set → Set)) : Set where 
     field  
      +T : ((Repr A) → ((Repr A) → (Repr A))) 
      0T : (Repr A)  
  
 