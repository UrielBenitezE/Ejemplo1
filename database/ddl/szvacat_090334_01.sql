REM ************************************************************************************************
REM *                                                                                              *
REM * szvacat_090334_01.sql                                                                        *
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
REM *  Description : Create SZVACAT  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZVACAT  Table.                                          MKU 04-NOV-2015 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 9.3.34 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade of table SZVACAT for Banner 9                                    MHI 16-OCT-2024 *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

REM *
REM * Fields Definition.
REM ************************************************************************************************

Create table SZVACAT
(
   SZVACAT_NAME   VARCHAR2(10 CHAR)   NOT NULL ,
   SZVACAT_DESC   VARCHAR2(200 CHAR)   NOT NULL ,
   SZVACAT_FINAL_TEST   VARCHAR2(1),
   SZVACAT_FINAL_PROJ   VARCHAR2(1),
   SZVACAT_USER_ID   VARCHAR2(30 CHAR)   NOT NULL ,
   SZVACAT_ACTIVITY_DATE   DATE   NOT NULL ,
   SZVACAT_DATA_ORIGIN   VARCHAR2(30 CHAR),
   SZVACAT_SURROGATE_ID   NUMBER(19,0),
   SZVACAT_VERSION   NUMBER(19,0),
   SZVACAT_VPDI_CODE   VARCHAR2(6 CHAR)
   );

ALTER TABLE SZVACAT
   ADD CONSTRAINT PK_SZVACAT PRIMARY KEY
   (
      SZVACAT_NAME);


REM *
REM * End.
REM ************************************************************************************************