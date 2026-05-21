/* ****************************************************************************** */
/* szpmrks.sql Copyright 2016 Ellucian Company L.P. and its affiliates.           */
/* ****************************************************************************** */
/*                                                                                */
/* ****************************************************************************** */
/*                                                                                */
/*                    CONFIDENTIAL BUSINESS INFORMATION                           */
/*                                                                                */
/* ****************************************************************************** */
/*                                                                                */
/* THIS PROGRAM IS PROPRIETARY INFORMATION OF ELLUCIAN AND ITS AFFILIATES AND IS  */
/* NOT TO BE COPIED, REPRODUCED, LENT OR DISPOSED OF, NOR USED FOR ANY PURPOSE    */
/* OTHER THAN THAT FOR WHICH IT IS SPECIFICALLY PROVIDED WITHOUT THE WRITTEN      */
/* PERMISSION OF SAID COMPANY.                                                    */
/*                                                                                */
/* ****************************************************************************** */
/*                                                                                */
/* FILE NAME..: szpmrks.sql                                                       */
/*                                                                                */
/* RELEASE....: 8.7.0 [UTM:002.1.0]                                               */
/*                                                                                */
/* OBJECT NAME: SZKMRKS                                                           */
/*                                                                                */
/* DESCRIPTION: This package processes massive  grades activities.                */
/*                                                                                */
/* ****************************************************************************** */
/*                                                                                */
/* FUNCTIONS                                                                      */
/*                                                                                */
/*   P_Process_Grade       - This function process the grade.                     */
/*                                                                                */
/* ****************************************************************************** */
/*                                                                                */
/* AUDIT TRAIL: 8.7.0 [UTM:002.1.0]                               INI    DATE     */
/* --------------------------------------------- ---------------- --- ----------- */
/* 1. Initial Creation.                                           DL  11-ENE-2015 */
/* -------------------------------------------------------------- --- ----------- */
/*                                                                                */
/* AUDIT TRAIL: 8.7.0 [UTM:002.1.1]                               INI    DATE     */
/* --------------------------------------------- ---------------- --- ----------- */
/* 1. Added a reference to a new procedure to calculate average   JAR 23-JUN-2016 */
/*    for subcomponents.                                                          */
/* 2. Added a reference to a new procedure to calculate delivery  JAR 23-SEP-2016 */
/*    and absences.                                                               */
/* -------------------------------------------------------------- --- ----------- */
/*  AUDIT TRAIL: 8.31.2 [MOD:02.2.0]                                              */
/* -------------------------------------------------------------- --- ----------- */
/*  1. Student version updated from 8.7 to 8.31.2                 LMR 07-NOV-2024 */
/* -------------------------------------------------------------- ---  ---------- */  
/* AUDIT TRAIL: END                                                               */
/*                                                                                */
/* ****************************************************************************** */
/*                                                                                */
/* BEGIN COMMENT                                                                  */
/*                                                                                */
/* This package processes massive  grades activities.                             */
/*                                                                                */
/* END COMMENT                                                                    */
/* ****************************************************************************** */

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

create or replace PACKAGE SZKMRKS AS
--AUDIT_TRAIL_MSGKEY_UPDATE
-- PROJECT : MSGKEY
-- MODULE  : SZKMRKS
-- SOURCE  : enUS
-- TARGET  : I18N
-- DATE    : Wed Sep 11 16:02:07 2013
-- MSGSIGN : #0000000000000000
--TMI18N.ETR DO NOT CHANGE--
--
-- FILE NAME..: szpmrks.sql
-- RELEASE....: 8.7.0 [UTM:002.1.1]
-- OBJECT NAME: SZKMRKS
-- USAGE......: This package processes massive  grades activities.
-- COPYRIGHT..: Copyright 2016 Ellucian Company L.P. and its affiliates.

--
-- DESCRIPTION:
--
-- This package processes massive  grades activities.
--
-- DESCRIPTION END
--

/*----------------------------------------------------------------------------*/

PROCEDURE P_Process_Grade( P_LINE          IN VARCHAR2,
                           P_MODE          IN VARCHAR2,
                           P_SESSIONID     IN VARCHAR2
                         );

PROCEDURE P_CalcCorqGrades( vPIDM     IN     SPRIDEN.SPRIDEN_PIDM%TYPE,
                            vTermCode IN     STVTERM.STVTERM_CODE%TYPE,
                            vCRN      IN     SSBSECT.SSBSECT_CRN%TYPE,
                            vMode     IN     VARCHAR2,
                            vMsg      IN OUT VARCHAR2
                          );
-- BA 8.7.0 [UTM:002.1.1]
PROCEDURE p_UpdateGrdeScore(nPidm NUMBER, nCrn VARCHAR2, nTerm VARCHAR2, nSubj VARCHAR2, nCrse VARCHAR2, 
                            nOrigin VARCHAR2 DEFAULT NULL   
                            );
                            

PROCEDURE p_UpdateLetterScore( nPidm NUMBER,
                                 nCrn VARCHAR2,
                                 nTerm VARCHAR2
                             );
                             
 PROCEDURE p_calculateAbscense(pidm      NUMBER,
                              pTerm     VARCHAR2,
                              pCrn      VARCHAR2,
                              pAbs OUT  NUMBER );
                              
 PROCEDURE p_calculateDelivery(pidm       NUMBER,
                               pTerm      VARCHAR2,
                               pCrn       VARCHAR2,
                               pDevs OUT  NUMBER );  
-- BA 8.7.0 [UTM:002.1.1]

END SZKMRKS;
/

SHOW ERRORS
SET DEFINE ON

--GRANT EXECUTE ON SZKMRKS TO BANINST1;s
GRANT ALL ON SZKMRKS TO banproxy;
GRANT ALL ON SZKMRKS TO ban_ss_user;

GRANT DEBUG ON "BANINST1"."SZKMRKS" TO "BANPROXY";

GRANT EXECUTE ON "BANINST1"."SZKMRKS" TO "BAN_SS_USER";
--
WHENEVER SQLERROR CONTINUE
DROP PUBLIC SYNONYM SZKMRKS;
--
WHENEVER SQLERROR CONTINUE 
CREATE PUBLIC SYNONYM SZKMRKS FOR SZKMRKS;
--
WHENEVER SQLERROR CONTINUE
start gurgrtb SZKMRKS
start gurgrth SZKMRKS

WHENEVER SQLERROR EXIT ROLLBACK

PROMPT *************************************************************************
PROMPT * End: SZKMRKS.sql                                                      * 
PROMPT *************************************************************************
