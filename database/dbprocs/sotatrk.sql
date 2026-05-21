REM ****************************************************************************
REM                                                                            *
REM sotatrk.sql Copyright 2024 Ellucian Company L.P. and its affiliates.       *
REM                                                                            *
REM ****************************************************************************
REM                                                                            *
REM                     CONFIDENTIAL BUSINESS INFORMATION                      *
REM                                                                            *
REM **************************************************************************** 
REM THIS PROGRAM IS PROPRIETARY INFORMATION OF SUNGARD HIGHER EDUCATION AND IS *
REM NOT TO BE COPIED, REPRODUCED, LENT OR DISPOSED OF, NOR USED FOR ANY PURPOSE*
REM OTHER THAN THAT FOR WHICH IT IS SPECIFICALLY PROVIDED WITHOUT THE WRITTEN  *
REM PERMISSION OF SAID COMPANY.                                                *
REM ****************************************************************************
REM                                                                            *
REM  Script Name : sotatrk.sql                                                 *
REM                                                                            *
REM      Project : TECMILE                                                     *
REM                                                                            *
REM      Release : 8.7.0 [TECMILE:02.1.0]                                      *
REM                                                                            *
REM  Description : Create the SZ_MC_ATRK_SYNC_I trigger.                       *
REM                                                                            *
REM  AUDIT TRAIL: 8.7.0 [TECMILE:02.1.0]                       INI    DATE     *
REM  --------------------------------------------------------- --- ----------- *
REM  1. Create the SZ_MC_ATRK_SYNC_I  trigger                  MSO 08-MAR-2015 *
REM  --------------------------------------------------------- --- ----------- *
REM  AUDIT TRAIL: 8.7.0 [TECMILE:02.1.1]                         INI    DATE   *
REM  --------------------------------------------------------- --- ----------- *
REM  1. Se agrega validacion para que no tome en cuenta        MSO 08-MAR-2015 *
REM     secciones del periodo 999996                                           *
REM  ---------------------------------------------------------- --- -----------*
REM  AUDIT TRAIL: 8.31.2 [MOD:02.2.0]                         INI    DATE      *
REM  --------------------------------------------------------- --- ----------- *
REM  1. Student version updated from 8.7 to 8.31.2             LMR 07-NOV-2024 *
REM  ---------------------------------------------------------- --- -----------*
REM                                                                            *
REM  AUDIT TRAIL : END                                                         *
REM                                                                            *
REM ****************************************************************************

REM
REM Prompting to the Output File.
REM
PROMPT
PROMPT ******************************************
PROMPT * Now Running sotatrk Trigger.          *
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

create or replace TRIGGER SZ_MC_ATRK_SYNC_I
BEFORE INSERT ON SSBSECT
FOR EACH ROW
DECLARE
    vNextSeqno      NUMBER;
BEGIN
     
    IF ( :new.SSBSECT_TERM_CODE <> '999996' ) THEN
        
        SELECT nvl(max(SORATRK_SEQ_NO),0) + 1
          into vNextSeqno
          FROM soratrk;
        INSERT INTO SORATRK (SORATRK_SEQ_NO,  /*BIEN*/
                            SORATRK_TERM_CODE,
                            SORATRK_CRN,
                            SORATRK_SUBJ_CODE,
                            SORATRK_CRSE_NUMB,
                            SORATRK_PTRM_CODE,
                            SORATRK_ENTRY_START_DATE,
                            SORATRK_ENTRY_END_DATE,
                            SORATRK_TRACKING_UNIT_CDE,
                            SORATRK_TRACK_ATTEND_IND,
                            SORATRK_ATTEND_ENTER_IND,
                            SORATRK_USER_ID,
                            SORATRK_ACTIVITY_DATE,
                            SORATRK_DATA_ORIGIN)
                     values (vNextSeqno,
                            :new.SSBSECT_TERM_CODE,
                            :new.SSBSECT_CRN,
                            :new.SSBSECT_SUBJ_CODE,
                            :new.SSBSECT_CRSE_NUMB,
                            :new.SSBSECT_PTRM_CODE,
                            :new.SSBSECT_PTRM_START_DATE,
                            :new.SSBSECT_PTRM_END_DATE,
                            '0001',
                            'Y',
                            'Y',
                            USER,
                            SYSDATE,
                            'SSBSECT'
                             );
    END IF;

END;
/

SHOW ERRORS
REM SET SCAN OFF
