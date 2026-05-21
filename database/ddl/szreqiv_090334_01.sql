REM ************************************************************************************************
REM *                                                                                              *
REM * szreqiv_090334_01.sql                                                                        *
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
REM *  Description : Create SZREQIV  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZREQIV  Table.                                          MSO 19-JAN-2016 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 9.3.34 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade of the SZREQIV table to Banner 9.                                MHI 16-OCT-2024 *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

REM *
REM * Fields Definition.
REM ************************************************************************************************

Create table SZREQIV
(
   SZREQIV_ORIGINAL_TERM_CODE  VARCHAR2(6)   NOT NULL ,
   SZREQIV_ORIGINAL_SUBJ_CODE  VARCHAR2(4)   NOT NULL ,
   SZREQIV_ORIGINAL_CRSE_NUMB  VARCHAR2(5)   NOT NULL ,
   SZREQIV_EQIV_TERM_CODE      VARCHAR2(6)   NOT NULL ,
   SZREQIV_EQIV_SUBJ_CODE      VARCHAR2(4)   NOT NULL ,
   SZREQIV_EQIV_CRSE_NUMB      VARCHAR2(5)   NOT NULL ,
   SZREQIV_ACTIVE_IND          VARCHAR2(1)  ,
   SZREQIV_USER_ID             VARCHAR2(30)  NOT NULL ,
   SZREQIV_ACTIVITY_DATE       DATE          NOT NULL ,
   SZREQIV_DATA_ORIGIN         VARCHAR2(30) ,
   SZREQIV_SURROGATE_ID        NUMBER(19)   ,
   SZREQIV_VERSION             NUMBER(19)   ,
   SZREQIV_VPDI_CODE           VARCHAR2(6)
   );

ALTER TABLE SZREQIV
   ADD CONSTRAINT PK_SZREQIV PRIMARY KEY
   (
     SZREQIV_ORIGINAL_TERM_CODE,
     SZREQIV_ORIGINAL_SUBJ_CODE,
     SZREQIV_ORIGINAL_CRSE_NUMB,
     SZREQIV_EQIV_TERM_CODE,
     SZREQIV_EQIV_SUBJ_CODE,
     SZREQIV_EQIV_CRSE_NUMB
    );


REM *
REM * End.
REM ************************************************************************************************
