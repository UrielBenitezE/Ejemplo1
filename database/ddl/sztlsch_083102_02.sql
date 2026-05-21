REM ************************************************************************************************
REM *                                                                                              *
REM * sztlsch_083102_02.sql                                                                        *
REM *                                                                                              *
REM ************************************************************************************************
REM * Copyright 2025 Ellucian. All rights reserved.                                                *
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
REM *  Description : Create SZTLSCH  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Add comments to table and columns.                                       MKU 27-ABR-2016 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.31.2 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade to Banner Student 8.31.2.                                        MHI 20-JAN-2025 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************


REM *
REM * Comments Definition.
REM ************************************************************************************************
COMMENT ON COLUMN SZTLSCH.SZTLSCH_SCHM_SEQNO    IS  'SZBSCHM sequence number';
COMMENT ON COLUMN SZTLSCH.SZTLSCH_TERM_CODE    IS  'This field identifies the term code referenced in the Catalog, Recruiting, Admissions, Gen. Student, Registration, Student Billing and Acad. Hist. Modules. Reqd. value: 999999 - End of Time.';
COMMENT ON COLUMN SZTLSCH.SZTLSCH_PTRM_CODE    IS  'This field identifies the part of term code referenced in the Class Schedule,   Registration and Acad. Hist. Modules.  Reqd. value:  1 - Full Term.';
COMMENT ON COLUMN SZTLSCH.SZTLSCH_SEQNO    IS  'Sequence number.';
COMMENT ON COLUMN SZTLSCH.SZTLSCH_ACAT_NAME    IS  'Activity catalog name.';
COMMENT ON COLUMN SZTLSCH.SZTLSCH_WEIGHT    IS  'Weighting factor';
COMMENT ON COLUMN SZTLSCH.SZTLSCH_INCLUDE_IND    IS  'It indicates if include Midterm or final. Default = F.';
COMMENT ON COLUMN SZTLSCH.SZTLSCH_DELIVER_IND    IS  'It indicates delivery activity. Default = Y';
COMMENT ON COLUMN SZTLSCH.SZTLSCH_START_DATE    IS  'Start date.';
COMMENT ON COLUMN SZTLSCH.SZTLSCH_DUE_DATE    IS  'Due date.';
COMMENT ON COLUMN SZTLSCH.SZTLSCH_RESTRICTED_IND    IS  'Default = N';
COMMENT ON COLUMN SZTLSCH.SZTLSCH_GSCH_NAME    IS  'Grade scale';
COMMENT ON COLUMN SZTLSCH.SZTLSCH_MIN_PASS_SCORE    IS  'Minimum score to pass.';
COMMENT ON COLUMN SZTLSCH.SZTLSCH_USER_ID    IS  'USER_ID: The ID of the user that most recently updated the record.';
COMMENT ON COLUMN SZTLSCH.SZTLSCH_ACTIVITY_DATE    IS  'ACTIVITY_DATE: Date on which the record was added or changed.';



REM *
REM * End.
REM ************************************************************************************************
