
module Monoid1   where
  open import Prelude
  open import Agda.Builtin.Equality
  open import Agda.Builtin.Nat
  open import Data.Fin
  open import Data.Vec
  record IsMonoid1  (A : Set) (1ᵢ : A) (op : (A → (A → A))) : Set where 
     field  
      lunit_1ᵢ : ( {x : A} → (op 1ᵢ x) ≡ x) 
      runit_1ᵢ : ( {x : A} → (op x 1ᵢ) ≡ x) 
      associative_op : ( {x y z : A} → (op (op x y) z) ≡ (op x (op y z)))  
  
  record Monoid1  (A : Set) : Set where 
     field  
      1ᵢ : A 
      op : (A → (A → A)) 
      isMonoid1 : (IsMonoid1 A 1ᵢ op)  
  
  open Monoid1
  record Sig  (AS : Set) : Set where 
     field  
      1S : AS 
      opS : (AS → (AS → AS))  
  
  record Product  (A : Set) : Set where 
     field  
      1P : (Prod A A) 
      opP : ((Prod A A) → ((Prod A A) → (Prod A A))) 
      lunit_1P : ( {xP : (Prod A A)} → (opP 1P xP) ≡ xP) 
      runit_1P : ( {xP : (Prod A A)} → (opP xP 1P) ≡ xP) 
      associative_opP : ( {xP yP zP : (Prod A A)} → (opP (opP xP yP) zP) ≡ (opP xP (opP yP zP)))  
  
  record Hom  {A1 : Set} {A2 : Set} (Mo1 : (Monoid1 A1)) (Mo2 : (Monoid1 A2)) : Set where 
     field  
      hom : (A1 → A2) 
      pres-1 : (hom (1ᵢ Mo1)) ≡ (1ᵢ Mo2) 
      pres-op : ( {x1 x2 : A1} → (hom ((op Mo1) x1 x2)) ≡ ((op Mo2) (hom x1) (hom x2)))  
  
  record RelInterp  {A1 : Set} {A2 : Set} (Mo1 : (Monoid1 A1)) (Mo2 : (Monoid1 A2)) : Set₁ where 
     field  
      interp : (A1 → (A2 → Set)) 
      interp-1 : (interp (1ᵢ Mo1) (1ᵢ Mo2)) 
      interp-op : ( {x1 x2 : A1} {y1 y2 : A2} → ((interp x1 y1) → ((interp x2 y2) → (interp ((op Mo1) x1 x2) ((op Mo2) y1 y2)))))  
  
  data Monoid1LTerm   : Set where 
      1L : Monoid1LTerm 
      opL : (Monoid1LTerm → (Monoid1LTerm → Monoid1LTerm))  
      
  data ClMonoid1ClTerm  (A : Set) : Set where 
      sing : (A → (ClMonoid1ClTerm A)) 
      1Cl : (ClMonoid1ClTerm A) 
      opCl : ((ClMonoid1ClTerm A) → ((ClMonoid1ClTerm A) → (ClMonoid1ClTerm A)))  
      
  data OpMonoid1OLTerm  (n : Nat) : Set where 
      v : ((Fin n) → (OpMonoid1OLTerm n)) 
      1OL : (OpMonoid1OLTerm n) 
      opOL : ((OpMonoid1OLTerm n) → ((OpMonoid1OLTerm n) → (OpMonoid1OLTerm n)))  
      
  data OpMonoid1OL2Term2  (n : Nat) (A : Set) : Set where 
      v2 : ((Fin n) → (OpMonoid1OL2Term2 n A)) 
      sing2 : (A → (OpMonoid1OL2Term2 n A)) 
      1OL2 : (OpMonoid1OL2Term2 n A) 
      opOL2 : ((OpMonoid1OL2Term2 n A) → ((OpMonoid1OL2Term2 n A) → (OpMonoid1OL2Term2 n A)))  
      
  simplifyCl :  {A : Set} →  ((ClMonoid1ClTerm A) → (ClMonoid1ClTerm A)) 
  simplifyCl (opCl 1Cl x) = x  
  simplifyCl (opCl x 1Cl) = x  
  simplifyCl 1Cl = 1Cl  
  simplifyCl (opCl x1 x2) = (opCl (simplifyCl x1) (simplifyCl x2))  
  simplifyCl (sing x1) = (sing x1)  
  simplifyOpB :  {n : Nat} →  ((OpMonoid1OLTerm n) → (OpMonoid1OLTerm n)) 
  simplifyOpB (opOL 1OL x) = x  
  simplifyOpB (opOL x 1OL) = x  
  simplifyOpB 1OL = 1OL  
  simplifyOpB (opOL x1 x2) = (opOL (simplifyOpB x1) (simplifyOpB x2))  
  simplifyOpB (v x1) = (v x1)  
  simplifyOp :  {n : Nat} {A : Set} →  ((OpMonoid1OL2Term2 n A) → (OpMonoid1OL2Term2 n A)) 
  simplifyOp (opOL2 1OL2 x) = x  
  simplifyOp (opOL2 x 1OL2) = x  
  simplifyOp 1OL2 = 1OL2  
  simplifyOp (opOL2 x1 x2) = (opOL2 (simplifyOp x1) (simplifyOp x2))  
  simplifyOp (v2 x1) = (v2 x1)  
  simplifyOp (sing2 x1) = (sing2 x1)  
  evalB :  {A : Set} →  ((Monoid1 A) → (Monoid1LTerm → A)) 
  evalB Mo 1L = (1ᵢ Mo)  
  evalB Mo (opL x1 x2) = ((op Mo) (evalB Mo x1) (evalB Mo x2))  
  evalCl :  {A : Set} →  ((Monoid1 A) → ((ClMonoid1ClTerm A) → A)) 
  evalCl Mo (sing x1) = x1  
  evalCl Mo 1Cl = (1ᵢ Mo)  
  evalCl Mo (opCl x1 x2) = ((op Mo) (evalCl Mo x1) (evalCl Mo x2))  
  evalOpB :  {A : Set} {n : Nat} →  ((Monoid1 A) → ((Vec A n) → ((OpMonoid1OLTerm n) → A))) 
  evalOpB Mo vars (v x1) = (lookup vars x1)  
  evalOpB Mo vars 1OL = (1ᵢ Mo)  
  evalOpB Mo vars (opOL x1 x2) = ((op Mo) (evalOpB Mo vars x1) (evalOpB Mo vars x2))  
  evalOp :  {A : Set} {n : Nat} →  ((Monoid1 A) → ((Vec A n) → ((OpMonoid1OL2Term2 n A) → A))) 
  evalOp Mo vars (v2 x1) = (lookup vars x1)  
  evalOp Mo vars (sing2 x1) = x1  
  evalOp Mo vars 1OL2 = (1ᵢ Mo)  
  evalOp Mo vars (opOL2 x1 x2) = ((op Mo) (evalOp Mo vars x1) (evalOp Mo vars x2))  
  inductionB :  {P : (Monoid1LTerm → Set)} →  ((P 1L) → (( (x1 x2 : Monoid1LTerm) → ((P x1) → ((P x2) → (P (opL x1 x2))))) → ( (x : Monoid1LTerm) → (P x)))) 
  inductionB p1l popl 1L = p1l  
  inductionB p1l popl (opL x1 x2) = (popl _ _ (inductionB p1l popl x1) (inductionB p1l popl x2))  
  inductionCl :  {A : Set} {P : ((ClMonoid1ClTerm A) → Set)} →  (( (x1 : A) → (P (sing x1))) → ((P 1Cl) → (( (x1 x2 : (ClMonoid1ClTerm A)) → ((P x1) → ((P x2) → (P (opCl x1 x2))))) → ( (x : (ClMonoid1ClTerm A)) → (P x))))) 
  inductionCl psing p1cl popcl (sing x1) = (psing x1)  
  inductionCl psing p1cl popcl 1Cl = p1cl  
  inductionCl psing p1cl popcl (opCl x1 x2) = (popcl _ _ (inductionCl psing p1cl popcl x1) (inductionCl psing p1cl popcl x2))  
  inductionOpB :  {n : Nat} {P : ((OpMonoid1OLTerm n) → Set)} →  (( (fin : (Fin n)) → (P (v fin))) → ((P 1OL) → (( (x1 x2 : (OpMonoid1OLTerm n)) → ((P x1) → ((P x2) → (P (opOL x1 x2))))) → ( (x : (OpMonoid1OLTerm n)) → (P x))))) 
  inductionOpB pv p1ol popol (v x1) = (pv x1)  
  inductionOpB pv p1ol popol 1OL = p1ol  
  inductionOpB pv p1ol popol (opOL x1 x2) = (popol _ _ (inductionOpB pv p1ol popol x1) (inductionOpB pv p1ol popol x2))  
  inductionOp :  {n : Nat} {A : Set} {P : ((OpMonoid1OL2Term2 n A) → Set)} →  (( (fin : (Fin n)) → (P (v2 fin))) → (( (x1 : A) → (P (sing2 x1))) → ((P 1OL2) → (( (x1 x2 : (OpMonoid1OL2Term2 n A)) → ((P x1) → ((P x2) → (P (opOL2 x1 x2))))) → ( (x : (OpMonoid1OL2Term2 n A)) → (P x)))))) 
  inductionOp pv2 psing2 p1ol2 popol2 (v2 x1) = (pv2 x1)  
  inductionOp pv2 psing2 p1ol2 popol2 (sing2 x1) = (psing2 x1)  
  inductionOp pv2 psing2 p1ol2 popol2 1OL2 = p1ol2  
  inductionOp pv2 psing2 p1ol2 popol2 (opOL2 x1 x2) = (popol2 _ _ (inductionOp pv2 psing2 p1ol2 popol2 x1) (inductionOp pv2 psing2 p1ol2 popol2 x2))  
  stageB :  (Monoid1LTerm → (Staged Monoid1LTerm))
  stageB 1L = (Now 1L)  
  stageB (opL x1 x2) = (stage2 opL (codeLift2 opL) (stageB x1) (stageB x2))  
  stageCl :  {A : Set} →  ((ClMonoid1ClTerm A) → (Staged (ClMonoid1ClTerm A))) 
  stageCl (sing x1) = (Now (sing x1))  
  stageCl 1Cl = (Now 1Cl)  
  stageCl (opCl x1 x2) = (stage2 opCl (codeLift2 opCl) (stageCl x1) (stageCl x2))  
  stageOpB :  {n : Nat} →  ((OpMonoid1OLTerm n) → (Staged (OpMonoid1OLTerm n))) 
  stageOpB (v x1) = (const (code (v x1)))  
  stageOpB 1OL = (Now 1OL)  
  stageOpB (opOL x1 x2) = (stage2 opOL (codeLift2 opOL) (stageOpB x1) (stageOpB x2))  
  stageOp :  {n : Nat} {A : Set} →  ((OpMonoid1OL2Term2 n A) → (Staged (OpMonoid1OL2Term2 n A))) 
  stageOp (sing2 x1) = (Now (sing2 x1))  
  stageOp (v2 x1) = (const (code (v2 x1)))  
  stageOp 1OL2 = (Now 1OL2)  
  stageOp (opOL2 x1 x2) = (stage2 opOL2 (codeLift2 opOL2) (stageOp x1) (stageOp x2))  
  record StagedRepr  (A : Set) (Repr : (Set → Set)) : Set where 
     field  
      1T : (Repr A) 
      opT : ((Repr A) → ((Repr A) → (Repr A)))  
  
 