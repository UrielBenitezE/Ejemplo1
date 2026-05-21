REM ************************************************************************************
REM *                                                                          
REM * sztvagr_083102_01.sql Copyright 2025 Ellucian Company L.P. and its affiliates.
REM ************************************************************************************
REM                     CONFIDENTIAL BUSINESS INFORMATION
REM ************************************************************************************
REM THIS PROGRAM IS PROPRIETARY INFORMATION OF ELLUCIAN AND ITS AFFILIATES AND IS
REM NOT TO BE COPIED, REPRODUCED, LENT OR DISPOSED OF, NOR USED FOR ANY PURPOSE
REM OTHER THAN THAT FOR WHICH IT IS SPECIFICALLY PROVIDED WITHOUT THE WRITTEN
REM PERMISSION OF SAID COMPANY.
REM ****************************************************************************
REM *                                                                          *
REM *  Script Name : sztvagr_083102_01.sql                                     *
REM *                                                                          *
REM *      Project : UTM                                                       *
REM * Modification : 002 -   Load massive  grades activities.                  *
REM *  Description : Create Columns Table.                                     *
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
REM Fields Definition.
REM ***************************************************************************
CREATE TABLE SZTVAGR
(
  SZTVAGR_TERM_CODE      VARCHAR2(6),
  SZTVAGR_PIDM           NUMBER(8),
  SZTVAGR_CRN            VARCHAR2(5),
  SZTVAGR_TYPE_COL       VARCHAR2(20),
  SZTVAGR_VALUE_GRADE    VARCHAR2(6),
  SZTVAGR_STATUS         VARCHAR2(1),
  SZTVAGR_ERROR          VARCHAR2(500),  
  SZTVAGR_SESSIONID      VARCHAR2(30)  NOT NULL
);

REM ***************************************************************************
REM END.
REM ***************************************************************************
