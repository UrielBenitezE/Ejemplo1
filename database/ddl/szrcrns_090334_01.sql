REM ************************************************************************************************
REM *                                                                                              *
REM * szrcrns_090334_01.sql                                                                        *
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
REM *  Description : Create SZRCRNS  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZRCRNS  Table.                                          MKU 26-0CT-2015 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 9.3.34 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade of the SZRCRNS table to Banner 9.                                MHI 16-0CT-2024 *
REM *                                                                                              *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

REM *
REM * Fields Definition.
REM ************************************************************************************************

Create table SZRCRNS
(
   SZRCRNS_TERM_CODE   VARCHAR2(6 CHAR)   NOT NULL ,
   SZRCRNS_PTRM_CODE   VARCHAR2(3 CHAR)   NOT NULL ,
   SZRCRNS_CRN   VARCHAR2(5 CHAR)   NOT NULL ,
   SZRCRNS_SCHM_SEQNO   NUMBER(9,0)   NOT NULL ,
   SZRCRNS_FGRDE_ENTRY   VARCHAR2(1)   NOT NULL ,
   SZRCRNS_FGRDE_ENTRY_EXPT   VARCHAR2(1)   NOT NULL ,
   SZRCRNS_CURRENT_IND   VARCHAR2(1)   NOT NULL ,
   SZRCRNS_USER_ID   VARCHAR2(30 CHAR)   NOT NULL ,
   SZRCRNS_ACTIVITY_DATE   DATE   NOT NULL ,
   SZRCRNS_DATA_ORIGIN   VARCHAR2(30 CHAR),
   SZRCRNS_SURROGATE_ID   NUMBER(19,0),
   SZRCRNS_VERSION   NUMBER(19,0),
   SZRCRNS_VPDI_CODE   VARCHAR2(6 CHAR));


ALTER TABLE SZRCRNS
   ADD CONSTRAINT PK_SZRCRNS PRIMARY KEY
   (
      SZRCRNS_TERM_CODE,
      SZRCRNS_PTRM_CODE,
      SZRCRNS_CRN,
      SZRCRNS_SCHM_SEQNO);

ALTER TABLE SZRCRNS ADD 
  CONSTRAINT FK1_SZRCRNS_INV_SSBSECT FOREIGN KEY 
   (SZRCRNS_TERM_CODE, SZRCRNS_CRN) 
  REFERENCES SSBSECT (SSBSECT_TERM_CODE,SSBSECT_CRN);

ALTER TABLE SZRCRNS ADD  
  CONSTRAINT FK1_SZRCRNS_INV_SZBSCHM_NUM FOREIGN KEY
   (SZRCRNS_SCHM_SEQNO, SZRCRNS_TERM_CODE, SZRCRNS_PTRM_CODE) 
  REFERENCES SZBSCHM (SZBSCHM_SEQNO,SZBSCHM_TERM_CODE,SZBSCHM_PTRM_CODE);



REM *
REM * End.
REM ************************************************************************************************