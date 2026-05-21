SET SHOWMODE OFF
SET ECHO OFF
REM ****************************************************************************
REM *                                                                          *
REM * szkutil.sql                                                              *
REM *                                                                          *
REM ****************************************************************************
REM *                                                                          *
REM * Copyright 2025 Ellucian Company L.P. and its affiliates                  *
REM *                                                                          *
REM ****************************************************************************
REM *                                                                          *
REM *                    CONFIDENTIAL BUSINESS INFORMATION                     *
REM *                                                                          *
REM ****************************************************************************
REM *                                                                          *
REM * This software contains confidential and proprietary information of       *
REM * Ellucian or its subsidiaries. Use of this software is limited to         *
REM * Ellucian licensees, and is subject to the terms and conditions of one or *
REM * more written license agreements between Ellucian and such licensees.     *
REM *                                                                          *
REM ****************************************************************************
REM *                                                                          *
REM *  Project     : UTM                                                       *
REM *  Modification: MOD-002: Mejora a Asistencia                              *
REM *                                                                          *
REM ****************************************************************************
REM *                                                                          *
REM *  AUDIT TRAIL: 9.3.34 [MCLA:002.2.0]                       INI    DATE     *
REM *  ------------------------------------------------------- --- ----------- *
REM *  1. Initial Creation.                                    MHI 17/JAN/2025 *
REM *  ------------------------------------------------------- --- ----------- *
REM *  AUDIT TRAIL: END                                                        *
REM *                                                                          *
REM ****************************************************************************
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
create or replace PACKAGE SZKUTIL AS
--
-- FILE NAME..: szkutil.sql
-- RELEASE....: 9.3.34 [MCLA:002.2.0]
-- OBJECT NAME: SZKUTIL
-- INSTITUTION: Latin America ModCenter
-- COPYRIGHT..: Copyright (C) Ellucian 2024. All rights reserved.
--
-- DESCRIPTION:
-- MHI BA [MCLA:002.2.0] 17-JAN-2025
-- Procedimientos y funciones extraidas de formas de Oracle para el funcionamiento de Admin Pages
-- MHI EA [MCLA:002.2.0] 17-JAN-2025
-- DESCRIPTION END

FUNCTION F_SZASCHC_COPY(p_term IN VARCHAR2, p_ptrm IN varchar2, p_key_term IN VARCHAR2, p_key_ptrm IN VARCHAR2)
  RETURN VARCHAR2;

  PROCEDURE P_SZAABJR_INSERT_SZRAATR(p_pidm         spriden.spriden_pidm%type,
                                     p_crn          ssbsect.ssbsect_crn%type,
                                     p_term_code    stvterm.stvterm_Code%type,
                                     p_mode         varchar2);

  FUNCTION F_SZAABXT_SAVE_UPDATE_SZRAATR(p_pidm        spriden.spriden_pidm%type,
                                          p_term_code   stvterm.stvterm_code%type,
                                          p_ptrm_code   stvptrm.stvptrm_code%type,
                                          p_crn         ssbsect.ssbsect_crn%type,
                                          p_levl_code   stvlevl.stvlevl_code%type,
                                          p_schd_code   stvschd.stvschd_code%type,
                                          p_ext_abs_ind varchar2,
                                          p_abjr_code   szvabjr.szvabjr_code%type)
  RETURN VARCHAR2;

  FUNCTION F_SZAABXT_CALCULATE_SESSION(P_Term_Code      Stvterm.Stvterm_Code%Type,
                                       P_Crn            Ssbsect.Ssbsect_Crn%Type,
                                       p_ptrm_code      Stvptrm.Stvptrm_Code%type)
  RETURN NUMBER;

  FUNCTION F_SZAABXT_EXCLUDE_DAY(P_Date             Date,
                                 P_Ptrm_Code        Stvptrm.Stvptrm_Code%Type)
  RETURN NUMBER;

  FUNCTION P_SZAANDL_CRN_LIST(P_KB_PTRM_CODE   STVPTRM.STVPTRM_CODE%TYPE,
                               P_KB_TERM_CODE   STVTERM.STVTERM_CODE%TYPE,
                               P_RB_CALCULATE   VARCHAR2,
                               P_LIST_ITEM      LONG,
                               P_ABS_OVERRIDE   VARCHAR2,
                               P_UNDE_OVERRIDE  VARCHAR2)
  RETURN VARCHAR2;

  FUNCTION P_SZAANDL_SELECTED_CRN(P_KB_TERM_CODE    STVTERM.STVTERM_CODE%TYPE,
                          P_KB_PTRM_CODE    STVPTRM.STVPTRM_CODE%TYPE,
                          P_SEL_CAMPUS      STVCAMP.STVCAMP_CODE%TYPE,
                          P_SEL_SCHD        STVSCHD.STVSCHD_CODE%TYPE,
                          P_SEL_SUB         SSBSECT.SSBSECT_SUBJ_CODE%TYPE,
                          P_SEL_CRSE_NUM    SSBSECT.SSBSECT_CRSE_NUMB%TYPE,
                          P_RB_CALCULATE   VARCHAR2)  RETURN VARCHAR2;

  PROCEDURE P_SZAANDL_PROCESS_CRN(p_term_code     stvterm.stvterm_code%type,
                          p_ptrm_code	  stvptrm.stvptrm_code%type,
                          p_crn           ssbsect.ssbsect_crn%type,
                          p_term_type     STVTRMT.STVTRMT_CODE%type,
                          p_AbsValue      number,
                          pStatus     out number);

  PROCEDURE P_SZAANDL_PROCESS_UNDELIV_CRN(p_term_code     stvterm.stvterm_code%type,
                                  p_ptrm_code	  stvptrm.stvptrm_code%type,
                                  p_crn           ssbsect.ssbsect_crn%type,
                                  p_Undeliv       number,
                                  pStatus     out number);

  PROCEDURE P_SZAANDL_SAVE_SZRATRK(p_term_code stvterm.stvterm_code%type,
                                   p_ptrm_code stvptrm.stvptrm_code%type,
                                   p_crn       ssbsect.ssbsect_crn%type,
                                   p_Subj_Code soratrk.SORATRK_SUBJ_CODE%type,
                                   p_Crse_Numb soratrk.SORATRK_CRSE_NUMB%type,
                                   p_AbsValue  number,
                                   p_Undeliv   number,
                                   p_type	   varchar2,
                                   pStatus     out number);


  FUNCTION F_CALCULATE_SESSION(P_Term_Code      Stvterm.Stvterm_Code%Type,
                               P_Crn             Ssbsect.Ssbsect_Crn%Type,
                               p_ptrm_code      Stvptrm.Stvptrm_Code%type) RETURN NUMBER;

  FUNCTION F_EXCLUDE_DAY(P_Date             Date,
                         P_Ptrm_Code        Stvptrm.Stvptrm_Code%Type) RETURN NUMBER;

  FUNCTION F_SZAMRKS_GET_GRADE( vGradeCode  IN VARCHAR2,
                                vPercentage OUT NUMBER) RETURN NUMBER;


  FUNCTION F_SZAMRKS_GET_SCORE( vGradeCode  IN VARCHAR2,
                                vPercentage OUT NUMBER) RETURN NUMBER;

  FUNCTION F_SZAGSMA_NEW_ASSIGNS(P_SCHM_NUM SZBSCHM.SZBSCHM_SEQNO%TYPE,
                                 P_TERM_CODE  STVTERM.STVTERM_CODE%TYPE,
                                 P_PTRM_CODE  STVPTRM.STVPTRM_CODE%TYPE,
                                 P_GSCH_NAME  SSBSECT.SSBSECT_GSCH_NAME%TYPE,
                                 P_CRN        SSBSECT.SSBSECT_CRN%TYPE) RETURN VARCHAR2;



   FUNCTION F_SZAGSMA_OVR_ASSIGNS(P_SCHM_NUM   SZBSCHM.SZBSCHM_SEQNO%TYPE,
                                 P_TERM_CODE    STVTERM.STVTERM_CODE%TYPE,
                                 P_PTRM_CODE    STVPTRM.STVPTRM_CODE%TYPE,
                                 P_GSCH_NAME    SSBSECT.SSBSECT_GSCH_NAME%TYPE,
                                 P_CRN          SSBSECT.SSBSECT_CRN%TYPE,
                                 P_OLD_SCHM_NUM SZBSCHM.SZBSCHM_SEQNO%TYPE) RETURN VARCHAR2;

  FUNCTION F_SZAGSMA_INSERT_SHRGCOM(P_SCHM_NUM   SZBSCHM.SZBSCHM_SEQNO%TYPE,
                                    P_TERM_CODE  STVTERM.STVTERM_CODE%TYPE,
                                    P_PTRM_CODE  STVPTRM.STVPTRM_CODE%TYPE,
                                    P_CRN        SSBSECT.SSBSECT_CRN%TYPE,
                                    P_GSCH_NAME  SSBSECT.SSBSECT_GSCH_NAME%TYPE) RETURN VARCHAR2;

  PROCEDURE P_CREATE_EXAM_ID(ID IN OUT NUMBER);

  FUNCTION F_CHECK_SEQ_NO (p_term    in shrgcom.shrgcom_term_code%type,
                            p_crn     in shrgcom.shrgcom_crn%type,
                            p_seq     in shrgcom.shrgcom_andor_seq_no%type,
                            p_gcom_id in shrgcom.shrgcom_id%type,
                            p_scom_id in shrscom.shrscom_id%type,
                            p_mode    in varchar2) RETURN VARCHAR2;


  FUNCTION F_SZAFTOP_PROCESS_ALLOW_ENTRY(P_CRNS LONG,
                                         P_TERM_CODE STVTERM.STVTERM_CODE%TYPE,
                                         P_PTRM_CODE STVPTRM.STVPTRM_CODE%TYPE,
                                         P_FGRDE_ENTRY VARCHAR2) RETURN VARCHAR2;

  FUNCTION F_SZAFTOP_PROCESS_EXPT_ENTRY(P_CRNS LONG,
                                        P_TERM_CODE STVTERM.STVTERM_CODE%TYPE,
                                        P_PTRM_CODE STVPTRM.STVPTRM_CODE%TYPE,
                                        P_FGRDE_ENTRY_EXPT VARCHAR2) RETURN VARCHAR2;

  ------------------------------------------------------------------------------
  -- Functions and Procedures for SSB9 Reports ---------------------------------
  ------------------------------------------------------------------------------


    /*PROCEDURE p_run_proc(p_stu_id       IN VARCHAR2
                        ,p_fac_id       IN VARCHAR2
                        ,p_process_name IN VARCHAR2
                        ,p_term_code    IN VARCHAR2
                        ,p_crn          IN VARCHAR2
                        ,p_old_grade    IN NUMBER
                        ,p_new_grade    IN NUMBER
                        ,p_gcom_id      IN NUMBER
                        ,p_sent_email   IN VARCHAR2 DEFAULT 'Y'
                         );*/

  FUNCTION F_ROLE_ADM_TABLE(p_table_name          ALL_TABLES.TABLE_NAME%TYPE,
                              p_column_name         ALL_TAB_COLUMNS.COLUMN_NAME%TYPE,
                              p_pidm                number,
                              p_term_code           STVTERM.STVTERM_CODE%TYPE,
                              p_value               varchar2,
                              p_role                SORADAS.SORADAS_RADM_CODE%TYPE DEFAULT NULL ) RETURN VARCHAR2;
                              
                              
     --MHI [LAET:002.2.2] Added Pro*C Funcionality from Banner 8 Package bwzkacrp 28/NOV/2025
     
     PROCEDURE p_UpdateLetterScore( nPidm NUMBER,
                               nCrn VARCHAR2,
                               nTerm VARCHAR2);
                               
                               
                               
    PROCEDURE p_calculateAbscense(pidm      NUMBER,
                                   pTerm     VARCHAR2,
                                   pCrn      VARCHAR2,
                                   pAbs OUT  NUMBER);
                                   
                                   
    PROCEDURE p_calculateDelivery(pidm       NUMBER,
                                   pTerm      VARCHAR2,
                                   pCrn       VARCHAR2,
                                   pDevs OUT  NUMBER);
                                   
                                   
    FUNCTION f_isNumber(vScore VARCHAR2)
       RETURN BOOLEAN;
       
    
    FUNCTION f_returnGrdeCode(vgrde VARCHAR2)
       RETURN VARCHAR2;
                             

END SZKUTIL;
/

SHOW ERRORS
SET DEFINE ON

--GRANT EXECUTE ON SZKUTIL TO BANINST1;s
GRANT ALL ON SZKUTIL TO banproxy;
GRANT ALL ON SZKUTIL TO ban_ss_user;

GRANT DEBUG ON "BANINST1"."SZKUTIL" TO "BANPROXY";

GRANT EXECUTE ON "BANINST1"."SZKUTIL" TO "BAN_SS_USER";
--
WHENEVER SQLERROR CONTINUE
DROP PUBLIC SYNONYM SZKUTIL;
--
WHENEVER SQLERROR CONTINUE 
CREATE PUBLIC SYNONYM SZKUTIL FOR SZKUTIL;
--
WHENEVER SQLERROR CONTINUE
start gurgrtb SZKUTIL
start gurgrth SZKUTIL

WHENEVER SQLERROR EXIT ROLLBACK

PROMPT *************************************************************************
PROMPT * End: SZKUTIL.sql                                                      * 
PROMPT *************************************************************************