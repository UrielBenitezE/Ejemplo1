REM ************************************************************************************************
REM *                                                                                              *
REM * sztlsch_083102_00.sql                                                                        *
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
REM *  Description : Create SZTLSCH  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZTLSCH  table.                                          MKU 27-ABR-2016 *
REM *                                                                                              *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.31.2 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade to Banner Student 8.31.2.                                        MHI 20-JAN-2025 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

CONNECT saturn/&&saturn_password;
SET ECHO OFF
SET SHOWMODE OFF

PROMPT
PROMPT ***   Creating SZTLSCH  Table
PROMPT

DROP TABLE SZTLSCH  CASCADE CONSTRAINTS;

REM *
REM * Create table SZTLSCH .
REM ************************************************************************************************
START sztlsch_083102_01.sql
START sztlsch_083102_02.sql



REM *
REM * Grant BANINST1 ACCESS with GRANT OPTION.
REM ************************************************************************************************
GRANT ALL ON SZTLSCH  TO BANINST1 WITH GRANT OPTION;

CONNECT baninst1/&&baninst1_password
SET ECHO OFF
SET SHOWMODE OFF

DROP PUBLIC SYNONYM SZTLSCH ;

CREATE PUBLIC SYNONYM SZTLSCH  FOR SATURN.SZTLSCH ;

REM *
REM * End.
REM ************************************************************************************************
