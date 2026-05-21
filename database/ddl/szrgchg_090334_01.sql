REM ************************************************************************************************
REM *                                                                                              *
REM * szrgchg_900334_01.sql                                                                        *
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
REM *  Description : Create SZRGCHG  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZRGCHG  Table.                                          MSO 19-JAN-2016 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 9.3.34 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of the SZRGCHG  table.                                          MHI 16-OCT-2024 *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

REM *
REM * Fields Definition.
REM ************************************************************************************************

Create table SZRGCHG
(
   SZRGCHG_SEQNO               NUMBER(4) NOT NULL,
   SZRGCHG_TERM_CODE           VARCHAR2(6)   NOT NULL ,
   SZRGCHG_CRN                 VARCHAR2(5)   NOT NULL ,
   SZRGCHG_ID                  VARCHAR2(9)   NOT NULL ,
   SZRGCHG_GRDE_CODE_ORIGINAL  VARCHAR2(6)   NOT NULL ,
   SZRGCHG_GRDE_CODE_UPDATE    VARCHAR2(6)   NOT NULL ,
   SZRGCHG_LOAD_FILE_NAME      VARCHAR2(100) NOT NULL ,
   SZRGCHG_GCHG_CODE           VARCHAR2(2)   NOT NULL ,
   SZRGCHG_GCMT_CODE           VARCHAR2(7)   NOT NULL ,
   SZRGCHG_MESSAGE             VARCHAR2(100) NOT NULL ,
   SZRGCHG_USER_ID             VARCHAR2(30)  NOT NULL ,
   SZRGCHG_ACTIVITY_DATE       DATE          NOT NULL ,
   SZRGCHG_DATA_ORIGIN         VARCHAR2(30)  NOT NULL ,
   SZRGCHG_SURROGATE_ID        NUMBER(19)             ,
   SZRGCHG_VERSION             NUMBER(19)             ,
   SZRGCHG_VPDI_CODE           VARCHAR2(6)    
   );


ALTER TABLE SZRGCHG ADD 
CONSTRAINT PK_SZRGCHG
 PRIMARY KEY (SZRGCHG_TERM_CODE, 
              SZRGCHG_GRDE_CODE_ORIGINAL, 
              SZRGCHG_ID, 
              SZRGCHG_CRN, 
              SZRGCHG_SEQNO);

 

REM *
REM * End.
REM ************************************************************************************************