REM ************************************************************************************************
REM *                                                                                              *
REM * szrroll_083102_objs.sql                                                                      *
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
REM *  Proposito   : Alta del objeto ProC en Banner                                                *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [UTM:002.1.0]                                              INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM * 1. Creacion del Codigo.                                                      MKU  24/DEC/2015*
REM *    --------------------                                                                      *
REM *    Este script da de alta al objeto en Banner y Banner Security.                             *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  AUDIT TRAIL: 8.31.2 [MOD:02.2.0]                                            INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM * 1. STUDENT version updgrade from 8.7 to 8.31.2                              LMR 16/DIC/2024  *
REM *    -------------------------------------------                                               *
REM *    Student version updated.                                                                  *
REM *  -------------------------------------------------------------------------- --- ------------ *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************


PROMPT
PROMPT ************************************************
PROMPT *  Now running szrroll_083102_objs.sql script  *
PROMPT ************************************************
PROMPT


REM ***************************************************************************
REM Alta en Banner Security.
REM ***************************************************************************
set echo off
set verify off
REM
SET SCAN ON
 CONNECT bansecr/&&bansecr_password;
SET ECHO OFF
SET SHOWMODE OFF
REM
START gsanobj SZRROLL BAN_DEFAULT_M '8.31.2' S BAN_STUDENT_C

COMMIT;

SET ECHO OFF
SET VERIFY OFF

REM ***************************************************************************
REM Alta en Banner - Definicion del Objeto
REM ***************************************************************************


SET SCAN ON
CONNECT general/&&general_password
SET ECHO OFF
SET SHOWMODE OFF

DELETE GUBOBJS WHERE GUBOBJS_NAME = 'SZRROLL';

INSERT INTO GUBOBJS ( GUBOBJS_NAME          ,
                      GUBOBJS_DESC          ,
                      GUBOBJS_OBJT_CODE     ,
                      GUBOBJS_SYSI_CODE     ,
                      GUBOBJS_USER_ID       ,
                      GUBOBJS_ACTIVITY_DATE ,
                      GUBOBJS_HELP_IND      ,
                      GUBOBJS_EXTRACT_ENABLED_IND )
             VALUES ( 'SZRROLL',
                      G$_NLS.GET('x','SQL','Grade Roll'), --TODO
                      'JOBS',
                      'S',
                      'LOCAL',
                      SYSDATE,
                      'N',
                      'N');

REM ***************************************************************************
REM Alta en Banner - Definicion del Job
REM ***************************************************************************

DELETE GJBJOBS WHERE GJBJOBS_NAME = 'SZRROLL';

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
             VALUES ( 'SZRROLL',
                      G$_NLS.GET('x','SQL','Grade Roll'), --TODO
                      SYSDATE,
                      'S',
                      'C',
                      G$_NLS.GET('x','SQL','Grade Roll to Academic History'), --TODO
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL );

REM ***************************************************************************
REM Alta en Banner - Definicion de los parametros
REM ***************************************************************************

DELETE GJBPDEF WHERE GJBPDEF_JOB = 'SZRROLL';

INSERT INTO GJBPDEF ( GJBPDEF_JOB, 
                      GJBPDEF_NUMBER, 
                      GJBPDEF_DESC, 
                      GJBPDEF_LENGTH, 
                      GJBPDEF_TYPE_IND, 
                      GJBPDEF_OPTIONAL_IND, 
                      GJBPDEF_SINGLE_IND, 
                      GJBPDEF_ACTIVITY_DATE, 
                      GJBPDEF_LOW_RANGE, 
                      GJBPDEF_HIGH_RANGE, 
                      GJBPDEF_HELP_TEXT, 
                      GJBPDEF_VALIDATION, 
                      GJBPDEF_LIST_VALUES
                    )
        VALUES ( 'SZRROLL', 
                 '01', 
                 G$_NLS.GET('x', 'SQL', 'Term Code'), 
                 6, 
                 'C', 
                 'R', 
                 'S', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Enter term to be processed.'), 
                 'STVTERM_LIKE', 
                 'STVTERM');


INSERT INTO GJBPDEF ( GJBPDEF_JOB, 
                      GJBPDEF_NUMBER, 
                      GJBPDEF_DESC, 
                      GJBPDEF_LENGTH, 
                      GJBPDEF_TYPE_IND, 
                      GJBPDEF_OPTIONAL_IND, 
                      GJBPDEF_SINGLE_IND, 
                      GJBPDEF_ACTIVITY_DATE, 
                      GJBPDEF_LOW_RANGE, 
                      GJBPDEF_HIGH_RANGE, 
                      GJBPDEF_HELP_TEXT, 
                      GJBPDEF_VALIDATION, 
                      GJBPDEF_LIST_VALUES
                    )
        VALUES ( 'SZRROLL', 
                 '02', 
                 G$_NLS.GET('x', 'SQL', 'Start Range From Date'), 
                 11, 
                 'D', 
                 'O', 
                 'S', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Enter Registration Start Range From Date (format DD-MMM-YYYY) to select.'), 
                 NULL, 
                 NULL);
 
 INSERT INTO GJBPDEF ( GJBPDEF_JOB, 
                      GJBPDEF_NUMBER, 
                      GJBPDEF_DESC, 
                      GJBPDEF_LENGTH, 
                      GJBPDEF_TYPE_IND, 
                      GJBPDEF_OPTIONAL_IND, 
                      GJBPDEF_SINGLE_IND, 
                      GJBPDEF_ACTIVITY_DATE, 
                      GJBPDEF_LOW_RANGE, 
                      GJBPDEF_HIGH_RANGE, 
                      GJBPDEF_HELP_TEXT, 
                      GJBPDEF_VALIDATION, 
                      GJBPDEF_LIST_VALUES
                    )
        VALUES ( 'SZRROLL', 
                 '03', 
                 G$_NLS.GET('x', 'SQL', 'Start Range To Date'), 
                 11, 
                 'D', 
                 'O', 
                 'S', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Enter Registration Start  Range To Date (format DD-MMM-YYYY) to select'), 
                 NULL, 
                 NULL);
 
 INSERT INTO GJBPDEF ( GJBPDEF_JOB, 
                      GJBPDEF_NUMBER, 
                      GJBPDEF_DESC, 
                      GJBPDEF_LENGTH, 
                      GJBPDEF_TYPE_IND, 
                      GJBPDEF_OPTIONAL_IND, 
                      GJBPDEF_SINGLE_IND, 
                      GJBPDEF_ACTIVITY_DATE, 
                      GJBPDEF_LOW_RANGE, 
                      GJBPDEF_HIGH_RANGE, 
                      GJBPDEF_HELP_TEXT, 
                      GJBPDEF_VALIDATION, 
                      GJBPDEF_LIST_VALUES
                    )
        VALUES ( 'SZRROLL', 
                 '04', 
                 G$_NLS.GET('x', 'SQL', 'Part of Term Code'), 
                 3, 
                 'C', 
                 'R', 
                 'M', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Enter part of term code or "%" for all part-of-term.'), 
                 'STVPTRM_LIKE', 
                 'STVPTRM');

 INSERT INTO GJBPDEF ( GJBPDEF_JOB, 
                      GJBPDEF_NUMBER, 
                      GJBPDEF_DESC, 
                      GJBPDEF_LENGTH, 
                      GJBPDEF_TYPE_IND, 
                      GJBPDEF_OPTIONAL_IND, 
                      GJBPDEF_SINGLE_IND, 
                      GJBPDEF_ACTIVITY_DATE, 
                      GJBPDEF_LOW_RANGE, 
                      GJBPDEF_HIGH_RANGE, 
                      GJBPDEF_HELP_TEXT, 
                      GJBPDEF_VALIDATION, 
                      GJBPDEF_LIST_VALUES
                    )
        VALUES ( 'SZRROLL', 
                 '05', 
                 G$_NLS.GET('x', 'SQL', 'Course Reference Number'), 
                 5, 
                 'C', 
                 'R', 
                 'M', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Enter course RReference number or "%" for all CRNs..'), 
                 NULL, 
                 null);

INSERT INTO GJBPDEF ( GJBPDEF_JOB, 
                      GJBPDEF_NUMBER, 
                      GJBPDEF_DESC, 
                      GJBPDEF_LENGTH, 
                      GJBPDEF_TYPE_IND, 
                      GJBPDEF_OPTIONAL_IND, 
                      GJBPDEF_SINGLE_IND, 
                      GJBPDEF_ACTIVITY_DATE, 
                      GJBPDEF_LOW_RANGE, 
                      GJBPDEF_HIGH_RANGE, 
                      GJBPDEF_HELP_TEXT, 
                      GJBPDEF_VALIDATION, 
                      GJBPDEF_LIST_VALUES
                    )
        VALUES ( 'SZRROLL', 
                 '06', 
                 G$_NLS.GET('x', 'SQL', 'User ID'), 
                 30, 
                 'C', 
                 'R', 
                 'S', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Enter user ID to be stored with grade records.'), 
                 NULL, 
                 NULL);

INSERT INTO GJBPDEF ( GJBPDEF_JOB, 
                      GJBPDEF_NUMBER, 
                      GJBPDEF_DESC, 
                      GJBPDEF_LENGTH, 
                      GJBPDEF_TYPE_IND, 
                      GJBPDEF_OPTIONAL_IND, 
                      GJBPDEF_SINGLE_IND, 
                      GJBPDEF_ACTIVITY_DATE, 
                      GJBPDEF_LOW_RANGE, 
                      GJBPDEF_HIGH_RANGE, 
                      GJBPDEF_HELP_TEXT, 
                      GJBPDEF_VALIDATION, 
                      GJBPDEF_LIST_VALUES
                    )
        VALUES ( 'SZRROLL', 
                 '07', 
                 G$_NLS.GET('x', 'SQL', 'Report Mode(A=Audit,U=Update)'), 
                 1, 
                 'C', 
                 'R', 
                 'S', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Enter A for audit mode or U for update.'), 
                 NULL, 
                 NULL);

INSERT INTO GJBPDEF ( GJBPDEF_JOB, 
                      GJBPDEF_NUMBER, 
                      GJBPDEF_DESC, 
                      GJBPDEF_LENGTH, 
                      GJBPDEF_TYPE_IND, 
                      GJBPDEF_OPTIONAL_IND, 
                      GJBPDEF_SINGLE_IND, 
                      GJBPDEF_ACTIVITY_DATE, 
                      GJBPDEF_LOW_RANGE, 
                      GJBPDEF_HIGH_RANGE, 
                      GJBPDEF_HELP_TEXT, 
                      GJBPDEF_VALIDATION, 
                      GJBPDEF_LIST_VALUES
                    )
        VALUES ( 'SZRROLL', 
                 '08', 
                 G$_NLS.GET('x', 'SQL', 'Print Selection(A=All,E=Error)'), 
                 1, 
                 'C', 
                 'R', 
                 'S', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Enter A to report results for all students/all CRNS; E for errors only.'), 
                 NULL, 
                 NULL);

INSERT INTO GJBPDEF ( GJBPDEF_JOB, 
                      GJBPDEF_NUMBER, 
                      GJBPDEF_DESC, 
                      GJBPDEF_LENGTH, 
                      GJBPDEF_TYPE_IND, 
                      GJBPDEF_OPTIONAL_IND, 
                      GJBPDEF_SINGLE_IND, 
                      GJBPDEF_ACTIVITY_DATE, 
                      GJBPDEF_LOW_RANGE, 
                      GJBPDEF_HIGH_RANGE, 
                      GJBPDEF_HELP_TEXT, 
                      GJBPDEF_VALIDATION, 
                      GJBPDEF_LIST_VALUES
                    )
        VALUES ( 'SZRROLL', 
                 '09', 
                 G$_NLS.GET('x', 'SQL', 'Grade Term'), 
                 6, 
                 'C', 
                 'O', 
                 'S', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Enter Grade Term to be recorded.'), 
                 'STVTERM_EQUAL', 
                 'STVTERM');                     
                         
INSERT INTO GJBPDEF ( GJBPDEF_JOB, 
                      GJBPDEF_NUMBER, 
                      GJBPDEF_DESC, 
                      GJBPDEF_LENGTH, 
                      GJBPDEF_TYPE_IND, 
                      GJBPDEF_OPTIONAL_IND, 
                      GJBPDEF_SINGLE_IND, 
                      GJBPDEF_ACTIVITY_DATE, 
                      GJBPDEF_LOW_RANGE, 
                      GJBPDEF_HIGH_RANGE, 
                      GJBPDEF_HELP_TEXT, 
                      GJBPDEF_VALIDATION, 
                      GJBPDEF_LIST_VALUES
                    )
        VALUES ( 'SZRROLL', 
                 '10', 
                 G$_NLS.GET('x', 'SQL', 'Roll Long Section Title'), 
                 1, 
                 'C', 
                 'R', 
                 'S', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Enter Y to roll the syllabus Long Section Title'), 
                 NULL, 
                 NULL); 

INSERT INTO GJBPDEF ( GJBPDEF_JOB, 
                      GJBPDEF_NUMBER, 
                      GJBPDEF_DESC, 
                      GJBPDEF_LENGTH, 
                      GJBPDEF_TYPE_IND, 
                      GJBPDEF_OPTIONAL_IND, 
                      GJBPDEF_SINGLE_IND, 
                      GJBPDEF_ACTIVITY_DATE, 
                      GJBPDEF_LOW_RANGE, 
                      GJBPDEF_HIGH_RANGE, 
                      GJBPDEF_HELP_TEXT, 
                      GJBPDEF_VALIDATION, 
                      GJBPDEF_LIST_VALUES
                    )
        VALUES ( 'SZRROLL', 
                 '11', 
                 G$_NLS.GET('x', 'SQL', 'Level'), 
                 2, 
                 'C', 
                 'R', 
                 'M', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Enter level code or "%" for all levels.'), 
                 'STVLEVL_LIKE', 
                 'STVLEVL'); 

INSERT INTO GJBPDEF ( GJBPDEF_JOB, 
                      GJBPDEF_NUMBER, 
                      GJBPDEF_DESC, 
                      GJBPDEF_LENGTH, 
                      GJBPDEF_TYPE_IND, 
                      GJBPDEF_OPTIONAL_IND, 
                      GJBPDEF_SINGLE_IND, 
                      GJBPDEF_ACTIVITY_DATE, 
                      GJBPDEF_LOW_RANGE, 
                      GJBPDEF_HIGH_RANGE, 
                      GJBPDEF_HELP_TEXT, 
                      GJBPDEF_VALIDATION, 
                      GJBPDEF_LIST_VALUES
                    )
        VALUES ( 'SZRROLL', 
                 '12', 
                 G$_NLS.GET('x', 'SQL', 'Campus'), 
                 3, 
                 'C', 
                 'O', 
                 'S', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Enter Campus code.'), 
                 'STVCAMP_LIKE', 
                 'STVCAMP');                             
                                                   
REM ****************************************************************************
REM Alta en Banner - Definicion de los Valores por Omision de los Parametros
REM ****************************************************************************

DELETE GJBPDFT WHERE GJBPDFT_JOB = 'SZRROLL';

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZRROLL','01',SYSDATE, NULL, NULL, NULL);

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZRROLL','02',SYSDATE, NULL, NULL, NULL);

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZRROLL','03',SYSDATE, NULL, NULL, NULL);

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZRROLL','04',SYSDATE, NULL, '%', NULL);

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZRROLL','05',SYSDATE, NULL, '%', NULL);

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZRROLL','06',SYSDATE, NULL, NULL, NULL);

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZRROLL','07',SYSDATE, NULL, 'A', NULL);

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZRROLL','08',SYSDATE, NULL, 'A', NULL);

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZRROLL','09',SYSDATE, NULL, NULL, NULL);

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZRROLL','10',SYSDATE, NULL, 'N', NULL);

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZRROLL','11',SYSDATE, NULL, '%', NULL);

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZRROLL','12',SYSDATE, NULL, null, NULL);

REM ****************************************************************************
REM Guardando cambios.
REM ****************************************************************************
COMMIT;

REM ****************************************************************************
REM Fin.
REM ****************************************************************************
