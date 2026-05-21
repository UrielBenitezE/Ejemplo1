/* *****************************************************************************/
/* szpmrk1.sql Copyright 2016 Ellucian Company L.P. and its affiliates.       */
/* *****************************************************************************/

/* *****************************************************************************/
/*                                                                            */
/*                    CONFIDENTIAL BUSINESS INFORMATION                       */
/*                                                                            */
/* *****************************************************************************/
/*                                                                            */
/*  THIS PROGRAM IS PROPRIETARY INFORMATION OF ELLUCIAN AND ITS AFFILIATES AND*/
/*  IS NOT TO BE COPIED, REPRODUCED, LENT OR DISPOSED OF, NOR USED FOR ANY    */
/*  PURPOSE OTHER THAN THAT FOR WHICH IT IS SPECIFICALLY PROVIDED WITHOUT THE */
/*  WRITTEN PERMISSION OF SAID COMPANY.                                       */
/*                                                                            */
/* *****************************************************************************/
/*                                                                            */
/* FILE NAME..: szpmrk1.sql                                                   */
/*                                                                            */
/* RELEASE....: 8.7.0 [UTM:002.1.0]                                           */
/*                                                                            */
/* OBJECT NAME: SZKMRKS                                                       */
/*                                                                            */
/* DESCRIPTION: This package processes massive  grades activities.            */
/*                                                                            */
/* *****************************************************************************/
/*                                                                            */
/* FUNCTIONS                                                                  */
/*                                                                            */
/*This package processes massive  grades activities.                          */
/*                                                                            */
/* *****************************************************************************/
/*                                                                            */
/* AUDIT TRAIL: 8.7.0 [UTM:002.1.0]                                           */
/* --------------------------------------------------------  ---  ----------- */
/* 1. Initial Code                                           DL   11/ENE/2016 */
/* --------------------------------------------------------  ---  ----------- */
/*                                                                            */
/* AUDIT TRAIL: 8.7.0 [UTM:002.1.1]                                           */
/* --------------------------------------------------------  ---  ----------- */
/* 1. Changes added to try to calculate the final grade      JAR  14/JUN/2016 */
/*    if all the component's grades are completed.                            */
/* 2. Added a reference to a new procedure to calculate      JAR  23/JUN/2016 */
/*    average for subcomponents.                                              */
/* --------------------------------------------------------  ---  ----------- */
/*                                                                            */
/* AUDIT TRAIL: 8.7.0 [UTM:002.1.2]                           INI    DATE     */
/* --------------------------------------------- ------------ --- ----------- */
/* 1. A delete was added to delete duplicated records.        MSO 27-JUL-2016 */
/* ---------------------------------------------------------- --- ----------- */
/*                                                                            */
/* AUDIT TRAIL: 8.7.0 [UTM:002.1.3]                           INI    DATE     */
/* --------------------------------------------- ------------ --- ----------- */
/* 1. A validation was added to avoid an update when grade    MSO 17-AGO-2016 */
/*    is not null.                                                            */
/* ---------------------------------------------------------- --- ----------- */
/* AUDIT TRAIL: 8.7.0 [UTM:002.1.4]                           INI    DATE     */
/* --------------------------------------------- ------------ --- ----------- */
/* 1. A validation was added to update final grade in SFRSTCR MSO 12-SEP-2016 */
/*    when data is not null in file uploaded to run SZPMRKS                   */
/* ---------------------------------------------------------- --- ----------- */
/* AUDIT TRAIL: 8.7.0 [UTM:002.1.5]                           INI    DATE     */
/* --------------------------------------------- ------------ --- ----------- */
/* 1. Procedures for SZPCADA pro*C were added, these new      MSO  15-SEP-2016*/
/*    procedures calculate the limit of absences and NE grades                */
/* ---------------------------------------------------------- --- ----------- */
/* AUDIT TRAIL: 8.7.0 [UTM:002.1.6]                           INI    DATE     */
/* --------------------------------------------- ------------ --- ----------- */
/* 1. Update to Data Origin and User_ID is added when grades  MSO 21-SEP-2016 */
/*    are uploaded from massive file.                                         */
/* --------------------------------------------------------  ---  ----------- */
/*  AUDIT TRAIL: 8.31.2 [MOD:02.2.0]                                          */
/*  -------------------------------------------------------  ---  ----------- */
/*  1. Student version updated from 8.7 to 8.31.2            LMR 07-NOV-2024  */
/*  -------------------------------------------------------  ---  ----------- */  
/*                                                                            */
/* AUDIT TRAIL END                                                            */
/*                                                                            */
/* *****************************************************************************/
/*                                                                            */
/* BEGIN COMMENT                                                              */
/*                                                                            */
/* This package processes massive  grades activities.                         */
/*                                                                            */
/* END COMMENT                                                                */
/* *****************************************************************************/

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

create or replace PACKAGE BODY SZKMRKS AS
--AUDIT_TRAIL_MSGKEY_UPDATE
-- PROJECT : MSGKEY
-- MODULE  : SZKMRK1
-- SOURCE  : enUS
-- TARGET  : I18N
-- DATE    : Wed Sep 11 16:02:07 2013
-- MSGSIGN : #3b41b77972145a07
--TMI18N.ETR DO NOT CHANGE--
--
-- FILE NAME..: szpmrk1.sql
-- RELEASE....: 8.7 [UTM:002.1.6]
-- OBJECT NAME: SZKMRKS
-- USAGE......: Utilities to process payments files.
-- COPYRIGHT..: Copyright 2016 Ellucian Company L.P. and its affiliates.
--
-- DESCRIPTION:
--
-- This package processes massive  grades activities.
--
-- DESCRIPTION END

  /*----------------------------------------------------------------------------*/
  /* CONSTANTS DECLARATION                                                      */
  /*----------------------------------------------------------------------------*/


  /*----------------------------------------------------------------------------*/
  /* PRIVATE VARIABLES DECLARATION                                              */
  /*----------------------------------------------------------------------------*/
  type array is table of varchar2(20) index by binary_integer;
  lv_linearray array;
  lv_pidm      SPRIDEN.SPRIDEN_PIDM%TYPE;
  
  vDebugTurnOn BOOLEAN := FALSE;
  
  -- BA 8.7.0 [UTM:002.1.1]
  CURSOR GET_REAL_GRDE_VALUES_C( vGrde SHRGRSC.SHRGRSC_GRDE_CODE%TYPE ) IS
    --SELECT SHRGRSC_GRDE_CODE,
    --       SHRGRSC_PERCENTAGE,
    --       SHRGRSC_MEDIAN
    SELECT SHRGRSC_GRDE_CODE AS SHRGRSC_GRDE_CODE,
           DECODE( SHRGRSC_MEDIAN, NULL, TO_NUMBER( SHRGRSC_GRDE_CODE ), SHRGRSC_MEDIAN ) AS SHRGRSC_PERCENTAGE,
           DECODE( SHRGRSC_MEDIAN, NULL, TO_NUMBER( SHRGRSC_GRDE_CODE ), SHRGRSC_MEDIAN ) AS SHRGRSC_MEDIAN
      FROM SHRGRSC
     WHERE SHRGRSC_GRDE_CODE = vGrde
       AND SHRGRSC_GSCH_NAME = 'UTM';
-- EA 8.7.0 [UTM:002.1.1]
  
  /*----------------------------------------------------------------------------*/
  /* PRIVATE CURSORS DECLARATION                                                */
  /*----------------------------------------------------------------------------*/

  /*----------------------------------------------------------------------------*/
  /*                                                                            */
  /* PRIVATE FUNCTIONS                                                          */
  /*                                                                            */
  /*----------------------------------------------------------------------------*/

  /*----------------------------------------------------------------------------*/
  /*                                                                            */
  /* PRIVATE PROCEDURES                                                         */
  /*                                                                            */
  /*----------------------------------------------------------------------------*/

FUNCTION F_StringType( p_String VARCHAR2 ) RETURN VARCHAR2 IS
  CURSOR CHK_STR_TYPE_C IS
    SELECT CASE
             WHEN REGEXP_LIKE(p_String, '^-?[[:digit:],.]*$') THEN
               'N'
             ELSE
               'A'
           END
      FROM DUAL;
  
  vResult VARCHAR2(1);
BEGIN
  IF p_String IS NOT NULL THEN
    OPEN CHK_STR_TYPE_C;
    FETCH CHK_STR_TYPE_C
     INTO vResult;
    IF CHK_STR_TYPE_C%NOTFOUND THEN
      vResult := 'X';
    END IF;
    CLOSE CHK_STR_TYPE_C;
  ELSE
    vResult := '-';
  END IF;
  
  RETURN vResult;
END F_StringType;

FUNCTION F_RetMaxGrdePriority( vGrdeCode1 VARCHAR2, vGrdeCode2 VARCHAR2 ) RETURN VARCHAR2 IS

  FUNCTION F_GetGradePriority( vGrdeCode VARCHAR2 ) RETURN NUMBER IS
  
    CURSOR GET_GRDE_PRIORITY_C IS
      SELECT vPriority
        FROM (   SELECT 1 vPriority, 'DA' vCode
                   FROM DUAL
               UNION
                 SELECT 2 vPriority, 'SD' vCode
                   FROM DUAL
               UNION
                 SELECT 3 vPriority, 'NP' vCode
                   FROM DUAL
               ORDER BY vPriority
             )
       WHERE vCode = vGrdeCode;
  
    vResult NUMBER;
  BEGIN
    OPEN GET_GRDE_PRIORITY_C;
    FETCH GET_GRDE_PRIORITY_C
     INTO vResult;
    IF GET_GRDE_PRIORITY_C%NOTFOUND THEN
      vResult := 1000;
    END IF;
    CLOSE GET_GRDE_PRIORITY_C;
  
    RETURN vResult;
  END F_GetGradePriority;

BEGIN
dbms_output.put_line('F_GetGradePriority( ' || vGrdeCode1 || ' )=[' || F_GetGradePriority( vGrdeCode1 ) || ']' );
dbms_output.put_line('F_GetGradePriority( ' || vGrdeCode2 || ' )=[' || F_GetGradePriority( vGrdeCode2 ) || ']' );
  IF F_GetGradePriority( vGrdeCode1 ) <= F_GetGradePriority( vGrdeCode2 ) THEN
    RETURN vGrdeCode1;
  ELSE
    RETURN vGrdeCode2;
  END IF;
END;

FUNCTION f_validate_grade( p_term_code         VARCHAR2,
                           p_crn               VARCHAR2,
                           p_grade_code        VARCHAR2
                         ) RETURN VARCHAR2 IS

  -- Cursor to check if Grade Code exists.
  CURSOR IsGrde_Code_C  IS
   SELECT 'Y'
     FROM SHRGRDE t1
    WHERE SHRGRDE_CODE            = p_grade_code
      AND EXISTS (  SELECT 'X'
                      FROM SCRLEVL T
                     WHERE SCRLEVL_LEVL_CODE = t1.SHRGRDE_LEVL_CODE
                       AND EXISTS (SELECT 'X'
                                     FROM SSBSECT
                                    WHERE SSBSECT_TERM_CODE = p_term_code
                                      AND SSBSECT_CRN       = p_crn
                                      AND SSBSECT_SUBJ_CODE = T.SCRLEVL_SUBJ_CODE
                                      AND SSBSECT_CRSE_NUMB = T.SCRLEVL_CRSE_NUMB
                                  )
                       AND SCRLEVL_EFF_TERM  = (select max(scrlevl_eff_term)
                                                  from scrlevl
                                                 where scrlevl_subj_code =  T.SCRLEVL_SUBJ_CODE
                                                   and scrlevl_crse_numb =  T.SCRLEVL_CRSE_NUMB
                                                   and scrlevl_eff_term <=  p_term_code
                                                )
                 )
      AND EXISTS (SELECT 'X'
                    FROM SHRGRDO
                   WHERE SHRGRDO_LEVL_CODE = t1.SHRGRDE_LEVL_CODE
                     AND SHRGRDO_GRDE_CODE = t1.SHRGRDE_CODE
                     AND SHRGRDO_GMOD_CODE = 'S'
              )
      AND SHRGRDE_TERM_CODE_EFFECTIVE = (SELECT MAX(SHRGRDE_TERM_CODE_EFFECTIVE)
                                           FROM SHRGRDE
                                          WHERE SHRGRDE_TERM_CODE_EFFECTIVE <= p_term_code
                                            AND SHRGRDE_CODE                 = t1.SHRGRDE_CODE
                                            AND SHRGRDE_LEVL_CODE            = t1.SHRGRDE_LEVL_CODE
                                        )
      AND SHRGRDE_GRDE_STATUS_IND = 'A';

  lv_exists_grde_code  VARCHAR2(1);

BEGIN
  -- Test if Grade Code exists.
  OPEN IsGrde_Code_C;
  FETCH IsGrde_Code_C INTO lv_exists_grde_code;
  IF (IsGrde_Code_C%NOTFOUND) THEN
    lv_exists_grde_code := 'N';
  ELSE
    lv_exists_grde_code := 'Y';
  END IF;
  CLOSE IsGrde_Code_C;

  RETURN lv_exists_grde_code;
END  f_validate_grade;

/* BA 8.7.0 [UTM:002.1.5] */
  FUNCTION f_GetGrdeCode(vPorcent NUMBER) RETURN VARCHAR2 IS

    CURSOR GET_GRDE_CODE IS
      SELECT SHRGRSC_GRDE_CODE
        FROM SHRGRSC
       WHERE SHRGRSC_GSCH_NAME = 'UTM'
         AND SHRGRSC_PERCENTAGE =
             ( SELECT MAX( SHRGRSC_PERCENTAGE )
                 FROM SHRGRSC
                WHERE SHRGRSC_GSCH_NAME = 'UTM'
                  AND SHRGRSC_PERCENTAGE <= vPorcent
             );
/*    SELECT SHRGRSC_GRDE_CODE AS SHRGRSC_GRDE_CODE
      FROM SHRGRSC
     WHERE SHRGRSC_GRDE_CODE = vPorcent
       AND SHRGRSC_GSCH_NAME = 'UTM';*/
     
    CURSOR GET_GRDE_AROUND_CODE IS
      SELECT SHRGRSC_GRDE_CODE
        FROM SHRGRSC
       WHERE SHRGRSC_GSCH_NAME = 'UTM'
         AND SHRGRSC_PERCENTAGE < ROUND(vPorcent,2)
         AND ROWNUM = 1
       ORDER BY SHRGRSC_PERCENTAGE DESC;

    lv_grde_code    VARCHAR2(6) := NULL;

  BEGIN
    OPEN GET_GRDE_CODE;
    FETCH GET_GRDE_CODE INTO lv_grde_code;
    CLOSE GET_GRDE_CODE;

    IF (lv_grde_code IS NULL) THEN
      OPEN GET_GRDE_AROUND_CODE;
      FETCH GET_GRDE_AROUND_CODE INTO lv_grde_code;
      CLOSE GET_GRDE_AROUND_CODE;
    END IF;

    RETURN lv_grde_code;
  END f_GetGrdeCode;

  FUNCTION f_GetNewScore(vgrde  VARCHAR2) RETURN NUMBER IS

    CURSOR GET_SCORE_VALUE IS
    SELECT TO_NUMBER(NVL(SHRGRSC_MEDIAN, ROUND(SHRGRSC_PERCENTAGE)))
      FROM SHRGRSC
     WHERE SHRGRSC_GRDE_CODE = vgrde;

    new_score       NUMBER(6,2);
  BEGIN
    
    OPEN GET_SCORE_VALUE;
    FETCH GET_SCORE_VALUE INTO new_score;
    CLOSE GET_SCORE_VALUE;
    
    RETURN new_score;
    
  END f_GetNewScore;

 FUNCTION f_isNumber(vScore VARCHAR2)
   RETURN BOOLEAN
   IS

     score    NUMBER(8);

   BEGIN
   
     score := TO_NUMBER(vScore);
     return (TRUE);
     Exception WHEN OTHERS THEN
     return (FALSE);

 END f_isNumber;

  PROCEDURE p_UpdateGrdeScore( nPidm NUMBER,
                               nCrn VARCHAR2,
                               nTerm VARCHAR2,
                               nSubj VARCHAR2,
                               nCrse VARCHAR2,
                               nOrigin VARCHAR2 DEFAULT NULL -- BA 8.5.3 [UTM:004.1.5] 
                             ) IS

    -- BA 8.5.3 [UTM:002.1.1]
    CURSOR GET_REAL_GRADE_C IS
      SELECT SUM( SHRMRKS_SCORE * SHRGCOM_WEIGHT / 100 )
        FROM SHRMRKS,
             SFRSTCR,
             SZRCRNS,
             SZRSCHM,
             SHRGCOM
       WHERE SHRGCOM_TERM_CODE   = SFRSTCR_TERM_CODE
         AND SHRGCOM_CRN         = SFRSTCR_CRN
         AND SHRGCOM_ID          =  SHRMRKS_GCOM_ID
         AND SHRGCOM_NAME        = SZRSCHM_ACAT_NAME
         AND SZRSCHM_TERM_CODE   = SFRSTCR_TERM_CODE
         AND SZRSCHM_PTRM_CODE   = SFRSTCR_PTRM_CODE
         AND SZRSCHM_SCHM_SEQNO  = SZRCRNS_SCHM_SEQNO
         AND SZRCRNS_TERM_CODE   = SFRSTCR_TERM_CODE
         AND SZRCRNS_PTRM_CODE   = SFRSTCR_PTRM_CODE
         AND SZRCRNS_CRN         = SFRSTCR_CRN
         AND SZRCRNS_CURRENT_IND = 'Y'
         AND SFRSTCR_PIDM        = SHRMRKS_PIDM
         AND SFRSTCR_TERM_CODE   = SHRMRKS_TERM_CODE
         AND SFRSTCR_CRN         = SHRMRKS_CRN
         AND SHRMRKS_PIDM        = nPidm
         AND SHRMRKS_TERM_CODE   = nTerm
         AND SHRMRKS_CRN         = nCrn;
    -- EA 8.5.3 [UTM:002.1.1]

    CURSOR VALID_SUM_SCORE IS
      SELECT SUM(NVL2(SHRMRKS_SCORE,0,1))
        FROM SHRMRKS, SHRGCOM
       WHERE SHRGCOM_ID = SHRMRKS_GCOM_ID
         AND SHRMRKS_TERM_CODE = SHRGCOM_TERM_CODE
         AND SHRMRKS_CRN = SHRGCOM_CRN
         AND SHRMRKS_TERM_CODE = nTerm
         AND SHRMRKS_CRN = nCrn
         AND SHRMRKS_PIDM = nPidm;

    CURSOR CALC_NEW_SCORE IS
      SELECT SUM(NVL((SHRGCOM_WEIGHT*SHRMRKS_SCORE)/100,0))
        FROM SHRMRKS, SHRGCOM
       WHERE SHRGCOM_ID = SHRMRKS_GCOM_ID
         AND SHRMRKS_TERM_CODE = SHRGCOM_TERM_CODE
         AND SHRMRKS_CRN = SHRGCOM_CRN
         AND SHRMRKS_TERM_CODE = nTerm
         AND SHRMRKS_CRN = nCrn
         AND SHRMRKS_PIDM = nPidm;

    CURSOR VALID_CO_REQ IS
      SELECT COUNT(*)
        FROM SCRCORQ
       WHERE    (     SCRCORQ_SUBJ_CODE= nSubj
                  AND SCRCORQ_CRSE_NUMB = nCrse
                )
             OR (     SCRCORQ_SUBJ_CODE_CORQ = nSubj
                  AND SCRCORQ_CRSE_NUMB_CORQ = nCrse
                );

    CURSOR CALC_COREQ_SCORE IS
      SELECT SUM(SHRMRKS_SCORE)
        FROM SHRMRKS
       WHERE SHRMRKS_TERM_CODE = nTerm
         AND SHRMRKS_CRN = nCrn
         AND SHRMRKS_PIDM = nPidm;

    CURSOR CALC_COREQ_SCOREC IS
      SELECT COUNT(SHRMRKS_SCORE)
        FROM SHRMRKS
       WHERE SHRMRKS_TERM_CODE = nTerm
         AND SHRMRKS_CRN = nCrn
         AND SHRMRKS_PIDM = nPidm;

    -- fix 29/03
    CURSOR GET_CRSES_COUNT IS
      SELECT COUNT(*)
        FROM SHRMRKS
       WHERE SHRMRKS_PIDM      = nPidm
         AND SHRMRKS_TERM_CODE = nTerm
         AND SHRMRKS_CRN       = nCrn;

    CURSOR GET_GRADES_COUNT IS
       SELECT COUNT(*)
         FROM SHRMRKS
        WHERE SHRMRKS_PIDM      = nPidm
          AND SHRMRKS_TERM_CODE = nTerm
          AND SHRMRKS_CRN       = nCrn
          AND  SHRMRKS_GRDE_CODE IS NOT NULL;

    CURSOR GET_VALUES_SHRMRKS IS
    SELECT SHRMRKS_GRDE_CODE,
           SHRMRKS_SURROGATE_ID
      FROM SHRMRKS
     WHERE SHRMRKS_TERM_CODE = nTerm
       AND SHRMRKS_CRN = nCrn
       AND SHRMRKS_PIDM = nPidm;

    	/* BA EMR 8.7.0 [UTM:002.1.7] COMMENTED CONDITION - NOT PROCESSING INB UPDTE FINAL EXAM TO DA. */
    CURSOR GET_ACTI_TYPE_ExFin_C IS
     SELECT nvl(count(1),0)
       From Shrmrks sk, Shrgcom, Szvacat, Sfrstcr   
      Where Shrmrks_Term_Code = nTerm
        And Shrmrks_Crn       = nCrn
        AND SHRMRKS_GRDE_CODE = 'DA'
        AND SHRMRKS_PIDM      = nPidm
        AND SHRGCOM_TERM_CODE = SHRMRKS_TERM_CODE
        AND SHRGCOM_CRN       = SHRMRKS_CRN
        AND SHRGCOM_ID        = SHRMRKS_GCOM_ID
        AND SFRSTCR_PIDM      = SHRMRKS_PIDM
        AND SHRMRKS_CRN       = SFRSTCR_CRN
        AND SHRMRKS_TERM_CODE = SFRSTCR_TERM_CODE
        AND ( SFRSTCR_RSTS_CODE IN ( select stvrsts_code
                                       from stvrsts
                                      where stvrsts_code         = SFRSTCR_RSTS_CODE
                                        and stvrsts_gradable_ind = 'Y'
                                        and stvrsts_withdraw_ind = 'N'
                                        and stvrsts_code Not in ('BG','BM','DW','WL')
                                   )
            )
        And Szvacat_Name = Shrgcom_Name
        AND (NVL(SZVACAT_FINAL_TEST,'N') = 'Y' or NVL(SZVACAT_FINAL_PROJ,'N') = 'Y')
        AND (
           SHRMRKS_DATA_ORIGIN = 'SZPCADA'      
           OR
           (SHRMRKS_USER_ID LIKE 'AP%' AND SHRMRKS_DATA_ORIGIN IS NULL)
        );
    /* EA EMR 8.7.0 [UTM:002.1.7] NOT PROCESSING INB UPDTE FINAL EXAM TO DA. */
       
    lv_count_crses   NUMBER(5) := 0;
    lv_count_grades  NUMBER(5) := 0;

    	lv_count_da     NUMBER(5) := 0; /* EMR 8.7.0 [UTM:002.1.7] NOT PROCESSING INB UPDTE FINAL EXAM TO DA. */


    count_vscore    NUMBER(10);
    new_grde_code   VARCHAR2(6);
    new_score       NUMBER(6,2);
    count_vcreq     NUMBER(10);

    new_score_cr    NUMBER(8,2);
    count_cr        NUMBER(10);
    total_score_cr  NUMBER(8,2);
    cpy_grde_code   VARCHAR2(6);
    cpy_surrogate   NUMBER(19);
    cpy_score       NUMBER(6,2);
    
    lv_subj         VARCHAR2(30);
    lv_crse         VARCHAR2(30);

  BEGIN
  
    COMMIT;
    
    lv_subj := nSubj;
    lv_crse := nCrse;
    
 -- DEBUG  INSERT INTO BANINST1.SZTEST VALUES (lv_subj, lv_crse);
    
  commit;
    
    OPEN VALID_SUM_SCORE;
    FETCH VALID_SUM_SCORE INTO count_vscore;
    CLOSE VALID_SUM_SCORE;
    OPEN GET_CRSES_COUNT;
    FETCH GET_CRSES_COUNT INTO lv_count_crses;
    CLOSE GET_CRSES_COUNT;

    OPEN GET_GRADES_COUNT;
    FETCH GET_GRADES_COUNT INTO lv_count_grades;
    CLOSE GET_GRADES_COUNT;

    IF count_vscore > 0 THEN
      UPDATE SFRSTCR /*BIEN*/
         SET SFRSTCR_GRDE_CODE     = NULL,
             SFRSTCR_GRDE_CODE_MID = NULL
       WHERE SFRSTCR_TERM_CODE = nTerm
         AND SFRSTCR_PIDM      = nPidm
         AND SFRSTCR_CRN       = nCrn;

      UPDATE SHRCMRK /*BIEN*/
         SET SHRCMRK_PERCENTAGE = new_score,
             SHRCMRK_GRDE_CODE = NULL
       WHERE SHRCMRK_TERM_CODE = nTerm
         AND SHRCMRK_PIDM      = nPidm
         AND SHRCMRK_CRN       = nCrn;

      COMMIT;
    END IF;

    IF count_vscore = 0 THEN
      OPEN VALID_CO_REQ;
      FETCH VALID_CO_REQ INTO count_vcreq;
      CLOSE VALID_CO_REQ;

      IF count_vcreq > 0 THEN
        OPEN CALC_COREQ_SCORE;
        FETCH CALC_COREQ_SCORE INTO new_score_cr;
        CLOSE CALC_COREQ_SCORE;

        OPEN CALC_COREQ_SCOREC;
        FETCH CALC_COREQ_SCOREC INTO count_cr;
        CLOSE CALC_COREQ_SCOREC;

        -- BA 8.5.3 [UTM:002.1.1]
        --total_score_cr := new_score_cr/count_cr;
        OPEN GET_REAL_GRADE_C;
        FETCH GET_REAL_GRADE_C
         INTO total_score_cr;
        IF GET_REAL_GRADE_C%NOTFOUND THEN
          total_score_cr := 0;
        END IF;
        CLOSE GET_REAL_GRADE_C;
        -- EA 8.5.3 [UTM:002.1.1]

        new_grde_code := f_GetGrdeCode(total_score_cr);

        IF f_isNumber(new_grde_code) THEN
           NULL;
        ELSE
           new_grde_code := f_GetNewScore(new_grde_code);
        END IF;
     
        UPDATE SFRSTCR /*BIEN*/
           SET SFRSTCR_GRDE_CODE_MID = new_grde_code
         WHERE SFRSTCR_TERM_CODE = nTerm
           AND SFRSTCR_PIDM = nPidm
           AND SFRSTCR_CRN = nCrn;
        
        IF nOrigin IS NULL THEN      --  8.5.3 [UTM:002.1.5]
         
          UPDATE SFRSTCR /*BIEN*/
             SET SFRSTCR_GRDE_CODE = NULL
           WHERE SFRSTCR_TERM_CODE = nTerm
             AND SFRSTCR_PIDM = nPidm
             AND SFRSTCR_CRN = nCrn;
        
        END IF;                       --  8.5.3 [UTM:002.1.5]
       /* 
        UPDATE SHRCMRK
           SET SHRCMRK_PERCENTAGE = total_score_cr,
               SHRCMRK_GRDE_CODE = new_grde_code
         WHERE SHRCMRK_TERM_CODE = nTerm
           AND SHRCMRK_PIDM      = nPidm
           AND SHRCMRK_CRN       = nCrn; */

        COMMIT;
      ELSE
        OPEN CALC_NEW_SCORE;
        FETCH CALC_NEW_SCORE INTO new_score;
        CLOSE CALC_NEW_SCORE;

        new_grde_code := f_GetGrdeCode(new_score);

        IF f_isNumber(new_grde_code) THEN
           NULL;
        ELSE
           new_grde_code := f_GetNewScore(new_grde_code);
        END IF;
        
        IF lv_count_crses = lv_count_grades THEN
          UPDATE SFRSTCR /*BIEN*/
             SET SFRSTCR_GRDE_CODE = new_grde_code
           WHERE SFRSTCR_TERM_CODE = nTerm
             AND SFRSTCR_PIDM = nPidm
             AND SFRSTCR_CRN = nCrn;
        /*
          UPDATE SHRCMRK
             SET SHRCMRK_PERCENTAGE = new_score,
                 SHRCMRK_GRDE_CODE = new_grde_code
           WHERE SHRCMRK_TERM_CODE = nTerm
             AND SHRCMRK_PIDM = nPidm
             AND SHRCMRK_CRN = nCrn; */

          COMMIT;
        ELSE
          UPDATE SFRSTCR SET SFRSTCR_GRDE_CODE = NULL,  SFRSTCR_GRDE_CODE_MID = NULL /*BIEN*/
           WHERE SFRSTCR_TERM_CODE = nTerm
             AND SFRSTCR_PIDM = nPidm
             AND SFRSTCR_CRN = nCrn;

          UPDATE SHRCMRK /*BIEN*/
             SET SHRCMRK_PERCENTAGE = NULL,
                 SHRCMRK_GRDE_CODE = NULL
           WHERE SHRCMRK_TERM_CODE = nTerm
             AND SHRCMRK_PIDM = nPidm
             AND SHRCMRK_CRN = nCrn;

          COMMIT;
        END IF;
      END IF;
    END IF;
    
    COMMIT;

    /* BA EMR 8.7.0 [UTM:002.1.7] NOT PROCESSING INB UPDTE FINAL EXAM TO DA. */
    OPEN GET_ACTI_TYPE_ExFin_C;
    FETCH GET_ACTI_TYPE_ExFin_C INTO lv_count_da;
    CLOSE GET_ACTI_TYPE_ExFin_C;

    IF lv_count_da > 0 THEN
      UPDATE SFRSTCR
         SET SFRSTCR_GRDE_CODE = 'DA'
       WHERE SFRSTCR_TERM_CODE = nTerm
         AND SFRSTCR_PIDM      = nPidm
         AND SFRSTCR_CRN       = nCrn;
         
      COMMIT;
    END IF;
    /* EA EMR 8.7.0 [UTM:002.1.7] NOT PROCESSING INB UPDTE FINAL EXAM TO DA. */

  END p_UpdateGrdeScore;

 PROCEDURE p_UpdateLetterScore( nPidm NUMBER,
                               nCrn VARCHAR2,
                               nTerm VARCHAR2
                             ) IS

    CURSOR VALID_SUM_SCORE IS
      SELECT SUM(TO_NUMBER(NVL(SHRMRKS_GRDE_CODE,0)))
        FROM SHRMRKS, SHRGCOM
       WHERE SHRGCOM_ID = SHRMRKS_GCOM_ID
         AND SHRMRKS_TERM_CODE = SHRGCOM_TERM_CODE
         AND SHRMRKS_CRN = SHRGCOM_CRN
         AND SHRMRKS_TERM_CODE = nTerm
         AND SHRMRKS_CRN = nCrn
         AND SHRMRKS_PIDM = nPidm;

    CURSOR COUNT_GRDE_CODE IS
      SELECT COUNT(*)
        FROM SHRMRKS, SHRGCOM
       WHERE SHRGCOM_ID = SHRMRKS_GCOM_ID
         AND SHRMRKS_TERM_CODE = SHRGCOM_TERM_CODE
         AND SHRMRKS_CRN = SHRGCOM_CRN
         AND SHRMRKS_TERM_CODE = nTerm
         AND SHRMRKS_CRN = nCrn
         AND SHRMRKS_PIDM = nPidm;

    CURSOR COUNT_GRDE_CODE_SC IS
      SELECT COUNT(*)
        FROM SHRMRKS, SHRGCOM
       WHERE SHRGCOM_ID = SHRMRKS_GCOM_ID
         AND SHRMRKS_TERM_CODE = SHRGCOM_TERM_CODE
         AND SHRMRKS_CRN = SHRGCOM_CRN
         AND SHRMRKS_TERM_CODE = nTerm
         AND SHRMRKS_CRN = nCrn
         AND SHRMRKS_PIDM = nPidm
         AND SHRMRKS_GRDE_CODE = 'SC'; 

    CURSOR GET_SFRSTCR_GRDE_CODE IS
      SELECT SFRSTCR_GRDE_CODE
        FROM SFRSTCR
       WHERE SFRSTCR_TERM_CODE = nTerm
         AND SFRSTCR_PIDM      = nPidm
         AND SFRSTCR_CRN       = nCrn;
   
   -- BA 8.5.3 [UTM:002.1.4]       
    CURSOR GET_SHRGCOM_INCL_IND IS
    SELECT DISTINCT(SHRGCOM_INCL_IND) 
      FROM shrgcom
     WHERE shrgcom_crn = nCrn
       AND SHRGCOM_TERM_CODE = nTerm;
  -- EA 8.5.3 [UTM:002.1.4]  
         
    count_total      NUMBER(5) := 0;
    count_sc         NUMBER(5) := 0;
    count_da         NUMBER(5) := 0;
    count_ne         NUMBER(5) := 0;
    shrgcom_ind      VARCHAR2(1 CHAR);
    sum_score        NUMBER(6,2);
    new_grde_code    VARCHAR2(6);

  BEGIN
  

    
 -- DEBUG  INSERT INTO BANINST1.SZTEST VALUES (nPidm, nCrn);
    
  commit;
  
      OPEN GET_SFRSTCR_GRDE_CODE;
      FETCH GET_SFRSTCR_GRDE_CODE INTO new_grde_code;
      CLOSE GET_SFRSTCR_GRDE_CODE;
      
      IF new_grde_code IS NOT NULL THEN
      
      UPDATE SFRSTCR /*BIEN*/
         SET SFRSTCR_GRDE_CODE_MID = NULL
       WHERE SFRSTCR_TERM_CODE = nTerm
         AND SFRSTCR_PIDM      = nPidm
         AND SFRSTCR_CRN       = nCrn;
         
      END IF;
      OPEN COUNT_GRDE_CODE;
      FETCH COUNT_GRDE_CODE INTO count_total;
      CLOSE COUNT_GRDE_CODE;

      OPEN COUNT_GRDE_CODE_SC;
      FETCH COUNT_GRDE_CODE_SC INTO count_sc;
      CLOSE COUNT_GRDE_CODE_SC;
 
   IF (count_total = count_sc ) THEN
   
      OPEN GET_SHRGCOM_INCL_IND;
      FETCH GET_SHRGCOM_INCL_IND INTO shrgcom_ind;
      CLOSE GET_SHRGCOM_INCL_IND;
      
      IF shrgcom_ind = 'M' THEN  --   -- BA 8.5.3 [UTM:002.1.4]  
         
        UPDATE SFRSTCR /*BIEN*/
           SET SFRSTCR_GRDE_CODE_MID = 0, SFRSTCR_GRDE_CODE = NULL
         WHERE SFRSTCR_TERM_CODE = nTerm
           AND SFRSTCR_PIDM      = nPidm
           AND SFRSTCR_CRN       = nCrn;
         
      ELSIF shrgcom_ind = 'F' THEN
      
        UPDATE SFRSTCR /*BIEN*/
           SET SFRSTCR_GRDE_CODE = 0, SFRSTCR_GRDE_CODE_MID = NULL
         WHERE SFRSTCR_TERM_CODE = nTerm
           AND SFRSTCR_PIDM      = nPidm
           AND SFRSTCR_CRN       = nCrn;
      
      ELSE
        NULL;
      END IF;
      
      COMMIT;
      
    END IF;
    
  END p_UpdateLetterScore;

 PROCEDURE p_calculateAbscense(pidm      NUMBER,
                               pTerm     VARCHAR2,
                               pCrn      VARCHAR2,
                               pAbs OUT  NUMBER) IS

  CURSOR getStuAbsence_C IS
  SELECT NVL(SZRAATR_ABS_ACCUM, 0) - NVL(SZRAATR_ABS_JSTF, 0) + NVL(SZRAATR_ABS_TRANS, 0) Absence, NVL(SZRAATR_ABS_EXT, 0)
    FROM SZRAATR
   WHERE SZRAATR_CRN       = pCrn
     AND SZRAATR_TERM_CODE = pTerm
     AND SZRAATR_PIDM      = pidm;

  CURSOR getCrseSubjPterm IS
  SELECT SSBSECT_PTRM_CODE,
         SSBSECT_SUBJ_CODE,
         SSBSECT_CRSE_NUMB         
    FROM SSBSECT
   WHERE SSBSECT_CRN       = pCrn
     AND SSBSECT_TERM_CODE = pTerm;
     
  CURSOR getCrnAbsence_C(pSubject VARCHAR2, pCrseNumb VARCHAR2, pPartTerm VARCHAR2) IS
  SELECT NVL(SZRATRK_ABS_LIMIT, 0)
         FROM SORATRK, SZRATRK
        WHERE SORATRK_CRN         = pCrn
          AND SORATRK_TERM_CODE   = pTerm
          AND SORATRK_PTRM_CODE   = pPartTerm
          AND SORATRK_SUBJ_CODE   = pSubject
          AND SORATRK_CRSE_NUMB   = pCrseNumb
          AND SZRATRK_ATRK_SEQ_NO = SORATRK_SEQ_NO;
          
  lvPartTerm    VARCHAR2(3);
  lvSubject     VARCHAR2(4);
  lvCrseNumb    VARCHAR2(5);
  
  vStuAbsence   NUMBER(8);
  vCrnAbsence   NUMBER(8);
  vExtAbsence   NUMBER(8); 
  vLimitAbsence   NUMBER(8);
  vTotalAbsence   NUMBER(8);
 
 BEGIN

   OPEN getStuAbsence_C;
   FETCH getStuAbsence_C INTO vStuAbsence, vExtAbsence;
   CLOSE getStuAbsence_C;

   OPEN getCrseSubjPterm;
   FETCH getCrseSubjPterm INTO lvPartTerm, lvSubject, lvCrseNumb;
   CLOSE getCrseSubjPterm;

   OPEN getCrnAbsence_C(lvSubject, lvCrseNumb,  lvPartTerm);
   FETCH getCrnAbsence_C INTO vCrnAbsence;
   CLOSE getCrnAbsence_C;
   
   vLimitAbsence := NVL(vCrnAbsence,0) + ROUND( (NVL(vCrnAbsence,0) * (NVL(vExtAbsence,0) )));
   
   vTotalAbsence := vLimitAbsence - vStuAbsence;
   
   pAbs :=  NVL(vTotalAbsence, 0);
   
 END p_calculateAbscense;

 PROCEDURE p_calculateDelivery(pidm       NUMBER,
                               pTerm      VARCHAR2,
                               pCrn       VARCHAR2,
                               pDevs OUT  NUMBER) IS

  CURSOR getNoDelivery_C(pPartTerm VARCHAR2) IS
  SELECT NVL(COUNT(*), 0)
          FROM SHRMRKS, SHRGCOM, SZRCRNS, SZRSCHM
         WHERE SHRMRKS_TERM_CODE = pTerm
           AND SHRMRKS_CRN       = pCrn
           AND SHRMRKS_PIDM      = pidm
           AND SHRMRKS_GRDE_CODE = 'NE'
           AND SHRGCOM_TERM_CODE = SHRMRKS_TERM_CODE
           AND SHRGCOM_CRN       = SHRMRKS_CRN
           AND SHRGCOM_ID        = SHRMRKS_GCOM_ID
           AND SZRCRNS_TERM_CODE = SHRMRKS_TERM_CODE
           AND SZRCRNS_PTRM_CODE = pPartTerm
           AND SZRCRNS_CRN       = SHRGCOM_CRN
           AND SZRSCHM_TERM_CODE   = SZRCRNS_TERM_CODE
           AND SZRSCHM_PTRM_CODE   = SZRCRNS_PTRM_CODE
           AND SZRSCHM_SCHM_SEQNO  = SZRCRNS_SCHM_SEQNO
           AND SZRSCHM_ACAT_NAME   = SHRGCOM_NAME
           AND SZRSCHM_DELIVER_IND = 'Y';

  CURSOR getCrseSubjPterm IS
  SELECT SSBSECT_PTRM_CODE,
         SSBSECT_SUBJ_CODE,
         SSBSECT_CRSE_NUMB         
    FROM SSBSECT
   WHERE SSBSECT_CRN       = pCrn
     AND SSBSECT_TERM_CODE = pTerm;
     
  CURSOR getCrnLimit_C(pSubject VARCHAR2, pCrseNumb VARCHAR2, pPartTerm VARCHAR2) IS
       SELECT NVL(SZRATRK_NE_LIMIT, 0)
         FROM SORATRK, SZRATRK
        WHERE SORATRK_CRN         = pCrn
          AND SORATRK_TERM_CODE   = pTerm
          AND SORATRK_PTRM_CODE   = pPartTerm
          AND SORATRK_SUBJ_CODE   = pSubject
          AND SORATRK_CRSE_NUMB   = pCrseNumb
          AND SZRATRK_ATRK_SEQ_NO = SORATRK_SEQ_NO;
          
  lvPartTerm    VARCHAR2(3);
  lvSubject     VARCHAR2(4);
  lvCrseNumb    VARCHAR2(5);
  
  vStuNoDelivery     NUMBER(8);
  vCrnNoDelivery     NUMBER(8);
  vTotalNoDelivery   NUMBER(8);
 
 BEGIN

   OPEN getCrseSubjPterm;
   FETCH getCrseSubjPterm INTO lvPartTerm, lvSubject, lvCrseNumb;
   CLOSE getCrseSubjPterm;

   OPEN getNoDelivery_C(lvPartTerm);
   FETCH getNoDelivery_C INTO vStuNoDelivery;
   CLOSE getNoDelivery_C;

   OPEN getCrnLimit_C(lvSubject, lvCrseNumb,  lvPartTerm);
   FETCH getCrnLimit_C INTO vCrnNoDelivery;
   CLOSE getCrnLimit_C;
   
   vTotalNoDelivery := NVL(vCrnNoDelivery,0) - NVL(vStuNoDelivery,0);

   pDevs :=  NVL(vTotalNoDelivery, 0);
   
 END p_calculateDelivery;
/* EA 8.7.0 [UTM:002.1.5] */

/* Update tables */
PROCEDURE p_Update_Tables(P_SESSIONID   VARCHAR2, P_IND   NUMBER DEFAULT NULL, P_SF   NUMBER DEFAULT NULL) IS

  CURSOR SZTVAGR_SEQ_C (pc_sessionid VARCHAR2) IS
    SELECT SZTVAGR_TERM_CODE,
           SZTVAGR_PIDM,
           SZTVAGR_CRN,
           SZTVAGR_TYPE_COL,
           SZTVAGR_VALUE_GRADE
      FROM SZTVAGR
     WHERE SZTVAGR_STATUS    = 'S'
       AND SZTVAGR_SESSIONID =  pc_sessionid
     ORDER BY SZTVAGR_TYPE_COL;

  -- BA 8.7.0 [UTM:002.1.1]
  CURSOR GET_SECT_INFO_C( pTerm SSBSECT.SSBSECT_TERM_CODE%TYPE,
                          pCRN  SSBSECT.SSBSECT_CRN%TYPE
                        ) IS
    SELECT SSBSECT_SUBJ_CODE,
           SSBSECT_CRSE_NUMB
      FROM SSBSECT
     WHERE SSBSECT_TERM_CODE = pTerm
       AND SSBSECT_CRN       = pCRN;

  lv_sect_info     GET_SECT_INFO_C%ROWTYPE;
  lvRealGrdeRec    GET_REAL_GRDE_VALUES_C%ROWTYPE;
-- EA 8.7.0 [UTM:002.1.1]

  lv_seq_no        SHRTCKG.SHRTCKG_SEQ_NO%TYPE;
  lv_tckn_seq_no   SHRTCKG.SHRTCKG_SEQ_NO%TYPE;
  lv_credit_hr     NUMBER;
  lv_grde_code     SHRMRKS.SHRMRKS_GRDE_CODE%TYPE;
  lv_message       VARCHAR2(500);
  lv_razon         VARCHAR2(2);

BEGIN
  FOR getGrade_rec IN SZTVAGR_SEQ_C(P_SESSIONID) LOOP
    IF vDebugTurnOn THEN dbms_output.put_line('1 - getGrade_rec.SZTVAGR_TYPE_COL=[' || getGrade_rec.SZTVAGR_TYPE_COL || ']'); END IF;
    /* ACTUALIZA SHRMRKS PARA SECUENCIAS COMPLETAS/INCOMPLETAS */
    IF getGrade_rec.SZTVAGR_TYPE_COL NOT IN ('Final','HA', 'RAZON') THEN
      IF vDebugTurnOn THEN dbms_output.put_line('2'); END IF;
      IF getGrade_rec.SZTVAGR_VALUE_GRADE = 'BORRAR' THEN
        IF vDebugTurnOn THEN dbms_output.put_line('3. BORRAR'); END IF;
        lv_grde_code := NULL;
      ELSIF getGrade_rec.SZTVAGR_VALUE_GRADE IS NULL THEN
        IF vDebugTurnOn THEN dbms_output.put_line('3. -1-1-1'); END IF;
        lv_grde_code := '-1-1-1';
      ELSE
        IF vDebugTurnOn THEN dbms_output.put_line('3. [' || getGrade_rec.SZTVAGR_VALUE_GRADE || ']'); END IF;
        lv_grde_code := getGrade_rec.SZTVAGR_VALUE_GRADE;
      END IF;
      
      -- BA 8.7.0 [UTM:002.1.1]
      BEGIN
        IF  vDebugTurnOn THEN dbms_output.put_line('4'); END IF;
        IF ( lv_grde_code IS NOT NULL ) THEN
          IF vDebugTurnOn THEN dbms_output.put_line('5'); END IF;
          OPEN GET_REAL_GRDE_VALUES_C( lv_grde_code );
          FETCH GET_REAL_GRDE_VALUES_C
           INTO lvRealGrdeRec;
          IF GET_REAL_GRDE_VALUES_C%NOTFOUND THEN
            IF vDebugTurnOn THEN dbms_output.put_line('5.1'); END IF;
            lvRealGrdeRec.SHRGRSC_GRDE_CODE := 'X';
            lvRealGrdeRec.SHRGRSC_PERCENTAGE := 0;
            lvRealGrdeRec.SHRGRSC_MEDIAN := NULL;
          END IF;
          CLOSE GET_REAL_GRDE_VALUES_C;
        ELSE
          IF vDebugTurnOn THEN dbms_output.put_line('6'); END IF;
          lvRealGrdeRec.SHRGRSC_GRDE_CODE := NULL;
          lvRealGrdeRec.SHRGRSC_PERCENTAGE := NULL;
          lvRealGrdeRec.SHRGRSC_MEDIAN := NULL;
        END IF;
        
        IF vDebugTurnOn THEN dbms_output.put_line('7 --> lv_grde_code=[' || lv_grde_code || ']'); END IF;
        IF lv_grde_code <> '-1-1-1' OR lv_grde_code IS NULL THEN
          IF vDebugTurnOn THEN
            dbms_output.put_line('8.1 --> lvRealGrdeRec.SHRGRSC_GRDE_CODE=[' || lvRealGrdeRec.SHRGRSC_GRDE_CODE || ']' );
            dbms_output.put_line('8.2 --> lvRealGrdeRec.SHRGRSC_PERCENTAGE=[' || lvRealGrdeRec.SHRGRSC_PERCENTAGE || ']' );
            dbms_output.put_line('8.3 --> lvRealGrdeRec.SHRGRSC_MEDIAN=[' || lvRealGrdeRec.SHRGRSC_MEDIAN || ']' );
            dbms_output.put_line('8.4 --> getGrade_rec.SZTVAGR_TERM_CODE=[' || getGrade_rec.SZTVAGR_TERM_CODE || ']' );
            dbms_output.put_line('8.5 --> getGrade_rec.SZTVAGR_CRN=[' || getGrade_rec.SZTVAGR_CRN || ']' );
            dbms_output.put_line('8.5 --> getGrade_rec.SZTVAGR_PIDM=[' || getGrade_rec.SZTVAGR_PIDM || ']' );
          END IF;
          
          UPDATE SHRMRKS /*BIEN*/
            -- SET SHRMRKS_GRDE_CODE  = lv_grde_code,
            --     SHRMRKS_PERCENTAGE = lv_grde_code,
            --     SHRMRKS_SCORE      = lv_grde_code
             SET SHRMRKS_GRDE_CODE  = lvRealGrdeRec.SHRGRSC_GRDE_CODE,
                 SHRMRKS_PERCENTAGE = lvRealGrdeRec.SHRGRSC_PERCENTAGE,
                 SHRMRKS_SCORE      = DECODE( lvRealGrdeRec.SHRGRSC_MEDIAN,
                                              NULL, lvRealGrdeRec.SHRGRSC_PERCENTAGE,
                                              lvRealGrdeRec.SHRGRSC_MEDIAN
                                            ),
                 shrmrks_user_id    = USER,       -- 8.7 [UTM:002.1.6]
                 shrmrks_data_origin = 'SZPMRKS',  -- 8.7 [UTM:002.1.6]
                 shrmrks_activity_date = SYSDATE
           WHERE SHRMRKS_TERM_CODE = getGrade_rec.SZTVAGR_TERM_CODE
             AND SHRMRKS_CRN       = getGrade_rec.SZTVAGR_CRN
             AND SHRMRKS_PIDM      = getGrade_rec.SZTVAGR_PIDM
             AND SHRMRKS_GCOM_ID   IN
                 ( SELECT SHRGCOM_ID
                     FROM SHRGCOM
                    WHERE SHRGCOM_TERM_CODE = SHRMRKS_TERM_CODE
                      AND SHRGCOM_CRN       = SHRMRKS_CRN
                      AND SHRGCOM_SEQ_NO    = getGrade_rec.SZTVAGR_TYPE_COL
                 );
         END IF;
         IF vDebugTurnOn THEN dbms_output.put_line('9'); END IF;
         
         EXCEPTION 
           WHEN OTHERS THEN
             IF vDebugTurnOn THEN dbms_output.put_line('EEEEEEE'); END IF;
             UPDATE SZTVAGR /*BIEN*/
                SET SZTVAGR_ERROR = 'E'
              WHERE SZTVAGR_TERM_CODE = getGrade_rec.SZTVAGR_TERM_CODE
                AND SZTVAGR_PIDM = getGrade_rec.SZTVAGR_PIDM
                AND SZTVAGR_CRN = getGrade_rec.SZTVAGR_CRN
                AND SZTVAGR_SESSIONID = P_SESSIONID;
      END;
      -- EA 8.7.0 [UTM:002.1.1]

    ELSIF getGrade_rec.SZTVAGR_TYPE_COL = 'Final' then   /* ACTUALIZAR CALIFICACION FINAL */
      IF getGrade_rec.SZTVAGR_VALUE_GRADE = 'BORRAR' THEN
        lv_grde_code := NULL;
      ELSE
        lv_grde_code := getGrade_rec.SZTVAGR_VALUE_GRADE;
      END IF;

       /* Actualizo SFRSTCR */     
         UPDATE SFRSTCR /*BIEN*/
            SET SFRSTCR_GRDE_CODE = lv_grde_code
          WHERE SFRSTCR_TERM_CODE = getGrade_rec.SZTVAGR_TERM_CODE
            AND SFRSTCR_PIDM      = getGrade_rec.SZTVAGR_PIDM
            AND SFRSTCR_CRN       = getGrade_rec.SZTVAGR_CRN;
      
       -- Only for debug in DEVL
       -- INSERT INTO SZTEST(SZTEST_56, SZTEST_57 ) VALUES (getGrade_rec.SZTVAGR_PIDM, lv_grde_code);
      
      
    ELSIF  getGrade_rec.SZTVAGR_TYPE_COL = 'RAZON' then    /* ACTUALIZAR CALIFICACION EN HISTORIA */
      /* OBTENGO LA MAX SECUENCIA */
      SELECT NVL(MAX(SHRTCKG_SEQ_NO), 0) + 1
        INTO lv_seq_no
        FROM SHRTCKG
       WHERE SHRTCKG_PIDM       = getGrade_rec.SZTVAGR_PIDM
         AND SHRTCKG_TERM_CODE  = getGrade_rec.SZTVAGR_TERM_CODE
         AND EXISTS
             ( SELECT 'X'
                 FROM SHRTCKN
                WHERE SHRTCKN_PIDM      = SHRTCKG_PIDM
                  AND SHRTCKN_TERM_CODE = SHRTCKG_TERM_CODE
                  AND SHRTCKN_CRN       = getGrade_rec.SZTVAGR_CRN
                  AND SHRTCKN_SEQ_NO    = SHRTCKG_TCKN_SEQ_NO
             );

      IF  lv_seq_no > 1 THEN
        BEGIN
          /* OBTENER CREDIT HOURS*/
          SELECT SFRSTCR_CREDIT_HR
            INTO lv_credit_hr
            FROM SFRSTCR
           WHERE SFRSTCR_TERM_CODE = getGrade_rec.SZTVAGR_TERM_CODE
             AND SFRSTCR_PIDM      = getGrade_rec.SZTVAGR_PIDM
             AND SFRSTCR_CRN       = getGrade_rec.SZTVAGR_CRN;

          /* OBTENER SECUENCIA */
          SELECT SHRTCKN_SEQ_NO
            INTO lv_tckn_seq_no
            FROM SHRTCKN
           WHERE SHRTCKN_PIDM      = getGrade_rec.SZTVAGR_PIDM
             AND SHRTCKN_TERM_CODE = getGrade_rec.SZTVAGR_TERM_CODE
             AND SHRTCKN_CRN       = getGrade_rec.SZTVAGR_CRN;

          /* OBTENER EL CODIGO DE LA CALIFICACION HISTORICA */
          SELECT SZTVAGR_VALUE_GRADE
            INTO lv_grde_code
            FROM SZTVAGR
           WHERE SZTVAGR_STATUS    =  'S'
             AND SZTVAGR_TERM_CODE =  getGrade_rec.SZTVAGR_TERM_CODE
             AND SZTVAGR_PIDM      =  getGrade_rec.SZTVAGR_PIDM
             AND SZTVAGR_CRN       =  getGrade_rec.SZTVAGR_CRN
             AND SZTVAGR_TYPE_COL  =  'HA'
             AND SZTVAGR_SESSIONID =  P_SESSIONID;

          lv_razon := substr(getGrade_rec.SZTVAGR_VALUE_GRADE,1,2);
          
          IF (P_IND IS NULL) THEN   /*  8.7.0 [UTM:002.1.4] */
          /* INSERTAR DATOS EN SHRTCKG */
            INSERT INTO SHRTCKG( SHRTCKG_PIDM, /*BIEN*/
                                 SHRTCKG_TERM_CODE,
                                 SHRTCKG_TCKN_SEQ_NO,
                                 SHRTCKG_SEQ_NO,
                                 SHRTCKG_GRDE_CODE_FINAL,
                                 SHRTCKG_GMOD_CODE,       -- 8.7.0 [UTM:002.1.2]
                                 SHRTCKG_CREDIT_HOURS,
                                 SHRTCKG_HOURS_ATTEMPTED, -- 8.7.0 [UTM:002.1.2]
                                 SHRTCKG_GCHG_CODE,
                                 SHRTCKG_FINAL_GRDE_CHG_DATE,
                                 SHRTCKG_FINAL_GRDE_CHG_USER,
                                 SHRTCKG_ACTIVITY_DATE
                               )
                         VALUES( getGrade_rec.SZTVAGR_PIDM,
                                 getGrade_rec.SZTVAGR_TERM_CODE,
                                 lv_tckn_seq_no,
                                 lv_seq_no,
                                 lv_grde_code,
                                 'S',                    -- 8.7.0 [UTM:002.1.2]
                                  lv_credit_hr ,
                                 lv_credit_hr,           -- 8.7.0 [UTM:002.1.2]
                                 lv_razon,
                                 SYSDATE,
                                 USER,
                                 SYSDATE
                                );

          END IF;         
          EXCEPTION WHEN OTHERS THEN
            lv_message := SUBSTR(SQLERRM,1,200);

        END;
          
      END IF;
    END IF;
    IF vDebugTurnOn THEN dbms_output.put_line('10'); END IF;

    -- BA 8.7.0 [UTM:002.1.1]
    OPEN GET_SECT_INFO_C( getGrade_rec.SZTVAGR_TERM_CODE, getGrade_rec.SZTVAGR_CRN );
    FETCH GET_SECT_INFO_C
     INTO lv_sect_info;
    IF GET_SECT_INFO_C%FOUND THEN
      IF vDebugTurnOn THEN 
        dbms_output.put_line('getGrade_rec.SZTVAGR_PIDM=[' || getGrade_rec.SZTVAGR_PIDM || ']');
        dbms_output.put_line('getGrade_rec.SZTVAGR_CRN=[' || getGrade_rec.SZTVAGR_CRN || ']');
        dbms_output.put_line('getGrade_rec.SZTVAGR_TERM_CODE=[' || getGrade_rec.SZTVAGR_TERM_CODE || ']');
        dbms_output.put_line('lv_sect_info.SSBSECT_SUBJ_CODE=[' || lv_sect_info.SSBSECT_SUBJ_CODE || ']');
        dbms_output.put_line('lv_sect_info.SSBSECT_CRSE_NUMB=[' || lv_sect_info.SSBSECT_CRSE_NUMB || ']');
      END IF;
      IF (P_SF IS NOT NULL) THEN -- 8.7.0 [UTM:002.1.4]
        /*bwzkacrp.p_UpdateGrdeScore( getGrade_rec.SZTVAGR_PIDM, 
	                                    getGrade_rec.SZTVAGR_CRN,
	                                    getGrade_rec.SZTVAGR_TERM_CODE,
	                                    lv_sect_info.SSBSECT_SUBJ_CODE,
	                                    lv_sect_info.SSBSECT_CRSE_NUMB,
	                                    'P'  -- 8.7.0 [UTM:002.1.3]
	                                  );*/
          NULL;
       END IF;                   -- 8.7.0 [UTM:002.1.4]
    END IF;

    CLOSE GET_SECT_INFO_C;
    -- BA 8.7.0 [UTM:002.1.1]

    COMMIT;

  END LOOP;
  
  -- BA 8.7.0 [UTM:002.1.2]
    COMMIT;
  
    FOR getGrade_rec IN SZTVAGR_SEQ_C(P_SESSIONID) LOOP
    delete from SHRTCKG 
     where SHRTCKG_SURROGATE_ID in(
                          select distinct n1.SHRTCKG_SURROGATE_ID 
                            from SHRTCKG n1, SHRTCKG n2
                           where n1.SHRTCKG_PIDM                = n2.SHRTCKG_PIDM
                             and n1.SHRTCKG_TERM_CODE           = n2.SHRTCKG_TERM_CODE
                             and n1.SHRTCKG_TCKN_SEQ_NO         = n2.SHRTCKG_TCKN_SEQ_NO
                             and n1.SHRTCKG_GRDE_CODE_FINAL     = n2.SHRTCKG_GRDE_CODE_FINAL
                             and n1.SHRTCKG_GCHG_CODE           = n2.SHRTCKG_GCHG_CODE
                             and n1.SHRTCKG_FINAL_GRDE_CHG_USER = n2.SHRTCKG_FINAL_GRDE_CHG_USER
                             and n1.SHRTCKG_PIDM                = getGrade_rec.SZTVAGR_PIDM
                             and n1.SHRTCKG_TERM_CODE           = getGrade_rec.SZTVAGR_TERM_CODE
                             and n1.SHRTCKG_FINAL_GRDE_SEQ_NO is null
                             and n1.SHRTCKG_SURROGATE_ID > n2.SHRTCKG_SURROGATE_ID
                             );
                             
   END LOOP;
  COMMIT;
  -- EA 8.7.0 [UTM:002.1.2]

END p_Update_Tables;

/*
* Insert data SZTVAGR
*/
PROCEDURE p_Insert_Data( P_STATUS      VARCHAR2,
                         P_ERRORS      VARCHAR2,
                         P_TIPOCOL     VARCHAR2,
                         P_CALIFI      VARCHAR2,
                         P_SESSIONID   VARCHAR2
                       ) IS

BEGIN
  /* Errors of validation */
  IF P_STATUS = 'E' THEN
    INSERT INTO SZTVAGR( SZTVAGR_TERM_CODE, /*BIEN*/
                         SZTVAGR_PIDM,
                         SZTVAGR_CRN,
                         SZTVAGR_TYPE_COL,
                         SZTVAGR_VALUE_GRADE,
                         SZTVAGR_STATUS,
                         SZTVAGR_ERROR,
                         SZTVAGR_SESSIONID
                       )
                 VALUES( lv_linearray(1),
                         lv_pidm,
                         lv_linearray(4),
                         P_TIPOCOL,
                         P_CALIFI,
                         P_STATUS,
                         P_ERRORS,
                         P_SESSIONID
                       );
    /* Data successful */
  ELSE
    INSERT INTO SZTVAGR( SZTVAGR_TERM_CODE, /*BIEN*/
                         SZTVAGR_PIDM,
                         SZTVAGR_CRN,
                         SZTVAGR_TYPE_COL,
                         SZTVAGR_VALUE_GRADE,
                         SZTVAGR_STATUS,
                         SZTVAGR_ERROR,
                         SZTVAGR_SESSIONID
                       )
                 VALUES( lv_linearray(1),
                         lv_pidm,
                         lv_linearray(4),
                         P_TIPOCOL,
                         P_CALIFI,
                         P_STATUS,
                         P_ERRORS,
                         P_SESSIONID
                       );
  END IF;

END p_Insert_Data;


  /*----------------------------------------------------------------------------*/
  /*                                                                            */
  /* PUBLIC PROCEDURES                                                          */
  /*                                                                            */
  /*----------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------*/
/* P_Process_Grade                                                             */
/*----------------------------------------------------------------------------*/
PROCEDURE P_Process_Grade( P_LINE      IN VARCHAR2,
                           P_MODE      IN VARCHAR2,
                           P_SESSIONID IN VARCHAR2
                         ) IS

  vIndex         NUMBER := 1;
  lv_status      VARCHAR2(1);
  lv_existCRN    VARCHAR2(1);
  lv_existterm   VARCHAR2(1);
  lv_existGRADE  VARCHAR2(1);
  lv_enrolledId  VARCHAR2(1);
  lv_subj_code   VARCHAR2(4);
  lv_crse_num    VARCHAR2(5);
  lv_menssage    VARCHAR2(250);
  lv_seccal      NUMBER;
  lv_TipoCol     VARCHAR2(10);
  lv_califi      VARCHAR2(10);
  lv_str         VARCHAR2(1000);
  lv_change_ind   NUMBER(8);
  lv_change_sf    NUMBER(8);
  
  /*CURSOR CRN IS CONFIGURED */
  CURSOR Get_ExistCRN_c( pc_term_code VARCHAR2,
                         pc_crn       VARCHAR2
                       ) IS
    SELECT 'Y'
      FROM SSBSECT
     WHERE SSBSECT_TERM_CODE  = pc_term_code
       AND SSBSECT_CRN        = pc_crn;

  /*CURSOR TERM IS CONFIGURED */
  CURSOR Get_ExistTERM_c (pc_term_code VARCHAR2) IS
    SELECT'Y'
      FROM STVTERM
     WHERE STVTERM_CODE =  pc_term_code;

  /*CURSOR GRADE IS CONFIGURED */
  /*CURSOR Get_ExistGrade_c (pvGradeCode VARCHAR2) IS
     SELECT 'Y'
         FROM SHRGRSC
        WHERE SHRGRSC_GRDE_CODE = pvGradeCode
          AND SHRGRSC_GSCH_NAME = 'UTM';
  */

  /*CURSOR CRN IS VALID */
  CURSOR Get_ValidCRN_c( pc_term_code VARCHAR2,
                         pc_crn       VARCHAR2,
                         pc_subj_code VARCHAR2,
                         pc_crse_num  VARCHAR2
                       ) IS
    SELECT 'Y'
      FROM SSBSECT
     WHERE SSBSECT_TERM_CODE  = pc_term_code
       AND SSBSECT_CRN        = pc_crn
       AND SSBSECT_SUBJ_CODE  = pc_subj_code
       AND SSBSECT_CRSE_NUMB  = pc_crse_num;

  /*CURSOR STUDENT IS ENROLLED */
  CURSOR Get_EnrolledID_c( pc_term_code VARCHAR2,
                           pc_crn       VARCHAR2,
                           pc_pidm      NUMBER
                         ) IS
    SELECT 'Y'
      FROM SFRSTCR
     WHERE SFRSTCR_TERM_CODE = pc_term_code
       AND SFRSTCR_PIDM      = pc_pidm
       AND SFRSTCR_CRN       = pc_crn;

BEGIN
  lv_status := 'S';
  lv_str    := P_LINE;

  /*P_LINE VARCHAR2(100) := '5645645,sdfdf,,lkfgj, , f8juu';*/

  SELECT replace(lv_str, '"', '')
    into lv_str
    FROM dual;

  SELECT replace(lv_str, ',,', ', , ')
    into lv_str
    FROM dual;

  SELECT col_val
    BULK COLLECT into lv_linearray
    FROM ( SELECT rownum,
                  SUBSTR(TRIM (REGEXP_SUBSTR (lv_str, '[^,]+', 1, LEVEL)),INSTR(TRIM (REGEXP_SUBSTR (lv_str, '[^,]+', 1, LEVEL)),':')+1 ) COL_VAL
             FROM dual
            CONNECT BY LEVEL < LENGTH (lv_str) - LENGTH (REPLACE (lv_str, ',', NULL)) + 2
         )
   order by rownum;

  /* SI EL VALOR DE HISTORIA ACEDEMICA ES 'BORRAR' NO PROCESAR */
  IF lv_linearray.count = 57 THEN
    IF ( lv_linearray(56) IS NOT NULL ) AND (lv_linearray(56) = 'BORRAR') THEN
      RETURN;
    END IF;
  END IF;

  /* Validate TERM */
  OPEN Get_ExistTERM_c( lv_linearray(1) );
  FETCH Get_ExistTERM_c INTO lv_existTERM;
  IF (Get_ExistTERM_c%NOTFOUND) THEN
    lv_existTERM := 'N';
  END IF;
  CLOSE Get_ExistTERM_c;

  IF lv_existTERM = 'N' THEN
    /* GUARDAR EL REGISTRO EN LA TABLA TEMPORAL CON EL ERROR*/
    lv_menssage := G$_NLS.GET('X','SQL',' TERM does not exist');
    lv_status := 'E';
    p_Insert_Data( lv_status, lv_menssage, lv_TipoCol, lv_califi, P_SESSIONID);
    RETURN;
  END IF;

  /* Get PIDM */
  BEGIN
    SELECT spriden_pidm
      INTO lv_pidm
      FROM spriden
     WHERE spriden_id = lv_linearray(2)
       AND ROWNUM = 1;

    EXCEPTION WHEN OTHERS THEN
      lv_pidm := NULL;
      lv_status     := 'E';
      lv_menssage   := G$_NLS.GET('X', 'SQL', '*ERROR* %01% Student does not exist.', lv_linearray(2));
      p_Insert_Data( lv_status, lv_menssage, lv_TipoCol, lv_califi, P_SESSIONID);
      RETURN;
  END;

  /* Validate CRN */
  OPEN Get_ExistCRN_c( lv_linearray(1),
                       lv_linearray(4)
                     );
  FETCH Get_ExistCRN_c INTO lv_existCRN;
  IF (Get_ExistCRN_c%NOTFOUND) THEN
    lv_existCRN := 'N';
  END IF;
  CLOSE Get_ExistCRN_c;

  IF lv_existCRN = 'N' THEN
    /* GUARDAR EL REGISTRO EN LA TABLA TEMPORAL CON EL ERROR*/
    lv_menssage := G$_NLS.GET('X','SQL','CRN does not exist in term') ;
    lv_status := 'E';
    p_Insert_Data( lv_status, lv_menssage, lv_TipoCol, lv_califi, P_SESSIONID);
    RETURN;
  END IF;

  /* Validate if CRN matches with course/term */
  SELECT SUBSTR(lv_linearray(3),1,4), SUBSTR(lv_linearray(3),5)
    INTO lv_subj_code, lv_crse_num
    FROM DUAL;

  OPEN Get_ValidCRN_c( lv_linearray(1),
                       lv_linearray(4),
                       lv_subj_code,
                       lv_crse_num
                     );
  FETCH Get_ValidCRN_c INTO lv_existCRN;
  IF (Get_ValidCRN_c%NOTFOUND) THEN
    lv_existCRN := 'N';
  END IF;
  CLOSE Get_ValidCRN_c;

  IF lv_existCRN = 'N' THEN
    /* GUARDAR EL REGISTRO EN LA TABLA TEMPORAL CON EL ERROR*/
    lv_menssage := G$_NLS.GET('X','SQL','CRN does not match course/term.');
    lv_status := 'E';
    p_Insert_Data( lv_status, lv_menssage, lv_TipoCol, lv_califi, P_SESSIONID);
    RETURN;
  END IF;

  /* Validate if student is enrolled */
  OPEN Get_EnrolledID_c( lv_linearray(1),
                         lv_linearray(4),
                         lv_pidm
                       );
  FETCH Get_EnrolledID_c INTO lv_enrolledId;
  IF (Get_EnrolledID_c%NOTFOUND) THEN
    lv_enrolledId := 'N';
  END IF;
  CLOSE Get_EnrolledID_c;

  IF lv_enrolledId = 'N' THEN
    /* GUARDAR EL REGISTRO EN LA TABLA TEMPORAL CON EL ERROR*/
    lv_menssage := G$_NLS.GET('X','SQL','Students not enrolled in CNR.');
    lv_status := 'E';
    p_Insert_Data( lv_status, lv_menssage, lv_TipoCol, lv_califi, P_SESSIONID);
    RETURN;
  END IF;

  /* Validate Grades Code from the activities */
  FOR i in 5..lv_linearray.COUNT - 3 LOOP
    IF (lv_linearray(i) IS NOT NULL) AND ( lv_linearray(i) != 'BORRAR') THEN
      lv_existGRADE := f_validate_grade( lv_linearray(1),   /* TERM */
                                         lv_linearray(4),   /* CRN */
                                         lv_linearray(i)    /* GRADE CODE */
                                       );
      IF lv_existGRADE = 'N' THEN
        /* GUARDAR EL REGISTRO EN LA TABLA TEMPORAL CON EL ERROR */
        lv_menssage  := G$_NLS.GET('X','SQL','Grade of sequence does not exist.');
        lv_status  := 'E';
        lv_califi   := lv_linearray(i);
        lv_seccal   := i - 4;
        lv_TipoCol  := TO_CHAR(lv_seccal);
        p_Insert_Data( lv_status, lv_menssage, lv_TipoCol, lv_califi, P_SESSIONID);
        RETURN;
      END IF;
    END IF;
  END LOOP;

  /* Validate Final and Historical Grades */
  FOR i in 55..lv_linearray.COUNT - 1  LOOP
    IF  (lv_linearray(i) IS NOT NULL) AND  ( lv_linearray(i) != 'BORRAR') THEN
      lv_existGRADE := f_validate_grade( lv_linearray(1),   /* TERM */
                                         lv_linearray(4),   /* CRN */
                                         lv_linearray(i)    /* GRADE CODE */
                                       );

      IF lv_existGRADE = 'N' THEN
        /* GUARDAR EL REGISTRO EN LA TABLA TEMPORAL CON EL ERROR */
        lv_status := 'E';
        lv_califi   := lv_linearray(i);
        IF i = 55 THEN
          lv_menssage  := G$_NLS.GET('X','SQL','Final Grade does not exist.');
          lv_TipoCol   := 'Final';
        ELSE
          lv_menssage := G$_NLS.GET('X','SQL','Historical Grade does not exist.');
          lv_TipoCol    := 'HA';
        END IF;
        p_Insert_Data( lv_status, lv_menssage, lv_TipoCol, lv_califi, P_SESSIONID);
        RETURN;
      END IF;
    END IF;
  END LOOP;

  /* IF THE LINE HAD NOT ERRORS */
  IF lv_status = 'S' THEN
    FOR i in 5..lv_linearray.COUNT - 1  LOOP
      IF lv_linearray(i) IS NOT NULL THEN
        IF i < 55 then
          IF lv_linearray(i) = 'BORRAR' THEN
            lv_menssage := G$_NLS.GET('X','SQL','Grade updated to null.');
          ELSE
            lv_menssage := G$_NLS.GET('X','SQL','Grade in processed activity.');
          END IF;

          lv_califi   := lv_linearray(i);
          lv_seccal   := i - 4;
          lv_TipoCol  := TO_CHAR(lv_seccal);
        ELSE
          lv_califi   := lv_linearray(i);
          IF i = 55 then
            IF lv_califi = 'BORRAR' THEN
              lv_menssage := G$_NLS.GET('X','SQL','Final Grade updated to null.');
            ELSE
              lv_menssage  := G$_NLS.GET('X','SQL','Final Grade processed.');
            END IF;

            lv_TipoCol    := 'Final';
          ELSE
            IF lv_califi = 'BORRAR' THEN
              lv_menssage := G$_NLS.GET('X','SQL','Historical Grade updated to null.');
            ELSE
              lv_menssage  := G$_NLS.GET('X','SQL','Historical Grade processed.');
            END IF;

            lv_TipoCol  := 'HA';
          END IF;
        END IF;

        p_Insert_Data( lv_status, lv_menssage, lv_TipoCol, lv_califi, P_SESSIONID);
      END IF;
    END LOOP;

    IF lv_linearray(57) IS NOT NULL THEN
      lv_menssage := G$_NLS.GET('X','SQL','Razon.');
      lv_TipoCol    := 'RAZON';
      lv_califi     := lv_linearray(57);
      p_Insert_Data( lv_status, lv_menssage, lv_TipoCol, lv_califi, P_SESSIONID);
    END IF;

    IF P_MODE = 'U' THEN
      /* ACTUALIZAR LOS CAMPOS DE LAS TABLAS */
      IF lv_linearray(56) IS NOT NULL THEN   -- 8.7.0 [UTM:002.1.4] 
         lv_change_ind := NULL;
      ELSE
             lv_change_ind := 1;
      END IF;
      
      IF lv_linearray(55) IS NOT NULL THEN   -- 8.7.0 [UTM:002.1.4]
         lv_change_sf := NULL;
      ELSE
               lv_change_sf := 1;
            END IF;
      
      p_Update_Tables(P_SESSIONID, lv_change_ind);
      COMMIT;
    END IF;
  END IF;
  
  EXCEPTION WHEN OTHERS THEN
    lv_status := 'E';



END P_Process_Grade;

PROCEDURE P_CalcCorqGrades( vPIDM     IN     SPRIDEN.SPRIDEN_PIDM%TYPE,
                            vTermCode IN     STVTERM.STVTERM_CODE%TYPE,
                            vCRN      IN     SSBSECT.SSBSECT_CRN%TYPE,
                            vMode     IN     VARCHAR2,
                            vMsg      IN OUT VARCHAR2
                          ) IS

  CURSOR GET_GRDE_CODE_MID_C IS
    SELECT SFRSTCR_GRDE_CODE_MID
      FROM SFRSTCR
     WHERE SFRSTCR_TERM_CODE = vTermCode
       AND SFRSTCR_CRN       = vCRN
       AND SFRSTCR_PIDM      = vPIDM;

  CURSOR GET_GRDE_TO_ASSIGN_C( vValue NUMBER ) IS
    SELECT SHRGRSC_GRDE_CODE
      FROM SHRGRSC
     WHERE SHRGRSC_GSCH_NAME = 'UTM' 
       AND SHRGRSC_PERCENTAGE =
           ( SELECT MAX( SHRGRSC_PERCENTAGE )
               FROM SHRGRSC
              WHERE SHRGRSC_GSCH_NAME = 'UTM'
                AND SHRGRSC_PERCENTAGE <= vValue
           );

  CURSOR GET_ALL_CORQ_COURSES_C IS
    SELECT A.SFRSTCR_TERM_CODE     AS cTermCode,
           A.SFRSTCR_PIDM          AS cPIDM,
           E.SFRSTCR_CRN           AS cCRN,
           E.SFRSTCR_GRDE_CODE_MID AS cMidGrde
      FROM SFRSTCR A,
           SSBSECT B,
           SCRCORQ C,
           SSBSECT D,
           SFRSTCR E
     WHERE E.SFRSTCR_TERM_CODE = A.SFRSTCR_TERM_CODE
       AND E.SFRSTCR_PIDM      = A.SFRSTCR_PIDM
       AND E.SFRSTCR_CRN       = D.SSBSECT_CRN
       AND NVL( E.SFRSTCR_ERROR_FLAG, 'N' ) <> 'F'
       AND (    E.SFRSTCR_ERROR_FLAG NOT IN ('F','D')
             OR E.SFRSTCR_ERROR_FLAG IS NULL
             OR E.SFRSTCR_RSTS_CODE IN
                ( SELECT STVRSTS_CODE
                    FROM STVRSTS
                   WHERE STVRSTS_CODE = E.SFRSTCR_RSTS_CODE
                     AND STVRSTS_GRADABLE_IND = 'Y'
                )
           )
       AND D.SSBSECT_SUBJ_CODE = C.SCRCORQ_SUBJ_CODE_CORQ
       AND D.SSBSECT_CRSE_NUMB = C.SCRCORQ_CRSE_NUMB_CORQ
       AND D.SSBSECT_TERM_CODE = A.SFRSTCR_TERM_CODE
       AND C.SCRCORQ_SUBJ_CODE = B.SSBSECT_SUBJ_CODE
       AND C.SCRCORQ_CRSE_NUMB = B.SSBSECT_CRSE_NUMB
       AND C.SCRCORQ_EFF_TERM =
           ( SELECT MAX( CC.SCRCORQ_EFF_TERM )
               FROM SCRCORQ CC
              WHERE CC.SCRCORQ_SUBJ_CODE = B.SSBSECT_SUBJ_CODE
                AND CC.SCRCORQ_CRSE_NUMB = B.SSBSECT_CRSE_NUMB
                AND CC.SCRCORQ_EFF_TERM <= B.SSBSECT_TERM_CODE
           )
       AND B.SSBSECT_TERM_CODE = A.SFRSTCR_TERM_CODE
       AND B.SSBSECT_CRN       = A.SFRSTCR_CRN
       AND A.SFRSTCR_TERM_CODE = vTermCode
       AND A.SFRSTCR_PIDM      = vPIDM
       AND A.SFRSTCR_CRN       = vCRN
       AND NVL( A.SFRSTCR_ERROR_FLAG, 'N' ) <> 'F'
       AND (    A.SFRSTCR_ERROR_FLAG NOT IN ('F','D')
             OR A.SFRSTCR_ERROR_FLAG IS NULL
             OR A.SFRSTCR_RSTS_CODE IN
                ( SELECT STVRSTS_CODE
                    FROM STVRSTS
                   WHERE STVRSTS_CODE = A.SFRSTCR_RSTS_CODE
                     AND STVRSTS_GRADABLE_IND = 'Y'
                )
           );

  vGrdeCode        SFRSTCR.SFRSTCR_GRDE_CODE_MID%TYPE;
  vSumGrades       NUMBER;
  vCountGrades     NUMBER := 1;
  vCountNullGrades NUMBER := 0;
  vAvgGrade        NUMBER;
  vFinalGrdeCode   SHRGRSC.SHRGRSC_GRDE_CODE%TYPE;
  c                VARCHAR2(1);
  
  lvRealGrdeRec    GET_REAL_GRDE_VALUES_C%ROWTYPE;
  vStringType      VARCHAR2(1);
  vANGrdeFound     BOOLEAN;
  vMaxGrdePriority SFRSTCR.SFRSTCR_GRDE_CODE_MID%TYPE;
  vTotCorqCrses    NUMBER := 0;
  
  xContador NUMBER := 0;
  
BEGIN
dbms_output.put_line('Iniciando');
  vSumGrades := NULL;
  vMsg := 0;
  vANGrdeFound := FALSE;
  vMaxGrdePriority := NULL;

  OPEN GET_GRDE_CODE_MID_C;
  FETCH GET_GRDE_CODE_MID_C
   INTO vGrdeCode;
  IF GET_GRDE_CODE_MID_C%NOTFOUND THEN
    vGrdeCode := CHR(9) || CHR(9);
  END IF;
  CLOSE GET_GRDE_CODE_MID_C;
  
dbms_output.put_line('vGrdeCode=[' || vGrdeCode || ']');
  
  IF vGrdeCode <> CHR(9) || CHR(9) THEN
    vStringType := F_StringType( vGrdeCode );
dbms_output.put_line('vStringType=[' || vStringType || ']');
    
    IF vStringType = 'N' THEN
      OPEN GET_REAL_GRDE_VALUES_C( vGrdeCode );
      FETCH GET_REAL_GRDE_VALUES_C
       INTO lvRealGrdeRec;
      CLOSE GET_REAL_GRDE_VALUES_C;
 
      vSumGrades := NVL( lvRealGrdeRec.SHRGRSC_MEDIAN, lvRealGrdeRec.SHRGRSC_PERCENTAGE );
    ELSIF vStringType = 'A' THEN
      vSumGrades := 0;
      vMaxGrdePriority := F_RetMaxGrdePriority( vGrdeCode, vMaxGrdePriority );
      vANGrdeFound := TRUE;
    ELSE
      vSumGrades := 0;
      
      IF vStringType = '-' THEN
        vCountNullGrades := 1;
      END IF;
    END IF;
dbms_output.put_line('vSumGrades=[' || vSumGrades || ']');
dbms_output.put_line('vMaxGrdePriority=[' || vMaxGrdePriority || ']');
    
--    IF ( NOT( vANGrdeFound ) ) THEN
      FOR vRec IN GET_ALL_CORQ_COURSES_C LOOP
dbms_output.put_line('xContador=[' || xContador || ']');
        xContador := xContador + 1;
        vTotCorqCrses := vTotCorqCrses + 1;
        EXIT WHEN xContador = 20;
        vStringType := F_StringType( vRec.cMidGrde );

dbms_output.put_line('vRec.cMidGrde=[' || vRec.cMidGrde || ']');


        IF vStringType = 'N' THEN
          OPEN GET_REAL_GRDE_VALUES_C( vRec.cMidGrde );
          FETCH GET_REAL_GRDE_VALUES_C
           INTO lvRealGrdeRec;
          CLOSE GET_REAL_GRDE_VALUES_C;

          vSumGrades := vSumGrades + NVL( lvRealGrdeRec.SHRGRSC_MEDIAN, lvRealGrdeRec.SHRGRSC_PERCENTAGE );
          vCountGrades := vCountGrades + 1;
        ELSIF vStringType = 'A' THEN
          vANGrdeFound := TRUE;
          vMaxGrdePriority := F_RetMaxGrdePriority( vRec.cMidGrde, vMaxGrdePriority );
        ELSE
          IF vStringType = '-' THEN
            vCountNullGrades := vCountNullGrades + 1;
          END IF;
        END IF;
      END LOOP;

dbms_output.put_line('vSumGrades=[' || vSumGrades || ']');
dbms_output.put_line('vCountNullGrades=[' || vCountNullGrades || ']');
dbms_output.put_line('vMaxGrdePriority=[' || vMaxGrdePriority || ']');

      IF vCountNullGrades = 0 AND vTotCorqCrses > 0 THEN
dbms_output.put_line('a');
        IF ( vMaxGrdePriority IS NULL ) THEN
dbms_output.put_line('b');
          vAvgGrade := vSumGrades / vCountGrades;
    
          OPEN GET_GRDE_TO_ASSIGN_C( vAvgGrade );
          FETCH GET_GRDE_TO_ASSIGN_C
           INTO vFinalGrdeCode;
          IF GET_GRDE_TO_ASSIGN_C%NOTFOUND THEN
            vFinalGrdeCode := NULL;
          END IF;
          CLOSE GET_GRDE_TO_ASSIGN_C;
        ELSE
dbms_output.put_line('c');
          vFinalGrdeCode := vMaxGrdePriority;
        END IF;
dbms_output.put_line('vFinalGrdeCode=[' || vFinalGrdeCode || ']');
    
        IF vMode = 'U' THEN
          UPDATE SFRSTCR /*BIEN*/
             SET SFRSTCR_GRDE_CODE     = vFinalGrdeCode,
                 SFRSTCR_ACTIVITY_DATE = SYSDATE,
                 SFRSTCR_USER_ID       = USER
           WHERE SFRSTCR_TERM_CODE = vTermCode
             AND SFRSTCR_PIDM      = vPIDM
             AND SFRSTCR_CRN       = vCRN;
        
          xContador := 0;    
          FOR vRec IN GET_ALL_CORQ_COURSES_C LOOP
            xContador := xContador + 1;
            EXIT WHEN xContador = 10;
            UPDATE SFRSTCR /*BIEN*/
               SET SFRSTCR_GRDE_CODE     = vFinalGrdeCode,
                   SFRSTCR_ACTIVITY_DATE = SYSDATE,
                   SFRSTCR_USER_ID       = USER
             WHERE SFRSTCR_TERM_CODE = vTermCode
                AND SFRSTCR_PIDM      = vPIDM
                AND SFRSTCR_CRN       = vRec.cCRN;
          END LOOP;
dbms_output.put_line( 'xContador=[' || xContador || ']');
      
          COMMIT;
        
          vMsg := 1;
        END IF;
    END IF;
  END IF;
END P_CalcCorqGrades;

END SZKMRKS;
/
SHOW ERRORS
SET SCAN ON
