REM ************************************************************************************************
REM *                                                                                              *
REM * szvacat_090334_03.sql                                                                        *
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
REM *  Description : Create SZVACAT  Table.                                                        *
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
REM *  1. Upgrade of table SZVACAT for Banner 9                                    MHI 16-OCT-2024 *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

REM *
REM * Primary Key Definition.
REM ************************************************************************************************

COMMENT ON COLUMN SZVACAT.SZVACAT_NAME    IS  'Activity name.';
COMMENT ON COLUMN SZVACAT.SZVACAT_DESC    IS  'Description of the activity.';
COMMENT ON COLUMN SZVACAT.SZVACAT_FINAL_TEST    IS  'Final test.';
COMMENT ON COLUMN SZVACAT.SZVACAT_FINAL_PROJ    IS  'Final project.';
COMMENT ON COLUMN SZVACAT.SZVACAT_USER_ID    IS  'USER_ID: The ID of the user that most recently updated the record.';
COMMENT ON COLUMN SZVACAT.SZVACAT_ACTIVITY_DATE    IS  'ACTIVITY_DATE: Date on which the record was added or changed.';
COMMENT ON COLUMN SZVACAT.SZVACAT_DATA_ORIGIN    IS  'DATA_ORIGIN: Source system that created or updated the row.';
COMMENT ON COLUMN SZVACAT.SZVACAT_SURROGATE_ID    IS  'SURROGATE_ID: Unique identifier for each row in the table.';
COMMENT ON COLUMN SZVACAT.SZVACAT_VERSION    IS  'VERSION: Integer that is incremented every time a row is updated.';
COMMENT ON COLUMN SZVACAT.SZVACAT_VPDI_CODE    IS  'VPDI: Code of entity to which the data belongs.';


REM *
REM * End.
REM ************************************************************************************************
