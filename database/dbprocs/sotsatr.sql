REM ****************************************************************************
REM                                                                            *
REM sotsatr.sql Copyright 2024 Ellucian Company L.P. and its affiliates.       *
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
REM  Script Name : sotsatr.sql                                                 *
REM                                                                            *
REM      Project : TECMILE                                                     *
REM                                                                            *
REM      Release : 8.7.0 [TECMILE:02.1.0]                                      *
REM                                                                            *
REM  Description : Create the SZ_MC_SORSATR_POST_IU trigger.                   *
REM                                                                            *
REM  AUDIT TRAIL: 8.7.0 [TECMILE:02.1.0]                         INI    DATE   *
REM  ---------------------------------------------------------- --- -----------*
REM  1. Create the SZ_MC_SORSATR_POST_IU  trigger               MSO 26-JAN-2015*
REM  ---------------------------------------------------------- --- -----------*
REM  AUDIT TRAIL: 8.31.2 [MOD:02.2.0]                          INI    DATE     *
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
PROMPT * Now Running sotsatr Trigger.          *
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

create or replace TRIGGER SZ_MC_SORSATR_POST_IU
--
-- FILE NAME..: sotsatr.sql.sql
-- RELEASE....: 8.31.2 [LAET:002.2.2]
-- OBJECT NAME: SZ_MC_SORSATR_POST_IU
-- PRODUCT....: STUDENT
-- USAGE......: Insert rows created into SORSATR table.
-- COPYRIGHT..: Copyright 2025 Ellucian Company L.P. and its affiliates.
--
-- DESCRIPTION:
--
-- This trigger inserts rows into SORSATR table.
--
-- DESCRIPTION END
--
  AFTER INSERT OR UPDATE OR DELETE
     ON SORSATR
    FOR EACH ROW


  DECLARE

    CURSOR VERIFY_SZRABSC(c_pidm  number, c_term varchar2, c_crn varchar2, c_date date) is
        SELECT COUNT(*)
          FROM SZRABSC
         WHERE SZRABSC_PIDM = c_pidm
           AND SZRABSC_TERM = c_term
           AND SZRABSC_CRN = c_crn
           AND SZRABSC_DATE = c_date;

    CURSOR VERIFY_SZRSATR(c_pidm  number, c_term varchar2, c_crn varchar2, c_date date) is
        SELECT COUNT(*)
          FROM SZRSATR
         WHERE SZRSATR_PIDM = c_pidm
           AND SZRSATR_TERM_CODE = c_term
           AND SZRSATR_CRN = c_crn
           AND SZRSATR_JUST_MEET_DATE = c_date;

    CURSOR GET_BB_IND(sPidm NUMBER, sTerm VARCHAR2, sCrn VARCHAR2) IS
        SELECT COUNT(*)
          FROM SZRAATR
         WHERE SZRAATR_PIDM = sPidm
           AND SZRAATR_CRN = sCrn
           AND SZRAATR_TERM_CODE = sTerm;


    CURSOR GET_SSRMEET(c_surro_id number) is
           SELECT  SSRMEET_TERM_CODE
                  ,SSRMEET_CRN
             FROM SSRMEET
            WHERE SSRMEET_SURROGATE_ID = c_surro_id;

    CURSOR COUNT_SZRABS(sPidm NUMBER, sTerm VARCHAR2, sCrn VARCHAR2) IS
        SELECT COUNT(*) 
         FROM SZRABSC 
        WHERE SZRABSC_PIDM = sPidm
          AND SZRABSC_TERM = sTerm
          AND SZRABSC_CRN = sCrn; 



    lv_count           NUMBER(8);
    lv_count_s         NUMBER(8);
    lv_term            VARCHAR2(6);
    lv_crn             VARCHAR2(5);
    lv_date            DATE;

    lv_count_b          NUMBER(8);
    lv_count_szrabsc    NUMBER(8);

  BEGIN
        IF INSERTING THEN
          IF :NEW.SORSATR_ATTEND_IND = 'N' THEN

            OPEN GET_SSRMEET(:NEW.SORSATR_SURROGATE_ID_SSRMEET);
            FETCH GET_SSRMEET INTO lv_term, lv_crn;
            CLOSE GET_SSRMEET;

            OPEN VERIFY_SZRABSC(:NEW.SORSATR_PIDM, lv_term, lv_crn, :NEW.SORSATR_MEET_DATE);
            FETCH VERIFY_SZRABSC INTO lv_count;
            CLOSE VERIFY_SZRABSC;

            OPEN VERIFY_SZRSATR(:NEW.SORSATR_PIDM, lv_term, lv_crn, :NEW.SORSATR_MEET_DATE);
            FETCH VERIFY_SZRSATR INTO lv_count_s;
            CLOSE VERIFY_SZRSATR;

            IF lv_count = 0 THEN
              INSERT INTO SZRABSC (
                SZRABSC_PIDM,
                SZRABSC_TERM,
                SZRABSC_CRN,
                SZRABSC_DATE
              )
              VALUES (
                :NEW.SORSATR_PIDM,
                lv_term,
                lv_crn,
                :NEW.SORSATR_MEET_DATE
              );
            END IF;

            IF lv_count_s = 0 THEN
              INSERT INTO SZRSATR (
                SZRSATR_PIDM,
                SZRSATR_TERM_CODE,
                SZRSATR_CRN,
                SZRSATR_JUST_MEET_DATE,
                SZRSATR_USER_ID,
                SZRSATR_ACTIVITY_DATE,
                SZRSATR_DATA_ORIGIN,
                SZRSATR_SATR_SURR_ID_MEET
              )
              VALUES (
                :NEW.SORSATR_PIDM,
                lv_term,
                lv_crn,
                :NEW.SORSATR_MEET_DATE,
                USER,
                SYSDATE,
                'TRIGGER_SR',
                :NEW.SORSATR_SURROGATE_ID_SSRMEET
              );
                END IF;

                OPEN GET_BB_IND(:NEW.SORSATR_PIDM, lv_term, lv_crn);
                FETCH GET_BB_IND INTO lv_count_b;
                CLOSE GET_BB_IND;

                OPEN COUNT_SZRABS(:NEW.SORSATR_PIDM, lv_term, lv_crn);  
                FETCH COUNT_SZRABS INTO lv_count_szrabsc;
                CLOSE COUNT_SZRABS;

                IF lv_count_b > 0 THEN
                    UPDATE SZRAATR
                       --SET SZRAATR_ABS_ACCUM = NVL(SZRAATR_ABS_ACCUM,0) + 1    --8.5.3 [UTM:002.2.1]
                         SET SZRAATR_ABS_ACCUM = lv_count_szrabsc                --8.5.3 [UTM:002.2.1]
                          ,SZRAATR_ACTIVITY_DATE = SYSDATE
                     WHERE SZRAATR_PIDM = :NEW.SORSATR_PIDM
                       AND SZRAATR_TERM_CODE = lv_term
                       AND SZRAATR_CRN = lv_crn;
                ELSE
                    INSERT INTO SZRAATR (  SZRAATR_PIDM
                                          ,SZRAATR_TERM_CODE
                                          ,SZRAATR_CRN
                                          ,SZRAATR_ABS_ACCUM
                                          ,SZRAATR_USER_ID
                                          ,SZRAATR_ACTIVITY_DATE
                                          ,SZRAATR_DATA_ORIGIN
                                          )
                                VALUES  (  :NEW.SORSATR_PIDM
                                          ,lv_term
                                          ,lv_crn
                                          ,1
                                          ,USER
                                          ,SYSDATE
                                          ,'TRIGGER_SR'
                                        );
                END IF;

            END IF;

        ELSIF UPDATING THEN 
            IF :OLD.SORSATR_ATTEND_IND = 'Y' AND :NEW.SORSATR_ATTEND_IND = 'N' THEN

            OPEN GET_SSRMEET(:NEW.SORSATR_SURROGATE_ID_SSRMEET);
            FETCH GET_SSRMEET INTO lv_term, lv_crn;
            CLOSE GET_SSRMEET;

            OPEN VERIFY_SZRABSC(:NEW.SORSATR_PIDM, lv_term, lv_crn, :NEW.SORSATR_MEET_DATE);
            FETCH VERIFY_SZRABSC INTO lv_count;
            CLOSE VERIFY_SZRABSC;

            OPEN VERIFY_SZRSATR(:NEW.SORSATR_PIDM, lv_term, lv_crn, :NEW.SORSATR_MEET_DATE);
            FETCH VERIFY_SZRSATR INTO lv_count_s;
            CLOSE VERIFY_SZRSATR;

            IF lv_count = 0 THEN
              INSERT INTO SZRABSC (
                SZRABSC_PIDM,
                SZRABSC_TERM,
                SZRABSC_CRN,
                SZRABSC_DATE
              )
              VALUES (
                :NEW.SORSATR_PIDM,
                lv_term,
                lv_crn,
                :NEW.SORSATR_MEET_DATE
              );
            END IF;

            IF lv_count_s = 0 THEN
              INSERT INTO SZRSATR (
                SZRSATR_PIDM,
                SZRSATR_TERM_CODE,
                SZRSATR_CRN,
                SZRSATR_JUST_MEET_DATE,
                SZRSATR_USER_ID,
                SZRSATR_ACTIVITY_DATE,
                SZRSATR_DATA_ORIGIN,
                SZRSATR_SATR_SURR_ID_MEET
              )
              VALUES (
                :NEW.SORSATR_PIDM,
                lv_term,
                lv_crn,
                :NEW.SORSATR_MEET_DATE,
                USER,
                SYSDATE,
                'TRIGGER_SR',
                :NEW.SORSATR_SURROGATE_ID_SSRMEET
              );
                END IF;

                OPEN GET_BB_IND(:NEW.SORSATR_PIDM, lv_term, lv_crn);
                FETCH GET_BB_IND INTO lv_count_b;
                CLOSE GET_BB_IND;

                OPEN COUNT_SZRABS(:NEW.SORSATR_PIDM, lv_term, lv_crn);  
                FETCH COUNT_SZRABS INTO lv_count_szrabsc;
                CLOSE COUNT_SZRABS;

                IF lv_count_b > 0 THEN
                    UPDATE SZRAATR
                       --SET SZRAATR_ABS_ACCUM = NVL(SZRAATR_ABS_ACCUM,0) + 1    --8.5.3 [UTM:002.2.1]
                         SET SZRAATR_ABS_ACCUM = lv_count_szrabsc                --8.5.3 [UTM:002.2.1]
                          ,SZRAATR_ACTIVITY_DATE = SYSDATE
                     WHERE SZRAATR_PIDM = :NEW.SORSATR_PIDM
                       AND SZRAATR_TERM_CODE = lv_term
                       AND SZRAATR_CRN = lv_crn;
                ELSE
                    INSERT INTO SZRAATR (  SZRAATR_PIDM
                                          ,SZRAATR_TERM_CODE
                                          ,SZRAATR_CRN
                                          ,SZRAATR_ABS_ACCUM
                                          ,SZRAATR_USER_ID
                                          ,SZRAATR_ACTIVITY_DATE
                                          ,SZRAATR_DATA_ORIGIN
                                          )
                                VALUES  (  :NEW.SORSATR_PIDM
                                          ,lv_term
                                          ,lv_crn
                                          ,1
                                          ,USER
                                          ,SYSDATE
                                          ,'TRIGGER_SR'
                                        );
                END IF;

            END IF;

        ELSIF DELETING THEN
            OPEN GET_SSRMEET(:OLD.SORSATR_SURROGATE_ID_SSRMEET);
            FETCH GET_SSRMEET INTO lv_term, lv_crn;
            CLOSE GET_SSRMEET;

            DELETE FROM SZRSATR
             WHERE SZRSATR_PIDM = :OLD.SORSATR_PIDM
               AND SZRSATR_TERM_CODE = lv_term
               AND SZRSATR_CRN = lv_crn
               AND SZRSATR_JUST_MEET_DATE = :OLD.SORSATR_MEET_DATE;

            DELETE FROM SZRABSC
             WHERE SZRABSC_PIDM = :OLD.SORSATR_PIDM
               AND SZRABSC_TERM = lv_term
               AND SZRABSC_CRN = lv_crn
               AND SZRABSC_DATE = :OLD.SORSATR_MEET_DATE;

            -- recalcular acumulado
            OPEN COUNT_SZRABS(:OLD.SORSATR_PIDM, lv_term, lv_crn);
            FETCH COUNT_SZRABS INTO lv_count_szrabsc;
            CLOSE COUNT_SZRABS;

            UPDATE SZRAATR
               SET SZRAATR_ABS_ACCUM = lv_count_szrabsc,
                   SZRAATR_ACTIVITY_DATE = SYSDATE
             WHERE SZRAATR_PIDM = :OLD.SORSATR_PIDM
               AND SZRAATR_TERM_CODE = lv_term
               AND SZRAATR_CRN = lv_crn;


        END IF;

  END;
/

SHOW ERRORS
REM SET SCAN OFF
