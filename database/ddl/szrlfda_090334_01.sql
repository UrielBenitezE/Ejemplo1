REM ************************************************************************************************
REM *                                                                                              *
REM * szrlfda_090334_01.sql                                                                        *
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
REM *  Description : Create szrlfda  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of the szrlfda  Table.                                          MKU 26-0CT-2015 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 9.3.34 [MCLA:002.2.0]                                             INI    DATE  *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade of the szrlfda table to Banner 9 .                              MHI 16-0CT-2024  *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

REM *
REM * Fields Definition.
REM ************************************************************************************************

Create table SZRLFDA
(
   SZRLFDA_SEQNO       NUMBER(9) NOT NULL,
   SZRLFDA_EFF_TERM_CODE   VARCHAR2(6 CHAR)   NOT NULL ,
   SZRLFDA_TRMT_CODE   VARCHAR2(1 CHAR)   NOT NULL ,
   SZRLFDA_PTRM_CODE   VARCHAR2(3 CHAR)   NOT NULL ,
   SZRLFDA_LEVL_CODE   VARCHAR2(2 CHAR)   NOT NULL ,
   SZRLFDA_SCHD_CODE   VARCHAR2(3 CHAR)   NOT NULL ,
   SZRLFDA_ABS_PERCENTAGE   NUMBER(5,2),
   SZRLFDA_ABS_LIMIT   NUMBER(3) ,
   SZRLFDA_ABS_EXT   NUMBER(5,2) NOT NULL,
   SZRLFDA_ACAD_DISHONESTY   NUMERIC(2) NOT NULL,
   SZRLFDA_ACTIVITY_DATE   DATE   NOT NULL ,
   SZRLFDA_USER_ID   VARCHAR2(30)   NOT NULL ,
   SZRLFDA_DATA_ORIGIN   VARCHAR2(30 CHAR)   NOT NULL ,
   SZRLFDA_SURROGATE_ID   NUMBER(19,0),
   SZRLFDA_VERSION   NUMBER(19,0),
   SZRLFDA_VPDI_CODE   VARCHAR2(6 CHAR)
 );

ALTER TABLE SZRLFDA
   ADD CONSTRAINT PK_SZRLFDA PRIMARY KEY
   (
      SZRLFDA_SEQNO,
      SZRLFDA_EFF_TERM_CODE,
      SZRLFDA_TRMT_CODE,
      SZRLFDA_PTRM_CODE,
      SZRLFDA_LEVL_CODE,
      SZRLFDA_SCHD_CODE
    );

ALTER TABLE SZRLFDA ADD 
  CONSTRAINT FK1_SZRLFDA_INV_STVTERM_CODE FOREIGN KEY 
   (SZRLFDA_EFF_TERM_CODE) 
  REFERENCES STVTERM (STVTERM_CODE);

ALTER TABLE SZRLFDA ADD  
  CONSTRAINT FK1_SZRLFDA_INV_STVPTRM_CODE FOREIGN KEY 
   (SZRLFDA_PTRM_CODE)
  REFERENCES STVPTRM (STVPTRM_CODE);
  
ALTER TABLE SZRLFDA ADD   
  CONSTRAINT FK1_SZRLFDA_INV_STVLEVL_CODE FOREIGN KEY
   (SZRLFDA_LEVL_CODE)
   REFERENCES STVLEVL (STVLEVL_CODE);
  
ALTER TABLE SZRLFDA ADD  
 CONSTRAINT FK1_SZRLFDA_INV_STVSCHD_CODE FOREIGN KEY 
   (SZRLFDA_SCHD_CODE)
   REFERENCES STVSCHD (STVSCHD_CODE);

ALTER TABLE SZRLFDA ADD   
  CONSTRAINT FK1_SZRLFDA_STVTRTM_CODE FOREIGN KEY 
   (SZRLFDA_TRMT_CODE)
   REFERENCES STVTRMT (STVTRMT_CODE);


REM *
REM * End.
REM ************************************************************************************************