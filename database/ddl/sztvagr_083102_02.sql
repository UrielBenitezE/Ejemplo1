REM ************************************************************************************
REM *                                                                          
REM * sztvagr_083102_02.sql Copyright 2025 Ellucian Company L.P. and its affiliates.
REM ************************************************************************************
REM                     CONFIDENTIAL BUSINESS INFORMATION
REM ************************************************************************************
REM THIS PROGRAM IS PROPRIETARY INFORMATION OF ELLUCIAN AND ITS AFFILIATES AND IS
REM NOT TO BE COPIED, REPRODUCED, LENT OR DISPOSED OF, NOR USED FOR ANY PURPOSE
REM OTHER THAN THAT FOR WHICH IT IS SPECIFICALLY PROVIDED WITHOUT THE WRITTEN
REM PERMISSION OF SAID COMPANY.
REM ****************************************************************************
REM *                                                                          *
REM *  Script Name : sztvagr_083102_02.sql                                     *
REM *                                                                          *
REM *      Project : UTM                                                       *
REM * Modification : 002 -   Load massive  grades activities.                  *
REM *  Description : Create Comments Table.                                    *
REM *                Local Development Installation Log Table.                 *
REM *                                                                          *
REM ****************************************************************************
REM *                                                                          *
REM *  AUDIT TRAIL: 8.7.0 [UTM:002.1.0]                        INI    DATE     *
REM *  ------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZTVAGR table.                       DLO 11-ENE-2016 *
REM *  ------------------------------------------------------- --- ----------- *
REM *                                                                          *
REM *  AUDIT TRAIL: 8.31.2 [MCLA:002.2.0]                      INI    DATE     *
REM *  ------------------------------------------------------------------------*
REM *  1. Upgrade to Banner Student 8.31.2.                    MHI 20-JAN-2025 *
REM *  AUDIT TRAIL: END                                                        *
REM *                                                                          *
REM ****************************************************************************


REM ***************************************************************************
REM Comments Definition.
REM ***************************************************************************

COMMENT ON TABLE  SZTVAGR IS
'Temporary Value Grade Table.';

COMMENT ON COLUMN SZTVAGR.SZTVAGR_TERM_CODE IS
'Term Code.';
COMMENT ON COLUMN SZTVAGR.SZTVAGR_PIDM IS
'Internal Identification Number of the person.';
COMMENT ON COLUMN SZTVAGR.SZTVAGR_CRN IS
'This field identifies the course reference number associated with the class section.';
COMMENT ON COLUMN SZTVAGR.SZTVAGR_TYPE_COL IS
'Type of column.';
COMMENT ON COLUMN SZTVAGR.SZTVAGR_VALUE_GRADE IS
'Value grade.';
COMMENT ON COLUMN SZTVAGR.SZTVAGR_STATUS IS
'(S) Success or (E) Error.';
COMMENT ON COLUMN SZTVAGR.SZTVAGR_ERROR IS
'Indicate the description of the error.';
COMMENT ON COLUMN SZTVAGR.SZTVAGR_SESSIONID IS
'Session ID.';

REM ***************************************************************************
REM END.
REM ***************************************************************************

