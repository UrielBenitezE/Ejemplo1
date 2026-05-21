REM ************************************************************************************************
REM *                                                                                              *
REM * shrgcom_090334_01.sql                                                                        *
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
REM *  Description : Modify SHRGCOM Table.                                                         *
REM *                Local Development Installation Log Table.                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 9.3.34 [LAET:002.2.2]                                          INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creation of script.                                                      MHI 28-NOV-2025 *
REM *                                                                                              *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************

REM *
REM * Fields Definition.
REM ************************************************************************************************

DECLARE
    v_count NUMBER;
BEGIN
    -- SHRGCOM_START_DATE
    SELECT COUNT(*)
    INTO v_count
    FROM USER_TAB_COLUMNS
    WHERE TABLE_NAME = 'SHRGCOM'
      AND COLUMN_NAME = 'SHRGCOM_START_DATE';

    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE SHRGCOM ADD SHRGCOM_START_DATE DATE';
    END IF;

    -- SHRGCOM_END_DATE
    SELECT COUNT(*)
    INTO v_count
    FROM USER_TAB_COLUMNS
    WHERE TABLE_NAME = 'SHRGCOM'
      AND COLUMN_NAME = 'SHRGCOM_END_DATE';

    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE SHRGCOM ADD SHRGCOM_END_DATE DATE';
    END IF;

    -- SHRGCOM_FGRDE_ENTRY
    SELECT COUNT(*)
    INTO v_count
    FROM USER_TAB_COLUMNS
    WHERE TABLE_NAME = 'SHRGCOM'
      AND COLUMN_NAME = 'SHRGCOM_FGRDE_ENTRY';

    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE SHRGCOM ADD SHRGCOM_FGRDE_ENTRY VARCHAR2(10)';
    END IF;

    -- SHRGCOM_FGRDE_ENTRY_EXPT
    SELECT COUNT(*)
    INTO v_count
    FROM USER_TAB_COLUMNS
    WHERE TABLE_NAME = 'SHRGCOM'
      AND COLUMN_NAME = 'SHRGCOM_FGRDE_ENTRY_EXPT';

    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE SHRGCOM ADD SHRGCOM_FGRDE_ENTRY_EXPT VARCHAR2(10)';
    END IF;

    -- SHRGCOM_ACTF_TEST
    SELECT COUNT(*)
    INTO v_count
    FROM USER_TAB_COLUMNS
    WHERE TABLE_NAME = 'SHRGCOM'
      AND COLUMN_NAME = 'SHRGCOM_ACTF_TEST';

    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE SHRGCOM ADD SHRGCOM_ACTF_TEST VARCHAR2(10)';
    END IF;

    -- SHRGCOM_ACTF_PROJ
    SELECT COUNT(*)
    INTO v_count
    FROM USER_TAB_COLUMNS
    WHERE TABLE_NAME = 'SHRGCOM'
      AND COLUMN_NAME = 'SHRGCOM_ACTF_PROJ';

    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE SHRGCOM ADD SHRGCOM_ACTF_PROJ VARCHAR2(10)';
    END IF;

END;
/



REM *
REM * End.
REM ************************************************************************************************
