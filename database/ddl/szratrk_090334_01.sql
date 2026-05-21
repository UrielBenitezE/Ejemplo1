REM ************************************************************************************************
REM *                                                                                              *
REM * szratrk_090334_01.sql                                                                        *
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
REM *  Description : Create SZRATRK  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZRATRK  Table.                                          MKU 03-NOV-2015 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 9.3.34 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade of the SZRATRK table to Banner 9.                                MHI 16-OCT-2024 *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

REM *
REM * Fields Definition.
REM ************************************************************************************************

Create table SZRATRK
(
   SZRATRK_ATRK_SEQ_NO   NUMBER(19,0)   NOT NULL ,
   SZRATRK_ABS_LIMIT   NUMBER(4,0),
   SZRATRK_NE_LIMIT   NUMBER(4,0),
   SZRATRK_USER_ID   VARCHAR2(30 CHAR)   NOT NULL ,
   SZRATRK_ACTIVITY_DATE   DATE   NOT NULL ,
   SZRATRK_DATA_ORIGIN   VARCHAR2(30 CHAR),
   SZRATRK_SURROGATE_ID   NUMBER(19,0),
   SZRATRK_VERSION   NUMBER(19,0),
   SZRATRK_VPDI_CODE   VARCHAR2(6 CHAR)
 );

ALTER TABLE SZRATRK
   ADD CONSTRAINT PK_SZRATRK PRIMARY KEY
   (
      SZRATRK_ATRK_SEQ_NO);

ALTER TABLE SZRATRK
   ADD CONSTRAINT FK1_SZRATRK_INV_SORATRK_SEQNO 
     FOREIGN KEY (SZRATRK_ATRK_SEQ_NO)
     REFERENCES SORATRK (SORATRK_SEQ_NO);
REM *
REM * End.
REM ************************************************************************************************