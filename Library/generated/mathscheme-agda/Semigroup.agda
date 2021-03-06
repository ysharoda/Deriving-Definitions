
module Semigroup   where
  open import Prelude
  open import Agda.Builtin.Equality
  open import Agda.Builtin.Nat
  open import Data.Fin
  open import Data.Vec
  record Semigroup  (A : Set) : Set where 
     field  
      op : (A → (A → A)) 
      associative_op : ( {x y z : A} → (op (op x y) z) ≡ (op x (op y z)))  
  
  open Semigroup
  record Sig  (AS : Set) : Set where 
     field  
      opS : (AS → (AS → AS))  
  
  record Product  (A : Set) : Set where 
     field  
      opP : ((Prod A A) → ((Prod A A) → (Prod A A))) 
      associative_opP : ( {xP yP zP : (Prod A A)} → (opP (opP xP yP) zP) ≡ (opP xP (opP yP zP)))  
  
  record Hom  {A1 : Set} {A2 : Set} (Se1 : (Semigroup A1)) (Se2 : (Semigroup A2)) : Set where 
     field  
      hom : (A1 → A2) 
      pres-op : ( {x1 x2 : A1} → (hom ((op Se1) x1 x2)) ≡ ((op Se2) (hom x1) (hom x2)))  
  
  record RelInterp  {A1 : Set} {A2 : Set} (Se1 : (Semigroup A1)) (Se2 : (Semigroup A2)) : Set₁ where 
     field  
      interp : (A1 → (A2 → Set)) 
      interp-op : ( {x1 x2 : A1} {y1 y2 : A2} → ((interp x1 y1) → ((interp x2 y2) → (interp ((op Se1) x1 x2) ((op Se2) y1 y2)))))  
  
  data SemigroupTerm   : Set where 
      opL : (SemigroupTerm → (SemigroupTerm → SemigroupTerm))  
      
  data ClSemigroupTerm  (A : Set) : Set where 
      sing : (A → (ClSemigroupTerm A)) 
      opCl : ((ClSemigroupTerm A) → ((ClSemigroupTerm A) → (ClSemigroupTerm A)))  
      
  data OpSemigroupTerm  (n : Nat) : Set where 
      v : ((Fin n) → (OpSemigroupTerm n)) 
      opOL : ((OpSemigroupTerm n) → ((OpSemigroupTerm n) → (OpSemigroupTerm n)))  
      
  data OpSemigroupTerm2  (n : Nat) (A : Set) : Set where 
      v2 : ((Fin n) → (OpSemigroupTerm2 n A)) 
      sing2 : (A → (OpSemigroupTerm2 n A)) 
      opOL2 : ((OpSemigroupTerm2 n A) → ((OpSemigroupTerm2 n A) → (OpSemigroupTerm2 n A)))  
      
  simplifyCl :  {A : Set} →  ((ClSemigroupTerm A) → (ClSemigroupTerm A)) 
  simplifyCl (opCl x1 x2) = (opCl (simplifyCl x1) (simplifyCl x2))  
  simplifyCl (sing x1) = (sing x1)  
  simplifyOpB :  {n : Nat} →  ((OpSemigroupTerm n) → (OpSemigroupTerm n)) 
  simplifyOpB (opOL x1 x2) = (opOL (simplifyOpB x1) (simplifyOpB x2))  
  simplifyOpB (v x1) = (v x1)  
  simplifyOp :  {n : Nat} {A : Set} →  ((OpSemigroupTerm2 n A) → (OpSemigroupTerm2 n A)) 
  simplifyOp (opOL2 x1 x2) = (opOL2 (simplifyOp x1) (simplifyOp x2))  
  simplifyOp (v2 x1) = (v2 x1)  
  simplifyOp (sing2 x1) = (sing2 x1)  
  evalB :  {A : Set} →  ((Semigroup A) → (SemigroupTerm → A)) 
  evalB Se (opL x1 x2) = ((op Se) (evalB Se x1) (evalB Se x2))  
  evalCl :  {A : Set} →  ((Semigroup A) → ((ClSemigroupTerm A) → A)) 
  evalCl Se (sing x1) = x1  
  evalCl Se (opCl x1 x2) = ((op Se) (evalCl Se x1) (evalCl Se x2))  
  evalOpB :  {A : Set} {n : Nat} →  ((Semigroup A) → ((Vec A n) → ((OpSemigroupTerm n) → A))) 
  evalOpB Se vars (v x1) = (lookup vars x1)  
  evalOpB Se vars (opOL x1 x2) = ((op Se) (evalOpB Se vars x1) (evalOpB Se vars x2))  
  evalOp :  {A : Set} {n : Nat} →  ((Semigroup A) → ((Vec A n) → ((OpSemigroupTerm2 n A) → A))) 
  evalOp Se vars (v2 x1) = (lookup vars x1)  
  evalOp Se vars (sing2 x1) = x1  
  evalOp Se vars (opOL2 x1 x2) = ((op Se) (evalOp Se vars x1) (evalOp Se vars x2))  
  inductionB :  {P : (SemigroupTerm → Set)} →  (( (x1 x2 : SemigroupTerm) → ((P x1) → ((P x2) → (P (opL x1 x2))))) → ( (x : SemigroupTerm) → (P x))) 
  inductionB popl (opL x1 x2) = (popl _ _ (inductionB popl x1) (inductionB popl x2))  
  inductionCl :  {A : Set} {P : ((ClSemigroupTerm A) → Set)} →  (( (x1 : A) → (P (sing x1))) → (( (x1 x2 : (ClSemigroupTerm A)) → ((P x1) → ((P x2) → (P (opCl x1 x2))))) → ( (x : (ClSemigroupTerm A)) → (P x)))) 
  inductionCl psing popcl (sing x1) = (psing x1)  
  inductionCl psing popcl (opCl x1 x2) = (popcl _ _ (inductionCl psing popcl x1) (inductionCl psing popcl x2))  
  inductionOpB :  {n : Nat} {P : ((OpSemigroupTerm n) → Set)} →  (( (fin : (Fin n)) → (P (v fin))) → (( (x1 x2 : (OpSemigroupTerm n)) → ((P x1) → ((P x2) → (P (opOL x1 x2))))) → ( (x : (OpSemigroupTerm n)) → (P x)))) 
  inductionOpB pv popol (v x1) = (pv x1)  
  inductionOpB pv popol (opOL x1 x2) = (popol _ _ (inductionOpB pv popol x1) (inductionOpB pv popol x2))  
  inductionOp :  {n : Nat} {A : Set} {P : ((OpSemigroupTerm2 n A) → Set)} →  (( (fin : (Fin n)) → (P (v2 fin))) → (( (x1 : A) → (P (sing2 x1))) → (( (x1 x2 : (OpSemigroupTerm2 n A)) → ((P x1) → ((P x2) → (P (opOL2 x1 x2))))) → ( (x : (OpSemigroupTerm2 n A)) → (P x))))) 
  inductionOp pv2 psing2 popol2 (v2 x1) = (pv2 x1)  
  inductionOp pv2 psing2 popol2 (sing2 x1) = (psing2 x1)  
  inductionOp pv2 psing2 popol2 (opOL2 x1 x2) = (popol2 _ _ (inductionOp pv2 psing2 popol2 x1) (inductionOp pv2 psing2 popol2 x2))  
  stageB :  (SemigroupTerm → (Staged SemigroupTerm))
  stageB (opL x1 x2) = (stage2 opL (codeLift2 opL) (stageB x1) (stageB x2))  
  stageCl :  {A : Set} →  ((ClSemigroupTerm A) → (Staged (ClSemigroupTerm A))) 
  stageCl (sing x1) = (Now (sing x1))  
  stageCl (opCl x1 x2) = (stage2 opCl (codeLift2 opCl) (stageCl x1) (stageCl x2))  
  stageOpB :  {n : Nat} →  ((OpSemigroupTerm n) → (Staged (OpSemigroupTerm n))) 
  stageOpB (v x1) = (const (code (v x1)))  
  stageOpB (opOL x1 x2) = (stage2 opOL (codeLift2 opOL) (stageOpB x1) (stageOpB x2))  
  stageOp :  {n : Nat} {A : Set} →  ((OpSemigroupTerm2 n A) → (Staged (OpSemigroupTerm2 n A))) 
  stageOp (sing2 x1) = (Now (sing2 x1))  
  stageOp (v2 x1) = (const (code (v2 x1)))  
  stageOp (opOL2 x1 x2) = (stage2 opOL2 (codeLift2 opOL2) (stageOp x1) (stageOp x2))  
  record StagedRepr  (A : Set) (Repr : (Set → Set)) : Set where 
     field  
      opT : ((Repr A) → ((Repr A) → (Repr A)))  
  
 