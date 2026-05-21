REM ************************************************************************************************
REM *                                                                                              *
REM * szrlfda_090334_03.sql                                                                        *
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
REM *  1. Add primary keys constraint to table.                                    MKU 26-0CT-2015 *
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
REM * Primary Key Definition.
REM ************************************************************************************************

COMMENT ON COLUMN SZRLFDA.SZRLFDA_SEQNO IS 'Sequence number.';
COMMENT ON COLUMN SZRLFDA.SZRLFDA_EFF_TERM_CODE    IS  'This field identifies the term this version of the course becomes effective.';
COMMENT ON COLUMN SZRLFDA.SZRLFDA_TRMT_CODE    IS  'Type of term, eg. 2 - semester, 4 - quarter.';
COMMENT ON COLUMN SZRLFDA.SZRLFDA_PTRM_CODE    IS  'This field identifies the part of term code referenced in the Class Schedule, Registration and Acad. Hist. Modules. Reqd. value: 1 - Full Term.';
COMMENT ON COLUMN SZRLFDA.SZRLFDA_LEVL_CODE    IS  'This field identifies the student level code referenced in the Catalog, Recruiting, Admissions, Gen Student, Registration, and Acad Hist Modules. Required value: 00 - Level Not Declared.';
COMMENT ON COLUMN SZRLFDA.SZRLFDA_SCHD_CODE    IS  'This field identifies the schedule type code referenced in the Catalog, Class Schedule and Registration Modules.';
COMMENT ON COLUMN SZRLFDA.SZRLFDA_ABS_PERCENTAGE    IS  'Percentage of abscences.';
COMMENT ON COLUMN SZRLFDA.SZRLFDA_ABS_LIMIT    IS  'Limit of abscences.';
COMMENT ON COLUMN SZRLFDA.SZRLFDA_ABS_EXT    IS  'Abscences extention.';
COMMENT ON COLUMN SZRLFDA.SZRLFDA_ACAD_DISHONESTY    IS  'Max academic dishonesty grades.';
COMMENT ON COLUMN SZRLFDA.SZRLFDA_ACTIVITY_DATE    IS  'ACTIVITY_DATE: Date on which the record was added or changed.';
COMMENT ON COLUMN SZRLFDA.SZRLFDA_USER_ID    IS  'USER_ID: The ID of the user that most recently updated the record.';
COMMENT ON COLUMN SZRLFDA.SZRLFDA_DATA_ORIGIN    IS  'DATA_ORIGIN: Source system that created or updated the row.';
COMMENT ON COLUMN SZRLFDA.SZRLFDA_SURROGATE_ID    IS  'SURROGATE ID: Unique identifier for each row in the table.';
COMMENT ON COLUMN SZRLFDA.SZRLFDA_VERSION    IS  'VERSION: Integer that is incremented every time a row is updated.';
COMMENT ON COLUMN SZRLFDA.SZRLFDA_VPDI_CODE    IS  'VPDI: Code of entity to which the data belongs.';

REM *
REM * End.
REM ************************************************************************************************
