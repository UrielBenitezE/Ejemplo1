REM ************************************************************************************
REM *                                                                          
REM * sztvsch_083102_02.sql Copyright 2016 Ellucian Company L.P. and its affiliates.
REM ************************************************************************************
REM                     CONFIDENTIAL BUSINESS INFORMATION
REM ************************************************************************************
REM THIS PROGRAM IS PROPRIETARY INFORMATION OF ELLUCIAN AND ITS AFFILIATES AND IS
REM NOT TO BE COPIED, REPRODUCED, LENT OR DISPOSED OF, NOR USED FOR ANY PURPOSE
REM OTHER THAN THAT FOR WHICH IT IS SPECIFICALLY PROVIDED WITHOUT THE WRITTEN
REM PERMISSION OF SAID COMPANY.
REM ****************************************************************************
REM *                                                                          *
REM *  Script Name : sztvsch_083102_02.sql                                     *
REM *                                                                          *
REM *      Project : UTM                                                       *
REM * Modification : 002 - Enhancement to attendance, grades and               *
REM *                      academic history.                                   *
REM *                      Massive assignment schemes to CRN.                  * 
REM *  Description : Create Comments Table.                                    *
REM *                Local Development Installation Log Table.                 *
REM *                                                                          *
REM ****************************************************************************
REM *                                                                          *
REM *  AUDIT TRAIL: 8.7.0 [UTM:002.1.0]                        INI    DATE     *
REM *  ------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZTVSCH table.                       DLO 11-ENE-2016 *
REM *  ------------------------------------------------------- --- ----------- *
REM *                                                                          *
REM *  AUDIT TRAIL: 8.31.2 [MCLA:002.2.0]                      INI    DATE     *
REM *  ------------------------------------------------------- --- ----------- *
REM *  1. Upgrade to Banner Student 8.31.2.                    MHI 20-JAN-2025 *
REM *  ------------------------------------------------------- --- ----------- *
REM *  AUDIT TRAIL: END                                                        *
REM *                                                                          *
REM ****************************************************************************

REM ***************************************************************************
REM Comments Definition.
REM ***************************************************************************

COMMENT ON TABLE  SZTVSCH IS
'Temporary Value Scheme Table.';
COMMENT ON COLUMN SZTVSCH.SZTVSCH_TERM_CODE IS
'Term Code.';
COMMENT ON COLUMN SZTVSCH.SZTVSCH_PTRM_CODE IS
'The Part of Term Code.';
COMMENT ON COLUMN SZTVSCH.SZTVSCH_CRN IS
'This field identifies the course reference number associated with the class section.';
COMMENT ON COLUMN SZTVSCH.SZTVSCH_SUBJ_CODE IS
'Subject Code.';
COMMENT ON COLUMN SZTVSCH.SZTVSCH_CRSE_NUMB IS
'The Course Number.';
COMMENT ON COLUMN SZTVSCH.SZTVSCH_CAMP_CODE IS
'The Campus Code.';
COMMENT ON COLUMN SZTVSCH.SZTVSCH_SCHD_CODE IS
'The Scheduled Code.';
COMMENT ON COLUMN SZTVSCH.SZTVSCH_SCHEME_NUM IS
'Scheme Number.';
COMMENT ON COLUMN SZTVSCH.SZTVSCH_STATUS IS
'Data status  (S) Success or (E) Error.';
COMMENT ON COLUMN SZTVSCH.SZTVSCH_ERROR IS
'Indicate the description of the error.';
COMMENT ON COLUMN SZTVSCH.SZTVSCH_SESSIONID IS
'Session ID.';

REM ***************************************************************************
REM END.
REM ***************************************************************************
