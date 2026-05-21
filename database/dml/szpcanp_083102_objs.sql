REM ************************************************************************************************
REM *                                                                                              *
REM * szpcanp_083102_objs.sql                                                                      *
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
REM * 1. STUDENT version updgrade from 8.7 to 8.31.2                              LMR 11/DIC/2024  *
REM *    -------------------------------------------                                               *
REM *    Student version updated.                                                                  *
REM *  -------------------------------------------------------------------------- --- ------------ *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************


PROMPT
PROMPT ************************************************
PROMPT *  Now running szpcanp_083102_objs.sql script  *
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
START gsanobj SZPCANP BAN_DEFAULT_M '8.31.2' S BAN_STUDENT_C

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

DELETE GUBOBJS WHERE GUBOBJS_NAME = 'SZPCANP';

INSERT INTO GUBOBJS ( GUBOBJS_NAME          ,
                      GUBOBJS_DESC          ,
                      GUBOBJS_OBJT_CODE     ,
                      GUBOBJS_SYSI_CODE     ,
                      GUBOBJS_USER_ID       ,
                      GUBOBJS_ACTIVITY_DATE ,
                      GUBOBJS_HELP_IND      ,
                      GUBOBJS_EXTRACT_ENABLED_IND )
             VALUES ( 'SZPCANP',
                      G$_NLS.GET('x','SQL','Grade assignment Not Presented'), --TODO
                      'JOBS',
                      'S',
                      'LOCAL',
                      SYSDATE,
                      'N',
                      'N');

REM ***************************************************************************
REM Alta en Banner - Definicion del Job
REM ***************************************************************************

DELETE GJBJOBS WHERE GJBJOBS_NAME = 'SZPCANP';

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
             VALUES ( 'SZPCANP',
                      G$_NLS.GET('x','SQL','Grade assignment Not Presented'), --TODO
                      SYSDATE,
                      'S',
                      'C',
                      G$_NLS.GET('x','SQL','Grade assignment Not Presented'), --TODO
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL );

REM ***************************************************************************
REM Alta en Banner - Definicion de los parametros
REM ***************************************************************************

DELETE GJBPDEF WHERE GJBPDEF_JOB = 'SZPCANP';

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
        VALUES ( 'SZPCANP', 
                 '01', 
                 G$_NLS.GET('x', 'SQL', 'File Name'), 
                 99, 
                 'C', 
                 'O', 
                 'S', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Enter file name.'), 
                 NULL, 
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
        VALUES ( 'SZPCANP', 
                 '02', 
                 G$_NLS.GET('x', 'SQL', 'Term'), 
                 6, 
                 'C', 
                 'O', 
                 'S', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Enter Term code. Required if file name is not provided.'), 
                 NULL, 
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
        VALUES ( 'SZPCANP', 
                 '03', 
                 G$_NLS.GET('x', 'SQL', 'Part of Term'), 
                 3, 
                 'C', 
                 'O', 
                 'S', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Enter part of term code.'), 
                 NULL, 
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
        VALUES ( 'SZPCANP', 
                 '04', 
                 G$_NLS.GET('x', 'SQL', 'Subject'), 
                 4, 
                 'C', 
                 'O', 
                 'S', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Enter subject code.'), 
                 NULL, 
                 'STVSUBJ');

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
        VALUES ( 'SZPCANP', 
                 '05', 
                 G$_NLS.GET('x', 'SQL', 'Course Number'), 
                 5, 
                 'C', 
                 'O', 
                 'S', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Enter course number.'), 
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
        VALUES ( 'SZPCANP', 
                 '06', 
                 G$_NLS.GET('x', 'SQL', 'CRN'), 
                 5, 
                 'C', 
                 'O', 
                 'S', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Enter CRN.'), 
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
        VALUES ( 'SZPCANP', 
                 '07', 
                 G$_NLS.GET('x', 'SQL', 'Schedule type'), 
                 3, 
                 'C', 
                 'O', 
                 'S', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Enter schedule type.'), 
                 NULL, 
                 'STVSCHD');

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
        VALUES ( 'SZPCANP', 
                 '08', 
                 G$_NLS.GET('x', 'SQL', 'Grade code'), 
                 6, 
                 'C', 
                 'R', 
                 'S', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Enter grade code.'), 
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
        VALUES ( 'SZPCANP', 
                 '09', 
                 G$_NLS.GET('x', 'SQL', 'Run Mode'), 
                 1, 
                 'C', 
                 'R', 
                 'S', 
                 SYSDATE, 
                 NULL, 
                 NULL, 
                 G$_NLS.GET('x', 'SQL', 'Type (A) Audit or (U) Update.'), 
                 NULL, 
                 NULL); 

                                                   
REM ****************************************************************************
REM Alta en Banner - Definicion de los Valores por Omision de los Parametros
REM ****************************************************************************

DELETE GJBPDFT WHERE GJBPDFT_JOB = 'SZPCANP';

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZPCANP', '01', SYSDATE, NULL, NULL, NULL );

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZPCANP', '02', SYSDATE, NULL, NULL, NULL );

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZPCANP', '03', SYSDATE, NULL, NULL, NULL );

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZPCANP', '04', SYSDATE, NULL, NULL, NULL );

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZPCANP', '05', SYSDATE, NULL, NULL, NULL );

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZPCANP', '06', SYSDATE, NULL, NULL, NULL );

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZPCANP', '07', SYSDATE, NULL, null, NULL );

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZPCANP', '08', SYSDATE, NULL, null, NULL );

INSERT INTO GJBPDFT( GJBPDFT_JOB, GJBPDFT_NUMBER, GJBPDFT_ACTIVITY_DATE, GJBPDFT_USER_ID, GJBPDFT_VALUE, GJBPDFT_JPRM_CODE )
VALUES ( 'SZPCANP', '09', SYSDATE, NULL, 'A', NULL );

REM ****************************************************************************
REM Guardando cambios.
REM ****************************************************************************
COMMIT;

REM ****************************************************************************
REM Fin.
REM ****************************************************************************
