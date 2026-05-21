REM ************************************************************************************************
REM *                                                                                              *
REM * szreqiv_090334_02.sql                                                                        *
REM *                                                                                              *
REM ************************************************************************************************
REM * Copyright 2024  Elucian. All rights reserved.                                                *
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
REM *  1. Add comments to table and columns.                                       MSO 19-JAN-2016 *
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
REM * Primary Key Definition.
REM ****************************************************************************
WHENEVER SQLERROR CONTINUE;

REM
REM Extend SATURN Table to generate Surrogate ID and version update triggers.
REM ****************************************************************************
WHENEVER SQLERROR CONTINUE;
    DROP TRIGGER SATURN.SZ_SZREQIV_SURROGATE_ID;
    DROP SEQUENCE SATURN.SZREQIV_SURROGATE_ID_SEQUENCE;
    DROP PUBLIC SYNONYM SZREQIV_SURROGATE_ID_SEQUENCE;

    CREATE SEQUENCE SATURN.SZREQIV_SURROGATE_ID_SEQUENCE START WITH 1;
    CREATE PUBLIC SYNONYM SZREQIV_SURROGATE_ID_SEQUENCE FOR SATURN.SZREQIV_SURROGATE_ID_SEQUENCE;


    CREATE OR REPLACE TRIGGER SATURN.SZ_SZREQIV_SURROGATE_ID 
    BEFORE INSERT OR UPDATE ON SATURN.SZREQIV
    FOR EACH ROW
    BEGIN
        IF INSERTING THEN
        IF :NEW.SZREQIV_SURROGATE_ID IS NULL THEN
            :NEW.SZREQIV_SURROGATE_ID := SZREQIV_SURROGATE_ID_SEQUENCE.NEXTVAL;
        END IF;
        :NEW.SZREQIV_VERSION :=0;
        ELSE
        IF :NEW.SZREQIV_VERSION = :OLD.SZREQIV_VERSION THEN
            :NEW.SZREQIV_VERSION := :OLD.SZREQIV_VERSION + 1;
        END IF;
        END IF;
    END;
/

REM *
REM * End.
REM ************************************************************************************************
