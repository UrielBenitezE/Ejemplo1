REM ************************************************************************************
REM *                                                                          
REM * sztvsch_083102_01.sql Copyright 2016 Ellucian Company L.P. and its affiliates.
REM ************************************************************************************
REM                     CONFIDENTIAL BUSINESS INFORMATION
REM ************************************************************************************
REM THIS PROGRAM IS PROPRIETARY INFORMATION OF ELLUCIAN AND ITS AFFILIATES AND IS
REM NOT TO BE COPIED, REPRODUCED, LENT OR DISPOSED OF, NOR USED FOR ANY PURPOSE
REM OTHER THAN THAT FOR WHICH IT IS SPECIFICALLY PROVIDED WITHOUT THE WRITTEN
REM PERMISSION OF SAID COMPANY.
REM ****************************************************************************
REM *                                                                          *
REM *  Script Name : sztvsch_083102_01.sql                                     *
REM *                                                                          *
REM *      Project : UTM                                                       *
REM * Modification : 002 - Enhancement to attendance, grades and               *
REM *                      academic history.                                   *
REM *  Description : Create Columns Table.                                     *
REM *                      Massive assignment schemes to CRN.                  * 
REM *                Local Development Installation Log Table.                 *
REM *                                                                          *
REM ****************************************************************************
REM *                                                                          *
REM *  AUDIT TRAIL: 8.7.0 [UTM:002.1.0]                        INI    DATE     *
REM *  ------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZTVSCH table.                       DLO 26-ENE-2016 *
REM *  ------------------------------------------------------- --- ----------- *
REM *                                                                          *
REM *  AUDIT TRAIL: 8.31.2 [MCLA:002.2.0]                      INI    DATE     *
REM *  ------------------------------------------------------- --- ----------- *
REM *  1. Upgrade to Banner Student 8.31.2.                    MHI 20-JAN-2025 *
REM *  ------------------------------------------------------- --- ----------- *
REM *  AUDIT TRAIL: END                                                        *
REM *                                                                          *
REM ****************************************************************************
REM Fields Definition.
REM ***************************************************************************
CREATE TABLE SZTVSCH
(
  SZTVSCH_TERM_CODE      VARCHAR2(6)   NOT NULL,
  SZTVSCH_PTRM_CODE      VARCHAR2(3)   NOT NULL,
  SZTVSCH_CRN            VARCHAR2(5)   NOT NULL,
  SZTVSCH_SUBJ_CODE      VARCHAR2(4)   NOT NULL,
  SZTVSCH_CRSE_NUMB      VARCHAR2(5)   NOT NULL,
  SZTVSCH_CAMP_CODE      VARCHAR2(3)   NOT NULL,
  SZTVSCH_SCHD_CODE      VARCHAR2(3)   NOT NULL,
  SZTVSCH_SCHEME_NUM     NUMBER(9)     NOT NULL,
  SZTVSCH_STATUS         VARCHAR2(1)   ,
  SZTVSCH_ERROR          VARCHAR2(500) ,    
  SZTVSCH_SESSIONID      VARCHAR2(30)  NOT NULL
);

REM ***************************************************************************
REM END.
REM ***************************************************************************
