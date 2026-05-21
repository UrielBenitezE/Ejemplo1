REM ************************************************************************************************
REM *                                                                                              *
REM * szrabsc_083102_02.sql                                                                        *
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
REM *  Description : Create SZRABSC  Table.                                                        *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Add comments to table and columns.                                       MSO 23-NOV-2015 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: 8.31.2 [MCLA:002.2.0]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Upgrade to Banner 8.31.2                                                 MHI 20-JAN-2025 *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************


REM *
REM * Comments Definition.
REM ************************************************************************************************

COMMENT ON TABLE  SZRABSC                      IS 'Evaluation Schemes Base Table.';
COMMENT ON COLUMN SZRABSC.SZRABSC_PIDM         IS 'SZRABSC_PIDM: This field will identifies student''s pidm.';
COMMENT ON COLUMN SZRABSC.SZRABSC_TERM         IS 'SZRABSC_TERM: This field is the term code.';
COMMENT ON COLUMN SZRABSC.SZRABSC_CRN          IS 'SZRABSC_CRN: This field identifies the CRN.';
COMMENT ON COLUMN SZRABSC.SZRABSC_DATE         IS 'SZRABSC_DATE: This field identifies the date which student has an absence.';
COMMENT ON COLUMN SZRABSC.SZRABSC_DAY          IS 'SZRABSC_DAY: This field identifies the day which student has an absence.';

REM *
REM * End.
REM ************************************************************************************************
