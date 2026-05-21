REM ************************************************************************************************
REM *                                                                                              *
REM * szrschm_090334_03.sql                                                                        *
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
REM *  1. Add primary keys constraint to table.                                    MKU 04-NOV-2015 *
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
REM * Primary Key Definition.
REM ************************************************************************************************

COMMENT ON COLUMN SZRSCHM.SZRSCHM_SCHM_SEQNO    IS  'SZBSCHM sequence number';
COMMENT ON COLUMN SZRSCHM.SZRSCHM_TERM_CODE    IS  'This field identifies the term code referenced in the Catalog, Recruiting, Admissions, Gen. Student, Registration, Student Billing and Acad. Hist. Modules. Reqd. value: 999999 - End of Time.';
COMMENT ON COLUMN SZRSCHM.SZRSCHM_PTRM_CODE    IS  'This field identifies the part of term code referenced in the Class Schedule,   Registration and Acad. Hist. Modules.  Reqd. value:  1 - Full Term.';
COMMENT ON COLUMN SZRSCHM.SZRSCHM_SEQNO    IS  'Sequence number.';
COMMENT ON COLUMN SZRSCHM.SZRSCHM_ACAT_NAME    IS  'Activity catalog name.';
COMMENT ON COLUMN SZRSCHM.SZRSCHM_WEIGHT    IS  'Weighting factor';
COMMENT ON COLUMN SZRSCHM.SZRSCHM_INCLUDE_IND    IS  'It indicates if include Midterm or final. Default = F.';
COMMENT ON COLUMN SZRSCHM.SZRSCHM_DELIVER_IND    IS  'It indicates delivery activity. Default = Y';
COMMENT ON COLUMN SZRSCHM.SZRSCHM_START_DATE    IS  'Start date.';
COMMENT ON COLUMN SZRSCHM.SZRSCHM_DUE_DATE    IS  'Due date.';
COMMENT ON COLUMN SZRSCHM.SZRSCHM_RESTRICTED_IND    IS  'Default = N';
COMMENT ON COLUMN SZRSCHM.SZRSCHM_GSCH_NAME    IS  'Grade scale';
COMMENT ON COLUMN SZRSCHM.SZRSCHM_MIN_PASS_SCORE    IS  'Minimum score to pass.';
COMMENT ON COLUMN SZRSCHM.SZRSCHM_USER_ID    IS  'USER_ID: The ID of the user that most recently updated the record.';
COMMENT ON COLUMN SZRSCHM.SZRSCHM_ACTIVITY_DATE    IS  'ACTIVITY_DATE: Date on which the record was added or changed.';
COMMENT ON COLUMN SZRSCHM.SZRSCHM_DATA_ORIGIN    IS  'DATA_ORIGIN: Source system that created or updated the row.';
COMMENT ON COLUMN SZRSCHM.SZRSCHM_SURROGATE_ID    IS  'SURROGATE_ID: Unique identifier for each row in the table.';
COMMENT ON COLUMN SZRSCHM.SZRSCHM_VERSION    IS  'VERSION: Integer that is incremented every time a row is updated.';
COMMENT ON COLUMN SZRSCHM.SZRSCHM_VPDI_CODE    IS  'VPDI: Code of entity to which the data belongs.';

REM *
REM * End.
REM ************************************************************************************************
