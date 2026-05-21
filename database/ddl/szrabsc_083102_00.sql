REM ************************************************************************************************
REM *                                                                                              *
REM * szrabsc_083102_00.sql                                                                        *
REM *                                                                                              *
REM ************************************************************************************************
REM * Copyright 2025 Ellucian. All rights reserved.                                                *
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
REM *  Description : Create SZRABSC  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZRABSC  table.                                          MSO 23-NOV-2015 *
REM *                                                                                              *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.31.2 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade to Banner 8.31.2                                                 MHI 20-JAN-2025 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

CONNECT saturn/&&saturn_password;
SET ECHO OFF
SET SHOWMODE OFF

PROMPT
PROMPT ***   Creating SZRABSC  Table
PROMPT

DROP TABLE SZRABSC  CASCADE CONSTRAINTS;

REM *
REM * Create table SZRABSC .
REM ************************************************************************************************
START szrabsc_083102_01.sql
START szrabsc_083102_02.sql


REM *
REM * Grant BANINST1 ACCESS with GRANT OPTION.
REM ************************************************************************************************
GRANT ALL ON SZRABSC  TO BANINST1 WITH GRANT OPTION;

CONNECT baninst1/&&baninst1_password
SET ECHO OFF
SET SHOWMODE OFF

DROP PUBLIC SYNONYM SZRABSC;

CREATE PUBLIC SYNONYM SZRABSC  FOR SATURN.SZRABSC;

REM *
REM * End.
REM ************************************************************************************************
