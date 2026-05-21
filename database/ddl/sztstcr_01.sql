REM ***************************************************************************
REM
REM sztstcr_01.sql Copyright 2016 Ellucian Company L.P. and its affiliates.
REM
REM ***************************************************************************
REM
REM                     CONFIDENTIAL BUSINESS INFORMATION
REM
REM ***************************************************************************
REM THIS PROGRAM IS PROPRIETARY INFORMATION OF SUNGARD HIGHER EDUCATION AND IS
REM NOT TO BE COPIED, REPRODUCED, LENT OR DISPOSED OF, NOR USED FOR ANY PURPOSE
REM OTHER THAN THAT FOR WHICH IT IS SPECIFICALLY PROVIDED WITHOUT THE WRITTEN
REM PERMISSION OF SAID COMPANY.
REM ***************************************************************************
REM
REM  Script Name : sztstcr_01.sql
REM
REM      Project : TECMILE
REM
REM      Release : 8.7.0 [TECMILE:02.1.0]
REM
REM  Description : Create the SZ_MC_SFRSTCR_BEFORE_DELETE trigger.
REM
REM  AUDIT TRAIL: 8.7.0 [TECMILE:02.1.0]                         INI    DATE
REM  ---------------------------------------------------------- --- -----------
REM  1. Create the SZ_MC_SFRSTCR_BEFORE_DELETE trigger           MSO 12/03/2016
REM  ---------------------------------------------------------- --- -----------
REM  AUDIT TRAIL: 8.31.2 [MOD:02.2.0]                         INI    DATE      
REM  --------------------------------------------------------- --- ------------
REM  1. Student version updated from 8.7 to 8.31.2             LMR 04-DIC-2024
REM  ---------------------------------------------------------- --- -----------
REM
REM
REM  AUDIT TRAIL : END
REM
REM ***************************************************************************

REM
REM Prompting to the Output File.
REM
PROMPT
PROMPT ******************************************
PROMPT * Now Running sztstcr_01 Trigger.          *
PROMPT ******************************************
PROMPT

SET DEFINE ON
SET SCAN ON
CONNECT saturn/&&saturn_password;
SET DEFINE OFF
SET SCAN OFF
SET SHOWMODE OFF
SET ECHO OFF
SET VERI OFF
SET HEAD OFF
SET TIME OFF
SET TRIMSPOOL ON

CREATE OR REPLACE TRIGGER SZ_MC_SFRSTCR_BEFORE_DELETE
--
-- FILE NAME..: sztstcr_01.sql
-- RELEASE....: 8.7.0 [TECMILE:02.1.0]
-- OBJECT NAME: SZ_MC_SFRSTCR_BEFORE_DELETE
-- PRODUCT....: STUDENT
-- USAGE......: Delete the rows in SZRSTCR before a Delete from SFRSTCR table.
-- COPYRIGHT..: Copyright 2016 Ellucian Company L.P. and its affiliates.
--
-- DESCRIPTION:
--
-- This trigger delete rows from SZRSPRC table.
--
-- DESCRIPTION END
--
  BEFORE DELETE
     ON SFRSTCR
    FOR EACH ROW

  
  DECLARE

  BEGIN
      DELETE FROM SZRSTCR
           WHERE SZRSTCR_TERM_CODE = :old.SFRSTCR_TERM_CODE
             AND SZRSTCR_CRN       = :old.SFRSTCR_CRN
         AND SZRSTCR_PIDM      = :old.SFRSTCR_PIDM;
    
  END;
/

SHOW ERRORS
REM SET SCAN OFF
