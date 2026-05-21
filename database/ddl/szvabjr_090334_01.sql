REM ************************************************************************************************
REM *                                                                                              *
REM * szvabjr_083100_01.sql                                                                        *
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
REM *  1. Creation of the SZVABJR  Table.                                          MKU 03-NOV-2015 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM * AUDIT TRAIL: 9.3.34   [MCLA:002.2.0]                                          INI    DATE   *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZVABJR  Table.                                          MHI  15/OCT/2024 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

REM *
REM * Fields Definition.
REM ************************************************************************************************

Create table SZVABJR
(
   SZVABJR_CODE   VARCHAR2(10)   NOT NULL ,
   SZVABJR_DESC   VARCHAR2(200)   NOT NULL ,
   SZVABJR_CODE_TYPE   VARCHAR2(1)   NOT NULL ,
   SZVABJR_USER_ID   VARCHAR2(30 CHAR)   NOT NULL ,
   SZVABJR_ACTIVITY_DATE   DATE   NOT NULL ,
   SZVABJR_DATA_ORIGIN   VARCHAR2(30 CHAR),
   SZVABJR_SURROGATE_ID   NUMBER(19,0),
   SZVABJR_VERSION   NUMBER(19,0),
   SZVABJR_VPDI_CODE   VARCHAR2(6 CHAR)
 );

ALTER TABLE SZVABJR
   ADD CONSTRAINT PK_SZVABJR PRIMARY KEY
   (
      SZVABJR_CODE);

REM *
REM * End.
REM ************************************************************************************************