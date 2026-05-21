REM ************************************************************************************************
REM *                                                                                              *
REM * szvvabj_view.sql                                                                           *
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
REM *  Modificacion: 002 - Mejoras a la Asistencia, calificaciones e historia academica            *                                           *
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
REM *  1. Upgrade of view SZVVABJ for Banner 9                                     MHI 11-DEC-2024 *
REM *                                                                                              *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************


REM
REM Creating the SZVVABJ view.
REM ****************************************************************************
PROMPT
PROMPT *************************************************************************
PROMPT * Begin: SZVVABJ.sql                                                    *
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
REM Drop view SZVVABJ.
REM ****************************************************************************
WHENEVER SQLERROR CONTINUE
DROP VIEW SZVVABJ CASCADE CONSTRAINTS;

REM
REM Create view SZVVABJ.
REM ****************************************************************************

CREATE OR REPLACE VIEW SZVVABJ (SZVVABJ_MEET_SURROGATE_ID ,
       SZVVABJ_PIDM, SZVVABJ_TERM_CODE, SZVVABJ_CRN, 
       SZVVABJ_PTRM_CODE, SZVVABJ_CAMP_CODE,
       SZVVABJ_RSTS_CODE, SZVVABJ_RSTS_DATE,
       SZVVABJ_CREDIT_HR, SZVVABJ_LEVL_CODE,
       SZVVABJ_SUBJ_CODE, SZVVABJ_CRSE_NUMB,  
       SZVVABJ_START_DATE, SZVVABJ_END_DATE,
       SZVVABJ_BEGIN_TIME, SZVVABJ_END_TIME,
       SZVVABJ_BLDG_CODE, SZVVABJ_ROOM_CODE, SZVVABJ_SCHD_CODE,
       SZVVABJ_CREDIT_HR_SESS, SZVVABJ_MEET_NO, SZVVABJ_HRS_WEEK,
       SZVVABJ_MON_DAY, SZVVABJ_TUE_DAY,
       SZVVABJ_WED_DAY, SZVVABJ_THU_DAY, 
       SZVVABJ_FRI_DAY, SZVVABJ_SAT_DAY, SZVVABJ_SUN_DAY,
       SZVVABJ_STSP_KEY_SEQUENCE, SZVVABJ_PTRM_WEEKS,
       SZVVABJ_ERROR_FLAG
       ) AS 
select SR.SSRMEET_SURROGATE_ID ,
       SF.SFRSTCR_PIDM, sf.SFRSTCR_TERM_CODE, sf.SFRSTCR_CRN, 
       SF.SFRSTCR_PTRM_CODE, SF.SFRSTCR_CAMP_CODE,
       SF.SFRSTCR_RSTS_CODE, SF.SFRSTCR_RSTS_DATE,
       SF.SFRSTCR_CREDIT_HR, SF.SFRSTCR_LEVL_CODE,
       SB.SSBSECT_SUBJ_CODE, SB.SSBSECT_CRSE_NUMB,  
       SR.SSRMEET_START_DATE, SR.SSRMEET_END_DATE,
       SR.SSRMEET_BEGIN_TIME, SR.SSRMEET_END_TIME,
       SR.SSRMEET_BLDG_CODE, SR.SSRMEET_ROOM_CODE, SR.SSRMEET_SCHD_CODE,
       SR.SSRMEET_CREDIT_HR_SESS, SR.SSRMEET_MEET_NO,SR.SSRMEET_HRS_WEEK,
       SR.SSRMEET_MON_DAY, SR.SSRMEET_TUE_DAY,
       SR.SSRMEET_WED_DAY, SR.SSRMEET_THU_DAY, 
       SR.SSRMEET_FRI_DAY, SR.SSRMEET_SAT_DAY, SR.SSRMEET_SUN_DAY,
       sf.SFRSTCR_STSP_KEY_SEQUENCE, sb.SSBSECT_PTRM_WEEKS,
       sf.SFRSTCR_ERROR_FLAG
  from sfrstcr sf
  left outer join ssrmeet sr
    on  SR.SSRMEET_CRN = SF.SFRSTCR_CRN
   and SR.SSRMEET_TERM_CODE = SF.SFRSTCR_TERM_CODE
  left outer join ssbsect sb
    on sb.SSBSECT_CRN = SF.SFRSTCR_CRN
   and sb.SSBSECT_TERM_CODE = SF.SFRSTCR_TERM_CODE;

CREATE OR REPLACE PUBLIC SYNONYM SZVVABJ FOR BANINST1.SZVVABJ;


PROMPT
PROMPT *************************************************************************
PROMPT * End: SZVVABJ.sql                                                      *
PROMPT *************************************************************************
PROMPT
REM *
REM * End.
REM ****************************************************************************
