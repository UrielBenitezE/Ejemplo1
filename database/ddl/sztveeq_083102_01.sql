REM ************************************************************************************
REM *                                                                          
REM * sztveeq_083102_01.sql Copyright 2025 Ellucian Company L.P. and its affiliates.
REM ************************************************************************************
REM                     CONFIDENTIAL BUSINESS INFORMATION
REM ************************************************************************************
REM THIS PROGRAM IS PROPRIETARY INFORMATION OF ELLUCIAN AND ITS AFFILIATES AND IS
REM NOT TO BE COPIED, REPRODUCED, LENT OR DISPOSED OF, NOR USED FOR ANY PURPOSE
REM OTHER THAN THAT FOR WHICH IT IS SPECIFICALLY PROVIDED WITHOUT THE WRITTEN
REM PERMISSION OF SAID COMPANY.
REM ****************************************************************************
REM *                                                                          *
REM *  Script Name : sztveeq_083102_01.sql                                     *
REM *                                                                          *
REM *      Project : UTM                                                       *
REM * Modification : 002 - Enhancement to attendance, grades and               *
REM *                      academic history.                                   *
REM *  Description : Create Columns Table.                                     *
REM *                      Massive load of external equivalences for students. *  
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
REM *                                                                          *
REM *  AUDIT TRAIL: END                                                        *
REM *                                                                          *
REM ****************************************************************************
REM Fields Definition.
REM ***************************************************************************
CREATE TABLE SZTVEEQ
(
  SZTVEEQ_PIDM               NUMBER(8)     NOT NULL,
  SZTVEEQ_ID                 VARCHAR2(9)   NOT NULL,
  SZTVEEQ_SBGI_CODE          VARCHAR2(6)   NOT NULL,
  SZTVEEQ_TERM_CODE          VARCHAR2(6)   NOT NULL,
  SZTVEEQ_FOLIO              VARCHAR2(60)  NOT NULL,
  SZTVEEQ_LEVEL_CODE         VARCHAR2(2)   NOT NULL,
  SZTVEEQ_SUBJ_CODE          VARCHAR2(4)   NOT NULL,
  SZTVEEQ_CRSE_NUMB          VARCHAR2(5)   NOT NULL,  
  SZTVEEQ_GMOD_CODE          VARCHAR2(1)   NOT NULL,
  SZTVEEQ_GRDE_CODE          VARCHAR2(6)   NOT NULL,
  SZTVEEQ_STATUS             VARCHAR2(1)   ,
  SZTVEEQ_ERROR              VARCHAR2(500) ,    
  SZTVEEQ_SESSIONID          VARCHAR2(30)  NOT NULL
);

REM ***************************************************************************
REM END.
REM ***************************************************************************
