/******************************************************************************/
/* szkgchg.sql Copyright 2015 Ellucian Company L.P. and its affiliates.       */
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
/* FILE NAME..: szkgchg.sql                                                   */
/*                                                                            */
/* RELEASE....: 8.7 [MCLA:002.1.0]                                            */
/*                                                                            */
/* OBJECT NAME: szkgchg                                                       */
/*                                                                            */
/* Massive process that upload file and changes grade on Academic History or  */
/* on registered course.                                                      */
/*                                                                            */
/******************************************************************************/
/*                                                                            */
/* AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                            */
/* --------------------------------------------------------  ---  ----------- */
/* 1. Initial Code                                           MKU  Jan/18/2016 */
/*                                                                            */
/*                                                                            */
/* --------------------------------------------------------  ---  ----------- */
/*  AUDIT TRAIL: 8.31.2 [MOD:02.2.0]                                          */
/*  -------------------------------------------------------  ---  ----------- */
/*  1. Student version updated from 8.7 to 8.31.2             LMR 07-NOV-2024 */
/*  -------------------------------------------------------  ---  ----------- */  
/*                                                                            */
/* AUDIT TRAIL END                                                            */
/*                                                                            */
/* BEGIN COMMENT                                                              */
/*                                                                            */
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

CREATE OR REPLACE PACKAGE BANINST1.SZKGCHG  AS
-- FILE NAME..: szkgchg.sql
-- RELEASE....: 8.7 [MCLA:002.1.0]
-- OBJECT NAME: szkgchg
-- PRODUCT....: STU
-- USAGE......: Massive process to change grades on Academic History or on registered courses.
-- COPYRIGHT..: Copyright 2015 Ellucian Company L.P. and its affiliates.
--                                     
-- 
    /* 
     *************************************************************************

        p_process_file: get parameters of the process and call the routine to save
                        or to process
        
        p_id:               student's ID
        p_term_code:        term code
        p_course:           subject code concatenated with course number
        p_grade:            grade code (SHAGRDE)
        p_crn:              crn (ssbsect_crn)
        p_grade_comm:       grade comment code (STVGCMT_CODE)
        p_file_name:        file name
        p_process:          process type: H or R
        p_change_reason:    change reason code (STVGCHG_CODE)
        p_ApprovedGrade:    parameter to validate grade on AH be lower than this value
        p_CheckReason:      parameter to validated rules for AH.            

     *************************************************************************
    */                    

    procedure p_process_file(p_id                   varchar2,
                             p_term_code            varchar2,
                             p_course               varchar2,
                             p_grade                varchar2,
                             p_crn                  varchar2,
                             p_grade_comm           varchar2,
                             p_run_mode             varchar2,
                             p_process              varchar2,
                             p_filename             varchar2,
                             p_change_reason        varchar2 default null,
                             p_approved_grade       varchar2 default null,
                             p_CheckReason          varchar2 default null
                            ); 

    procedure p_delete_szrgchg(p_FileName   varchar2,
                               p_RunMode    varchar2);

END SZKGCHG;
/

SHOW ERRORS
SET DEFINE ON

--GRANT EXECUTE ON SZKGCHG TO BANINST1;s
GRANT ALL ON SZKGCHG TO banproxy;
GRANT ALL ON SZKGCHG TO ban_ss_user;

GRANT DEBUG ON "BANINST1"."SZKGCHG" TO "BANPROXY";

GRANT EXECUTE ON "BANINST1"."SZKGCHG" TO "BAN_SS_USER";
--
WHENEVER SQLERROR CONTINUE
DROP PUBLIC SYNONYM SZKGCHG;
--
WHENEVER SQLERROR CONTINUE 
CREATE PUBLIC SYNONYM SZKGCHG FOR SZKGCHG;
--
WHENEVER SQLERROR CONTINUE
start gurgrtb SZKGCHG
start gurgrth SZKGCHG

WHENEVER SQLERROR EXIT ROLLBACK

PROMPT *************************************************************************
PROMPT * End: SZKGCHG.sql                                                      * 
PROMPT *************************************************************************
