REM ************************************************************************************************
REM *                                                                                              *
REM * szrstcr_083102_00.sql                                                                        *
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
REM *  Description : Create SZRSTCR  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZRSTCR  table.                                          MKU 25-NOV-2015 *
REM *                                                                                              *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 9.3.34 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade of the SZRSTCR table to Banner 9.                                MHI 16-OCT-2024 *
REM *                                                                                              *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

CONNECT saturn/&&saturn_password;
SET ECHO OFF
SET SHOWMODE OFF

PROMPT
PROMPT ***   Creating SZRSTCR  Table
PROMPT

DROP TABLE SZRSTCR  CASCADE CONSTRAINTS;

REM *
REM * Create table SZRSTCR .
REM ************************************************************************************************
START szrstcr_083102_01.sql
START szrstcr_083102_02.sql
START szrstcr_083102_03.sql


REM *
REM * Grant BANINST1 ACCESS with GRANT OPTION.
REM ************************************************************************************************
GRANT ALL ON SZRSTCR  TO BANINST1 WITH GRANT OPTION;

CONNECT baninst1/&&baninst1_password
SET ECHO OFF
SET SHOWMODE OFF

DROP PUBLIC SYNONYM SZRSTCR ;

CREATE PUBLIC SYNONYM SZRSTCR  FOR SATURN.SZRSTCR ;

REM *
REM * End.
REM ************************************************************************************************
