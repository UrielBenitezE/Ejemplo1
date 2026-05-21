/******************************************************************************/
/* szksecg.sql Copyright 2015 Ellucian Company L.P. and its affiliates.       */
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
/* FILE NAME..: szksecg.sql                                                   */
/*                                                                            */
/* RELEASE....: 8.7 [MCLA:001.1.0]                                            */
/*                                                                            */
/* OBJECT NAME: szksecg                                                       */
/*                                                                            */
/* These procedures are used by SFAREGS, VR, and Web Registration. They       */
/* check for registration restrictions and then update base tables when       */
/* registrations have passed all edits and are committed.                     */
/*                                                                            */
/******************************************************************************/
/*                                                                            */
/* AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                            */
/* --------------------------------------------------------  ---  ----------- */
/* 1. Initial Code                                           MKU  Nov/30/2015 */
/*                                                                            */
/* These procedures prepare an email to be send to students when their grades */
/* are changed by the professor. The body of the email is based on            */
/* configurations in the SOALETR forms.                                       */
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
/*                                                                            */
/*  This package send email to notify student about changing on their grades. */
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

create or replace PACKAGE  SZKSECG  AS
-- FILE NAME..: szksecg.sql
-- RELEASE....: 8.7 [MCLA:002.1.0]
-- OBJECT NAME: szksecg
-- PRODUCT....: STU
-- USAGE......: To prepare and send email to students.
-- COPYRIGHT..: Copyright 2025 Ellucian Company L.P. and its affiliates.
--
-- DESCRIPTION:
-- These procedures prepare an email to be send to students when their grades
-- are changed by the professor. The body of the email is based on
-- configurations in the SOAELTR forms.
--
--
                                              
    -- this procedure builds and sends email to students.
    procedure p_BuildEmail  (p_pidm             number,
                             p_term_code        varchar2,
                             p_crn              varchar2,
                             p_gcom_id          varchar2,
                             p_seqno            number,
                             p_grde_new         varchar2,
                             p_grde_old         varchar2,
                             p_ErrMsg       out varchar2);

END SZKSECG;
/ 

SHOW ERRORS
SET DEFINE ON

--GRANT EXECUTE ON SZKMRKS TO BANINST1;s
GRANT ALL ON SZKSECG TO banproxy;
GRANT ALL ON SZKSECG TO ban_ss_user;

GRANT DEBUG ON "BANINST1"."SZKSECG" TO "BANPROXY";

GRANT EXECUTE ON "BANINST1"."SZKSECG" TO "BAN_SS_USER";
--
WHENEVER SQLERROR CONTINUE
DROP PUBLIC SYNONYM SZKSECG;
--
WHENEVER SQLERROR CONTINUE 
CREATE PUBLIC SYNONYM SZKSECG FOR SZKSECG;
--
WHENEVER SQLERROR CONTINUE
start gurgrtb SZKSECG
start gurgrth SZKSECG

WHENEVER SQLERROR EXIT ROLLBACK
