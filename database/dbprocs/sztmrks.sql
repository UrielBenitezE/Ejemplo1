REM ***************************************************************************
REM
REM sztmrks.sql Copyright 2015 Ellucian Company L.P. and its affiliates.
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
REM  Script Name : sztmrks.sql
REM
REM      Project : TECMILE
REM
REM      Release : 8.7.0 [TECMILE:02.1.0]
REM
REM  Description : Create the SZ_MC_SHRMRKS_POST_IU trigger.
REM
REM  AUDIT TRAIL: 8.7.0 [TECMILE:02.1.0]                         INI    DATE
REM  ---------------------------------------------------------- --- -----------
REM  1. Create the SZ_MC_SHRMRKS_POST_IU  trigger               MKU 26-NOV-2015
REM  ---------------------------------------------------------- --- -----------
REM  AUDIT TRAIL: 8.31.2 [MOD:02.2.0]                         INI    DATE      
REM  --------------------------------------------------------- --- ------------
REM  1. Student version updated from 8.7 to 8.31.2             LMR 07-NOV-2024
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
PROMPT * Now Running sztmrks Trigger.          *
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

CREATE OR REPLACE TRIGGER SZ_MC_SHRMRKS_POST_IU
--
-- FILE NAME..: sztmrks.sql
-- RELEASE....: 8.7.0 [TECMILE:02.1.0]
-- OBJECT NAME: SZ_MC_SHRMRKS_POST_IU
-- PRODUCT....: STUDENT
-- USAGE......: Insert rows created into SZRMRKS table.
-- COPYRIGHT..: Copyright 2015 Ellucian Company L.P. and its affiliates.
--
-- DESCRIPTION:
--
-- This trigger inserts rows into SZRMRKS table.
--
-- DESCRIPTION END
--
  AFTER INSERT 
     OR UPDATE
     ON SHRMRKS
    FOR EACH ROW

  
  DECLARE
    Cursor get_next_seqno_c(c_term_code     varchar2,
                            c_crn           varchar2,
                            c_pidm          number,
                            c_gcom_id       number) is
        SELECT NVL(MAX(SZ.SZRMRKS_SEQNO),0) + 1
          FROM SZRMRKS SZ
         WHERE SZ.SZRMRKS_TERM_CODE = c_term_code
           AND SZ.SZRMRKS_CRN = c_crn
           AND SZ.SZRMRKS_PIDM = c_pidm
           AND SZ.SZRMRKS_GCOM_ID = c_gcom_id;
           
    vNextSeqno      NUMBER;
    vMensErro       varchar2(200);

  BEGIN

    vNextSeqno := null;
    vMensErro := null;
    
    
    -- make a copy from shrmrks to szrmrks

    IF NVL(trim(:old.SHRMRKS_GRDE_CODE),'-999') <> NVL(trim(:new.SHRMRKS_GRDE_CODE),'-999') OR
       NVL(trim(:old.SHRMRKS_SCORE),-999) <> NVL(trim(:new.SHRMRKS_SCORE),-999) THEN
    
        open get_next_seqno_c(:NEW.SHRMRKS_TERM_CODE, 
                              :NEW.SHRMRKS_CRN, 
                              :NEW.SHRMRKS_PIDM, 
                              :NEW.SHRMRKS_GCOM_ID);
        fetch get_next_seqno_c into vNextSeqno;
        close get_next_seqno_c;

        insert into szrmrks(SZRMRKS_TERM_CODE, SZRMRKS_CRN, SZRMRKS_PIDM, SZRMRKS_GCOM_ID, /*BIEN*/
                        SZRMRKS_SEQNO, SZRMRKS_ACTIVITY_DATE, SZRMRKS_USER_ID, SZRMRKS_GCOM_DATE,
                        SZRMRKS_MARK_CALC_DATE, SZRMRKS_SCORE, SZRMRKS_PERCENTAGE,
                        SZRMRKS_GRDE_CODE, SZRMRKS_COMPLETED_DATE, SZRMRKS_RETURNED_DATE,
                        SZRMRKS_COMMENTS, SZRMRKS_GCHG_CODE, SZRMRKS_EXTENSION_DATE,
                        SZRMRKS_ROLL_DATE, SZRMRKS_MARKER, SZRMRKS_DATA_ORIGIN,
                        SZRMRKS_SURROGATE_ID, SZRMRKS_VERSION, SZRMRKS_VPDI_CODE)
                 values(:NEW.SHRMRKS_TERM_CODE, :NEW.SHRMRKS_CRN, :NEW.SHRMRKS_PIDM, :NEW.SHRMRKS_GCOM_ID,
                        vNextSeqno, sysdate, :NEW.SHRMRKS_USER_ID, :NEW.SHRMRKS_GCOM_DATE,
                        :NEW.SHRMRKS_MARK_CALC_DATE, :NEW.SHRMRKS_SCORE, :NEW.SHRMRKS_PERCENTAGE,
                        :NEW.SHRMRKS_GRDE_CODE, :NEW.SHRMRKS_COMPLETED_DATE, :NEW.SHRMRKS_RETURNED_DATE,
                        :NEW.SHRMRKS_COMMENTS, :NEW.SHRMRKS_GCHG_CODE, :NEW.SHRMRKS_EXTENSION_DATE,
                        :NEW.SHRMRKS_ROLL_DATE, :NEW.SHRMRKS_MARKER, 'SZ_MC_SHRMRKS_POST_IU',
                        :NEW.SHRMRKS_SURROGATE_ID, :NEW.SHRMRKS_VERSION, :NEW.SHRMRKS_VPDI_CODE
                        );
                        
        -- send email to student just when grade changes and user = WWW_USER
        if :new.SHRMRKS_USER_ID = 'WWW_USER' and 
            trim(:new.SHRMRKS_GRDE_CODE) is not null and
            trim(:old.SHRMRKS_GRDE_CODE) is not null then 
            
            szksecg.p_BuildEmail(:new.SHRMRKS_PIDM , /*BIEN*/
                                 :new.SHRMRKS_TERM_CODE,
                                 :new.SHRMRKS_CRN,
                                 :new.SHRMRKS_GCOM_ID,
                                 vNextSeqno,
                                 :new.SHRMRKS_GRDE_CODE,
                                 :old.SHRMRKS_GRDE_CODE,
                                 vMensErro);
                         
        end if;
    

    END IF;

   
    
  END;
/

SHOW ERRORS
REM SET SCAN OFF
