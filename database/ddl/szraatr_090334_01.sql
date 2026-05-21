REM ************************************************************************************************
REM *                                                                                              *
REM * szraatr_090334_01.sql                                                                        *
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
REM *  Description : Create SZRAATR  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZRAATR  Table.                                          MKU 03-NOV-2015 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 9.3.34 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade of the SZRAATR table to Banner 9.                                MHI 16-OCT-2024 *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

REM *
REM * Fields Definition.
REM ************************************************************************************************

Create table SZRAATR
(
   SZRAATR_PIDM   NUMBER(8,0)   NOT NULL ,
   SZRAATR_TERM_CODE   VARCHAR2(6 CHAR)   NOT NULL ,
   SZRAATR_CRN   VARCHAR2(5 CHAR)   NOT NULL ,
   SZRAATR_BB_IND   VARCHAR2(1),
   SZRAATR_ABS_ACCUM   NUMBER(3,0),
   SZRAATR_ABS_JSTF   NUMBER(3,0),
   SZRAATR_ABS_EXT   NUMBER(3,0),
   SZRAATR_ABS_TRANS   NUMBER(3,0),
   SZRAATR_CRN_ABS_TRANS   VARCHAR2(5 CHAR),
   SZRAATR_EXT_ABS_IND VARCHAR2(1 CHAR),
   SZRAATR_ABJR_CODE VARCHAR2(10 CHAR),
   SZRAATR_USER_ID   VARCHAR2(30 CHAR)   NOT NULL ,
   SZRAATR_ACTIVITY_DATE   DATE   NOT NULL ,
   SZRAATR_DATA_ORIGIN   VARCHAR2(30 CHAR),
   SZRAATR_SURROGATE_ID   NUMBER(19,0),
   SZRAATR_VERSION   NUMBER(19,0),
   SZRAATR_VPDI_CODE   VARCHAR2(6 CHAR)
 );

 ALTER TABLE SZRAATR
   ADD CONSTRAINT PK_SZRAATR PRIMARY KEY
   (
      SZRAATR_PIDM,
      SZRAATR_TERM_CODE,
      SZRAATR_CRN);

ALTER TABLE SZRAATR
   ADD CONSTRAINT FK1_SZRAATR_INV_SSBSECT 
     FOREIGN KEY (SZRAATR_TERM_CODE, SZRAATR_CRN)
     REFERENCES SSBSECT (SSBSECT_TERM_CODE, SSBSECT_CRN);
  
 ALTER TABLE SZRAATR 
    ADD CONSTRAINT FK2_SZRAATR_INV_SSBSECT 
      FOREIGN KEY (SZRAATR_TERM_CODE, SZRAATR_CRN_ABS_TRANS)
      REFERENCES SSBSECT (SSBSECT_TERM_CODE, SSBSECT_CRN);

ALTER TABLE SZRAATR 
        ADD CONSTRAINT FK1_SZRAATR_INV_SZVABJR
        FOREIGN KEY (SZRAATR_ABJR_CODE)
        REFERENCES SZVABJR (SZVABJR_CODE);

REM *
REM * End.
REM ************************************************************************************************