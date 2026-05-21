REM ************************************************************************************************
REM *                                                                                              *
REM * szrcrns_090334_exists.sql                                                                    *
REM *                                                                                              *
REM ************************************************************************************************
REM * Copyright 2024 Ellucian. All rights reserved.                                                *
REM * This copyrighted software contains confidential and proprietary information of Ellucian      *
REM * and its subsidiaries. Any use of this software is limited solely to Ellucian                 *
REM * licensees, and is further subject to the terms and conditions of one or                      *
REM * more written license agreements between Ellucian and the licensee in                         *
REM * question. Ellucian, Banner and Luminis are either registered trademarks or trademarks of     *
REM * Ellucian in the U.S.A. and/or other regions and/or countries.                                *
REM ************************************************************************************************
REM *                                                                                              *
REM *      Project : MODS Latin America                                                            *
REM *                                                                                              *
REM *  Description : Create SZRCRNS  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZRCRNS  table.                                          MKU 26-0CT-2015 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 9.3.34 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade of the SZRCRNS table to Banner 9.                                MHI 16-0CT-2024 *
REM *                                                                                              *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

CONNECT baninst1/&&baninst1_password

SET ECHO OFF
SET VERI OFF
SET HEAD OFF
SET TRIMSPOOL ON

VARIABLE script VARCHAR2(50)
COLUMN SCRIPT NEW_VAL SCRIPT_TO_RUN

REM *
REM * If SZRCRNS  table does not exist, create it.  Otherwise, do nothing.
REM ************************************************************************************************

DECLARE
  table_exist VARCHAR2(1) := 'N';

  CURSOR ChkTableC IS
    SELECT 'Y'
      FROM ALL_TABLES
     WHERE TABLE_NAME = 'SZRCRNS';
BEGIN
  OPEN ChkTableC;
  FETCH ChkTableC
   INTO table_exist;

  IF ChkTableC%NOTFOUND THEN
    :script := 'szrcrns_090334_00.sql';
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

REM *
REM * End.
REM ************************************************************************************************
