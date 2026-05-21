REM ************************************************************************************
REM *                                                                          
REM * sztvagr_083102_exists.sql Copyright 2025 Ellucian Company L.P. and its affiliates.
REM ************************************************************************************
REM                     CONFIDENTIAL BUSINESS INFORMATION
REM ************************************************************************************
REM THIS PROGRAM IS PROPRIETARY INFORMATION OF ELLUCIAN AND ITS AFFILIATES AND IS
REM NOT TO BE COPIED, REPRODUCED, LENT OR DISPOSED OF, NOR USED FOR ANY PURPOSE
REM OTHER THAN THAT FOR WHICH IT IS SPECIFICALLY PROVIDED WITHOUT THE WRITTEN
REM PERMISSION OF SAID COMPANY.
REM ****************************************************************************
REM *                                                                          *
REM *  Script Name : sztvagr_083102_exists.sql                                 *
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

CONNECT baninst1/&&baninst1_password                    

SET ECHO OFF                                            
SET VERI OFF                                            
SET HEAD OFF                                            
SET TRIMSPOOL ON                                        

VARIABLE script VARCHAR2(50)
COLUMN SCRIPT NEW_VAL SCRIPT_TO_RUN

REM ***************************************************************************
REM Check if the SZTVAGR table exists...
REM ***************************************************************************
DECLARE
  table_exists VARCHAR2(1) := 'N';

  CURSOR ChkTableC IS
    SELECT 'Y'
      FROM ALL_TABLES
     WHERE TABLE_NAME = 'SZTVAGR';
BEGIN
  OPEN ChkTableC;
  FETCH ChkTableC
   INTO table_exists;

  IF ChkTableC%NOTFOUND THEN
    :script := 'sztvagr_083102_00.sql';
  ELSE
    :script := 'INVALID';
  END IF;

  CLOSE ChkTableC;
END;
/

SELECT DECODE( :SCRIPT,
               'INVALID', 'dummy.sql',
               :SCRIPT ) SCRIPT
  FROM DUAL;
@&SCRIPT_TO_RUN

REM ***************************************************************************
REM END.
REM ***************************************************************************
