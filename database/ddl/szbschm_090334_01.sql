REM ************************************************************************************************
REM *                                                                                              *
REM * szbschm_090334_01.sql                                                                        *
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
REM *  Description : Create SZBSCHM  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [TECMILE:002.1.0]                                             INI    DATE  *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZBSCHM  Table.                                          MKU 26-OCT-2015 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 9.3.34 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade of the SZBSCHM  table to Banner 9                                MHI 16-OCT-2024 *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

REM *
REM * Fields Definition.
REM ************************************************************************************************

Create table SZBSCHM
(
   SZBSCHM_SEQNO   NUMBER(9,0)   NOT NULL ,
   SZBSCHM_TERM_CODE   VARCHAR2(6 CHAR)   NOT NULL ,
   SZBSCHM_PTRM_CODE   VARCHAR2(3 CHAR)   NOT NULL ,
   SZBSCHM_GSCH_NAME   VARCHAR2(10 CHAR)   NOT NULL ,
   SZBSCHM_NE_PERCENTAGE   VARCHAR(3)   NOT NULL ,
   SZBSCHM_ASSIGNED_CRN   VARCHAR2(1),
   SZBSCHM_USER_ID   VARCHAR2(30 CHAR)   NOT NULL ,
   SZBSCHM_ACTIVITY_DATE   DATE   NOT NULL ,
   SZBSCHM_DATA_ORIGIN   VARCHAR2(30 CHAR),
   SZBSCHM_SURROGATE_ID   NUMBER(19,0),
   SZBSCHM_VERSION   NUMBER(19,0),
   SZBSCHM_VPDI_CODE   VARCHAR2(6 CHAR)
 );

 ALTER TABLE SZBSCHM
   ADD CONSTRAINT PK_SZBSCHM PRIMARY KEY
   (
      SZBSCHM_SEQNO,
      SZBSCHM_TERM_CODE,
      SZBSCHM_PTRM_CODE);

ALTER TABLE SZBSCHM ADD 
  CONSTRAINT FK1_SZBSCHM_INV_STVPTRM_CODE FOREIGN KEY
   (SZBSCHM_PTRM_CODE) 
  REFERENCES STVPTRM (STVPTRM_CODE);

ALTER TABLE SZBSCHM ADD   
  CONSTRAINT FK1_SZBSCHM_INV_STVTERM_CODE FOREIGN KEY
   (SZBSCHM_TERM_CODE) 
  REFERENCES STVTERM (STVTERM_CODE); 

ALTER TABLE SZBSCHM ADD
  CONSTRAINT FK1_SZBSCHM_INV_SHBGSCH_NAME FOREIGN KEY 
  (SZBSCHM_GSCH_NAME)
  REFERENCES SHBGSCH (SHBGSCH_NAME);


REM *
REM * End.
REM ************************************************************************************************