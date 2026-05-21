REM ************************************************************************************
REM *                                                                          
REM * sztveeq_083102_exists.sql Copyright 2025 Ellucian Company L.P. and its affiliates.
REM ************************************************************************************
REM                     CONFIDENTIAL BUSINESS INFORMATION
REM ************************************************************************************
REM THIS PROGRAM IS PROPRIETARY INFORMATION OF ELLUCIAN AND ITS AFFILIATES AND IS
REM NOT TO BE COPIED, REPRODUCED, LENT OR DISPOSED OF, NOR USED FOR ANY PURPOSE
REM OTHER THAN THAT FOR WHICH IT IS SPECIFICALLY PROVIDED WITHOUT THE WRITTEN
REM PERMISSION OF SAID COMPANY.
REM ****************************************************************************
REM *                                                                          *
REM *  Script Name : sztveeq_083102_00.sql                                     *
REM *                                                                          *
REM *      Project : UTM                                                       *
REM * Modification : 002 - Enhancement to attendance, grades and               *
REM *                      academic history.                                   *
REM *                      Massive load of external equivalences for students. *  
REM *  Description : Create SZTVEEQ Table.                                     *
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

CONNECT saturn/&&saturn_password;
SET ECHO OFF
SET SHOWMODE OFF

PROMPT
PROMPT ***   Creating SZTVEEQ  Table
PROMPT

DROP TABLE SZTVEEQ CASCADE CONSTRAINTS;

REM ***************************************************************************
REM Create table SZTVEEQ
REM ***************************************************************************

START sztveeq_083102_01.sql
START sztveeq_083102_02.sql

REM *
REM * Grant BANINST1 ACCESS with GRANT OPTION.
REM ****************************************************************************
GRANT ALL ON SZTVEEQ TO BANINST1 WITH GRANT OPTION;

CONNECT baninst1/&&baninst1_password
SET ECHO OFF
SET SHOWMODE OFF

DROP PUBLIC SYNONYM SZTVEEQ;
CREATE PUBLIC SYNONYM SZTVEEQ FOR SATURN.SZTVEEQ;


REM ***************************************************************************
REM END.
REM ***************************************************************************
