
module CancellativeMonoid   where
  open import Prelude
  open import Agda.Builtin.Equality
  open import Agda.Builtin.Nat
  open import Data.Fin
  open import Data.Vec
  record IsCancellativeMonoid  (A : Set) (op : (A → (A → A))) (e : A) : Set where 
     field  
      lunit_e : ( {x : A} → (op e x) ≡ x) 
      runit_e : ( {x : A} → (op x e) ≡ x) 
      associative_op : ( {x y z : A} → (op (op x y) z) ≡ (op x (op y z))) 
      leftCancellative : ( {x y z : A} → ((op z x) ≡ (op z y) → x ≡ y)) 
      rightCancellative : ( {x y z : A} → ((op x z) ≡ (op y z) → x ≡ y))  
  
  record CancellativeMonoid  (A : Set) : Set where 
     field  
      op : (A → (A → A)) 
      e : A 
      isCancellativeMonoid : (IsCancellativeMonoid A op e)  
  
  open CancellativeMonoid
  record Sig  (AS : Set) : Set where 
     field  
      opS : (AS → (AS → AS)) 
      eS : AS  
  
  record Product  (A : Set) : Set where 
     field  
      opP : ((Prod A A) → ((Prod A A) → (Prod A A))) 
      eP : (Prod A A) 
      lunit_eP : ( {xP : (Prod A A)} → (opP eP xP) ≡ xP) 
      runit_eP : ( {xP : (Prod A A)} → (opP xP eP) ≡ xP) 
      associative_opP : ( {xP yP zP : (Prod A A)} → (opP (opP xP yP) zP) ≡ (opP xP (opP yP zP))) 
      leftCancellativeP : ( {xP yP zP : (Prod A A)} → ((opP zP xP) ≡ (opP zP yP) → xP ≡ yP)) 
      rightCancellativeP : ( {xP yP zP : (Prod A A)} → ((opP xP zP) ≡ (opP yP zP) → xP ≡ yP))  
  
  record Hom  {A1 : Set} {A2 : Set} (Ca1 : (CancellativeMonoid A1)) (Ca2 : (CancellativeMonoid A2)) : Set where 
     field  
      hom : (A1 → A2) 
      pres-op : ( {x1 x2 : A1} → (hom ((op Ca1) x1 x2)) ≡ ((op Ca2) (hom x1) (hom x2))) 
      pres-e : (hom (e Ca1)) ≡ (e Ca2)  
  
  record RelInterp  {A1 : Set} {A2 : Set} (Ca1 : (CancellativeMonoid A1)) (Ca2 : (CancellativeMonoid A2)) : Set₁ where 
     field  
      interp : (A1 → (A2 → Set)) 
      interp-op : ( {x1 x2 : A1} {y1 y2 : A2} → ((interp x1 y1) → ((interp x2 y2) → (interp ((op Ca1) x1 x2) ((op Ca2) y1 y2))))) 
      interp-e : (interp (e Ca1) (e Ca2))  
  
  data CancellativeMonoidTerm   : Set where 
      opL : (CancellativeMonoidTerm → (CancellativeMonoidTerm → CancellativeMonoidTerm)) 
      eL : CancellativeMonoidTerm  
      
  data ClCancellativeMonoidTerm  (A : Set) : Set where 
      sing : (A → (ClCancellativeMonoidTerm A)) 
      opCl : ((ClCancellativeMonoidTerm A) → ((ClCancellativeMonoidTerm A) → (ClCancellativeMonoidTerm A))) 
      eCl : (ClCancellativeMonoidTerm A)  
      
  data OpCancellativeMonoidTerm  (n : Nat) : Set where 
      v : ((Fin n) → (OpCancellativeMonoidTerm n)) 
      opOL : ((OpCancellativeMonoidTerm n) → ((OpCancellativeMonoidTerm n) → (OpCancellativeMonoidTerm n))) 
      eOL : (OpCancellativeMonoidTerm n)  
      
  data OpCancellativeMonoidTerm2  (n : Nat) (A : Set) : Set where 
      v2 : ((Fin n) → (OpCancellativeMonoidTerm2 n A)) 
      sing2 : (A → (OpCancellativeMonoidTerm2 n A)) 
      opOL2 : ((OpCancellativeMonoidTerm2 n A) → ((OpCancellativeMonoidTerm2 n A) → (OpCancellativeMonoidTerm2 n A))) 
      eOL2 : (OpCancellativeMonoidTerm2 n A)  
      
  simplifyCl :  {A : Set} →  ((ClCancellativeMonoidTerm A) → (ClCancellativeMonoidTerm A)) 
  simplifyCl (opCl eCl x) = x  
  simplifyCl (opCl x eCl) = x  
  simplifyCl (opCl x1 x2) = (opCl (simplifyCl x1) (simplifyCl x2))  
  simplifyCl eCl = eCl  
  simplifyCl (sing x1) = (sing x1)  
  simplifyOpB :  {n : Nat} →  ((OpCancellativeMonoidTerm n) → (OpCancellativeMonoidTerm n)) 
  simplifyOpB (opOL eOL x) = x  
  simplifyOpB (opOL x eOL) = x  
  simplifyOpB (opOL x1 x2) = (opOL (simplifyOpB x1) (simplifyOpB x2))  
  simplifyOpB eOL = eOL  
  simplifyOpB (v x1) = (v x1)  
  simplifyOp :  {n : Nat} {A : Set} →  ((OpCancellativeMonoidTerm2 n A) → (OpCancellativeMonoidTerm2 n A)) 
  simplifyOp (opOL2 eOL2 x) = x  
  simplifyOp (opOL2 x eOL2) = x  
  simplifyOp (opOL2 x1 x2) = (opOL2 (simplifyOp x1) (simplifyOp x2))  
  simplifyOp eOL2 = eOL2  
  simplifyOp (v2 x1) = (v2 x1)  
  simplifyOp (sing2 x1) = (sing2 x1)  
  evalB :  {A : Set} →  ((CancellativeMonoid A) → (CancellativeMonoidTerm → A)) 
  evalB Ca (opL x1 x2) = ((op Ca) (evalB Ca x1) (evalB Ca x2))  
  evalB Ca eL = (e Ca)  
  evalCl :  {A : Set} →  ((CancellativeMonoid A) → ((ClCancellativeMonoidTerm A) → A)) 
  evalCl Ca (sing x1) = x1  
  evalCl Ca (opCl x1 x2) = ((op Ca) (evalCl Ca x1) (evalCl Ca x2))  
  evalCl Ca eCl = (e Ca)  
  evalOpB :  {A : Set} {n : Nat} →  ((CancellativeMonoid A) → ((Vec A n) → ((OpCancellativeMonoidTerm n) → A))) 
  evalOpB Ca vars (v x1) = (lookup vars x1)  
  evalOpB Ca vars (opOL x1 x2) = ((op Ca) (evalOpB Ca vars x1) (evalOpB Ca vars x2))  
  evalOpB Ca vars eOL = (e Ca)  
  evalOp :  {A : Set} {n : Nat} →  ((CancellativeMonoid A) → ((Vec A n) → ((OpCancellativeMonoidTerm2 n A) → A))) 
  evalOp Ca vars (v2 x1) = (lookup vars x1)  
  evalOp Ca vars (sing2 x1) = x1  
  evalOp Ca vars (opOL2 x1 x2) = ((op Ca) (evalOp Ca vars x1) (evalOp Ca vars x2))  
  evalOp Ca vars eOL2 = (e Ca)  
  inductionB :  {P : (CancellativeMonoidTerm → Set)} →  (( (x1 x2 : CancellativeMonoidTerm) → ((P x1) → ((P x2) → (P (opL x1 x2))))) → ((P eL) → ( (x : CancellativeMonoidTerm) → (P x)))) 
  inductionB popl pel (opL x1 x2) = (popl _ _ (inductionB popl pel x1) (inductionB popl pel x2))  
  inductionB popl pel eL = pel  
  inductionCl :  {A : Set} {P : ((ClCancellativeMonoidTerm A) → Set)} →  (( (x1 : A) → (P (sing x1))) → (( (x1 x2 : (ClCancellativeMonoidTerm A)) → ((P x1) → ((P x2) → (P (opCl x1 x2))))) → ((P eCl) → ( (x : (ClCancellativeMonoidTerm A)) → (P x))))) 
  inductionCl psing popcl pecl (sing x1) = (psing x1)  
  inductionCl psing popcl pecl (opCl x1 x2) = (popcl _ _ (inductionCl psing popcl pecl x1) (inductionCl psing popcl pecl x2))  
  inductionCl psing popcl pecl eCl = pecl  
  inductionOpB :  {n : Nat} {P : ((OpCancellativeMonoidTerm n) → Set)} →  (( (fin : (Fin n)) → (P (v fin))) → (( (x1 x2 : (OpCancellativeMonoidTerm n)) → ((P x1) → ((P x2) → (P (opOL x1 x2))))) → ((P eOL) → ( (x : (OpCancellativeMonoidTerm n)) → (P x))))) 
  inductionOpB pv popol peol (v x1) = (pv x1)  
  inductionOpB pv popol peol (opOL x1 x2) = (popol _ _ (inductionOpB pv popol peol x1) (inductionOpB pv popol peol x2))  
  inductionOpB pv popol peol eOL = peol  
  inductionOp :  {n : Nat} {A : Set} {P : ((OpCancellativeMonoidTerm2 n A) → Set)} →  (( (fin : (Fin n)) → (P (v2 fin))) → (( (x1 : A) → (P (sing2 x1))) → (( (x1 x2 : (OpCancellativeMonoidTerm2 n A)) → ((P x1) → ((P x2) → (P (opOL2 x1 x2))))) → ((P eOL2) → ( (x : (OpCancellativeMonoidTerm2 n A)) → (P x)))))) 
  inductionOp pv2 psing2 popol2 peol2 (v2 x1) = (pv2 x1)  
  inductionOp pv2 psing2 popol2 peol2 (sing2 x1) = (psing2 x1)  
  inductionOp pv2 psing2 popol2 peol2 (opOL2 x1 x2) = (popol2 _ _ (inductionOp pv2 psing2 popol2 peol2 x1) (inductionOp pv2 psing2 popol2 peol2 x2))  
  inductionOp pv2 psing2 popol2 peol2 eOL2 = peol2  
  stageB :  (CancellativeMonoidTerm → (Staged CancellativeMonoidTerm))
  stageB (opL x1 x2) = (stage2 opL (codeLift2 opL) (stageB x1) (stageB x2))  
  stageB eL = (Now eL)  
  stageCl :  {A : Set} →  ((ClCancellativeMonoidTerm A) → (Staged (ClCancellativeMonoidTerm A))) 
  stageCl (sing x1) = (Now (sing x1))  
  stageCl (opCl x1 x2) = (stage2 opCl (codeLift2 opCl) (stageCl x1) (stageCl x2))  
  stageCl eCl = (Now eCl)  
  stageOpB :  {n : Nat} →  ((OpCancellativeMonoidTerm n) → (Staged (OpCancellativeMonoidTerm n))) 
  stageOpB (v x1) = (const (code (v x1)))  
  stageOpB (opOL x1 x2) = (stage2 opOL (codeLift2 opOL) (stageOpB x1) (stageOpB x2))  
  stageOpB eOL = (Now eOL)  
  stageOp :  {n : Nat} {A : Set} →  ((OpCancellativeMonoidTerm2 n A) → (Staged (OpCancellativeMonoidTerm2 n A))) 
  stageOp (sing2 x1) = (Now (sing2 x1))  
  stageOp (v2 x1) = (const (code (v2 x1)))  
  stageOp (opOL2 x1 x2) = (stage2 opOL2 (codeLift2 opOL2) (stageOp x1) (stageOp x2))  
  stageOp eOL2 = (Now eOL2)  
  record StagedRepr  (A : Set) (Repr : (Set → Set)) : Set where 
     field  
      opT : ((Repr A) → ((Repr A) → (Repr A))) 
      eT : (Repr A)  
  
 