REM ************************************************************************************
REM *                                                                          
REM * sztvagr_083102_00.sql Copyright 2025 Ellucian Company L.P. and its affiliates.
REM ************************************************************************************
REM                     CONFIDENTIAL BUSINESS INFORMATION
REM ************************************************************************************
REM THIS PROGRAM IS PROPRIETARY INFORMATION OF ELLUCIAN AND ITS AFFILIATES AND IS
REM NOT TO BE COPIED, REPRODUCED, LENT OR DISPOSED OF, NOR USED FOR ANY PURPOSE
REM OTHER THAN THAT FOR WHICH IT IS SPECIFICALLY PROVIDED WITHOUT THE WRITTEN
REM PERMISSION OF SAID COMPANY.
REM ****************************************************************************
REM *                                                                          *
REM *  Script Name : sztvagr_083102_00.sql                                     *
REM *                                                                          *
REM *      Project : UTM                                                       *
REM * Modification : 002 -   Load massive  grades activities.                  *
REM *  Description : Create SZTVAGR Table.                                     *
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

CONNECT saturn/&&saturn_password;
SET ECHO OFF
SET SHOWMODE OFF

PROMPT
PROMPT ***   Creating SZTVAGR  Table
PROMPT

DROP TABLE SZTVAGR CASCADE CONSTRAINTS;

REM ***************************************************************************
REM Create table SZTVAGR
REM ***************************************************************************

START sztvagr_083102_01.sql
START sztvagr_083102_02.sql


REM *
REM * Grant BANINST1 ACCESS with GRANT OPTION.
REM ****************************************************************************
GRANT ALL ON SZTVAGR TO BANINST1 WITH GRANT OPTION;

CONNECT baninst1/&&baninst1_password
SET ECHO OFF
SET SHOWMODE OFF

DROP PUBLIC SYNONYM SZTVAGR;
CREATE PUBLIC SYNONYM SZTVAGR FOR SATURN.SZTVAGR;


REM ***************************************************************************
REM END.
REM ***************************************************************************
