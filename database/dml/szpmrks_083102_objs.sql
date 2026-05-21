REM ****************************************************************************
REM *                                                                          *
REM * szpmrks_083102_objs.sql                                                  *
REM * Copyright 2024 Ellucian Company L.P. and its affiliates.                 *
REM *                                                                          *
REM ****************************************************************************
REM *                                                                          *
REM *                    CONFIDENTIAL BUSINESS INFORMATION                     *
REM *                                                                          *
REM ****************************************************************************
REM * This software contains confidential and proprietary information of       *
REM * Ellucian or its subsidiaries.                                            *
REM * Use of this software is limited to Ellucian licensees, and is subject to *
REM * the terms and conditions of one or more written license agreements       *
REM * between Ellucian and such licensees.                                     *
REM ****************************************************************************
REM *                                                                          *
REM *  Script Name : szpmrks_083102_objs.sql                                   *
REM *                                                                          *
REM *      Project : UTM                                                       *
REM * Modification : 002 - Enhancement to attendance, grades and               *
REM *                      academic history.                                   *
REM *  Description : Create SZPMRKS JOB.                                       *
REM *                                                                          *
REM ****************************************************************************
REM *                                                                          *
REM *  AUDIT TRAIL: 8.7.0 [UTM:002.1.0]                     INI    DATE      *
REM *  ------------------------------------------------------ --- ------------ *
REM * 1. Creacion del Codigo.                                 DLO 08/ENE/2016  *
REM *    --------------------                                                  *
REM *    Este script da de alta al objeto en Banner                            *
REM *    y Banner Security.                                                    *
REM *  ------------------------------------------------------ --- ------------ *
REM *  AUDIT TRAIL: 8.31.2 [MOD:02.2.0]                       INI    DATE      *
REM *  ------------------------------------------------------ --- ------------ *
REM * 1. STUDENT version updgrade from 8.7 to 8.31.2          LMR 11/DIC/2024  *
REM *    -------------------------------------------                           *
REM *    Student version updated.                                              *
REM *  ------------------------------------------------------ --- ------------ *
REM *                                                                          *
REM *  AUDIT TRAIL: END                                                        *
REM *                                                                          *
REM ****************************************************************************


PROMPT
PROMPT ************************************************
PROMPT *  Now running szpmrks_083102_objs.sql script  *
PROMPT ************************************************
PROMPT


REM ****************************************************************************
REM Alta en Banner Security.
REM ****************************************************************************
set echo off
set verify off
REM
SET SCAN ON
CONNECT bansecr/&&bansecr_password;
SET ECHO OFF
SET SHOWMODE OFF
REM
START gsanobj SZPMRKS BAN_DEFAULT_M '8.31.2' T BAN_STUDENT_C

COMMIT;

SET ECHO OFF
SET VERIFY OFF

REM ****************************************************************************
REM Alta en Banner - Definicion del Objeto
REM ****************************************************************************


SET SCAN ON
CONNECT general/&&general_password
SET ECHO OFF
SET SHOWMODE OFF

DELETE GUBOBJS WHERE GUBOBJS_NAME = 'SZPMRKS';

INSERT INTO GUBOBJS ( GUBOBJS_NAME          ,
                      GUBOBJS_DESC          ,
                      GUBOBJS_OBJT_CODE     ,
                      GUBOBJS_SYSI_CODE     ,
                      GUBOBJS_USER_ID       ,
                      GUBOBJS_ACTIVITY_DATE ,
                      GUBOBJS_HELP_IND      ,
                      GUBOBJS_EXTRACT_ENABLED_IND )
             VALUES ( 'SZPMRKS',
                      G$_NLS.GET('x','SQL','Massive load grades in activities'),
                      'JOBS',
                      'S',
                      'LOCAL',
                      SYSDATE,
                      'N',
                      'N');

REM ****************************************************************************
REM Alta en Banner - Definicion del Job
REM ****************************************************************************

DELETE GJBJOBS WHERE GJBJOBS_NAME = 'SZPMRKS';

INSERT INTO GJBJOBS ( GJBJOBS_NAME         ,
                      GJBJOBS_TITLE        ,
                      GJBJOBS_ACTIVITY_DATE,
                      GJBJOBS_SYSI_CODE    ,
                      GJBJOBS_JOB_TYPE_IND ,
                      GJBJOBS_DESC         ,
                      GJBJOBS_COMMAND_NAME ,
                      GJBJOBS_PRNT_FORM    ,
                      GJBJOBS_PRNT_CODE    ,
                      GJBJOBS_LINE_COUNT   ,
                      GJBJOBS_VALIDATION   )
             VALUES ( 'SZPMRKS',
                      G$_NLS.GET('x','SQL','Massive load grades in act.'),
                      SYSDATE,
                      'S',
                      'C',
                      G$_NLS.GET('x','SQL','Massive load grades in activities'),
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL );

REM ***************************************************************************
REM Alta en Banner - Definicion de los parametros
REM ***************************************************************************

DELETE GJBPDEF WHERE GJBPDEF_JOB = 'SZPMRKS';

INSERT INTO GJBPDEF (GJBPDEF_JOB, GJBPDEF_NUMBER, GJBPDEF_DESC, GJBPDEF_LENGTH, GJBPDEF_TYPE_IND, GJBPDEF_OPTIONAL_IND, GJBPDEF_SINGLE_IND, GJBPDEF_ACTIVITY_DATE, GJBPDEF_LOW_RANGE, GJBPDEF_HIGH_RANGE, GJBPDEF_HELP_TEXT, GJBPDEF_VALIDATION, GJBPDEF_LIST_VALUES)
VALUES ( 'SZPMRKS', '01', G$_NLS.GET('x', 'SQL', 'Layout'), 30, 'C', 'R', 'S', SYSDATE, NULL, NULL, G$_NLS.GET('x', 'SQL', 'File Name.'), NULL, NULL );
                                                                  
INSERT INTO GJBPDEF (GJBPDEF_JOB, GJBPDEF_NUMBER, GJBPDEF_DESC, GJBPDEF_LENGTH, GJBPDEF_TYPE_IND, GJBPDEF_OPTIONAL_IND, GJBPDEF_SINGLE_IND, GJBPDEF_ACTIVITY_DATE, GJBPDEF_LOW_RANGE, GJBPDEF_HIGH_RANGE, GJBPDEF_HELP_TEXT, GJBPDEF_VALIDATION, GJBPDEF_LIST_VALUES)
VALUES ( 'SZPMRKS', '02', 'Enter Run Mode [A/U]', 1, 'C', 'R', 'S', SYSDATE, NULL, NULL, 'Enter Run Mode [A-Audit/U-Update]', NULL, NULL);
                                   
REM ****************************************************************************
REM Alta en Banner - Definicion de los Valores por Omision de los Parametros
REM ****************************************************************************
DELETE GJBPDFT WHERE GJBPDFT_JOB = 'SZPMRKS';


INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZPMRKS', '01', SYSDATE, NULL, NULL, NULL );

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZPMRKS', '02', SYSDATE, NULL, 'A', NULL );

REM ****************************************************************************
REM Alta en Banner - Definicion de los valores validos de parametros
REM ****************************************************************************
DELETE GJBPVAL WHERE GJBPVAL_JOB = 'SZPMRKS';

INSERT INTO GJBPVAL( GJBPVAL_JOB, GJBPVAL_NUMBER, GJBPVAL_VALUE, GJBPVAL_DESC, GJBPVAL_ACTIVITY_DATE )
VALUES ( 'SZPMRKS', '02', 'A', 'Run Mode [(A)udit/(U)pdate]', SYSDATE);

INSERT INTO GJBPVAL( GJBPVAL_JOB, GJBPVAL_NUMBER, GJBPVAL_VALUE, GJBPVAL_DESC, GJBPVAL_ACTIVITY_DATE )
VALUES ( 'SZPMRKS', '02', 'U', 'Run Mode [(A)udit/(U)pdate]', SYSDATE);

REM ****************************************************************************
REM Guardando cambios.
REM ****************************************************************************
COMMIT;

REM ****************************************************************************
REM Fin.
REM ****************************************************************************

