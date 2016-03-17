{-# OPTIONS_GHC -w #-}
{-

ASN.2 - 2016

(C) Copyright Buster Kim Mejborn 2016

All Rights Reserved.

-}

module Parser where
import Lexer
import Ast
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.5

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 t4
	| HappyAbsSyn5 t5
	| HappyAbsSyn6 t6
	| HappyAbsSyn7 t7
	| HappyAbsSyn8 t8
	| HappyAbsSyn9 t9
	| HappyAbsSyn10 t10
	| HappyAbsSyn11 t11
	| HappyAbsSyn12 t12
	| HappyAbsSyn13 t13
	| HappyAbsSyn14 t14
	| HappyAbsSyn15 t15
	| HappyAbsSyn16 t16
	| HappyAbsSyn17 t17

action_0 (18) = happyShift action_4
action_0 (4) = happyGoto action_5
action_0 (5) = happyGoto action_2
action_0 (6) = happyGoto action_3
action_0 _ = happyFail

action_1 (18) = happyShift action_4
action_1 (5) = happyGoto action_2
action_1 (6) = happyGoto action_3
action_1 _ = happyFail

action_2 (18) = happyShift action_4
action_2 (6) = happyGoto action_7
action_2 _ = happyReduce_1

action_3 _ = happyReduce_2

action_4 (19) = happyShift action_6
action_4 _ = happyFail

action_5 (28) = happyAccept
action_5 _ = happyFail

action_6 (23) = happyShift action_8
action_6 _ = happyFail

action_7 _ = happyReduce_3

action_8 (18) = happyShift action_9
action_8 _ = happyFail

action_9 (23) = happyShift action_10
action_9 _ = happyFail

action_10 (24) = happyShift action_11
action_10 _ = happyFail

action_11 (21) = happyShift action_12
action_11 _ = happyFail

action_12 (23) = happyShift action_16
action_12 (7) = happyGoto action_13
action_12 (8) = happyGoto action_14
action_12 (9) = happyGoto action_15
action_12 _ = happyFail

action_13 _ = happyReduce_7

action_14 (22) = happyShift action_19
action_14 _ = happyFail

action_15 (24) = happyShift action_18
action_15 _ = happyReduce_6

action_16 (18) = happyShift action_17
action_16 _ = happyFail

action_17 (23) = happyShift action_22
action_17 _ = happyFail

action_18 (23) = happyShift action_16
action_18 (7) = happyGoto action_21
action_18 _ = happyFail

action_19 (20) = happyShift action_20
action_19 _ = happyFail

action_20 (25) = happyShift action_23
action_20 _ = happyFail

action_21 _ = happyReduce_8

action_22 _ = happyReduce_5

action_23 (26) = happyShift action_25
action_23 (27) = happyShift action_26
action_23 (10) = happyGoto action_24
action_23 _ = happyFail

action_24 _ = happyReduce_4

action_25 (19) = happyShift action_28
action_25 _ = happyFail

action_26 (19) = happyShift action_27
action_26 _ = happyFail

action_27 (21) = happyShift action_30
action_27 _ = happyFail

action_28 (21) = happyShift action_29
action_28 _ = happyFail

action_29 (19) = happyShift action_38
action_29 (14) = happyGoto action_35
action_29 (15) = happyGoto action_36
action_29 (16) = happyGoto action_37
action_29 _ = happyFail

action_30 (19) = happyShift action_34
action_30 (11) = happyGoto action_31
action_30 (12) = happyGoto action_32
action_30 (13) = happyGoto action_33
action_30 _ = happyFail

action_31 _ = happyReduce_13

action_32 (22) = happyShift action_44
action_32 _ = happyFail

action_33 (24) = happyShift action_43
action_33 _ = happyReduce_12

action_34 (23) = happyShift action_42
action_34 _ = happyFail

action_35 _ = happyReduce_17

action_36 (22) = happyShift action_41
action_36 _ = happyFail

action_37 (24) = happyShift action_40
action_37 _ = happyReduce_16

action_38 (23) = happyShift action_39
action_38 _ = happyFail

action_39 (18) = happyShift action_50
action_39 _ = happyFail

action_40 (19) = happyShift action_38
action_40 (14) = happyGoto action_49
action_40 _ = happyFail

action_41 (20) = happyShift action_48
action_41 _ = happyFail

action_42 (18) = happyShift action_47
action_42 _ = happyFail

action_43 (19) = happyShift action_34
action_43 (11) = happyGoto action_46
action_43 _ = happyFail

action_44 (20) = happyShift action_45
action_44 _ = happyFail

action_45 _ = happyReduce_10

action_46 _ = happyReduce_14

action_47 (23) = happyShift action_52
action_47 _ = happyFail

action_48 _ = happyReduce_9

action_49 _ = happyReduce_18

action_50 (23) = happyShift action_51
action_50 _ = happyFail

action_51 (24) = happyShift action_54
action_51 _ = happyFail

action_52 (24) = happyShift action_53
action_52 _ = happyFail

action_53 (23) = happyShift action_56
action_53 _ = happyFail

action_54 (23) = happyShift action_55
action_54 _ = happyFail

action_55 (18) = happyShift action_58
action_55 _ = happyFail

action_56 (18) = happyShift action_57
action_56 _ = happyFail

action_57 (23) = happyShift action_60
action_57 _ = happyFail

action_58 (23) = happyShift action_59
action_58 _ = happyFail

action_59 (24) = happyShift action_62
action_59 _ = happyFail

action_60 (20) = happyShift action_61
action_60 _ = happyFail

action_61 _ = happyReduce_11

action_62 (23) = happyShift action_63
action_62 _ = happyFail

action_63 (18) = happyShift action_65
action_63 (17) = happyGoto action_64
action_63 _ = happyFail

action_64 (23) = happyShift action_66
action_64 _ = happyFail

action_65 _ = happyReduce_19

action_66 (20) = happyShift action_67
action_66 _ = happyFail

action_67 _ = happyReduce_15

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 (reverse happy_var_1
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_1  5 happyReduction_2
happyReduction_2 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_1 : []
	)
happyReduction_2 _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_2  5 happyReduction_3
happyReduction_3 (HappyAbsSyn6  happy_var_2)
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_2 : happy_var_1
	)
happyReduction_3 _ _  = notHappyAtAll 

happyReduce_4 = happyReduce 12 6 happyReduction_4
happyReduction_4 ((HappyAbsSyn10  happy_var_12) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_8) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TATOM _ happy_var_4)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (Format happy_var_4 happy_var_8 happy_var_12
	) `HappyStk` happyRest

happyReduce_5 = happySpecReduce_3  7 happyReduction_5
happyReduction_5 _
	(HappyTerminal (TATOM _ happy_var_2))
	_
	 =  HappyAbsSyn7
		 (happy_var_2
	)
happyReduction_5 _ _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_1  8 happyReduction_6
happyReduction_6 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn8
		 (reverse happy_var_1
	)
happyReduction_6 _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_1  9 happyReduction_7
happyReduction_7 (HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_1 : []
	)
happyReduction_7 _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_3  9 happyReduction_8
happyReduction_8 (HappyAbsSyn7  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_3 : happy_var_1
	)
happyReduction_8 _ _ _  = notHappyAtAll 

happyReduce_9 = happyReduce 6 10 happyReduction_9
happyReduction_9 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (XML "XML" happy_var_4
	) `HappyStk` happyRest

happyReduce_10 = happyReduce 6 10 happyReduction_10
happyReduction_10 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (ASN "ASN1" happy_var_4
	) `HappyStk` happyRest

happyReduce_11 = happyReduce 9 11 happyReduction_11
happyReduction_11 (_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TATOM _ happy_var_7)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TATOM _ happy_var_3)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (Field_ASN happy_var_3 happy_var_7
	) `HappyStk` happyRest

happyReduce_12 = happySpecReduce_1  12 happyReduction_12
happyReduction_12 (HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn12
		 (reverse happy_var_1
	)
happyReduction_12 _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_1  13 happyReduction_13
happyReduction_13 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_1 : []
	)
happyReduction_13 _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_3  13 happyReduction_14
happyReduction_14 (HappyAbsSyn11  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_3 : happy_var_1
	)
happyReduction_14 _ _ _  = notHappyAtAll 

happyReduce_15 = happyReduce 13 14 happyReduction_15
happyReduction_15 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn17  happy_var_11) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TATOM _ happy_var_7)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TATOM _ happy_var_3)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 (Field_XML happy_var_3 happy_var_7 happy_var_11
	) `HappyStk` happyRest

happyReduce_16 = happySpecReduce_1  15 happyReduction_16
happyReduction_16 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn15
		 (reverse happy_var_1
	)
happyReduction_16 _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_1  16 happyReduction_17
happyReduction_17 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1 : []
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_3  16 happyReduction_18
happyReduction_18 (HappyAbsSyn14  happy_var_3)
	_
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_3 : happy_var_1
	)
happyReduction_18 _ _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_1  17 happyReduction_19
happyReduction_19 (HappyTerminal (TATOM _ happy_var_1))
	 =  HappyAbsSyn17
		 (Encoding happy_var_1
	)
happyReduction_19 _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 28 28 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TATOM _ happy_dollar_dollar -> cont 18;
	TOPENP _ -> cont 19;
	TCLOSEP _ -> cont 20;
	TOPENSQ _ -> cont 21;
	TCLOSESQ _ -> cont 22;
	TQUOTE _ -> cont 23;
	TCOMMA _ -> cont 24;
	TEQ _ -> cont 25;
	TXML _ -> cont 26;
	TASN _ -> cont 27;
	_ -> happyError' (tk:tks)
	}

happyError_ 28 tk tks = happyError' tks
happyError_ _ tk tks = happyError' (tk:tks)

newtype HappyIdentity a = HappyIdentity a
happyIdentity = HappyIdentity
happyRunIdentity (HappyIdentity a) = a

instance Functor HappyIdentity where
    fmap f (HappyIdentity a) = HappyIdentity (f a)

instance Applicative HappyIdentity where
    pure  = return
    (<*>) = ap
instance Monad HappyIdentity where
    return = HappyIdentity
    (HappyIdentity p) >>= q = q p

happyThen :: () => HappyIdentity a -> (a -> HappyIdentity b) -> HappyIdentity b
happyThen = (>>=)
happyReturn :: () => a -> HappyIdentity a
happyReturn = (return)
happyThen1 m k tks = (>>=) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> HappyIdentity a
happyReturn1 = \a tks -> (return) a
happyError' :: () => [(Token)] -> HappyIdentity a
happyError' = HappyIdentity . happyError

parser tks = happyRunIdentity happySomeParser where
  happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


happyError :: [Token] -> a
happyError tks = error ("Parse error at " ++ lcn ++ "\n" )
    where
    lcn =   case tks of
          [] -> "end of file"
          tk:_ -> "line " ++ show l ++ ", column " ++ show c ++ " - Token: " ++ show tk
            where
            AlexPn _ l c = token_posn tk
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "<built-in>" #-}
{-# LINE 1 "<command-line>" #-}
{-# LINE 8 "<command-line>" #-}
# 1 "/usr/include/stdc-predef.h" 1 3 4

# 17 "/usr/include/stdc-predef.h" 3 4















































{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "/usr/lib/ghc-7.10.3/include/ghcversion.h" #-}

















{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 

{-# LINE 13 "templates/GenericTemplate.hs" #-}

{-# LINE 46 "templates/GenericTemplate.hs" #-}








{-# LINE 67 "templates/GenericTemplate.hs" #-}

{-# LINE 77 "templates/GenericTemplate.hs" #-}

{-# LINE 86 "templates/GenericTemplate.hs" #-}

infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is (1), it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action

{-# LINE 155 "templates/GenericTemplate.hs" #-}

-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Int ->                    -- token number
         Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction

{-# LINE 256 "templates/GenericTemplate.hs" #-}
happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  (1) tk old_st (((HappyState (action))):(sts)) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        action (1) (1) tk (HappyState (action)) sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail  i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ( (HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.

{-# LINE 322 "templates/GenericTemplate.hs" #-}
{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
