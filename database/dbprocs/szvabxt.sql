REM ************************************************************************************************
REM *                                                                                              *
REM * szvabxt_view.sql                                                                           *
REM *                                                                                              *
REM ************************************************************************************************
REM * Copyright (c) 2024 Ellucian. All rights reserved.                                            *
REM *                                                                                              *
REM * This copyrighted software contains confidential and proprietary information of Ellucian      *
REM * and its subsidiaries. Any use of this software is limited solely to Ellucian                 *
REM * licensees, and is further subject to the terms and conditions of one or                      *
REM * more written license agreements between Ellucian and the licensee in                         *
REM * question. Ellucian, Banner and Luminis are either registered trademarks or trademarks of     *
REM * Ellucian in the U.S.A. and/or other regions and/or countries.                                *
REM ************************************************************************************************
REM *                                                                                              *
REM *  Proyecto    : UTM                                                                           *
REM *  Modificacion: 002 - Mejoras a la Asistencia, calificaciones e historia academica            *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [UTM:002.1.0]                                              INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM * 1. Code creation                                                             MKU  26/NOV/2015*
REM *    -------------                                                                             *
REM *    Create view based on table SFRSTCR, SSRMEET and SSBSECT.                                  *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 9.3.34 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade of view SZVABXT for Banner 9                                     MHI 11-DEC-2024 *
REM *                                                                                              *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************


REM
REM Creating the SZVABXT view.
REM ****************************************************************************
PROMPT
PROMPT *************************************************************************
PROMPT * Begin: szvabxt.sql                                                    *
PROMPT *************************************************************************
PROMPT

REM
REM Connect to the Database
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

REM
REM Drop view SZVABXT.
REM ****************************************************************************
WHENEVER SQLERROR CONTINUE
DROP VIEW SZVABXT CASCADE CONSTRAINTS;

REM
REM Create view SZVABXT.
REM ****************************************************************************

CREATE OR REPLACE VIEW SZVABXT 
   (
       SZVABXT_PIDM, SZVABXT_TERM_CODE, SZVABXT_CRN, 
       SZVABXT_PTRM_CODE, SZVABXT_CAMP_CODE,
       SZVABXT_RSTS_CODE, SZVABXT_RSTS_DATE,
       SZVABXT_CREDIT_HR, SZVABXT_LEVL_CODE,
       SZVABXT_SUBJ_CODE, SZVABXT_CRSE_NUMB,  
       SZVABXT_EXT_ABS_IND, SZVABXT_ABJR_CODE,
       SZVABXT_PTRM_WEEKS, SZVABXT_SCHD_CODE,
       SZVABXT_STSP_KEY_SEQUENCE,
       SZVABXT_ABS_EXT, SZVABXT_ABS_JSTF,
       SZVABXT_ABS_ACCUM, SZVABXT_ABS_TRANS,
       SZVABXT_USER_ID, SZVABXT_ACTIVITY_DATE,
       SZVABXT_ERROR_FLAG
    ) AS 
select SF.SFRSTCR_PIDM, sf.SFRSTCR_TERM_CODE, sf.SFRSTCR_CRN, 
       SF.SFRSTCR_PTRM_CODE, SF.SFRSTCR_CAMP_CODE,
       SF.SFRSTCR_RSTS_CODE, SF.SFRSTCR_RSTS_DATE,
       SF.SFRSTCR_CREDIT_HR, SF.SFRSTCR_LEVL_CODE,
       SB.SSBSECT_SUBJ_CODE, SB.SSBSECT_CRSE_NUMB,
       tr.SZRAATR_EXT_ABS_IND, tr.SZRAATR_ABJR_CODE,
       sb.SSBSECT_PTRM_WEEKS, sb.SSBSECT_SCHD_CODE,
       sf.SFRSTCR_STSP_KEY_SEQUENCE, 
       tr.SZRAATR_ABS_EXT, tr.SZRAATR_ABS_JSTF,
       tr.SZRAATR_ABS_ACCUM, tr.SZRAATR_ABS_TRANS,
       tr.SZRAATR_USER_ID, tr.SZRAATR_ACTIVITY_DATE,
       sf.SFRSTCR_ERROR_FLAG
  from sfrstcr sf
  left outer join ssbsect sb
    on sb.SSBSECT_CRN = SF.SFRSTCR_CRN
   and sb.SSBSECT_TERM_CODE = SF.SFRSTCR_TERM_CODE
  left outer join szraatr tr
    on tr.SZRAATR_PIDM = SF.SFRSTCR_PIDM
   and tr.SZRAATR_TERM_CODE = sf.SFRSTCR_TERM_CODE
   and tr.SZRAATR_CRN = sf.SFRSTCR_CRN;
   
CREATE OR REPLACE PUBLIC SYNONYM SZVABXT FOR BANINST1.SZVABXT;

PROMPT
PROMPT *************************************************************************
PROMPT * End: szvabxt.sql                                                      *
PROMPT *************************************************************************
PROMPT
REM *
REM * End.
REM ****************************************************************************