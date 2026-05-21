REM ************************************************************************************************
REM *                                                                                              *
REM * szvabjr_083100_00.sql                                                                        *
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
REM *  Description : Create SZVABJR  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZVABJR  table.                                          MKU 03-NOV-2015 *
REM *                                                                                              *
REM *                                                                                              *
REM * AUDIT TRAIL: 9.3.34   [MCLA:002.2.0]                                          INI    DATE   *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM * 1. Creacion del Codigo.                                                      MHI  15/OCT/2024*
REM *    --------------------                                                                      *
REM *    Creation of the SZVABJR  table                                                            *
REM *                                                                                              *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

SET DEFINE ON
SET SCAN ON
CONNECT saturn/&&saturn_password;
SET DEFINE OFF
SET SCAN OFF
SET SHOWMODE OFF
SET ECHO OFF
SET VERI OFF
SET HEAD OFF
SET TIME OFF
SET TRIMSPOOL ON

PROMPT
PROMPT ***   Creating SZVABJR  Table
PROMPT

DROP TABLE SZVABJR  CASCADE CONSTRAINTS;

REM *
REM * Create table SZVABJR .
REM ************************************************************************************************
START szvabjr_090334_01.sql
START szvabjr_090334_02.sql
START szvabjr_090334_03.sql


REM *
REM * Grant BANINST1 ACCESS with GRANT OPTION.
REM ************************************************************************************************
GRANT ALL ON SZVABJR  TO BANINST1 WITH GRANT OPTION;

SET DEFINE ON
SET SCAN ON
CONNECT baninst1/&&baninst1_password
SET ECHO OFF
SET SHOWMODE OFF
SET DEFINE OFF
SET SCAN OFF

WHENEVER SQLERROR CONTINUE;
DROP PUBLIC SYNONYM SZVABJR;

WHENEVER SQLERROR CONTINUE;
CREATE PUBLIC SYNONYM SZVABJR FOR SATURN.SZVABJR;

REM *
REM * End.
REM ************************************************************************************************
