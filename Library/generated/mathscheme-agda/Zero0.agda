
module Zero0   where
  open import Prelude
  open import Agda.Builtin.Equality
  open import Agda.Builtin.Nat
  open import Data.Fin
  open import Data.Vec
  record Zero0  (A : Set) : Set where 
     field  
      0ᵢ : A 
      * : (A → (A → A)) 
      leftZero_op_0ᵢ : ( {x : A} → (* 0ᵢ x) ≡ 0ᵢ) 
      rightZero_op_0ᵢ : ( {x : A} → (* x 0ᵢ) ≡ 0ᵢ)  
  
  open Zero0
  record Sig  (AS : Set) : Set where 
     field  
      0S : AS 
      *S : (AS → (AS → AS))  
  
  record Product  (A : Set) : Set where 
     field  
      0P : (Prod A A) 
      *P : ((Prod A A) → ((Prod A A) → (Prod A A))) 
      leftZero_op_0P : ( {xP : (Prod A A)} → (*P 0P xP) ≡ 0P) 
      rightZero_op_0P : ( {xP : (Prod A A)} → (*P xP 0P) ≡ 0P)  
  
  record Hom  {A1 : Set} {A2 : Set} (Ze1 : (Zero0 A1)) (Ze2 : (Zero0 A2)) : Set where 
     field  
      hom : (A1 → A2) 
      pres-0 : (hom (0ᵢ Ze1)) ≡ (0ᵢ Ze2) 
      pres-* : ( {x1 x2 : A1} → (hom ((* Ze1) x1 x2)) ≡ ((* Ze2) (hom x1) (hom x2)))  
  
  record RelInterp  {A1 : Set} {A2 : Set} (Ze1 : (Zero0 A1)) (Ze2 : (Zero0 A2)) : Set₁ where 
     field  
      interp : (A1 → (A2 → Set)) 
      interp-0 : (interp (0ᵢ Ze1) (0ᵢ Ze2)) 
      interp-* : ( {x1 x2 : A1} {y1 y2 : A2} → ((interp x1 y1) → ((interp x2 y2) → (interp ((* Ze1) x1 x2) ((* Ze2) y1 y2)))))  
  
  data Zero0LTerm   : Set where 
      0L : Zero0LTerm 
      *L : (Zero0LTerm → (Zero0LTerm → Zero0LTerm))  
      
  data ClZero0ClTerm  (A : Set) : Set where 
      sing : (A → (ClZero0ClTerm A)) 
      0Cl : (ClZero0ClTerm A) 
      *Cl : ((ClZero0ClTerm A) → ((ClZero0ClTerm A) → (ClZero0ClTerm A)))  
      
  data OpZero0OLTerm  (n : Nat) : Set where 
      v : ((Fin n) → (OpZero0OLTerm n)) 
      0OL : (OpZero0OLTerm n) 
      *OL : ((OpZero0OLTerm n) → ((OpZero0OLTerm n) → (OpZero0OLTerm n)))  
      
  data OpZero0OL2Term2  (n : Nat) (A : Set) : Set where 
      v2 : ((Fin n) → (OpZero0OL2Term2 n A)) 
      sing2 : (A → (OpZero0OL2Term2 n A)) 
      0OL2 : (OpZero0OL2Term2 n A) 
      *OL2 : ((OpZero0OL2Term2 n A) → ((OpZero0OL2Term2 n A) → (OpZero0OL2Term2 n A)))  
      
  simplifyCl :  (A : Set) →  ((ClZero0ClTerm A) → (ClZero0ClTerm A)) 
  simplifyCl _ 0Cl = 0Cl  
  simplifyCl _ (*Cl x1 x2) = (*Cl (simplifyCl _ x1) (simplifyCl _ x2))  
  simplifyCl _ (sing x1) = (sing x1)  
  simplifyOpB :  (n : Nat) →  ((OpZero0OLTerm n) → (OpZero0OLTerm n)) 
  simplifyOpB _ 0OL = 0OL  
  simplifyOpB _ (*OL x1 x2) = (*OL (simplifyOpB _ x1) (simplifyOpB _ x2))  
  simplifyOpB _ (v x1) = (v x1)  
  simplifyOp :  (n : Nat) (A : Set) →  ((OpZero0OL2Term2 n A) → (OpZero0OL2Term2 n A)) 
  simplifyOp _ _ 0OL2 = 0OL2  
  simplifyOp _ _ (*OL2 x1 x2) = (*OL2 (simplifyOp _ _ x1) (simplifyOp _ _ x2))  
  simplifyOp _ _ (v2 x1) = (v2 x1)  
  simplifyOp _ _ (sing2 x1) = (sing2 x1)  
  evalB :  {A : Set} →  ((Zero0 A) → (Zero0LTerm → A)) 
  evalB Ze 0L = (0ᵢ Ze)  
  evalB Ze (*L x1 x2) = ((* Ze) (evalB Ze x1) (evalB Ze x2))  
  evalCl :  {A : Set} →  ((Zero0 A) → ((ClZero0ClTerm A) → A)) 
  evalCl Ze (sing x1) = x1  
  evalCl Ze 0Cl = (0ᵢ Ze)  
  evalCl Ze (*Cl x1 x2) = ((* Ze) (evalCl Ze x1) (evalCl Ze x2))  
  evalOpB :  {A : Set} (n : Nat) →  ((Zero0 A) → ((Vec A n) → ((OpZero0OLTerm n) → A))) 
  evalOpB n Ze vars (v x1) = (lookup vars x1)  
  evalOpB n Ze vars 0OL = (0ᵢ Ze)  
  evalOpB n Ze vars (*OL x1 x2) = ((* Ze) (evalOpB n Ze vars x1) (evalOpB n Ze vars x2))  
  evalOp :  {A : Set} (n : Nat) →  ((Zero0 A) → ((Vec A n) → ((OpZero0OL2Term2 n A) → A))) 
  evalOp n Ze vars (v2 x1) = (lookup vars x1)  
  evalOp n Ze vars (sing2 x1) = x1  
  evalOp n Ze vars 0OL2 = (0ᵢ Ze)  
  evalOp n Ze vars (*OL2 x1 x2) = ((* Ze) (evalOp n Ze vars x1) (evalOp n Ze vars x2))  
  inductionB :  (P : (Zero0LTerm → Set)) →  ((P 0L) → (( (x1 x2 : Zero0LTerm) → ((P x1) → ((P x2) → (P (*L x1 x2))))) → ( (x : Zero0LTerm) → (P x)))) 
  inductionB p p0l p*l 0L = p0l  
  inductionB p p0l p*l (*L x1 x2) = (p*l _ _ (inductionB p p0l p*l x1) (inductionB p p0l p*l x2))  
  inductionCl :  (A : Set) (P : ((ClZero0ClTerm A) → Set)) →  (( (x1 : A) → (P (sing x1))) → ((P 0Cl) → (( (x1 x2 : (ClZero0ClTerm A)) → ((P x1) → ((P x2) → (P (*Cl x1 x2))))) → ( (x : (ClZero0ClTerm A)) → (P x))))) 
  inductionCl _ p psing p0cl p*cl (sing x1) = (psing x1)  
  inductionCl _ p psing p0cl p*cl 0Cl = p0cl  
  inductionCl _ p psing p0cl p*cl (*Cl x1 x2) = (p*cl _ _ (inductionCl _ p psing p0cl p*cl x1) (inductionCl _ p psing p0cl p*cl x2))  
  inductionOpB :  (n : Nat) (P : ((OpZero0OLTerm n) → Set)) →  (( (fin : (Fin n)) → (P (v fin))) → ((P 0OL) → (( (x1 x2 : (OpZero0OLTerm n)) → ((P x1) → ((P x2) → (P (*OL x1 x2))))) → ( (x : (OpZero0OLTerm n)) → (P x))))) 
  inductionOpB _ p pv p0ol p*ol (v x1) = (pv x1)  
  inductionOpB _ p pv p0ol p*ol 0OL = p0ol  
  inductionOpB _ p pv p0ol p*ol (*OL x1 x2) = (p*ol _ _ (inductionOpB _ p pv p0ol p*ol x1) (inductionOpB _ p pv p0ol p*ol x2))  
  inductionOp :  (n : Nat) (A : Set) (P : ((OpZero0OL2Term2 n A) → Set)) →  (( (fin : (Fin n)) → (P (v2 fin))) → (( (x1 : A) → (P (sing2 x1))) → ((P 0OL2) → (( (x1 x2 : (OpZero0OL2Term2 n A)) → ((P x1) → ((P x2) → (P (*OL2 x1 x2))))) → ( (x : (OpZero0OL2Term2 n A)) → (P x)))))) 
  inductionOp _ _ p pv2 psing2 p0ol2 p*ol2 (v2 x1) = (pv2 x1)  
  inductionOp _ _ p pv2 psing2 p0ol2 p*ol2 (sing2 x1) = (psing2 x1)  
  inductionOp _ _ p pv2 psing2 p0ol2 p*ol2 0OL2 = p0ol2  
  inductionOp _ _ p pv2 psing2 p0ol2 p*ol2 (*OL2 x1 x2) = (p*ol2 _ _ (inductionOp _ _ p pv2 psing2 p0ol2 p*ol2 x1) (inductionOp _ _ p pv2 psing2 p0ol2 p*ol2 x2))  
  stageB :  (Zero0LTerm → (Staged Zero0LTerm))
  stageB 0L = (Now 0L)  
  stageB (*L x1 x2) = (stage2 *L (codeLift2 *L) (stageB x1) (stageB x2))  
  stageCl :  (A : Set) →  ((ClZero0ClTerm A) → (Staged (ClZero0ClTerm A))) 
  stageCl _ (sing x1) = (Now (sing x1))  
  stageCl _ 0Cl = (Now 0Cl)  
  stageCl _ (*Cl x1 x2) = (stage2 *Cl (codeLift2 *Cl) (stageCl _ x1) (stageCl _ x2))  
  stageOpB :  (n : Nat) →  ((OpZero0OLTerm n) → (Staged (OpZero0OLTerm n))) 
  stageOpB _ (v x1) = (const (code (v x1)))  
  stageOpB _ 0OL = (Now 0OL)  
  stageOpB _ (*OL x1 x2) = (stage2 *OL (codeLift2 *OL) (stageOpB _ x1) (stageOpB _ x2))  
  stageOp :  (n : Nat) (A : Set) →  ((OpZero0OL2Term2 n A) → (Staged (OpZero0OL2Term2 n A))) 
  stageOp _ _ (sing2 x1) = (Now (sing2 x1))  
  stageOp _ _ (v2 x1) = (const (code (v2 x1)))  
  stageOp _ _ 0OL2 = (Now 0OL2)  
  stageOp _ _ (*OL2 x1 x2) = (stage2 *OL2 (codeLift2 *OL2) (stageOp _ _ x1) (stageOp _ _ x2))  
  record StagedRepr  (A : Set) (Repr : (Set → Set)) : Set where 
     field  
      0T : (Repr A) 
      *T : ((Repr A) → ((Repr A) → (Repr A)))  
  
 