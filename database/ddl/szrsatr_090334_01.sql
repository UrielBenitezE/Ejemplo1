REM ************************************************************************************************
REM *                                                                                              *
REM * szrsatr_090334_01.sql                                                                        *
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
REM *  Description : Create SZRSATR  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZRSATR  Table.                                          MKU 16/NOV/2015 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 9.3.34 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade of the SZRSATR table to Banner 9.                                MHI 16/OCT/2024 *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

REM *
REM * Fields Definition.
REM ************************************************************************************************

Create table SZRSATR
(
   SZRSATR_PIDM   NUMBER(8,0)   NOT NULL ,
   SZRSATR_TERM_CODE   VARCHAR2(6 CHAR)   NOT NULL ,
   SZRSATR_CRN   VARCHAR2(5 CHAR)   NOT NULL ,
   SZRSATR_JUST_MEET_DATE   DATE   NOT NULL ,
   SZRSATR_ABJR_CODE   VARCHAR2(10),
   SZRSATR_SATR_SURR_ID_MEET NUMBER(19),
   SZRSATR_USER_ID   VARCHAR2(30 CHAR)   NOT NULL ,
   SZRSATR_ACTIVITY_DATE   DATE   NOT NULL ,
   SZRSATR_DATA_ORIGIN   VARCHAR2(30 CHAR),
   SZRSATR_SURROGATE_ID   NUMBER(19,0),
   SZRSATR_VERSION   NUMBER(19,0),
   SZRSATR_VPDI_CODE   VARCHAR2(6 CHAR));

ALTER TABLE SZRSATR
   ADD CONSTRAINT PK_SZRSATR PRIMARY KEY
   (
       SZRSATR_PIDM,
       SZRSATR_TERM_CODE,
       SZRSATR_CRN,
       SZRSATR_JUST_MEET_DATE);

ALTER TABLE SZRSATR
   ADD CONSTRAINT FK1_SZRSATR_INV_SFRSTCR 
     FOREIGN KEY (SZRSATR_TERM_CODE,
                  SZRSATR_PIDM, 
                  SZRSATR_CRN) 
     REFERENCES SFRSTCR (SFRSTCR_TERM_CODE, 
                         SFRSTCR_PIDM, 
                         SFRSTCR_CRN);
                         
ALTER TABLE SZRSATR
   ADD CONSTRAINT FK1_SZRSATR_INV_SZVABJR_CODE 
     FOREIGN KEY (SZRSATR_ABJR_CODE)
     REFERENCES SZVABJR (SZVABJR_CODE);

ALTER TABLE SZRSATR 
   ADD CONSTRAINT FK1_SZRSATR_INV_SORSATR_KEY
     FOREIGN KEY (SZRSATR_SATR_SURR_ID_MEET, SZRSATR_PIDM, SZRSATR_JUST_MEET_DATE)
     REFERENCES SORSATR (SORSATR_SURROGATE_ID_SSRMEET, SORSATR_PIDM, SORSATR_MEET_DATE);



REM *
REM * End.
REM ************************************************************************************************