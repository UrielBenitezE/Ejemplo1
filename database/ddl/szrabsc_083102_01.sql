REM ************************************************************************************************
REM *                                                                                              *
REM * szrabsc_083102_01.sql                                                                        *
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
REM *  1. Creation of the SZRABSC  Table.                                          MSO 23-NOV-2015 *
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

REM *
REM * Fields Definition.
REM ************************************************************************************************

CREATE TABLE SZRABSC 
(
  SZRABSC_PIDM              NUMBER(8)    NOT NULL, 
  SZRABSC_TERM              VARCHAR2(6)  NOT NULL,
  SZRABSC_CRN               VARCHAR2(5)  NOT NULL,
  SZRABSC_DATE              DATE         NOT NULL,
  SZRABSC_DAY               VARCHAR2(10) 
  );

REM *
REM * End.
REM ************************************************************************************************