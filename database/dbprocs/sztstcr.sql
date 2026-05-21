REM ***************************************************************************
REM
REM sztstcr.sql Copyright 2015 Ellucian Company L.P. and its affiliates.
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
REM  Script Name : sztstcr.sql
REM
REM      Project : TECMILE
REM
REM      Release : 8.7.0 [TECMILE:02.1.0]
REM
REM  Description : Create the SZ_MC_SFRSTCR_POST_IU trigger.
REM
REM  AUDIT TRAIL: 8.7.0 [TECMILE:02.1.0]                         INI    DATE
REM  ---------------------------------------------------------- --- -----------
REM  1. Create the SZ_MC_SFRSTCR_POST_UDPATE trigger            MKU 26-NOV-2015
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
PROMPT * Now Running sztstcr Trigger.          *
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

CREATE OR REPLACE TRIGGER SZ_MC_SFRSTCR_POST_IU
--
-- FILE NAME..: sztstcr.sql
-- RELEASE....: 8.7.0 [TECMILE:02.1.0]
-- OBJECT NAME: SZ_MC_SFRSTCR_POST_INSERT_UDPATE
-- PRODUCT....: STUDENT
-- USAGE......: Insert the rows created into SZRSTCR table.
-- COPYRIGHT..: Copyright 2015 Ellucian Company L.P. and its affiliates.
--
-- DESCRIPTION:
--
-- This trigger inserts rows into SZRSPRC table.
--
-- DESCRIPTION END
--
  AFTER INSERT 
     OR UPDATE
     ON SFRSTCR
    FOR EACH ROW
    when ( nvl(new.SFRSTCR_GRDE_CODE,'--') <> nvl(old.SFRSTCR_GRDE_CODE,'--') or
           nvl(new.SFRSTCR_GRDE_CODE_MID,'--') <> nvl(old.SFRSTCR_GRDE_CODE_MID,'--')
          )
  
  DECLARE
    vNextSeqno      NUMBER;

  BEGIN

    if nvl(:new.SFRSTCR_GRDE_CODE,'--') <> nvl(:old.SFRSTCR_GRDE_CODE,'--') and
        :new.SFRSTCR_GRDE_CODE is not null then
        vNextSeqno := null;
      
        SELECT nvl(max(SZ.SZRSTCR_SEQ),0) + 1
          into vNextSeqno
          FROM SZRSTCR SZ
         WHERE SZ.SZRSTCR_TERM_CODE = :NEW.SFRSTCR_TERM_CODE
           and SZ.SZRSTCR_CRN = :NEW.SFRSTCR_CRN
           and SZ.SZRSTCR_PIDM = :NEW.SFRSTCR_PIDM;

        insert into SZRSTCR(SZRSTCR_TERM_CODE, SZRSTCR_CRN, SZRSTCR_PIDM, /*BIEN*/
                            SZRSTCR_SEQ, SZRSTCR_GRDE_CODE, 
                            SZRSTCR_USER_ID, SZRSTCR_ACTIVITY_DATE,
                            SZRSTCR_DATA_ORIGIN)
                     values(:new.SFRSTCR_TERM_CODE, :new.SFRSTCR_CRN, :new.SFRSTCR_PIDM, 
                            vNextSeqno, :new.SFRSTCR_GRDE_CODE,
                            user, sysdate,
                            'SZ_MC_SFRSTCR_POST_IU' 
                            );
    end if;
    
    if nvl(:new.SFRSTCR_GRDE_CODE_MID,'--') <> nvl(:old.SFRSTCR_GRDE_CODE_MID,'--') 
        and :new.SFRSTCR_GRDE_CODE_MID is not null then
        vNextSeqno := null;
      
        SELECT nvl(max(SZ.SZRSTCR_SEQ),0) + 1
          into vNextSeqno
          FROM SZRSTCR SZ
         WHERE SZ.SZRSTCR_TERM_CODE = :NEW.SFRSTCR_TERM_CODE
           and SZ.SZRSTCR_CRN = :NEW.SFRSTCR_CRN
           and SZ.SZRSTCR_PIDM = :NEW.SFRSTCR_PIDM;

        insert into SZRSTCR(SZRSTCR_TERM_CODE, SZRSTCR_CRN, SZRSTCR_PIDM, /*BIEN*/
                            SZRSTCR_SEQ, SZRSTCR_GRDE_CODE, 
                            SZRSTCR_USER_ID, SZRSTCR_ACTIVITY_DATE,
                            SZRSTCR_DATA_ORIGIN)
                     values(:new.SFRSTCR_TERM_CODE, :new.SFRSTCR_CRN, :new.SFRSTCR_PIDM, 
                            vNextSeqno, :new.SFRSTCR_GRDE_CODE_MID,
                            user, sysdate,
                            'SZ_MC_SFRSTCR_POST_IU' 
                            );    
    end if;
    
  END;
/

SHOW ERRORS
REM SET SCAN OFF
