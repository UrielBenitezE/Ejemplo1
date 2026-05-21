REM ************************************************************************************
REM *                                                                          
REM * sztveeq_083102_02.sql Copyright 2025 Ellucian Company L.P. and its affiliates.
REM ************************************************************************************
REM                     CONFIDENTIAL BUSINESS INFORMATION
REM ************************************************************************************
REM THIS PROGRAM IS PROPRIETARY INFORMATION OF ELLUCIAN AND ITS AFFILIATES AND IS
REM NOT TO BE COPIED, REPRODUCED, LENT OR DISPOSED OF, NOR USED FOR ANY PURPOSE
REM OTHER THAN THAT FOR WHICH IT IS SPECIFICALLY PROVIDED WITHOUT THE WRITTEN
REM PERMISSION OF SAID COMPANY.
REM ****************************************************************************
REM *                                                                          *
REM *  Script Name : sztveeq_083102_02.sql                                     *
REM *                                                                          *
REM *      Project : UTM                                                       *
REM * Modification : 002 - Enhancement to attendance, grades and               *
REM *                      academic history.                                   *
REM *                      Massive load of external equivalences for students. * 
REM *  Description : Create Comments Table.                                    *
REM *                Local Development Installation Log Table.                 *
REM *                                                                          *
REM ****************************************************************************
REM *                                                                          *
REM *  AUDIT TRAIL: 8.7.0 [UTM:002.1.0]                        INI    DATE     *
REM *  ------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZTVEEQ table.                       DLO 12-FEB-2016 *
REM *  ------------------------------------------------------- --- ----------- *
REM *                                                                          *
REM *  AUDIT TRAIL: 8.31.2 [MCLA:002.2.0]                      INI    DATE     *
REM *  ------------------------------------------------------------------------*
REM *  1. Upgrade to Banner Student 8.31.2.                    MHI 20-JAN-2025 *
REM *  AUDIT TRAIL: END                                                        *
REM *                                                                          *
REM ****************************************************************************



REM *
REM * Primary Key Definition.
REM ************************************************************************************************

COMMENT ON TABLE  SZTVEEQ IS
'Temporary Value External Equivalences Table.';
COMMENT ON COLUMN SZTVEEQ.SZTVEEQ_PIDM IS
'Internal Identification Number of student.';
COMMENT ON COLUMN SZTVEEQ.SZTVEEQ_ID IS
'This field defines the identification number used to access person on-line.';
COMMENT ON COLUMN SZTVEEQ.SZTVEEQ_SBGI_CODE IS
'Transfer Institution Code.';
COMMENT ON COLUMN SZTVEEQ.SZTVEEQ_TERM_CODE IS
'Term Code.';
COMMENT ON COLUMN SZTVEEQ.SZTVEEQ_FOLIO IS
'Transfer Course Name.';
COMMENT ON COLUMN SZTVEEQ.SZTVEEQ_LEVEL_CODE IS
'Level associated with the transfer course.';
COMMENT ON COLUMN SZTVEEQ.SZTVEEQ_SUBJ_CODE IS
'Subject Code.';
COMMENT ON COLUMN SZTVEEQ.SZTVEEQ_CRSE_NUMB IS
'The Course Number.';
COMMENT ON COLUMN SZTVEEQ.SZTVEEQ_GMOD_CODE IS
'Grading Mode Code.';
COMMENT ON COLUMN SZTVEEQ.SZTVEEQ_GRDE_CODE IS
'Grade Code.';
COMMENT ON COLUMN SZTVEEQ.SZTVEEQ_STATUS IS
'Data status  (S) Success or (E) Error.';
COMMENT ON COLUMN SZTVEEQ.SZTVEEQ_ERROR IS
'Indicate the description of the error.';
COMMENT ON COLUMN SZTVEEQ.SZTVEEQ_SESSIONID IS
'Session ID.';

REM *
REM * End.
REM ************************************************************************************************
