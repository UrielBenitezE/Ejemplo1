REM ************************************************************************************************
REM *                                                                                              *
REM * szrmrks_090334_03.sql                                                                        *
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
REM *  1. Add primary keys constraint to table.                                    MKU 20-NOV-2015 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 9.3.34 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade of the SZRMRKS table to Banner 9.                                MHI 16-OCT-2024 *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

REM *
REM * Comments Definition.
REM ************************************************************************************************
COMMENT ON COLUMN SZRMRKS.SZRMRKS_TERM_CODE    IS  'Term Code associated with Marks Record';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_CRN    IS  'CRN associated with Marks Record';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_PIDM    IS  'PIDM of student';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_GCOM_ID    IS  'Gradable Component ID';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_SEQNO    IS  'SZRMRKS sequence number';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_ACTIVITY_DATE    IS  'ACTIVITY_DATE: Date on which the record was added or changed.';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_USER_ID    IS  'USER_ID: The ID of the user that most recently updated the record.';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_GCOM_DATE    IS  'Gradable Component Date';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_MARK_CALC_DATE    IS  'Date Mark was calculated';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_SCORE    IS  'Score of Gradable Component';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_PERCENTAGE    IS  'Calculated Percentage';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_GRDE_CODE    IS  'Grade Code Assigned';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_COMPLETED_DATE    IS  'Date received from student';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_RETURNED_DATE    IS  'Date returned to student';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_COMMENTS    IS  'General comments';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_GCHG_CODE    IS  'COMPONENT GRADE CHANGE CODE: This field indicates the value of the grade change code which indicates the reason for a grade change';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_EXTENSION_DATE    IS  'COMPONENT MARK EXTENSION DATE: This field indicates the date given to student for extension';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_ROLL_DATE    IS  'COMPONENT MARK ROLL DATE: This field indicates the date the marks were rolled to academic history';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_MARKER    IS  'COMPONENT MARKER: This field indicates the person responsible for marking the sub-component';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_DATA_ORIGIN    IS  'DATA_ORIGIN: Source system that created or updated the row.';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_SURROGATE_ID    IS  'SURROGATE_ID: Unique identifier for each row in the table.';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_VERSION    IS  'VERSION: Integer that is incremented every time a row is updated.';
COMMENT ON COLUMN SZRMRKS.SZRMRKS_VPDI_CODE    IS  'VPDI: Code of entity to which the data belongs.';



REM *
REM * End.
REM ************************************************************************************************
