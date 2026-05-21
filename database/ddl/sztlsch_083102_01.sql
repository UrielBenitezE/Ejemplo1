REM ************************************************************************************************
REM *                                                                                              *
REM * sztlsch_083102_01.sql                                                                        *
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
REM *  1. Creation of the SZTLSCH  Table.                                          MKU 27-ABR-2016 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.31.2 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade to Banner Student 8.31.2.                                        MHI 20-JAN-2025 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

REM *
REM * Fields Definition.
REM ************************************************************************************************

Create table SZTLSCH
(
   SZTLSCH_SCHM_SEQNO   NUMBER(9,0)    ,
   SZTLSCH_TERM_CODE   VARCHAR2(6 CHAR)   ,
   SZTLSCH_PTRM_CODE   VARCHAR2(3 CHAR)    ,
   SZTLSCH_SEQNO   NUMBER(3,0)    ,
   SZTLSCH_ACAT_NAME   VARCHAR2(10)   ,
   SZTLSCH_WEIGHT   NUMBER(5,2)    ,
   SZTLSCH_INCLUDE_IND   VARCHAR2(1)    ,
   SZTLSCH_DELIVER_IND   VARCHAR2(1)    ,
   SZTLSCH_START_DATE   DATE   ,
   SZTLSCH_DUE_DATE   DATE,
   SZTLSCH_RESTRICTED_IND   VARCHAR2(1),
   SZTLSCH_TYPE   VARCHAR2(1) NOT NULL,
   SZTLSCH_GSCH_NAME   VARCHAR2(10 CHAR),
   SZTLSCH_MIN_PASS_SCORE   NUMBER(5,2),
   SZTLSCH_USER_ID   VARCHAR2(30 CHAR) NOT NULL,
   SZTLSCH_ACTIVITY_DATE   DATE   NOT NULL ,
   SZTLSCH_STATUS   VARCHAR2(1) NOT NULL,
   SZTLSCH_ERROR    VARCHAR2(50),
   SZTLSCH_SESSION  VARCHAR2(30 CHAR) NOT NULL
   );


REM *
REM * End.
REM ************************************************************************************************