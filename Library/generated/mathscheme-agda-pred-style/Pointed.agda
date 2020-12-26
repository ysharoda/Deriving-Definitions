
module Pointed   where
  open import Prelude
  open import Agda.Builtin.Equality
  open import Agda.Builtin.Nat
  open import Data.Fin
  open import Data.Vec
  record IsPointed  (A : Set) (e : A) : Set where 
    
  record Pointed  (A : Set) : Set where 
     field  
      e : A 
      isPointed : (IsPointed A e)  
  
  open Pointed
  record Sig  (AS : Set) : Set where 
     field  
      eS : AS  
  
  record Product  (A : Set) : Set where 
     field  
      eP : (Prod A A)  
  
  record Hom  {A1 : Set} {A2 : Set} (Po1 : (Pointed A1)) (Po2 : (Pointed A2)) : Set where 
     field  
      hom : (A1 → A2) 
      pres-e : (hom (e Po1)) ≡ (e Po2)  
  
  record RelInterp  {A1 : Set} {A2 : Set} (Po1 : (Pointed A1)) (Po2 : (Pointed A2)) : Set₁ where 
     field  
      interp : (A1 → (A2 → Set)) 
      interp-e : (interp (e Po1) (e Po2))  
  
  data PointedTerm   : Set where 
      eL : PointedTerm  
      
  data ClPointedTerm  (A : Set) : Set where 
      sing : (A → (ClPointedTerm A)) 
      eCl : (ClPointedTerm A)  
      
  data OpPointedTerm  (n : Nat) : Set where 
      v : ((Fin n) → (OpPointedTerm n)) 
      eOL : (OpPointedTerm n)  
      
  data OpPointedTerm2  (n : Nat) (A : Set) : Set where 
      v2 : ((Fin n) → (OpPointedTerm2 n A)) 
      sing2 : (A → (OpPointedTerm2 n A)) 
      eOL2 : (OpPointedTerm2 n A)  
      
  simplifyCl :  (A : Set) →  ((ClPointedTerm A) → (ClPointedTerm A)) 
  simplifyCl _ eCl = eCl  
  simplifyCl _ (sing x1) = (sing x1)  
  simplifyOpB :  (n : Nat) →  ((OpPointedTerm n) → (OpPointedTerm n)) 
  simplifyOpB _ eOL = eOL  
  simplifyOpB _ (v x1) = (v x1)  
  simplifyOp :  (n : Nat) (A : Set) →  ((OpPointedTerm2 n A) → (OpPointedTerm2 n A)) 
  simplifyOp _ _ eOL2 = eOL2  
  simplifyOp _ _ (v2 x1) = (v2 x1)  
  simplifyOp _ _ (sing2 x1) = (sing2 x1)  
  evalB :  {A : Set} →  ((Pointed A) → (PointedTerm → A)) 
  evalB Po eL = (e Po)  
  evalCl :  {A : Set} →  ((Pointed A) → ((ClPointedTerm A) → A)) 
  evalCl Po (sing x1) = x1  
  evalCl Po eCl = (e Po)  
  evalOpB :  {A : Set} (n : Nat) →  ((Pointed A) → ((Vec A n) → ((OpPointedTerm n) → A))) 
  evalOpB n Po vars (v x1) = (lookup vars x1)  
  evalOpB n Po vars eOL = (e Po)  
  evalOp :  {A : Set} (n : Nat) →  ((Pointed A) → ((Vec A n) → ((OpPointedTerm2 n A) → A))) 
  evalOp n Po vars (v2 x1) = (lookup vars x1)  
  evalOp n Po vars (sing2 x1) = x1  
  evalOp n Po vars eOL2 = (e Po)  
  inductionB :  (P : (PointedTerm → Set)) →  ((P eL) → ( (x : PointedTerm) → (P x))) 
  inductionB p pel eL = pel  
  inductionCl :  (A : Set) (P : ((ClPointedTerm A) → Set)) →  (( (x1 : A) → (P (sing x1))) → ((P eCl) → ( (x : (ClPointedTerm A)) → (P x)))) 
  inductionCl _ p psing pecl (sing x1) = (psing x1)  
  inductionCl _ p psing pecl eCl = pecl  
  inductionOpB :  (n : Nat) (P : ((OpPointedTerm n) → Set)) →  (( (fin : (Fin n)) → (P (v fin))) → ((P eOL) → ( (x : (OpPointedTerm n)) → (P x)))) 
  inductionOpB _ p pv peol (v x1) = (pv x1)  
  inductionOpB _ p pv peol eOL = peol  
  inductionOp :  (n : Nat) (A : Set) (P : ((OpPointedTerm2 n A) → Set)) →  (( (fin : (Fin n)) → (P (v2 fin))) → (( (x1 : A) → (P (sing2 x1))) → ((P eOL2) → ( (x : (OpPointedTerm2 n A)) → (P x))))) 
  inductionOp _ _ p pv2 psing2 peol2 (v2 x1) = (pv2 x1)  
  inductionOp _ _ p pv2 psing2 peol2 (sing2 x1) = (psing2 x1)  
  inductionOp _ _ p pv2 psing2 peol2 eOL2 = peol2  
  stageB :  (PointedTerm → (Staged PointedTerm))
  stageB eL = (Now eL)  
  stageCl :  (A : Set) →  ((ClPointedTerm A) → (Staged (ClPointedTerm A))) 
  stageCl _ (sing x1) = (Now (sing x1))  
  stageCl _ eCl = (Now eCl)  
  stageOpB :  (n : Nat) →  ((OpPointedTerm n) → (Staged (OpPointedTerm n))) 
  stageOpB _ (v x1) = (const (code (v x1)))  
  stageOpB _ eOL = (Now eOL)  
  stageOp :  (n : Nat) (A : Set) →  ((OpPointedTerm2 n A) → (Staged (OpPointedTerm2 n A))) 
  stageOp _ _ (sing2 x1) = (Now (sing2 x1))  
  stageOp _ _ (v2 x1) = (const (code (v2 x1)))  
  stageOp _ _ eOL2 = (Now eOL2)  
  record StagedRepr  (A : Set) (Repr : (Set → Set)) : Set where 
     field  
      eT : (Repr A)  
  
 