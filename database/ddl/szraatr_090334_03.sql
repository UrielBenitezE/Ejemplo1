REM ************************************************************************************************
REM *                                                                                              *
REM * szraatr_090334_03.sql                                                                        *
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
REM *  Description : Create SZRAATR  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Add primary keys constraint to table.                                    MKU 03-NOV-2015 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 9.3.34 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade of the SZRAATR table to Banner 9.                                MHI 16-OCT-2024 *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

REM *
REM * Comments Definition.
REM ************************************************************************************************
COMMENT ON COLUMN SZRAATR.SZRAATR_PIDM    IS  'Internal identification number of the person.';
COMMENT ON COLUMN SZRAATR.SZRAATR_TERM_CODE    IS  'It defines the Term code for the course section information. ';
COMMENT ON COLUMN SZRAATR.SZRAATR_CRN    IS  'It will display the Course Reference Number (CRN) assigned to this course section when it was initially added.';
COMMENT ON COLUMN SZRAATR.SZRAATR_BB_IND    IS  'Blackboard indicator.';
COMMENT ON COLUMN SZRAATR.SZRAATR_ABS_ACCUM    IS  'Accumulate absences.';
COMMENT ON COLUMN SZRAATR.SZRAATR_ABS_JSTF    IS  'Amount of justified absences.';
COMMENT ON COLUMN SZRAATR.SZRAATR_ABS_EXT    IS  'Amount of absences extention.';
COMMENT ON COLUMN SZRAATR.SZRAATR_ABS_TRANS    IS  'Amount of absences transfered.';
COMMENT ON COLUMN SZRAATR.SZRAATR_CRN_ABS_TRANS    IS  'Course Reference Number (CRN) related to absences transfered.';
COMMENT ON COLUMN SZRAATR.SZRAATR_EXT_ABS_IND    IS  'Extension Absence indicator.';
COMMENT ON COLUMN SZRAATR.SZRAATR_ABJR_CODE    IS  'Absence code to indicate extension absence reason.';
COMMENT ON COLUMN SZRAATR.SZRAATR_USER_ID    IS  'USER_ID: The ID of the user that most recently updated the record.';
COMMENT ON COLUMN SZRAATR.SZRAATR_ACTIVITY_DATE    IS  'ACTIVITY_DATE: Date on which the record was added or changed.';
COMMENT ON COLUMN SZRAATR.SZRAATR_DATA_ORIGIN    IS  'DATA_ORIGIN: Source system that created or updated the row.';
COMMENT ON COLUMN SZRAATR.SZRAATR_SURROGATE_ID    IS  'SURROGATE_ID: Unique identifier for each row in the table.';
COMMENT ON COLUMN SZRAATR.SZRAATR_VERSION    IS  'VERSION: Integer that is incremented every time a row is updated.';
COMMENT ON COLUMN SZRAATR.SZRAATR_VPDI_CODE    IS  'VPDI: Code of entity to which the data belongs.';


REM *
REM * End.
REM ************************************************************************************************
