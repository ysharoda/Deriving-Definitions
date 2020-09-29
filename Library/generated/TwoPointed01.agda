
 module TwoPointed01  where
  open import Prelude
  open import Agda.Builtin.Equality
  open import Agda.Builtin.Nat
  open import Data.Fin
  open import Data.Vec
  record TwoPointed01 (A  : Set )  : Set where
    constructor TwoPointed01C
    field
      e1 : A 
      e2 : A  
  
  open TwoPointed01
  record Sig (AS  : Set )  : Set where
    constructor SigSigC
    field
      e1S : AS 
      e2S : AS  
  
  record Product (AP  : Set )  : Set where
    constructor ProductC
    field
      e1P : (Prod AP AP )
      e2P : (Prod AP AP ) 
  
  record Hom (A1 A2  : Set ) (Tw1  : (TwoPointed01 A1 )) (Tw2  : (TwoPointed01 A2 ))  : Set where
    constructor HomC
    field
      hom : (A1 → A2)
      pres-e1 : (  (hom (e1 Tw1 )  ) ≡ (e1 Tw2 ) )
      pres-e2 : (  (hom (e2 Tw1 )  ) ≡ (e2 Tw2 ) ) 
  
  record RelInterp (A1 A2  : Set ) (Tw1  : (TwoPointed01 A1 )) (Tw2  : (TwoPointed01 A2 ))  : Set₁ where
    constructor RelInterpC
    field
      interp : (A1 → (A2 → Set))
      interp-e1 : (  (interp (e1 Tw1 )  (e1 Tw2 )  ))
      interp-e2 : (  (interp (e2 Tw1 )  (e2 Tw2 )  )) 
  
  data TwoPointed01Term  : Set where
    e1L : TwoPointed01Term  
    e2L : TwoPointed01Term   
  
  data ClTwoPointed01Term (A  : Set )  : Set where
    sing : (A  → (ClTwoPointed01Term A ) )
    e1Cl : (ClTwoPointed01Term A ) 
    e2Cl : (ClTwoPointed01Term A )  
  
  data OpTwoPointed01Term (n  : Nat)  : Set where
    v : ((Fin n ) → (OpTwoPointed01Term n ) )
    e1OL : (OpTwoPointed01Term n ) 
    e2OL : (OpTwoPointed01Term n )  
  
  data OpTwoPointed01Term2 (n  : Nat ) (A  : Set )  : Set where
    v2 : ((Fin n ) → (OpTwoPointed01Term2 n A ) )
    sing2 : (A  → (OpTwoPointed01Term2 n A ) )
    e1OL2 : (OpTwoPointed01Term2 n A ) 
    e2OL2 : (OpTwoPointed01Term2 n A )  
  
  simplifyB : (TwoPointed01Term  → TwoPointed01Term )
  simplifyB e1L  = e1L 
  
  simplifyB e2L  = e2L 
  
  simplifyCl : ((A  : Set )  → ((ClTwoPointed01Term A ) → (ClTwoPointed01Term A )))
  simplifyCl _ e1Cl  = e1Cl 
  
  simplifyCl _ e2Cl  = e2Cl 
  
  simplifyCl _ (sing x1 )  = (sing x1 )
  
  simplifyOp : ((n  : Nat)  → ((OpTwoPointed01Term n ) → (OpTwoPointed01Term n )))
  simplifyOp _ e1OL  = e1OL 
  
  simplifyOp _ e2OL  = e2OL 
  
  simplifyOp _ (v x1 )  = (v x1 )
  
  simplifyOpE : ((n  : Nat ) (A  : Set )  → ((OpTwoPointed01Term2 n A ) → (OpTwoPointed01Term2 n A )))
  simplifyOpE _ _ e1OL2  = e1OL2 
  
  simplifyOpE _ _ e2OL2  = e2OL2 
  
  simplifyOpE _ _ (v2 x1 )  = (v2 x1 )
  
  simplifyOpE _ _ (sing2 x1 )  = (sing2 x1 )
  
  evalB : ({A  : Set }  → ((TwoPointed01 A ) → (TwoPointed01Term  → A )))
  evalB Tw e1L  = (e1 Tw ) 
  
  evalB Tw e2L  = (e2 Tw ) 
  
  evalCl : ({A  : Set }  → ((TwoPointed01 A ) → ((ClTwoPointed01Term A ) → A )))
  evalCl Tw (sing x1 )  = x1 
  
  evalCl Tw e1Cl  = (e1 Tw ) 
  
  evalCl Tw e2Cl  = (e2 Tw ) 
  
  evalOp : ({A  : Set } (n  : Nat)  → ((TwoPointed01 A ) → ((Vec A n ) → ((OpTwoPointed01Term n ) → A ))))
  evalOp n Tw vars (v x1 )  = (lookup vars x1 )
  
  evalOp n Tw vars e1OL  = (e1 Tw ) 
  
  evalOp n Tw vars e2OL  = (e2 Tw ) 
  
  evalOpE : ({A  : Set } (n  : Nat )  → ((TwoPointed01 A ) → ((Vec A n ) → ((OpTwoPointed01Term2 n A ) → A ))))
  evalOpE n Tw vars (v2 x1 )  = (lookup vars x1 )
  
  evalOpE n Tw vars (sing2 x1 )  = x1 
  
  evalOpE n Tw vars e1OL2  = (e1 Tw ) 
  
  evalOpE n Tw vars e2OL2  = (e2 Tw ) 
  
  inductionB : ((P  : (TwoPointed01Term  → Set ))  → ((P e1L ) → ((P e2L ) → ((x  : TwoPointed01Term )  → (P x )))))
  inductionB p pe1l pe2l e1L  = pe1l 
  
  inductionB p pe1l pe2l e2L  = pe2l 
  
  inductionCl : ((A  : Set ) (P  : ((ClTwoPointed01Term A ) → Set ))  → (((x1  : A )  → (P (sing x1 ) )) → ((P e1Cl ) → ((P e2Cl ) → ((x  : (ClTwoPointed01Term A ))  → (P x ))))))
  inductionCl _ p psing pe1cl pe2cl (sing x1 )  = (psing x1 )
  
  inductionCl _ p psing pe1cl pe2cl e1Cl  = pe1cl 
  
  inductionCl _ p psing pe1cl pe2cl e2Cl  = pe2cl 
  
  inductionOp : ((n  : Nat) (P  : ((OpTwoPointed01Term n ) → Set ))  → (((fin  : (Fin n ))  → (P (v fin ) )) → ((P e1OL ) → ((P e2OL ) → ((x  : (OpTwoPointed01Term n ))  → (P x ))))))
  inductionOp _ p pv pe1ol pe2ol (v x1 )  = (pv x1 )
  
  inductionOp _ p pv pe1ol pe2ol e1OL  = pe1ol 
  
  inductionOp _ p pv pe1ol pe2ol e2OL  = pe2ol 
  
  inductionOpE : ((n  : Nat ) (A  : Set ) (P  : ((OpTwoPointed01Term2 n A ) → Set ))  → (((fin  : (Fin n ))  → (P (v2 fin ) )) → (((x1  : A )  → (P (sing2 x1 ) )) → ((P e1OL2 ) → ((P e2OL2 ) → ((x  : (OpTwoPointed01Term2 n A ))  → (P x )))))))
  inductionOpE _ _ p pv2 psing2 pe1ol2 pe2ol2 (v2 x1 )  = (pv2 x1 )
  
  inductionOpE _ _ p pv2 psing2 pe1ol2 pe2ol2 (sing2 x1 )  = (psing2 x1 )
  
  inductionOpE _ _ p pv2 psing2 pe1ol2 pe2ol2 e1OL2  = pe1ol2 
  
  inductionOpE _ _ p pv2 psing2 pe1ol2 pe2ol2 e2OL2  = pe2ol2 
  
  e1L' : (  TwoPointed01Term  )
  e1L'  = e1L 
  
  e2L' : (  TwoPointed01Term  )
  e2L'  = e2L 
  
  stageB : (TwoPointed01Term  → (Staged TwoPointed01Term  ))
  stageB e1L  = (Now e1L )
  
  stageB e2L  = (Now e2L )
  
  e1Cl' : ({A  : Set }  → (ClTwoPointed01Term A ) )
  e1Cl'  = e1Cl 
  
  e2Cl' : ({A  : Set }  → (ClTwoPointed01Term A ) )
  e2Cl'  = e2Cl 
  
  stageCl : ((A  : Set )  → ((ClTwoPointed01Term A ) → (Staged (ClTwoPointed01Term A ) )))
  stageCl _ (sing x1 )  = (Now (sing x1 ) )
  
  stageCl _ e1Cl  = (Now e1Cl )
  
  stageCl _ e2Cl  = (Now e2Cl )
  
  e1OL' : ({n  : Nat}  → (OpTwoPointed01Term n ) )
  e1OL'  = e1OL 
  
  e2OL' : ({n  : Nat}  → (OpTwoPointed01Term n ) )
  e2OL'  = e2OL 
  
  stageOp : ((n  : Nat)  → ((OpTwoPointed01Term n ) → (Staged (OpTwoPointed01Term n ) )))
  stageOp _ (v x1 )  = (const (code (v x1 ) ) )
  
  stageOp _ e1OL  = (Now e1OL )
  
  stageOp _ e2OL  = (Now e2OL )
  
  e1OL2' : ({n  : Nat } {A  : Set }  → (OpTwoPointed01Term2 n A ) )
  e1OL2'  = e1OL2 
  
  e2OL2' : ({n  : Nat } {A  : Set }  → (OpTwoPointed01Term2 n A ) )
  e2OL2'  = e2OL2 
  
  stageOpE : ((n  : Nat ) (A  : Set )  → ((OpTwoPointed01Term2 n A ) → (Staged (OpTwoPointed01Term2 n A ) )))
  stageOpE _ _ (sing2 x1 )  = (Now (sing2 x1 ) )
  
  stageOpE _ _ (v2 x1 )  = (const (code (v2 x1 ) ) )
  
  stageOpE _ _ e1OL2  = (Now e1OL2 )
  
  stageOpE _ _ e2OL2  = (Now e2OL2 )
  
  record Tagless (A  : Set) (Repr  : (Set  → Set ))  : Set where
    constructor tagless
    field
      e1T : (Repr A ) 
      e2T : (Repr A )  
   