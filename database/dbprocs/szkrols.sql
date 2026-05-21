/******************************************************************************/
/* szkrols.sql Copyright 2015 Ellucian Company L.P. and its affiliates.       */
/******************************************************************************/

/******************************************************************************/
/*                                                                            */
/*                    CONFIDENTIAL BUSINESS INFORMATION                       */
/*                                                                            */
/******************************************************************************/
/*                                                                            */
/*  THIS PROGRAM IS PROPRIETARY INFORMATION OF ELLUCIAN AND ITS AFFILIATES AND*/
/*  IS NOT TO BE COPIED, REPRODUCED, LENT OR DISPOSED OF, NOR USED FOR ANY    */
/*  PURPOSE OTHER THAN THAT FOR WHICH IT IS SPECIFICALLY PROVIDED WITHOUT THE */
/*  WRITTEN PERMISSION OF SAID COMPANY.                                       */
/*                                                                            */
/******************************************************************************/
/*                                                                            */
/* FILE NAME..: szkrols.sql                                                   */
/*                                                                            */
/* RELEASE....: 8.7 [MCLA:002.1.0]                                            */
/*                                                                            */
/* OBJECT NAME: szkrols                                                       */
/*                                                                            */
/* Grade Roll package for BannerStudent System.                               */
/*                                                                            */
/******************************************************************************/
/*                                                                            */
/* AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                            */
/* --------------------------------------------------------  ---  ----------- */
/* 1. Initial Code                                           MKU  Jan/04/2016 */
/*                                                                            */
/*  MOD002- Mejora a la asistencia, HA                                        */
/*  Grade Roll package for BannerStudent System.                              */
/*                                                                            */
/*                                                                            */
/* --------------------------------------------------------  ---  ----------- */ 
/*  AUDIT TRAIL: 8.31.2 [MOD:02.2.0]                                          */
/*  -------------------------------------------------------  ---  ----------- */
/*  1. Student version updated from 8.7 to 8.31.2            LMR 07-NOV-2024  */
/*  -------------------------------------------------------  ---  ----------- */ 
/*                                                                            */
/* AUDIT TRAIL END                                                            */
/*                                                                            */
/* BEGIN COMMENT                                                              */
/*                                                                            */
/*  Grade Roll package for BannerStudent System.                              */
/*                                                                            */
/* END COMMENT                                                                */
/******************************************************************************/

SET DEFINE ON
SET SCAN ON
CONNECT baninst1/&&baninst1_password
SET DEFINE OFF
SET SHOWMODE OFF
SET SCAN OFF
SET ECHO OFF
SET VERI OFF
SET HEAD OFF
SET TIME OFF
SET TRIMSPOOL ON


CREATE OR REPLACE PACKAGE szkrols  AS

  -- FILE NAME..: szkrols.sql
  -- RELEASE....: 8.7 [MCLA:002.1.0]
  -- OBJECT NAME: szkrols
  -- PRODUCT....: STUDENT
  -- USAGE......: Grade Roll package for BannerStudent System.
  -- COPYRIGHT..: Copyright 2015 Ellucian Company L.P. and its affiliates.
    --
-- DESCRIPTION:
--
-- This package contains procedures required to perform the Grade Roll in
-- the Student System.
--
-- This package contains ONLY Grade Roll functionality and should not be
-- modified for any other purpose.
--
--
-- DESCRIPTION END
--
--
--- This is executed from shrroll, sfaalst and sfaslst to roll grades and create degrees from the
--- the learner curriculum
PROCEDURE p_do_graderoll (term_in IN ssbsect.ssbsect_term_code%TYPE,
                          crn_in IN ssbsect.ssbsect_crn%TYPE,
                          user_in IN shrtckg.shrtckg_final_grde_chg_user%TYPE,
                          sessionid_in IN sprcolr.sprcolr_sessionid%TYPE,
                          print_sel_in IN VARCHAR2,
                          report_mode_in IN VARCHAR2,
                          start_from_date_in IN VARCHAR2,
                          start_to_date_in IN VARCHAR2,
                          grade_term_in IN shrtckg.shrtckg_term_code_grade%TYPE,
                          roll_title_in IN VARCHAR2,
                          p_campus_in        IN STVCAMP.STVCAMP_CODE%type,         -- 8.7 [MCLA:002.1.0]
                          p_level_in         IN STVLEVL.STVLEVL_CODE%TYPE          -- 8.7 [MCLA:002.1.0]
                           
                          );

-- New option to create the degree from the learner record on the forms sgastdn, sfaregs on the
-- curriculum tab.  This by passes the the requirment to have a graded course to create the degree
 PROCEDURE  p_roll_manual_degree
     (     p_pidm                       spriden.spriden_pidm%type,
           P_term_code               stvterm.stvterm_code%type,
           P_lcur_seqno              sorlcur.sorlcur_seqno%type,
            p_term_code_eff         stvterm.stvterm_code%type,
           p_current_ind    varchar2,
           p_user_id                    varchar2,
           P_grst_code                stvgrst.stvgrst_code%type default null,
           P_award_courses        VARCHAR2,
           P_graduation_date      date  default null,
           P_acyr_code                stvacyr.stvacyr_code%type default null,
           P_fee_ind                    shrdgmr.shrdgmr_fee_ind%type default null,
           p_fee_date                  date default null,
           P_term_code_grad       stvterm.stvterm_code%type default null,
           p_gradapp_date           date default null,
           P_roll_ind                    varchar2 default 'Y',
           p_term_code_completed stvterm.stvterm_code%type default null,
           P_degree_seqno  IN OUT  shrdgmr.shrdgmr_seq_no%TYPE ,
           p_err_msg    OUT      VARCHAR2
      );

--  This is called from the grad application and shrrout.  this is to create the degree from a
--  graduation application which was created from the learner curriculum
procedure p_gradapp_roll (p_pidm  spriden.spriden_pidm%type,
       p_gapp_seqno    shbgapp.shbgapp_seqno%TYPE,
       p_roll_curriculum   varchar2 default 'Y',
       p_apply_courses  varchar2,
       p_err_msg OUT varchar2   );

--  This procedure is called from the manual roll and p_do_graderoll.  Before 8.0 release it was
--  part of the p_do_graderoll but moved out so it could be made independent of graded courses
-- being rolled to history.  This procedure rolls the learner curriculum to the outcome.
 PROCEDURE     P_roll_outcome
       (p_pidm            spriden.spriden_pidm%type,
        P_term_code    stvterm.stvterm_code%type,
        P_lcur_seqno    sorlcur.sorlcur_seqno%type,
        P_lcur_rec        sb_curriculum.curriculum_rec,
         p_current_ind    varchar2,
        p_roll_ind          varchar2,
        P_grst_code       stvgrst.stvgrst_code%type default null,
        P_graduation_date   date  default null,
        P_acyr_code       stvacyr.stvacyr_code%type default null,
        P_fee_ind           shrdgmr.shrdgmr_fee_ind%type default null,
        p_fee_date         date default null,
        P_term_code_grad  stvterm.stvterm_code%type default null,
        p_term_code_completed stvterm.stvterm_code%type default null,
        P_degree_seqno   IN OUT  shrdgmr.shrdgmr_seq_no%TYPE
       );



-- Perform a reroll for a single pidm from Gradebook
PROCEDURE p_do_graderoll_pidm ( p_term IN ssbsect.ssbsect_term_code%TYPE
                               ,p_crn IN ssbsect.ssbsect_crn%TYPE
                               ,p_pidm IN sfrstcr.sfrstcr_pidm%TYPE
                               ,p_user IN shrtckg.shrtckg_final_grde_chg_user%TYPE);

END szkrols;
/
SHOW ERRORS
SET DEFINE ON

--GRANT EXECUTE ON SZKROLS TO BANINST1;s
GRANT ALL ON SZKROLS TO banproxy;
GRANT ALL ON SZKROLS TO ban_ss_user;

GRANT DEBUG ON "BANINST1"."SZKROLS" TO "BANPROXY";

GRANT EXECUTE ON "BANINST1"."SZKROLS" TO "BAN_SS_USER";
--
WHENEVER SQLERROR CONTINUE
DROP PUBLIC SYNONYM SZKROLS;
--
WHENEVER SQLERROR CONTINUE 
CREATE PUBLIC SYNONYM SZKROLS FOR SZKROLS;
--
WHENEVER SQLERROR CONTINUE
start gurgrtb SZKROLS
start gurgrth SZKROLS

WHENEVER SQLERROR EXIT ROLLBACK

PROMPT *************************************************************************
PROMPT * End: SZKROLS.sql                                                      * 
PROMPT *************************************************************************
/
