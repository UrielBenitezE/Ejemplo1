REM ************************************************************************************************
REM *                                                                                              *
REM * szrlfda_090334_00.sql                                                                        *
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
REM *  Description : Create szrlfda  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of the szrlfda  table.                                          MKU 26-0CT-2015 *
REM *                                                                                              *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 9.3.34 [MCLA:002.2.0]                                             INI    DATE  *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade of the szrlfda table to Banner 9                                MHI 16-0CT-2024  *
REM *                                                                                              *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

CONNECT saturn/&&saturn_password;
SET ECHO OFF
SET SHOWMODE OFF

PROMPT
PROMPT ***   Creating szrlfda  Table
PROMPT

DROP TABLE szrlfda  CASCADE CONSTRAINTS;

REM *
REM * Create table szrlfda .
REM ************************************************************************************************
START szrlfda_090334_01.sql
START szrlfda_090334_02.sql
START szrlfda_090334_03.sql


REM *
REM * Grant BANINST1 ACCESS with GRANT OPTION.
REM ************************************************************************************************
GRANT ALL ON SZRLFDA  TO BANINST1 WITH GRANT OPTION;

CONNECT baninst1/&&baninst1_password
SET ECHO OFF
SET SHOWMODE OFF

DROP PUBLIC SYNONYM SZRLFDA;

CREATE PUBLIC SYNONYM SZRLFDA  FOR SATURN.SZRLFDA ;

REM *
REM * End.
REM ************************************************************************************************
