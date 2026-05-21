REM ************************************************************************************
REM *                                                                          
REM * sztvsch_083102_00.sql Copyright 2016 Ellucian Company L.P. and its affiliates.
REM ************************************************************************************
REM                     CONFIDENTIAL BUSINESS INFORMATION
REM ************************************************************************************
REM THIS PROGRAM IS PROPRIETARY INFORMATION OF ELLUCIAN AND ITS AFFILIATES AND IS
REM NOT TO BE COPIED, REPRODUCED, LENT OR DISPOSED OF, NOR USED FOR ANY PURPOSE
REM OTHER THAN THAT FOR WHICH IT IS SPECIFICALLY PROVIDED WITHOUT THE WRITTEN
REM PERMISSION OF SAID COMPANY.
REM ****************************************************************************
REM *                                                                          *
REM *  Script Name : sztvsch_083102_00.sql                                     *
REM *                                                                          *
REM *      Project : UTM                                                       *
REM * Modification : 002 - Enhancement to attendance, grades and               *
REM *                      academic history.                                   *
REM *                      Massive assignment schemes to CRN.                  * 
REM *  Description : Create SZTVSCH Table.                                     *
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

CONNECT saturn/&&saturn_password;
SET ECHO OFF
SET SHOWMODE OFF

PROMPT
PROMPT ***   Creating SZTVSCH  Table
PROMPT

DROP TABLE SZTVSCH CASCADE CONSTRAINTS;

REM ***************************************************************************
REM Create table SZTVSCH
REM ***************************************************************************

START sztvsch_083102_01.sql
START sztvsch_083102_02.sql

REM *
REM * Grant BANINST1 ACCESS with GRANT OPTION.
REM ****************************************************************************
GRANT ALL ON SZTVSCH TO BANINST1 WITH GRANT OPTION;

CONNECT baninst1/&&baninst1_password
SET ECHO OFF
SET SHOWMODE OFF

DROP PUBLIC SYNONYM SZTVSCH;
CREATE PUBLIC SYNONYM SZTVSCH FOR SATURN.SZTVSCH;


REM ***************************************************************************
REM END.
REM ***************************************************************************
