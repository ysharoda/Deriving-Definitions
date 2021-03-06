
module LeftInverseMagma   where
  open import Prelude
  open import Agda.Builtin.Equality
  open import Agda.Builtin.Nat
  open import Data.Fin
  open import Data.Vec
  record IsLeftInverseMagma  (A : Set) (linv : (A → (A → A))) : Set where 
    
  record LeftInverseMagma  (A : Set) : Set where 
     field  
      linv : (A → (A → A)) 
      isLeftInverseMagma : (IsLeftInverseMagma A linv)  
  
  open LeftInverseMagma
  record Sig  (AS : Set) : Set where 
     field  
      linvS : (AS → (AS → AS))  
  
  record Product  (A : Set) : Set where 
     field  
      linvP : ((Prod A A) → ((Prod A A) → (Prod A A)))  
  
  record Hom  {A1 : Set} {A2 : Set} (Le1 : (LeftInverseMagma A1)) (Le2 : (LeftInverseMagma A2)) : Set where 
     field  
      hom : (A1 → A2) 
      pres-linv : ( {x1 x2 : A1} → (hom ((linv Le1) x1 x2)) ≡ ((linv Le2) (hom x1) (hom x2)))  
  
  record RelInterp  {A1 : Set} {A2 : Set} (Le1 : (LeftInverseMagma A1)) (Le2 : (LeftInverseMagma A2)) : Set₁ where 
     field  
      interp : (A1 → (A2 → Set)) 
      interp-linv : ( {x1 x2 : A1} {y1 y2 : A2} → ((interp x1 y1) → ((interp x2 y2) → (interp ((linv Le1) x1 x2) ((linv Le2) y1 y2)))))  
  
  data LeftInverseMagmaTerm   : Set where 
      linvL : (LeftInverseMagmaTerm → (LeftInverseMagmaTerm → LeftInverseMagmaTerm))  
      
  data ClLeftInverseMagmaTerm  (A : Set) : Set where 
      sing : (A → (ClLeftInverseMagmaTerm A)) 
      linvCl : ((ClLeftInverseMagmaTerm A) → ((ClLeftInverseMagmaTerm A) → (ClLeftInverseMagmaTerm A)))  
      
  data OpLeftInverseMagmaTerm  (n : Nat) : Set where 
      v : ((Fin n) → (OpLeftInverseMagmaTerm n)) 
      linvOL : ((OpLeftInverseMagmaTerm n) → ((OpLeftInverseMagmaTerm n) → (OpLeftInverseMagmaTerm n)))  
      
  data OpLeftInverseMagmaTerm2  (n : Nat) (A : Set) : Set where 
      v2 : ((Fin n) → (OpLeftInverseMagmaTerm2 n A)) 
      sing2 : (A → (OpLeftInverseMagmaTerm2 n A)) 
      linvOL2 : ((OpLeftInverseMagmaTerm2 n A) → ((OpLeftInverseMagmaTerm2 n A) → (OpLeftInverseMagmaTerm2 n A)))  
      
  simplifyCl :  {A : Set} →  ((ClLeftInverseMagmaTerm A) → (ClLeftInverseMagmaTerm A)) 
  simplifyCl (linvCl x1 x2) = (linvCl (simplifyCl x1) (simplifyCl x2))  
  simplifyCl (sing x1) = (sing x1)  
  simplifyOpB :  {n : Nat} →  ((OpLeftInverseMagmaTerm n) → (OpLeftInverseMagmaTerm n)) 
  simplifyOpB (linvOL x1 x2) = (linvOL (simplifyOpB x1) (simplifyOpB x2))  
  simplifyOpB (v x1) = (v x1)  
  simplifyOp :  {n : Nat} {A : Set} →  ((OpLeftInverseMagmaTerm2 n A) → (OpLeftInverseMagmaTerm2 n A)) 
  simplifyOp (linvOL2 x1 x2) = (linvOL2 (simplifyOp x1) (simplifyOp x2))  
  simplifyOp (v2 x1) = (v2 x1)  
  simplifyOp (sing2 x1) = (sing2 x1)  
  evalB :  {A : Set} →  ((LeftInverseMagma A) → (LeftInverseMagmaTerm → A)) 
  evalB Le (linvL x1 x2) = ((linv Le) (evalB Le x1) (evalB Le x2))  
  evalCl :  {A : Set} →  ((LeftInverseMagma A) → ((ClLeftInverseMagmaTerm A) → A)) 
  evalCl Le (sing x1) = x1  
  evalCl Le (linvCl x1 x2) = ((linv Le) (evalCl Le x1) (evalCl Le x2))  
  evalOpB :  {A : Set} {n : Nat} →  ((LeftInverseMagma A) → ((Vec A n) → ((OpLeftInverseMagmaTerm n) → A))) 
  evalOpB Le vars (v x1) = (lookup vars x1)  
  evalOpB Le vars (linvOL x1 x2) = ((linv Le) (evalOpB Le vars x1) (evalOpB Le vars x2))  
  evalOp :  {A : Set} {n : Nat} →  ((LeftInverseMagma A) → ((Vec A n) → ((OpLeftInverseMagmaTerm2 n A) → A))) 
  evalOp Le vars (v2 x1) = (lookup vars x1)  
  evalOp Le vars (sing2 x1) = x1  
  evalOp Le vars (linvOL2 x1 x2) = ((linv Le) (evalOp Le vars x1) (evalOp Le vars x2))  
  inductionB :  {P : (LeftInverseMagmaTerm → Set)} →  (( (x1 x2 : LeftInverseMagmaTerm) → ((P x1) → ((P x2) → (P (linvL x1 x2))))) → ( (x : LeftInverseMagmaTerm) → (P x))) 
  inductionB plinvl (linvL x1 x2) = (plinvl _ _ (inductionB plinvl x1) (inductionB plinvl x2))  
  inductionCl :  {A : Set} {P : ((ClLeftInverseMagmaTerm A) → Set)} →  (( (x1 : A) → (P (sing x1))) → (( (x1 x2 : (ClLeftInverseMagmaTerm A)) → ((P x1) → ((P x2) → (P (linvCl x1 x2))))) → ( (x : (ClLeftInverseMagmaTerm A)) → (P x)))) 
  inductionCl psing plinvcl (sing x1) = (psing x1)  
  inductionCl psing plinvcl (linvCl x1 x2) = (plinvcl _ _ (inductionCl psing plinvcl x1) (inductionCl psing plinvcl x2))  
  inductionOpB :  {n : Nat} {P : ((OpLeftInverseMagmaTerm n) → Set)} →  (( (fin : (Fin n)) → (P (v fin))) → (( (x1 x2 : (OpLeftInverseMagmaTerm n)) → ((P x1) → ((P x2) → (P (linvOL x1 x2))))) → ( (x : (OpLeftInverseMagmaTerm n)) → (P x)))) 
  inductionOpB pv plinvol (v x1) = (pv x1)  
  inductionOpB pv plinvol (linvOL x1 x2) = (plinvol _ _ (inductionOpB pv plinvol x1) (inductionOpB pv plinvol x2))  
  inductionOp :  {n : Nat} {A : Set} {P : ((OpLeftInverseMagmaTerm2 n A) → Set)} →  (( (fin : (Fin n)) → (P (v2 fin))) → (( (x1 : A) → (P (sing2 x1))) → (( (x1 x2 : (OpLeftInverseMagmaTerm2 n A)) → ((P x1) → ((P x2) → (P (linvOL2 x1 x2))))) → ( (x : (OpLeftInverseMagmaTerm2 n A)) → (P x))))) 
  inductionOp pv2 psing2 plinvol2 (v2 x1) = (pv2 x1)  
  inductionOp pv2 psing2 plinvol2 (sing2 x1) = (psing2 x1)  
  inductionOp pv2 psing2 plinvol2 (linvOL2 x1 x2) = (plinvol2 _ _ (inductionOp pv2 psing2 plinvol2 x1) (inductionOp pv2 psing2 plinvol2 x2))  
  stageB :  (LeftInverseMagmaTerm → (Staged LeftInverseMagmaTerm))
  stageB (linvL x1 x2) = (stage2 linvL (codeLift2 linvL) (stageB x1) (stageB x2))  
  stageCl :  {A : Set} →  ((ClLeftInverseMagmaTerm A) → (Staged (ClLeftInverseMagmaTerm A))) 
  stageCl (sing x1) = (Now (sing x1))  
  stageCl (linvCl x1 x2) = (stage2 linvCl (codeLift2 linvCl) (stageCl x1) (stageCl x2))  
  stageOpB :  {n : Nat} →  ((OpLeftInverseMagmaTerm n) → (Staged (OpLeftInverseMagmaTerm n))) 
  stageOpB (v x1) = (const (code (v x1)))  
  stageOpB (linvOL x1 x2) = (stage2 linvOL (codeLift2 linvOL) (stageOpB x1) (stageOpB x2))  
  stageOp :  {n : Nat} {A : Set} →  ((OpLeftInverseMagmaTerm2 n A) → (Staged (OpLeftInverseMagmaTerm2 n A))) 
  stageOp (sing2 x1) = (Now (sing2 x1))  
  stageOp (v2 x1) = (const (code (v2 x1)))  
  stageOp (linvOL2 x1 x2) = (stage2 linvOL2 (codeLift2 linvOL2) (stageOp x1) (stageOp x2))  
  record StagedRepr  (A : Set) (Repr : (Set → Set)) : Set where 
     field  
      linvT : ((Repr A) → ((Repr A) → (Repr A)))  
  
 