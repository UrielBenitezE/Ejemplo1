REM ************************************************************************************************
REM *                                                                                              *
REM * szrmrks_090334_01.sql                                                                        *
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
REM *  Description : Create SZRMRKS  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZRMRKS  Table.                                          MKU 20-NOV-2015 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 9.3.34 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade of the SZRMRKS table to Banner 9.                                MHI 16-OCT-2024 *
REM *                                                                                              *s
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

REM *
REM * Fields Definition.
REM ************************************************************************************************

Create table SZRMRKS
(
   SZRMRKS_TERM_CODE   VARCHAR2(6 CHAR)   NOT NULL ,
   SZRMRKS_CRN   VARCHAR2(5 CHAR)   NOT NULL ,
   SZRMRKS_PIDM   NUMBER(8,0)   NOT NULL ,
   SZRMRKS_GCOM_ID   NUMBER(8,0)   NOT NULL ,
   SZRMRKS_SEQNO   NUMBER(3,0)   NOT NULL ,
   SZRMRKS_ACTIVITY_DATE   DATE   NOT NULL ,
   SZRMRKS_USER_ID   VARCHAR2(30 CHAR)   NOT NULL ,
   SZRMRKS_GCOM_DATE   DATE,
   SZRMRKS_MARK_CALC_DATE   DATE,
   SZRMRKS_SCORE   NUMBER(6,2),
   SZRMRKS_PERCENTAGE   NUMBER(5,2),
   SZRMRKS_GRDE_CODE   VARCHAR2(6 CHAR),
   SZRMRKS_COMPLETED_DATE   DATE,
   SZRMRKS_RETURNED_DATE   DATE,
   SZRMRKS_COMMENTS   VARCHAR2(2000 CHAR),
   SZRMRKS_GCHG_CODE   VARCHAR2(2 CHAR)   NOT NULL ,
   SZRMRKS_EXTENSION_DATE   DATE,
   SZRMRKS_ROLL_DATE   DATE,
   SZRMRKS_MARKER   NUMBER(8,0),
   SZRMRKS_DATA_ORIGIN   VARCHAR2(30 CHAR),
   SZRMRKS_SURROGATE_ID   NUMBER(19,0),
   SZRMRKS_VERSION   NUMBER(19,0),
   SZRMRKS_VPDI_CODE   VARCHAR2(6 CHAR)
 );

 ALTER TABLE SZRMRKS
   ADD CONSTRAINT PK_SZRMRKS PRIMARY KEY
   (
      SZRMRKS_TERM_CODE,
      SZRMRKS_CRN,
      SZRMRKS_PIDM,
      SZRMRKS_GCOM_ID,
      SZRMRKS_SEQNO
    );

ALTER TABLE SZRMRKS 
  ADD CONSTRAINT FK1_SZRMRKS_INV_STVGCHG_CODE
 FOREIGN KEY (SZRMRKS_GCHG_CODE)
 REFERENCES STVGCHG (STVGCHG_CODE);

REM *
REM * End.
REM ************************************************************************************************