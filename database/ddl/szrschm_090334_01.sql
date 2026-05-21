REM ************************************************************************************************
REM *                                                                                              *
REM * szrschm_090334_01.sql                                                                        *
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
REM *  Description : Create SZRSCHM  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZRSCHM  Table.                                          MKU 04-NOV-2015 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 9.3.34 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade of the SZRSCHM  table to Banner 9                                MHI 16-OCT-2024 *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

REM *
REM * Fields Definition.
REM ************************************************************************************************

Create table SZRSCHM
(
   SZRSCHM_SCHM_SEQNO   NUMBER(9,0)   NOT NULL ,
   SZRSCHM_TERM_CODE   VARCHAR2(6 CHAR)   NOT NULL ,
   SZRSCHM_PTRM_CODE   VARCHAR2(3 CHAR)   NOT NULL ,
   SZRSCHM_SEQNO   NUMBER(3,0)   NOT NULL ,
   SZRSCHM_ACAT_NAME   VARCHAR2(10)   NOT NULL ,
   SZRSCHM_WEIGHT   NUMBER(5,2)   NOT NULL ,
   SZRSCHM_INCLUDE_IND   VARCHAR2(1)   NOT NULL ,
   SZRSCHM_DELIVER_IND   VARCHAR2(1)   NOT NULL ,
   SZRSCHM_START_DATE   DATE   NOT NULL ,
   SZRSCHM_DUE_DATE   DATE   NOT NULL ,
   SZRSCHM_RESTRICTED_IND   VARCHAR2(1),
   SZRSCHM_GSCH_NAME   VARCHAR2(10 CHAR)   NOT NULL ,
   SZRSCHM_MIN_PASS_SCORE   NUMBER(5,2)   NOT NULL ,
   SZRSCHM_USER_ID   VARCHAR2(30 CHAR)   NOT NULL ,
   SZRSCHM_ACTIVITY_DATE   DATE   NOT NULL ,
   SZRSCHM_DATA_ORIGIN   VARCHAR2(30 CHAR),
   SZRSCHM_SURROGATE_ID   NUMBER(19,0),
   SZRSCHM_VERSION   NUMBER(19,0),
   SZRSCHM_VPDI_CODE   VARCHAR2(6 CHAR)
   );

   ALTER TABLE SZRSCHM
   ADD CONSTRAINT PK_SZRSCHM PRIMARY KEY
   (
      SZRSCHM_SCHM_SEQNO,
      SZRSCHM_TERM_CODE,
      SZRSCHM_PTRM_CODE,
      SZRSCHM_SEQNO);

ALTER TABLE SZRSCHM 
  ADD CONSTRAINT FK1_SZRSCHM_INV_SZVACAT_NAME FOREIGN KEY (SZRSCHM_ACAT_NAME)
  REFERENCES SZVACAT (SZVACAT_NAME);

ALTER TABLE SZRSCHM 
  ADD CONSTRAINT FK1_SZRSCHM_INV_SZBSCHM FOREIGN KEY (SZRSCHM_SCHM_SEQNO, SZRSCHM_TERM_CODE, SZRSCHM_PTRM_CODE) 
  REFERENCES SZBSCHM (SZBSCHM_SEQNO, SZBSCHM_TERM_CODE, SZBSCHM_PTRM_CODE);
 
ALTER TABLE SZRSCHM 
  ADD CONSTRAINT FK1_SZRSCHM_INV_SHBGSCH_NAME FOREIGN KEY (SZRSCHM_GSCH_NAME)
  REFERENCES SHBGSCH (SHBGSCH_NAME);


REM *
REM * End.
REM ************************************************************************************************