
module LeftPreSemiring   where
  open import Prelude
  open import Agda.Builtin.Equality
  open import Agda.Builtin.Nat
  open import Data.Fin
  open import Data.Vec
  record LeftPreSemiring  (A : Set) : Set where 
     field  
      * : (A → (A → A)) 
      + : (A → (A → A)) 
      associative_* : ( {x y z : A} → (* (* x y) z) ≡ (* x (* y z))) 
      leftDistributive_*_+ : ( {x y z : A} → (* x (+ y z)) ≡ (+ (* x y) (* x z))) 
      commutative_+ : ( {x y : A} → (+ x y) ≡ (+ y x)) 
      associative_+ : ( {x y z : A} → (+ (+ x y) z) ≡ (+ x (+ y z)))  
  
  open LeftPreSemiring
  record Sig  (AS : Set) : Set where 
     field  
      *S : (AS → (AS → AS)) 
      +S : (AS → (AS → AS))  
  
  record Product  (A : Set) : Set where 
     field  
      *P : ((Prod A A) → ((Prod A A) → (Prod A A))) 
      +P : ((Prod A A) → ((Prod A A) → (Prod A A))) 
      associative_*P : ( {xP yP zP : (Prod A A)} → (*P (*P xP yP) zP) ≡ (*P xP (*P yP zP))) 
      leftDistributive_*_+P : ( {xP yP zP : (Prod A A)} → (*P xP (+P yP zP)) ≡ (+P (*P xP yP) (*P xP zP))) 
      commutative_+P : ( {xP yP : (Prod A A)} → (+P xP yP) ≡ (+P yP xP)) 
      associative_+P : ( {xP yP zP : (Prod A A)} → (+P (+P xP yP) zP) ≡ (+P xP (+P yP zP)))  
  
  record Hom  {A1 : Set} {A2 : Set} (Le1 : (LeftPreSemiring A1)) (Le2 : (LeftPreSemiring A2)) : Set where 
     field  
      hom : (A1 → A2) 
      pres-* : ( {x1 x2 : A1} → (hom ((* Le1) x1 x2)) ≡ ((* Le2) (hom x1) (hom x2))) 
      pres-+ : ( {x1 x2 : A1} → (hom ((+ Le1) x1 x2)) ≡ ((+ Le2) (hom x1) (hom x2)))  
  
  record RelInterp  {A1 : Set} {A2 : Set} (Le1 : (LeftPreSemiring A1)) (Le2 : (LeftPreSemiring A2)) : Set₁ where 
     field  
      interp : (A1 → (A2 → Set)) 
      interp-* : ( {x1 x2 : A1} {y1 y2 : A2} → ((interp x1 y1) → ((interp x2 y2) → (interp ((* Le1) x1 x2) ((* Le2) y1 y2))))) 
      interp-+ : ( {x1 x2 : A1} {y1 y2 : A2} → ((interp x1 y1) → ((interp x2 y2) → (interp ((+ Le1) x1 x2) ((+ Le2) y1 y2)))))  
  
  data LeftPreSemiringTerm   : Set where 
      *L : (LeftPreSemiringTerm → (LeftPreSemiringTerm → LeftPreSemiringTerm)) 
      +L : (LeftPreSemiringTerm → (LeftPreSemiringTerm → LeftPreSemiringTerm))  
      
  data ClLeftPreSemiringTerm  (A : Set) : Set where 
      sing : (A → (ClLeftPreSemiringTerm A)) 
      *Cl : ((ClLeftPreSemiringTerm A) → ((ClLeftPreSemiringTerm A) → (ClLeftPreSemiringTerm A))) 
      +Cl : ((ClLeftPreSemiringTerm A) → ((ClLeftPreSemiringTerm A) → (ClLeftPreSemiringTerm A)))  
      
  data OpLeftPreSemiringTerm  (n : Nat) : Set where 
      v : ((Fin n) → (OpLeftPreSemiringTerm n)) 
      *OL : ((OpLeftPreSemiringTerm n) → ((OpLeftPreSemiringTerm n) → (OpLeftPreSemiringTerm n))) 
      +OL : ((OpLeftPreSemiringTerm n) → ((OpLeftPreSemiringTerm n) → (OpLeftPreSemiringTerm n)))  
      
  data OpLeftPreSemiringTerm2  (n : Nat) (A : Set) : Set where 
      v2 : ((Fin n) → (OpLeftPreSemiringTerm2 n A)) 
      sing2 : (A → (OpLeftPreSemiringTerm2 n A)) 
      *OL2 : ((OpLeftPreSemiringTerm2 n A) → ((OpLeftPreSemiringTerm2 n A) → (OpLeftPreSemiringTerm2 n A))) 
      +OL2 : ((OpLeftPreSemiringTerm2 n A) → ((OpLeftPreSemiringTerm2 n A) → (OpLeftPreSemiringTerm2 n A)))  
      
  simplifyCl :  {A : Set} →  ((ClLeftPreSemiringTerm A) → (ClLeftPreSemiringTerm A)) 
  simplifyCl (*Cl x1 x2) = (*Cl (simplifyCl x1) (simplifyCl x2))  
  simplifyCl (+Cl x1 x2) = (+Cl (simplifyCl x1) (simplifyCl x2))  
  simplifyCl (sing x1) = (sing x1)  
  simplifyOpB :  {n : Nat} →  ((OpLeftPreSemiringTerm n) → (OpLeftPreSemiringTerm n)) 
  simplifyOpB (*OL x1 x2) = (*OL (simplifyOpB x1) (simplifyOpB x2))  
  simplifyOpB (+OL x1 x2) = (+OL (simplifyOpB x1) (simplifyOpB x2))  
  simplifyOpB (v x1) = (v x1)  
  simplifyOp :  {n : Nat} {A : Set} →  ((OpLeftPreSemiringTerm2 n A) → (OpLeftPreSemiringTerm2 n A)) 
  simplifyOp (*OL2 x1 x2) = (*OL2 (simplifyOp x1) (simplifyOp x2))  
  simplifyOp (+OL2 x1 x2) = (+OL2 (simplifyOp x1) (simplifyOp x2))  
  simplifyOp (v2 x1) = (v2 x1)  
  simplifyOp (sing2 x1) = (sing2 x1)  
  evalB :  {A : Set} →  ((LeftPreSemiring A) → (LeftPreSemiringTerm → A)) 
  evalB Le (*L x1 x2) = ((* Le) (evalB Le x1) (evalB Le x2))  
  evalB Le (+L x1 x2) = ((+ Le) (evalB Le x1) (evalB Le x2))  
  evalCl :  {A : Set} →  ((LeftPreSemiring A) → ((ClLeftPreSemiringTerm A) → A)) 
  evalCl Le (sing x1) = x1  
  evalCl Le (*Cl x1 x2) = ((* Le) (evalCl Le x1) (evalCl Le x2))  
  evalCl Le (+Cl x1 x2) = ((+ Le) (evalCl Le x1) (evalCl Le x2))  
  evalOpB :  {A : Set} {n : Nat} →  ((LeftPreSemiring A) → ((Vec A n) → ((OpLeftPreSemiringTerm n) → A))) 
  evalOpB Le vars (v x1) = (lookup vars x1)  
  evalOpB Le vars (*OL x1 x2) = ((* Le) (evalOpB Le vars x1) (evalOpB Le vars x2))  
  evalOpB Le vars (+OL x1 x2) = ((+ Le) (evalOpB Le vars x1) (evalOpB Le vars x2))  
  evalOp :  {A : Set} {n : Nat} →  ((LeftPreSemiring A) → ((Vec A n) → ((OpLeftPreSemiringTerm2 n A) → A))) 
  evalOp Le vars (v2 x1) = (lookup vars x1)  
  evalOp Le vars (sing2 x1) = x1  
  evalOp Le vars (*OL2 x1 x2) = ((* Le) (evalOp Le vars x1) (evalOp Le vars x2))  
  evalOp Le vars (+OL2 x1 x2) = ((+ Le) (evalOp Le vars x1) (evalOp Le vars x2))  
  inductionB :  {P : (LeftPreSemiringTerm → Set)} →  (( (x1 x2 : LeftPreSemiringTerm) → ((P x1) → ((P x2) → (P (*L x1 x2))))) → (( (x1 x2 : LeftPreSemiringTerm) → ((P x1) → ((P x2) → (P (+L x1 x2))))) → ( (x : LeftPreSemiringTerm) → (P x)))) 
  inductionB p*l p+l (*L x1 x2) = (p*l _ _ (inductionB p*l p+l x1) (inductionB p*l p+l x2))  
  inductionB p*l p+l (+L x1 x2) = (p+l _ _ (inductionB p*l p+l x1) (inductionB p*l p+l x2))  
  inductionCl :  {A : Set} {P : ((ClLeftPreSemiringTerm A) → Set)} →  (( (x1 : A) → (P (sing x1))) → (( (x1 x2 : (ClLeftPreSemiringTerm A)) → ((P x1) → ((P x2) → (P (*Cl x1 x2))))) → (( (x1 x2 : (ClLeftPreSemiringTerm A)) → ((P x1) → ((P x2) → (P (+Cl x1 x2))))) → ( (x : (ClLeftPreSemiringTerm A)) → (P x))))) 
  inductionCl psing p*cl p+cl (sing x1) = (psing x1)  
  inductionCl psing p*cl p+cl (*Cl x1 x2) = (p*cl _ _ (inductionCl psing p*cl p+cl x1) (inductionCl psing p*cl p+cl x2))  
  inductionCl psing p*cl p+cl (+Cl x1 x2) = (p+cl _ _ (inductionCl psing p*cl p+cl x1) (inductionCl psing p*cl p+cl x2))  
  inductionOpB :  {n : Nat} {P : ((OpLeftPreSemiringTerm n) → Set)} →  (( (fin : (Fin n)) → (P (v fin))) → (( (x1 x2 : (OpLeftPreSemiringTerm n)) → ((P x1) → ((P x2) → (P (*OL x1 x2))))) → (( (x1 x2 : (OpLeftPreSemiringTerm n)) → ((P x1) → ((P x2) → (P (+OL x1 x2))))) → ( (x : (OpLeftPreSemiringTerm n)) → (P x))))) 
  inductionOpB pv p*ol p+ol (v x1) = (pv x1)  
  inductionOpB pv p*ol p+ol (*OL x1 x2) = (p*ol _ _ (inductionOpB pv p*ol p+ol x1) (inductionOpB pv p*ol p+ol x2))  
  inductionOpB pv p*ol p+ol (+OL x1 x2) = (p+ol _ _ (inductionOpB pv p*ol p+ol x1) (inductionOpB pv p*ol p+ol x2))  
  inductionOp :  {n : Nat} {A : Set} {P : ((OpLeftPreSemiringTerm2 n A) → Set)} →  (( (fin : (Fin n)) → (P (v2 fin))) → (( (x1 : A) → (P (sing2 x1))) → (( (x1 x2 : (OpLeftPreSemiringTerm2 n A)) → ((P x1) → ((P x2) → (P (*OL2 x1 x2))))) → (( (x1 x2 : (OpLeftPreSemiringTerm2 n A)) → ((P x1) → ((P x2) → (P (+OL2 x1 x2))))) → ( (x : (OpLeftPreSemiringTerm2 n A)) → (P x)))))) 
  inductionOp pv2 psing2 p*ol2 p+ol2 (v2 x1) = (pv2 x1)  
  inductionOp pv2 psing2 p*ol2 p+ol2 (sing2 x1) = (psing2 x1)  
  inductionOp pv2 psing2 p*ol2 p+ol2 (*OL2 x1 x2) = (p*ol2 _ _ (inductionOp pv2 psing2 p*ol2 p+ol2 x1) (inductionOp pv2 psing2 p*ol2 p+ol2 x2))  
  inductionOp pv2 psing2 p*ol2 p+ol2 (+OL2 x1 x2) = (p+ol2 _ _ (inductionOp pv2 psing2 p*ol2 p+ol2 x1) (inductionOp pv2 psing2 p*ol2 p+ol2 x2))  
  stageB :  (LeftPreSemiringTerm → (Staged LeftPreSemiringTerm))
  stageB (*L x1 x2) = (stage2 *L (codeLift2 *L) (stageB x1) (stageB x2))  
  stageB (+L x1 x2) = (stage2 +L (codeLift2 +L) (stageB x1) (stageB x2))  
  stageCl :  {A : Set} →  ((ClLeftPreSemiringTerm A) → (Staged (ClLeftPreSemiringTerm A))) 
  stageCl (sing x1) = (Now (sing x1))  
  stageCl (*Cl x1 x2) = (stage2 *Cl (codeLift2 *Cl) (stageCl x1) (stageCl x2))  
  stageCl (+Cl x1 x2) = (stage2 +Cl (codeLift2 +Cl) (stageCl x1) (stageCl x2))  
  stageOpB :  {n : Nat} →  ((OpLeftPreSemiringTerm n) → (Staged (OpLeftPreSemiringTerm n))) 
  stageOpB (v x1) = (const (code (v x1)))  
  stageOpB (*OL x1 x2) = (stage2 *OL (codeLift2 *OL) (stageOpB x1) (stageOpB x2))  
  stageOpB (+OL x1 x2) = (stage2 +OL (codeLift2 +OL) (stageOpB x1) (stageOpB x2))  
  stageOp :  {n : Nat} {A : Set} →  ((OpLeftPreSemiringTerm2 n A) → (Staged (OpLeftPreSemiringTerm2 n A))) 
  stageOp (sing2 x1) = (Now (sing2 x1))  
  stageOp (v2 x1) = (const (code (v2 x1)))  
  stageOp (*OL2 x1 x2) = (stage2 *OL2 (codeLift2 *OL2) (stageOp x1) (stageOp x2))  
  stageOp (+OL2 x1 x2) = (stage2 +OL2 (codeLift2 +OL2) (stageOp x1) (stageOp x2))  
  record StagedRepr  (A : Set) (Repr : (Set → Set)) : Set where 
     field  
      *T : ((Repr A) → ((Repr A) → (Repr A))) 
      +T : ((Repr A) → ((Repr A) → (Repr A)))  
  
 