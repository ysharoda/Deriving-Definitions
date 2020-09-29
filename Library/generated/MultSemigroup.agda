
 module MultSemigroup  where
  open import Prelude
  open import Agda.Builtin.Equality
  open import Agda.Builtin.Nat
  open import Data.Fin
  open import Data.Vec
  record MultSemigroup (A  : Set )  : Set where
    constructor MultSemigroupC
    field
      * : (A  → (A  → A ))
      associative_* : ({x y z  : A }  → (* (* x y ) z ) ≡ (* x (* y z ) )) 
  
  open MultSemigroup
  record Sig (AS  : Set )  : Set where
    constructor SigSigC
    field
      *S : (AS  → (AS  → AS )) 
  
  record Product (AP  : Set )  : Set where
    constructor ProductC
    field
      *P : ((Prod AP AP ) → ((Prod AP AP ) → (Prod AP AP )))
      associative_*P : ({xP yP zP  : (Prod AP AP )}  → (*P (*P xP yP ) zP ) ≡ (*P xP (*P yP zP ) )) 
  
  record Hom (A1 A2  : Set ) (Mu1  : (MultSemigroup A1 )) (Mu2  : (MultSemigroup A2 ))  : Set where
    constructor HomC
    field
      hom : (A1 → A2)
      pres-* : ({x1  : A1} {x2  : A1}  → (hom ((* Mu1 ) x1 x2 ) ) ≡ ((* Mu2 ) (hom x1 ) (hom x2 ) )) 
  
  record RelInterp (A1 A2  : Set ) (Mu1  : (MultSemigroup A1 )) (Mu2  : (MultSemigroup A2 ))  : Set₁ where
    constructor RelInterpC
    field
      interp : (A1 → (A2 → Set))
      interp-* : ({x1  : A1} {x2  : A1} {y1  : A2} {y2  : A2}  → ((interp x1 y1 ) → ((interp x2 y2 ) → (interp ((* Mu1 ) x1 x2 ) ((* Mu2 ) y1 y2 ) )))) 
  
  data MultSemigroupTerm  : Set where
    *L : (MultSemigroupTerm   → (MultSemigroupTerm   → MultSemigroupTerm  )) 
  
  data ClMultSemigroupTerm (A  : Set )  : Set where
    sing : (A  → (ClMultSemigroupTerm A ) )
    *Cl : ((ClMultSemigroupTerm A )  → ((ClMultSemigroupTerm A )  → (ClMultSemigroupTerm A ) )) 
  
  data OpMultSemigroupTerm (n  : Nat)  : Set where
    v : ((Fin n ) → (OpMultSemigroupTerm n ) )
    *OL : ((OpMultSemigroupTerm n )  → ((OpMultSemigroupTerm n )  → (OpMultSemigroupTerm n ) )) 
  
  data OpMultSemigroupTerm2 (n  : Nat ) (A  : Set )  : Set where
    v2 : ((Fin n ) → (OpMultSemigroupTerm2 n A ) )
    sing2 : (A  → (OpMultSemigroupTerm2 n A ) )
    *OL2 : ((OpMultSemigroupTerm2 n A )  → ((OpMultSemigroupTerm2 n A )  → (OpMultSemigroupTerm2 n A ) )) 
  
  simplifyB : (MultSemigroupTerm  → MultSemigroupTerm )
  simplifyB (*L x1 x2 )  = (*L (simplifyB x1 ) (simplifyB x2 ) )
  
  simplifyCl : ((A  : Set )  → ((ClMultSemigroupTerm A ) → (ClMultSemigroupTerm A )))
  simplifyCl _ (*Cl x1 x2 )  = (*Cl (simplifyCl _ x1 ) (simplifyCl _ x2 ) )
  
  simplifyCl _ (sing x1 )  = (sing x1 )
  
  simplifyOp : ((n  : Nat)  → ((OpMultSemigroupTerm n ) → (OpMultSemigroupTerm n )))
  simplifyOp _ (*OL x1 x2 )  = (*OL (simplifyOp _ x1 ) (simplifyOp _ x2 ) )
  
  simplifyOp _ (v x1 )  = (v x1 )
  
  simplifyOpE : ((n  : Nat ) (A  : Set )  → ((OpMultSemigroupTerm2 n A ) → (OpMultSemigroupTerm2 n A )))
  simplifyOpE _ _ (*OL2 x1 x2 )  = (*OL2 (simplifyOpE _ _ x1 ) (simplifyOpE _ _ x2 ) )
  
  simplifyOpE _ _ (v2 x1 )  = (v2 x1 )
  
  simplifyOpE _ _ (sing2 x1 )  = (sing2 x1 )
  
  evalB : ({A  : Set }  → ((MultSemigroup A ) → (MultSemigroupTerm  → A )))
  evalB Mu (*L x1 x2 )  = ((* Mu ) (evalB Mu x1 ) (evalB Mu x2 ) )
  
  evalCl : ({A  : Set }  → ((MultSemigroup A ) → ((ClMultSemigroupTerm A ) → A )))
  evalCl Mu (sing x1 )  = x1 
  
  evalCl Mu (*Cl x1 x2 )  = ((* Mu ) (evalCl Mu x1 ) (evalCl Mu x2 ) )
  
  evalOp : ({A  : Set } (n  : Nat)  → ((MultSemigroup A ) → ((Vec A n ) → ((OpMultSemigroupTerm n ) → A ))))
  evalOp n Mu vars (v x1 )  = (lookup vars x1 )
  
  evalOp n Mu vars (*OL x1 x2 )  = ((* Mu ) (evalOp n Mu vars x1 ) (evalOp n Mu vars x2 ) )
  
  evalOpE : ({A  : Set } (n  : Nat )  → ((MultSemigroup A ) → ((Vec A n ) → ((OpMultSemigroupTerm2 n A ) → A ))))
  evalOpE n Mu vars (v2 x1 )  = (lookup vars x1 )
  
  evalOpE n Mu vars (sing2 x1 )  = x1 
  
  evalOpE n Mu vars (*OL2 x1 x2 )  = ((* Mu ) (evalOpE n Mu vars x1 ) (evalOpE n Mu vars x2 ) )
  
  inductionB : ((P  : (MultSemigroupTerm  → Set ))  → (((x1 x2  : MultSemigroupTerm  )  → ((P x1 ) → ((P x2 ) → (P (*L x1 x2 ) )))) → ((x  : MultSemigroupTerm )  → (P x ))))
  inductionB p p*l (*L x1 x2 )  = (p*l _ _ (inductionB p p*l x1 ) (inductionB p p*l x2 ) )
  
  inductionCl : ((A  : Set ) (P  : ((ClMultSemigroupTerm A ) → Set ))  → (((x1  : A )  → (P (sing x1 ) )) → (((x1 x2  : (ClMultSemigroupTerm A ) )  → ((P x1 ) → ((P x2 ) → (P (*Cl x1 x2 ) )))) → ((x  : (ClMultSemigroupTerm A ))  → (P x )))))
  inductionCl _ p psing p*cl (sing x1 )  = (psing x1 )
  
  inductionCl _ p psing p*cl (*Cl x1 x2 )  = (p*cl _ _ (inductionCl _ p psing p*cl x1 ) (inductionCl _ p psing p*cl x2 ) )
  
  inductionOp : ((n  : Nat) (P  : ((OpMultSemigroupTerm n ) → Set ))  → (((fin  : (Fin n ))  → (P (v fin ) )) → (((x1 x2  : (OpMultSemigroupTerm n ) )  → ((P x1 ) → ((P x2 ) → (P (*OL x1 x2 ) )))) → ((x  : (OpMultSemigroupTerm n ))  → (P x )))))
  inductionOp _ p pv p*ol (v x1 )  = (pv x1 )
  
  inductionOp _ p pv p*ol (*OL x1 x2 )  = (p*ol _ _ (inductionOp _ p pv p*ol x1 ) (inductionOp _ p pv p*ol x2 ) )
  
  inductionOpE : ((n  : Nat ) (A  : Set ) (P  : ((OpMultSemigroupTerm2 n A ) → Set ))  → (((fin  : (Fin n ))  → (P (v2 fin ) )) → (((x1  : A )  → (P (sing2 x1 ) )) → (((x1 x2  : (OpMultSemigroupTerm2 n A ) )  → ((P x1 ) → ((P x2 ) → (P (*OL2 x1 x2 ) )))) → ((x  : (OpMultSemigroupTerm2 n A ))  → (P x ))))))
  inductionOpE _ _ p pv2 psing2 p*ol2 (v2 x1 )  = (pv2 x1 )
  
  inductionOpE _ _ p pv2 psing2 p*ol2 (sing2 x1 )  = (psing2 x1 )
  
  inductionOpE _ _ p pv2 psing2 p*ol2 (*OL2 x1 x2 )  = (p*ol2 _ _ (inductionOpE _ _ p pv2 psing2 p*ol2 x1 ) (inductionOpE _ _ p pv2 psing2 p*ol2 x2 ) )
  
  *L' : (  (MultSemigroupTerm   → (MultSemigroupTerm   → MultSemigroupTerm  )))
  *L' x1 x2  = (*L x1 x2 )
  
  stageB : (MultSemigroupTerm  → (Staged MultSemigroupTerm  ))
  stageB (*L x1 x2 )  = (stage2 *L' (codeLift2 *L' ) (stageB  x1 ) (stageB  x2 ) )
  
  *Cl' : ({A  : Set }  → ((ClMultSemigroupTerm A )  → ((ClMultSemigroupTerm A )  → (ClMultSemigroupTerm A ) )))
  *Cl' x1 x2  = (*Cl x1 x2 )
  
  stageCl : ((A  : Set )  → ((ClMultSemigroupTerm A ) → (Staged (ClMultSemigroupTerm A ) )))
  stageCl _ (sing x1 )  = (Now (sing x1 ) )
  
  stageCl _ (*Cl x1 x2 )  = (stage2 *Cl' (codeLift2 *Cl' ) ((stageCl _ ) x1 ) ((stageCl _ ) x2 ) )
  
  *OL' : ({n  : Nat}  → ((OpMultSemigroupTerm n )  → ((OpMultSemigroupTerm n )  → (OpMultSemigroupTerm n ) )))
  *OL' x1 x2  = (*OL x1 x2 )
  
  stageOp : ((n  : Nat)  → ((OpMultSemigroupTerm n ) → (Staged (OpMultSemigroupTerm n ) )))
  stageOp _ (v x1 )  = (const (code (v x1 ) ) )
  
  stageOp _ (*OL x1 x2 )  = (stage2 *OL' (codeLift2 *OL' ) ((stageOp _ ) x1 ) ((stageOp _ ) x2 ) )
  
  *OL2' : ({n  : Nat } {A  : Set }  → ((OpMultSemigroupTerm2 n A )  → ((OpMultSemigroupTerm2 n A )  → (OpMultSemigroupTerm2 n A ) )))
  *OL2' x1 x2  = (*OL2 x1 x2 )
  
  stageOpE : ((n  : Nat ) (A  : Set )  → ((OpMultSemigroupTerm2 n A ) → (Staged (OpMultSemigroupTerm2 n A ) )))
  stageOpE _ _ (sing2 x1 )  = (Now (sing2 x1 ) )
  
  stageOpE _ _ (v2 x1 )  = (const (code (v2 x1 ) ) )
  
  stageOpE _ _ (*OL2 x1 x2 )  = (stage2 *OL2' (codeLift2 *OL2' ) ((stageOpE _ _ ) x1 ) ((stageOpE _ _ ) x2 ) )
  
  record Tagless (A  : Set) (Repr  : (Set  → Set ))  : Set where
    constructor tagless
    field
      *T : ((Repr A )  → ((Repr A )  → (Repr A ) )) 
   
