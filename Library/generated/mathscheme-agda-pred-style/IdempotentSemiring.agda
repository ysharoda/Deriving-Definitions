
module IdempotentSemiring   where
  open import Prelude
  open import Agda.Builtin.Equality
  open import Agda.Builtin.Nat
  open import Data.Fin
  open import Data.Vec
  record IsIdempotentSemiring  (A : Set) (+ : (A → (A → A))) (0ᵢ : A) (* : (A → (A → A))) (1ᵢ : A) : Set where 
     field  
      associative_* : ( {x y z : A} → (* (* x y) z) ≡ (* x (* y z))) 
      lunit_1ᵢ : ( {x : A} → (* 1ᵢ x) ≡ x) 
      runit_1ᵢ : ( {x : A} → (* x 1ᵢ) ≡ x) 
      lunit_0ᵢ : ( {x : A} → (+ 0ᵢ x) ≡ x) 
      runit_0ᵢ : ( {x : A} → (+ x 0ᵢ) ≡ x) 
      associative_+ : ( {x y z : A} → (+ (+ x y) z) ≡ (+ x (+ y z))) 
      commutative_+ : ( {x y : A} → (+ x y) ≡ (+ y x)) 
      leftDistributive_*_+ : ( {x y z : A} → (* x (+ y z)) ≡ (+ (* x y) (* x z))) 
      rightDistributive_*_+ : ( {x y z : A} → (* (+ y z) x) ≡ (+ (* y x) (* z x))) 
      leftZero_op_0ᵢ : ( {x : A} → (* 0ᵢ x) ≡ 0ᵢ) 
      rightZero_op_0ᵢ : ( {x : A} → (* x 0ᵢ) ≡ 0ᵢ) 
      idempotent_+ : ( {x : A} → (+ x x) ≡ x)  
  
  record IdempotentSemiring  (A : Set) : Set where 
     field  
      + : (A → (A → A)) 
      0ᵢ : A 
      * : (A → (A → A)) 
      1ᵢ : A 
      isIdempotentSemiring : (IsIdempotentSemiring A (+) 0ᵢ (*) 1ᵢ)  
  
  open IdempotentSemiring
  record Sig  (AS : Set) : Set where 
     field  
      +S : (AS → (AS → AS)) 
      0S : AS 
      *S : (AS → (AS → AS)) 
      1S : AS  
  
  record Product  (A : Set) : Set where 
     field  
      +P : ((Prod A A) → ((Prod A A) → (Prod A A))) 
      0P : (Prod A A) 
      *P : ((Prod A A) → ((Prod A A) → (Prod A A))) 
      1P : (Prod A A) 
      associative_*P : ( {xP yP zP : (Prod A A)} → (*P (*P xP yP) zP) ≡ (*P xP (*P yP zP))) 
      lunit_1P : ( {xP : (Prod A A)} → (*P 1P xP) ≡ xP) 
      runit_1P : ( {xP : (Prod A A)} → (*P xP 1P) ≡ xP) 
      lunit_0P : ( {xP : (Prod A A)} → (+P 0P xP) ≡ xP) 
      runit_0P : ( {xP : (Prod A A)} → (+P xP 0P) ≡ xP) 
      associative_+P : ( {xP yP zP : (Prod A A)} → (+P (+P xP yP) zP) ≡ (+P xP (+P yP zP))) 
      commutative_+P : ( {xP yP : (Prod A A)} → (+P xP yP) ≡ (+P yP xP)) 
      leftDistributive_*_+P : ( {xP yP zP : (Prod A A)} → (*P xP (+P yP zP)) ≡ (+P (*P xP yP) (*P xP zP))) 
      rightDistributive_*_+P : ( {xP yP zP : (Prod A A)} → (*P (+P yP zP) xP) ≡ (+P (*P yP xP) (*P zP xP))) 
      leftZero_op_0P : ( {xP : (Prod A A)} → (*P 0P xP) ≡ 0P) 
      rightZero_op_0P : ( {xP : (Prod A A)} → (*P xP 0P) ≡ 0P) 
      idempotent_+P : ( {xP : (Prod A A)} → (+P xP xP) ≡ xP)  
  
  record Hom  {A1 : Set} {A2 : Set} (Id1 : (IdempotentSemiring A1)) (Id2 : (IdempotentSemiring A2)) : Set where 
     field  
      hom : (A1 → A2) 
      pres-+ : ( {x1 x2 : A1} → (hom ((+ Id1) x1 x2)) ≡ ((+ Id2) (hom x1) (hom x2))) 
      pres-0 : (hom (0ᵢ Id1)) ≡ (0ᵢ Id2) 
      pres-* : ( {x1 x2 : A1} → (hom ((* Id1) x1 x2)) ≡ ((* Id2) (hom x1) (hom x2))) 
      pres-1 : (hom (1ᵢ Id1)) ≡ (1ᵢ Id2)  
  
  record RelInterp  {A1 : Set} {A2 : Set} (Id1 : (IdempotentSemiring A1)) (Id2 : (IdempotentSemiring A2)) : Set₁ where 
     field  
      interp : (A1 → (A2 → Set)) 
      interp-+ : ( {x1 x2 : A1} {y1 y2 : A2} → ((interp x1 y1) → ((interp x2 y2) → (interp ((+ Id1) x1 x2) ((+ Id2) y1 y2))))) 
      interp-0 : (interp (0ᵢ Id1) (0ᵢ Id2)) 
      interp-* : ( {x1 x2 : A1} {y1 y2 : A2} → ((interp x1 y1) → ((interp x2 y2) → (interp ((* Id1) x1 x2) ((* Id2) y1 y2))))) 
      interp-1 : (interp (1ᵢ Id1) (1ᵢ Id2))  
  
  data IdempotentSemiringTerm   : Set where 
      +L : (IdempotentSemiringTerm → (IdempotentSemiringTerm → IdempotentSemiringTerm)) 
      0L : IdempotentSemiringTerm 
      *L : (IdempotentSemiringTerm → (IdempotentSemiringTerm → IdempotentSemiringTerm)) 
      1L : IdempotentSemiringTerm  
      
  data ClIdempotentSemiringTerm  (A : Set) : Set where 
      sing : (A → (ClIdempotentSemiringTerm A)) 
      +Cl : ((ClIdempotentSemiringTerm A) → ((ClIdempotentSemiringTerm A) → (ClIdempotentSemiringTerm A))) 
      0Cl : (ClIdempotentSemiringTerm A) 
      *Cl : ((ClIdempotentSemiringTerm A) → ((ClIdempotentSemiringTerm A) → (ClIdempotentSemiringTerm A))) 
      1Cl : (ClIdempotentSemiringTerm A)  
      
  data OpIdempotentSemiringTerm  (n : Nat) : Set where 
      v : ((Fin n) → (OpIdempotentSemiringTerm n)) 
      +OL : ((OpIdempotentSemiringTerm n) → ((OpIdempotentSemiringTerm n) → (OpIdempotentSemiringTerm n))) 
      0OL : (OpIdempotentSemiringTerm n) 
      *OL : ((OpIdempotentSemiringTerm n) → ((OpIdempotentSemiringTerm n) → (OpIdempotentSemiringTerm n))) 
      1OL : (OpIdempotentSemiringTerm n)  
      
  data OpIdempotentSemiringTerm2  (n : Nat) (A : Set) : Set where 
      v2 : ((Fin n) → (OpIdempotentSemiringTerm2 n A)) 
      sing2 : (A → (OpIdempotentSemiringTerm2 n A)) 
      +OL2 : ((OpIdempotentSemiringTerm2 n A) → ((OpIdempotentSemiringTerm2 n A) → (OpIdempotentSemiringTerm2 n A))) 
      0OL2 : (OpIdempotentSemiringTerm2 n A) 
      *OL2 : ((OpIdempotentSemiringTerm2 n A) → ((OpIdempotentSemiringTerm2 n A) → (OpIdempotentSemiringTerm2 n A))) 
      1OL2 : (OpIdempotentSemiringTerm2 n A)  
      
  simplifyCl :  {A : Set} →  ((ClIdempotentSemiringTerm A) → (ClIdempotentSemiringTerm A)) 
  simplifyCl (*Cl 1Cl x) = x  
  simplifyCl (*Cl x 1Cl) = x  
  simplifyCl (+Cl 0Cl x) = x  
  simplifyCl (+Cl x 0Cl) = x  
  simplifyCl (+Cl x1 x2) = (+Cl (simplifyCl x1) (simplifyCl x2))  
  simplifyCl 0Cl = 0Cl  
  simplifyCl (*Cl x1 x2) = (*Cl (simplifyCl x1) (simplifyCl x2))  
  simplifyCl 1Cl = 1Cl  
  simplifyCl (sing x1) = (sing x1)  
  simplifyOpB :  {n : Nat} →  ((OpIdempotentSemiringTerm n) → (OpIdempotentSemiringTerm n)) 
  simplifyOpB (*OL 1OL x) = x  
  simplifyOpB (*OL x 1OL) = x  
  simplifyOpB (+OL 0OL x) = x  
  simplifyOpB (+OL x 0OL) = x  
  simplifyOpB (+OL x1 x2) = (+OL (simplifyOpB x1) (simplifyOpB x2))  
  simplifyOpB 0OL = 0OL  
  simplifyOpB (*OL x1 x2) = (*OL (simplifyOpB x1) (simplifyOpB x2))  
  simplifyOpB 1OL = 1OL  
  simplifyOpB (v x1) = (v x1)  
  simplifyOp :  {n : Nat} {A : Set} →  ((OpIdempotentSemiringTerm2 n A) → (OpIdempotentSemiringTerm2 n A)) 
  simplifyOp (*OL2 1OL2 x) = x  
  simplifyOp (*OL2 x 1OL2) = x  
  simplifyOp (+OL2 0OL2 x) = x  
  simplifyOp (+OL2 x 0OL2) = x  
  simplifyOp (+OL2 x1 x2) = (+OL2 (simplifyOp x1) (simplifyOp x2))  
  simplifyOp 0OL2 = 0OL2  
  simplifyOp (*OL2 x1 x2) = (*OL2 (simplifyOp x1) (simplifyOp x2))  
  simplifyOp 1OL2 = 1OL2  
  simplifyOp (v2 x1) = (v2 x1)  
  simplifyOp (sing2 x1) = (sing2 x1)  
  evalB :  {A : Set} →  ((IdempotentSemiring A) → (IdempotentSemiringTerm → A)) 
  evalB Id (+L x1 x2) = ((+ Id) (evalB Id x1) (evalB Id x2))  
  evalB Id 0L = (0ᵢ Id)  
  evalB Id (*L x1 x2) = ((* Id) (evalB Id x1) (evalB Id x2))  
  evalB Id 1L = (1ᵢ Id)  
  evalCl :  {A : Set} →  ((IdempotentSemiring A) → ((ClIdempotentSemiringTerm A) → A)) 
  evalCl Id (sing x1) = x1  
  evalCl Id (+Cl x1 x2) = ((+ Id) (evalCl Id x1) (evalCl Id x2))  
  evalCl Id 0Cl = (0ᵢ Id)  
  evalCl Id (*Cl x1 x2) = ((* Id) (evalCl Id x1) (evalCl Id x2))  
  evalCl Id 1Cl = (1ᵢ Id)  
  evalOpB :  {A : Set} {n : Nat} →  ((IdempotentSemiring A) → ((Vec A n) → ((OpIdempotentSemiringTerm n) → A))) 
  evalOpB Id vars (v x1) = (lookup vars x1)  
  evalOpB Id vars (+OL x1 x2) = ((+ Id) (evalOpB Id vars x1) (evalOpB Id vars x2))  
  evalOpB Id vars 0OL = (0ᵢ Id)  
  evalOpB Id vars (*OL x1 x2) = ((* Id) (evalOpB Id vars x1) (evalOpB Id vars x2))  
  evalOpB Id vars 1OL = (1ᵢ Id)  
  evalOp :  {A : Set} {n : Nat} →  ((IdempotentSemiring A) → ((Vec A n) → ((OpIdempotentSemiringTerm2 n A) → A))) 
  evalOp Id vars (v2 x1) = (lookup vars x1)  
  evalOp Id vars (sing2 x1) = x1  
  evalOp Id vars (+OL2 x1 x2) = ((+ Id) (evalOp Id vars x1) (evalOp Id vars x2))  
  evalOp Id vars 0OL2 = (0ᵢ Id)  
  evalOp Id vars (*OL2 x1 x2) = ((* Id) (evalOp Id vars x1) (evalOp Id vars x2))  
  evalOp Id vars 1OL2 = (1ᵢ Id)  
  inductionB :  {P : (IdempotentSemiringTerm → Set)} →  (( (x1 x2 : IdempotentSemiringTerm) → ((P x1) → ((P x2) → (P (+L x1 x2))))) → ((P 0L) → (( (x1 x2 : IdempotentSemiringTerm) → ((P x1) → ((P x2) → (P (*L x1 x2))))) → ((P 1L) → ( (x : IdempotentSemiringTerm) → (P x)))))) 
  inductionB p+l p0l p*l p1l (+L x1 x2) = (p+l _ _ (inductionB p+l p0l p*l p1l x1) (inductionB p+l p0l p*l p1l x2))  
  inductionB p+l p0l p*l p1l 0L = p0l  
  inductionB p+l p0l p*l p1l (*L x1 x2) = (p*l _ _ (inductionB p+l p0l p*l p1l x1) (inductionB p+l p0l p*l p1l x2))  
  inductionB p+l p0l p*l p1l 1L = p1l  
  inductionCl :  {A : Set} {P : ((ClIdempotentSemiringTerm A) → Set)} →  (( (x1 : A) → (P (sing x1))) → (( (x1 x2 : (ClIdempotentSemiringTerm A)) → ((P x1) → ((P x2) → (P (+Cl x1 x2))))) → ((P 0Cl) → (( (x1 x2 : (ClIdempotentSemiringTerm A)) → ((P x1) → ((P x2) → (P (*Cl x1 x2))))) → ((P 1Cl) → ( (x : (ClIdempotentSemiringTerm A)) → (P x))))))) 
  inductionCl psing p+cl p0cl p*cl p1cl (sing x1) = (psing x1)  
  inductionCl psing p+cl p0cl p*cl p1cl (+Cl x1 x2) = (p+cl _ _ (inductionCl psing p+cl p0cl p*cl p1cl x1) (inductionCl psing p+cl p0cl p*cl p1cl x2))  
  inductionCl psing p+cl p0cl p*cl p1cl 0Cl = p0cl  
  inductionCl psing p+cl p0cl p*cl p1cl (*Cl x1 x2) = (p*cl _ _ (inductionCl psing p+cl p0cl p*cl p1cl x1) (inductionCl psing p+cl p0cl p*cl p1cl x2))  
  inductionCl psing p+cl p0cl p*cl p1cl 1Cl = p1cl  
  inductionOpB :  {n : Nat} {P : ((OpIdempotentSemiringTerm n) → Set)} →  (( (fin : (Fin n)) → (P (v fin))) → (( (x1 x2 : (OpIdempotentSemiringTerm n)) → ((P x1) → ((P x2) → (P (+OL x1 x2))))) → ((P 0OL) → (( (x1 x2 : (OpIdempotentSemiringTerm n)) → ((P x1) → ((P x2) → (P (*OL x1 x2))))) → ((P 1OL) → ( (x : (OpIdempotentSemiringTerm n)) → (P x))))))) 
  inductionOpB pv p+ol p0ol p*ol p1ol (v x1) = (pv x1)  
  inductionOpB pv p+ol p0ol p*ol p1ol (+OL x1 x2) = (p+ol _ _ (inductionOpB pv p+ol p0ol p*ol p1ol x1) (inductionOpB pv p+ol p0ol p*ol p1ol x2))  
  inductionOpB pv p+ol p0ol p*ol p1ol 0OL = p0ol  
  inductionOpB pv p+ol p0ol p*ol p1ol (*OL x1 x2) = (p*ol _ _ (inductionOpB pv p+ol p0ol p*ol p1ol x1) (inductionOpB pv p+ol p0ol p*ol p1ol x2))  
  inductionOpB pv p+ol p0ol p*ol p1ol 1OL = p1ol  
  inductionOp :  {n : Nat} {A : Set} {P : ((OpIdempotentSemiringTerm2 n A) → Set)} →  (( (fin : (Fin n)) → (P (v2 fin))) → (( (x1 : A) → (P (sing2 x1))) → (( (x1 x2 : (OpIdempotentSemiringTerm2 n A)) → ((P x1) → ((P x2) → (P (+OL2 x1 x2))))) → ((P 0OL2) → (( (x1 x2 : (OpIdempotentSemiringTerm2 n A)) → ((P x1) → ((P x2) → (P (*OL2 x1 x2))))) → ((P 1OL2) → ( (x : (OpIdempotentSemiringTerm2 n A)) → (P x)))))))) 
  inductionOp pv2 psing2 p+ol2 p0ol2 p*ol2 p1ol2 (v2 x1) = (pv2 x1)  
  inductionOp pv2 psing2 p+ol2 p0ol2 p*ol2 p1ol2 (sing2 x1) = (psing2 x1)  
  inductionOp pv2 psing2 p+ol2 p0ol2 p*ol2 p1ol2 (+OL2 x1 x2) = (p+ol2 _ _ (inductionOp pv2 psing2 p+ol2 p0ol2 p*ol2 p1ol2 x1) (inductionOp pv2 psing2 p+ol2 p0ol2 p*ol2 p1ol2 x2))  
  inductionOp pv2 psing2 p+ol2 p0ol2 p*ol2 p1ol2 0OL2 = p0ol2  
  inductionOp pv2 psing2 p+ol2 p0ol2 p*ol2 p1ol2 (*OL2 x1 x2) = (p*ol2 _ _ (inductionOp pv2 psing2 p+ol2 p0ol2 p*ol2 p1ol2 x1) (inductionOp pv2 psing2 p+ol2 p0ol2 p*ol2 p1ol2 x2))  
  inductionOp pv2 psing2 p+ol2 p0ol2 p*ol2 p1ol2 1OL2 = p1ol2  
  stageB :  (IdempotentSemiringTerm → (Staged IdempotentSemiringTerm))
  stageB (+L x1 x2) = (stage2 +L (codeLift2 +L) (stageB x1) (stageB x2))  
  stageB 0L = (Now 0L)  
  stageB (*L x1 x2) = (stage2 *L (codeLift2 *L) (stageB x1) (stageB x2))  
  stageB 1L = (Now 1L)  
  stageCl :  {A : Set} →  ((ClIdempotentSemiringTerm A) → (Staged (ClIdempotentSemiringTerm A))) 
  stageCl (sing x1) = (Now (sing x1))  
  stageCl (+Cl x1 x2) = (stage2 +Cl (codeLift2 +Cl) (stageCl x1) (stageCl x2))  
  stageCl 0Cl = (Now 0Cl)  
  stageCl (*Cl x1 x2) = (stage2 *Cl (codeLift2 *Cl) (stageCl x1) (stageCl x2))  
  stageCl 1Cl = (Now 1Cl)  
  stageOpB :  {n : Nat} →  ((OpIdempotentSemiringTerm n) → (Staged (OpIdempotentSemiringTerm n))) 
  stageOpB (v x1) = (const (code (v x1)))  
  stageOpB (+OL x1 x2) = (stage2 +OL (codeLift2 +OL) (stageOpB x1) (stageOpB x2))  
  stageOpB 0OL = (Now 0OL)  
  stageOpB (*OL x1 x2) = (stage2 *OL (codeLift2 *OL) (stageOpB x1) (stageOpB x2))  
  stageOpB 1OL = (Now 1OL)  
  stageOp :  {n : Nat} {A : Set} →  ((OpIdempotentSemiringTerm2 n A) → (Staged (OpIdempotentSemiringTerm2 n A))) 
  stageOp (sing2 x1) = (Now (sing2 x1))  
  stageOp (v2 x1) = (const (code (v2 x1)))  
  stageOp (+OL2 x1 x2) = (stage2 +OL2 (codeLift2 +OL2) (stageOp x1) (stageOp x2))  
  stageOp 0OL2 = (Now 0OL2)  
  stageOp (*OL2 x1 x2) = (stage2 *OL2 (codeLift2 *OL2) (stageOp x1) (stageOp x2))  
  stageOp 1OL2 = (Now 1OL2)  
  record StagedRepr  (A : Set) (Repr : (Set → Set)) : Set where 
     field  
      +T : ((Repr A) → ((Repr A) → (Repr A))) 
      0T : (Repr A) 
      *T : ((Repr A) → ((Repr A) → (Repr A))) 
      1T : (Repr A)  
  
 