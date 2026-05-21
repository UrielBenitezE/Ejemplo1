REM ************************************************************************************************
REM *                                                                                              *
REM * szrstcr_083102_01.sql                                                                        *
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
REM *  Description : Create SZRSTCR  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZRSTCR  Table.                                          MKU 25-NOV-2015 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 9.3.34 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade of the SZRSTCR table to Banner 9.                                MHI 16-OCT-2024 *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

REM *
REM * Fields Definition.
REM ************************************************************************************************

Create table SZRSTCR
(
   SZRSTCR_TERM_CODE   VARCHAR2(6 CHAR)   NOT NULL ,
   SZRSTCR_CRN   VARCHAR2(5 CHAR)   NOT NULL ,
   SZRSTCR_PIDM   NUMBER(8,0)   NOT NULL ,
   SZRSTCR_SEQ   NUMBER(3,0)   NOT NULL ,
   SZRSTCR_GRDE_CODE   VARCHAR2(6 CHAR)   NOT NULL ,
   SZRSTCR_USER_ID   VARCHAR2(30 CHAR)   NOT NULL ,
   SZRSTCR_ACTIVITY_DATE   DATE   NOT NULL ,
   SZRSTCR_DATA_ORIGIN   VARCHAR2(30 CHAR),
   SZRSTCR_SURROGATE_ID   NUMBER(19,0),
   SZRSTCR_VERSION   NUMBER(19,0),
   SZRSTCR_VPDI_CODE   VARCHAR2(6 CHAR)
   );


ALTER TABLE SZRSTCR
   ADD CONSTRAINT PK_SZRSTCR PRIMARY KEY
   (
      SZRSTCR_TERM_CODE,
      SZRSTCR_CRN,
      SZRSTCR_PIDM,
      SZRSTCR_SEQ);

ALTER TABLE SZRSTCR
   ADD CONSTRAINT FK1_SZRSTCR_INV_SFRSTCR_KEY FOREIGN KEY 
           (SZRSTCR_TERM_CODE,
            SZRSTCR_PIDM, 
            SZRSTCR_CRN) 
        REFERENCES SFRSTCR
        (
            SFRSTCR_TERM_CODE, 
            SFRSTCR_PIDM, 
            SFRSTCR_CRN);

REM *
REM * End.
REM ************************************************************************************************