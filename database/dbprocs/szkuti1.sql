SET SHOWMODE OFF
SET ECHO OFF
REM ****************************************************************************
REM *                                                                          *
REM * szkutil.sql                                                              *
REM *                                                                          *
REM ****************************************************************************
REM *                                                                          *
REM * Copyright 2025 Ellucian Company L.P. and its affiliates                  *
REM *                                                                          *
REM ****************************************************************************
REM *                                                                          *
REM *                    CONFIDENTIAL BUSINESS INFORMATION                     *
REM *                                                                          *
REM ****************************************************************************
REM *                                                                          *
REM * This software contains confidential and proprietary information of       *
REM * Ellucian or its subsidiaries. Use of this software is limited to         *
REM * Ellucian licensees, and is subject to the terms and conditions of one or *
REM * more written license agreements between Ellucian and such licensees.     *
REM *                                                                          *
REM ****************************************************************************
REM *                                                                          *
REM *  Project     : UTM                                                       *
REM *  Modification: MOD-002: Mejora a Asistencia                              *
REM *                                                                          *
REM ****************************************************************************
REM *                                                                          *
REM *  AUDIT TRAIL: 9.3.34 [MCLA:002.2.0]                       INI    DATE     *
REM *  ------------------------------------------------------- --- ----------- *
REM *  1. Initial Creation.                                    MHI 17/JAN/2025 *
REM *  ------------------------------------------------------- --- ----------- *
REM *  AUDIT TRAIL: END                                                        *
REM *                                                                          *
REM ****************************************************************************
SET DEFINE ON
SET SCAN ON
CONNECT baninst1/&&baninst1_password
SET DEFINE OFF
SET SHOWMODE OFF
SET SCAN OFF
SET ECHO OFF
SET VERI OFF
SET HEAD OFF
SET TIME OFF
SET TRIMSPOOL ON
create or replace PACKAGE BODY SZKUTIL AS
  -- -----------------------------------------------------------------------------
-- FILE NAME..: szkuti1.sql
-- RELEASE....: 8.32.0
-- OBJECT NAME: SZKUTIL
-- COPYRIGHT..: Copyright 2024 Ellucian Company L.P. AND its affiliates
-- -----------------------------------------------------------------------------
-- AUDIT TRAIL
-- 8.32   Creation of Package of procedures and function comming from
--        UTM Oracle forms for Upgrade to Banner 9                              MHI  14/NOV/2024
--
-- AUDIT TRAIL END

  -- BA MHI 14/NOV/2024 [MCLA:002.2.0]
  -- Procedure F_SZASCHC_COPY: Function that copies the schemas generated in SZASCHM to a determined Term and Ptrm code

  --Global Cursors for SSB9 Reports
  cursor get_schema_c(cTermCode       varchar2,
                        cPtrmCode       varchar2) is
        select SZ.SZBSCHM_SEQNO aCode
          from szbschm sz
         where SZ.SZBSCHM_TERM_CODE = cTermCode
           AND SZ.SZBSCHM_PTRM_CODE = cPtrmCode
         order by 1;

  cursor get_schema_detail_c(cSchemaCode      Number,
                               cTermCode        STVTERM.STVTERM_CODE%type,  /*   MKU        Added       8.7 [MCLA:002.1.2]   22/Jun/2016  */
                               cPtrmCode        STVPTRM.STVPTRM_CODE%type   /*   MKU        Added       8.7 [MCLA:002.1.2]   22/Jun/2016  */
                               ) is
        SELECT AC.SZVACAT_NAME || ' _ ' || AC.SZVACAT_DESC aActivity,
               TO_CHAR(CH.SZRSCHM_START_DATE, G$_DATE.GET_NLS_DATE_FORMAT ) aStartDate  ,
               TO_CHAR(CH.SZRSCHM_DUE_DATE, G$_DATE.GET_NLS_DATE_FORMAT ) aEndDate ,
               to_char(CH.SZRSCHM_WEIGHT) aWeight ,
               CH.SZRSCHM_USER_ID aUser,
               to_char(CH.SZRSCHM_ACTIVITY_DATE, G$_DATE.GET_NLS_DATE_FORMAT ) || ', ' ||
                  to_char(CH.SZRSCHM_ACTIVITY_DATE, 'hh24:mi:ss') aActivityDate
          FROM szrschm ch, szvacat ac
         WHERE ch.SZRSCHM_ACAT_NAME = AC.SZVACAT_NAME
           AND CH.SZRSCHM_SCHM_SEQNO = cSchemaCode
           AND CH.SZRSCHM_TERM_CODE = cTermCode
           AND CH.SZRSCHM_PTRM_CODE = cPtrmCode
         order by ch.szrschm_seqno;

   CURSOR get_rule_c(p_pidm        number,
                      p_term_code   STVTERM.STVTERM_CODE%TYPE,
                      p_rule        SORADAS.SORADAS_RADM_CODE%TYPE) IS
        SELECT RD.SORADAS_RULE, RD.SORADAS_RADM_CODE
          FROM SORADAS rd
         WHERE RD.SORADAS_AROL_PIDM = p_pidm
           AND RD.SORADAS_ACTIVE_IND = 'A'
           AND RD.SORADAS_TERM_CODE_EFF = (SELECT max(X.SORADAS_TERM_CODE_EFF )
                                             FROM soradas x
                                            WHERE X.SORADAS_AROL_PIDM = p_pidm
                                              AND X.SORADAS_ACTIVE_IND = 'A'
                                              AND X.SORADAS_TERM_CODE_EFF <= p_term_code)
           AND (RD.SORADAS_RADM_CODE = p_rule  OR p_rule IS NULL);

     CURSOR get_assignment_rules_c(p_pidm           number,
                                   r_rule_num       number,
                                   p_base_table     varchar2,
                                   p_column         varchar2) IS
          SELECT C.STVADDA_CODE,
                 C.STVADDA_BASE_TABLE,
                 R.SORADDA_OPERATOR,
                 R.SORADDA_FROM_VALUE fromvalue,
                 nvl(R.SORADDA_TO_VALUE,R.SORADDA_FROM_VALUE) tovalue,
                 ROWNUM num
            FROM stvadda c, soradda r
           WHERE stvadda_code =  soradda_adda_code
             AND stvadda_base_table = p_base_table
             AND soradda_arol_pidm =  p_pidm
             AND soradda_rule      = r_rule_num
             AND C.STVADDA_CODE = p_column;

  FUNCTION F_SZASCHC_COPY(p_term IN VARCHAR2, p_ptrm IN varchar2, p_key_term IN VARCHAR2, p_key_ptrm IN VARCHAR2) RETURN VARCHAR2 IS
     cursor check_term_pterm_c(pTerm VARCHAR2,
                                pPrtm VARCHAR2)  is
            select 'Y'
              from SOBPTRM sp
             where SP.SOBPTRM_TERM_CODE = pTerm
               and SP.SOBPTRM_PTRM_CODE = pPrtm;

      CURSOR COUNT_SZRSCHM(pTerm VARCHAR2, pPrtm VARCHAR2) IS
        SELECT COUNT(*)
          FROM SZRSCHM
         WHERE SZRSCHM_TERM_CODE = pTerm
           AND SZRSCHM_PTRM_CODE = pPrtm;

        lv_count_d  NUMBER(8);
        lv_count_o  NUMBER(8);

        lv_Dummy		varchar2(1);
        lv_message      varchar2(100);
  BEGIN
    lv_Dummy := null;

    open check_term_pterm_c(p_term, p_ptrm);
        fetch check_term_pterm_c into lv_Dummy;
        if check_term_pterm_c%notfound then
            lv_Dummy := 'N';
        end if;
    close check_term_pterm_c;
    DBMS_OUTPUT.PUT_LINE('Dummy ' || lv_Dummy);
    if lv_Dummy = 'N' then
        lv_message := 'ERROR,PERIODO Y PARTE DE PERIDO NO HACEN MATCH';
        return lv_message;
    end if;

    OPEN COUNT_SZRSCHM(p_term, p_ptrm);
    FETCH COUNT_SZRSCHM INTO lv_count_d;
    CLOSE COUNT_SZRSCHM;

    OPEN COUNT_SZRSCHM(p_key_term, p_key_ptrm);
    FETCH COUNT_SZRSCHM INTO lv_count_o;
    CLOSE COUNT_SZRSCHM;

    IF (lv_count_d = 0) THEN
        IF (lv_count_o > 0) THEN
            IF p_term IS NULL OR p_ptrm IS NULL THEN
                lv_message:= 'Se deben llenar el periodo y la parte de periodo';
            ELSE
                INSERT INTO SZBSCHM (
                    SZBSCHM_SEQNO,
                    SZBSCHM_TERM_CODE,
                    SZBSCHM_PTRM_CODE,
                    SZBSCHM_GSCH_NAME,
                    SZBSCHM_NE_PERCENTAGE,
                    SZBSCHM_ASSIGNED_CRN,
                    SZBSCHM_USER_ID,
                    SZBSCHM_ACTIVITY_DATE,
                    SZBSCHM_DATA_ORIGIN
                )
                SELECT
                    SZBSCHM_SEQNO,
                    p_term,
                    p_ptrm,
                    SZBSCHM_GSCH_NAME,
                    SZBSCHM_NE_PERCENTAGE,
                    'N',
                    USER,
                    SYSDATE,
                    'SZASCHC'
                FROM SZBSCHM
                WHERE SZBSCHM_TERM_CODE = p_key_term
                    AND SZBSCHM_PTRM_CODE = p_key_ptrm;

                INSERT INTO SZRSCHM (
                    SZRSCHM_SCHM_SEQNO,
                    SZRSCHM_TERM_CODE,
                    SZRSCHM_PTRM_CODE,
                    SZRSCHM_SEQNO,
                    SZRSCHM_ACAT_NAME,
                    SZRSCHM_WEIGHT,
                    SZRSCHM_INCLUDE_IND,
                    SZRSCHM_DELIVER_IND,
                    SZRSCHM_START_DATE,
                    SZRSCHM_DUE_DATE,
                    SZRSCHM_RESTRICTED_IND,
                    SZRSCHM_GSCH_NAME,
                    SZRSCHM_MIN_PASS_SCORE,
                    SZRSCHM_USER_ID,
                    SZRSCHM_ACTIVITY_DATE,
                    SZRSCHM_DATA_ORIGIN
                )
                SELECT
                    SZRSCHM_SCHM_SEQNO,
                    p_term,
                    p_ptrm,
                    SZRSCHM_SEQNO,
                    SZRSCHM_ACAT_NAME,
                    SZRSCHM_WEIGHT,
                    SZRSCHM_INCLUDE_IND,
                    SZRSCHM_DELIVER_IND,
                    SZRSCHM_START_DATE,
                    SZRSCHM_DUE_DATE,
                    SZRSCHM_RESTRICTED_IND,
                    SZRSCHM_GSCH_NAME,
                    SZRSCHM_MIN_PASS_SCORE,
                    USER,
                    SYSDATE,
                    'SZASCHC'
                FROM SZRSCHM
                WHERE SZRSCHM_TERM_CODE = p_key_term
                    AND SZRSCHM_PTRM_CODE = p_key_ptrm;

                lv_message := 'Esquemas copiados correctamente';

                COMMIT;
            END IF;
        ELSE
            IF p_term IS NULL OR p_ptrm IS NULL THEN
                lv_message:= 'Se deben llenar el periodo y la parte de periodo';
            ELSE
                lv_message := 'No existen esquemas del periodo-parte de periodo original';
            END IF;
        END IF;
    ELSE
        IF p_term IS NULL OR p_ptrm IS NULL THEN
            lv_message:= 'Se deben llenar el periodo y la parte de periodo';
        ELSE
            lv_message := 'Ya existen esquemas creados para este periodo - parte de periodo';
        END IF;
    END IF;
    RETURN lv_message;
  END F_SZASCHC_COPY;
  -- EA MHI 14/NOV/2024 [MCLA:002.2.0]

  -- BA MHI 14/NOV/2024 [MCLA:002.2.0]
  -- Procedure P_SZAABJR_INSERT_SZRAATR: Procedure that makes an insert into SZAART table through the Admin Page SZAABJR to state the justified absences

  PROCEDURE P_SZAABJR_INSERT_SZRAATR(p_pidm         spriden.spriden_pidm%type,
                                     p_crn          ssbsect.ssbsect_crn%type,
                                     p_term_code    stvterm.stvterm_Code%type,
                                     p_mode         varchar2) AS

    cursor verify_row is
	   select rowid
		  from  SZRAATR zr
		 where ZR.SZRAATR_CRN = p_crn
		   and ZR.SZRAATR_PIDM = p_pidm
		   and ZR.SZRAATR_TERM_CODE = p_term_code;

	cursor count_rows is
		select count(1)
		 from szrsatr tr
		where TR.SZRSATR_CRN = p_crn
		  and TR.SZRSATR_PIDM = p_pidm
		  and tr.SZRSATR_ABJR_CODE is not null
		  AND TR.SZRSATR_TERM_CODE = p_term_code;

	vR				   verify_row%rowtype;
	vDummy			 number(5);


    BEGIN
        vDummy := 0;

	open verify_row;
	fetch verify_row into vR;
	close verify_row;


	open count_rows;
	fetch count_rows into vDummy;
	close count_rows;

	if p_mode = 'U' then


		if vR.rowid is null then

			insert into SZRAATR(SZRAATR_PIDM, SZRAATR_TERM_CODE,
			                    SZRAATR_CRN,SZRAATR_ABS_JSTF,
			                    SZRAATR_USER_ID, SZRAATR_ACTIVITY_DATE,
			                    SZRAATR_DATA_ORIGIN)
									values (p_pidm, p_term_code,
													p_crn , vDummy,
													user,sysdate,
													'SZAABJR'
														);

		else
			update SZRAATR zr
			    set ZR.SZRAATR_ABS_JSTF = vDummy,
			        ZR.SZRAATR_ACTIVITY_DATE = sysdate,
			        ZR.SZRAATR_USER_ID = user,
			        ZR.SZRAATR_DATA_ORIGIN = 'SZAABJR'
			 where rowid = vR.rowid;
		end if;

	elsif p_mode = 'D' then
		if vR.rowid is not null then
			update SZRAATR zr
			    set ZR.SZRAATR_ABS_JSTF = vDummy,
			        ZR.SZRAATR_ACTIVITY_DATE = sysdate,
			        ZR.SZRAATR_USER_ID = user,
			        ZR.SZRAATR_DATA_ORIGIN = 'SZAABJR'
			 where rowid = vR.rowid;
		end if;
	end if;

  END P_SZAABJR_INSERT_SZRAATR;
  -- EA MHI 14/NOV/2024 [MCLA:002.2.0]


  -- BA MHI 14/NOV/2024 [MCLA:002.2.0]
  -- Procedure F_SZAABXT_SAVE_UPDATE_SZRAATR: Function that inserts or updates the table SZRAATR based on
  --                                          whether the student has an extended absence or not

  FUNCTION F_SZAABXT_SAVE_UPDATE_SZRAATR(p_pidm        spriden.spriden_pidm%type,
                                          p_term_code   stvterm.stvterm_code%type,
                                          p_ptrm_code   stvptrm.stvptrm_code%type,
                                          p_crn         ssbsect.ssbsect_crn%type,
                                          p_levl_code   stvlevl.stvlevl_code%type,
                                          p_schd_code   stvschd.stvschd_code%type,
                                          p_ext_abs_ind varchar2,
                                          p_abjr_code   szvabjr.szvabjr_code%type) RETURN VARCHAR2 IS

    cursor get_count_pk(c_pidm			number) is
	    select count(1)
			  from szraatr tr
			 where TR.SZRAATR_PIDM = c_pidm
			   and TR.SZRAATR_CRN = p_crn
			   and TR.SZRAATR_TERM_CODE = p_term_code;

    cursor get_trmt_code is
     select ST.STVTERM_TRMT_CODE
		   from stvterm st
		  where ST.STVTERM_CODE = p_term_code;

    cursor get_szrlfda_percentage_c(c_trmt_code 	varchar2)  is
         select SZRLFDA_ABS_EXT
           from szrlfda fd
					where fd.szrlfda_eff_term_code =(select max(x.szrlfda_eff_term_code)
                                           from szrlfda x
                                          where x.szrlfda_eff_term_code <= p_term_code
                                            and X.SZRLFDA_TRMT_CODE = c_trmt_code
                                            and x.szrlfda_levl_code = p_levl_code
                                            and x.szrlfda_ptrm_code = p_ptrm_code
                                            and x.szrlfda_schd_code = p_schd_code
                                            )
            and fd.szrlfda_levl_code = p_levl_code
            and fd.SZRLFDA_TRMT_CODE = c_trmt_code
            and fd.szrlfda_ptrm_code = p_ptrm_code
            and fd.szrlfda_schd_code = p_schd_code ;


	vSumSession             number(5);
	vABSPerc                szrlfda.SZRLFDA_ABS_EXT%type;
	vLimAbs                 SZRAATR.SZRAATR_ABS_EXT%type;
	vTRMTCode			    szrlfda.SZRLFDA_TRMT_CODE%type;
	nCount				    number;

    lv_message              varchar2(100);
    BEGIN
        vSumSession := null;
        vABSPerc := null;
        vLimAbs := null;
        vTRMTCode := null;
        nCount := 0;

      if p_ext_abs_ind = 'Y' and p_abjr_code is null then
        DBMS_OUTPUT.PUT_LINE('Must define a reason.');
        lv_message := 'Must define a reason.';
        return lv_message;
      end if;

      if p_ext_abs_ind is null and p_abjr_code is not null then
         DBMS_OUTPUT.PUT_LINE('Must check on Extended Absences field or choose blank on Reason field.');
         lv_message := 'Must check on Extended Absences field or choose blank on Reason field.';
         return lv_message;
      end if;

      if p_ext_abs_ind = 'Y' THEN
            -- sum sessions

            vSumSession := szkutil.F_SZAABXT_CALCULATE_SESSION(p_term_code,
                                               p_crn,
                                               p_ptrm_code);



            open get_trmt_code;
            fetch get_trmt_code into vTRMTCode;
            close get_trmt_code;

            open get_szrlfda_percentage_c(vTRMTCode);
        fetch get_szrlfda_percentage_c into  vABSPerc;
        close get_szrlfda_percentage_c;


            --vLimAbs := (vSumSession * p_weeks)*(vABSPerc/100);
            vLimAbs := vSumSession *(vABSPerc/100);



      END IF;

      lv_message := 'Registros guardados con exito';
      open get_count_pk(p_pidm);
      fetch get_count_pk into nCount;
      close get_count_pk;


        if nvl(nCount,0) = 0  then
            DBMS_OUTPUT.PUT_LINE('304' || ' ' || vSumSession || ' ' || vTRMTCode || ' ' || vABSPerc || ' ' || vLimAbs || ' ' || nCount);

                BEGIN
                insert into SZRAATR(SZRAATR_PIDM, SZRAATR_TERM_CODE,
                                        SZRAATR_CRN,SZRAATR_EXT_ABS_IND,
                                        SZRAATR_ABJR_CODE, SZRAATR_ABS_EXT,
                                        SZRAATR_USER_ID, SZRAATR_ACTIVITY_DATE,
                                        SZRAATR_DATA_ORIGIN)
                                            values (p_pidm, p_term_code,
                                                            p_crn , p_ext_abs_ind,
                                                            p_abjr_code, vLimAbs,
                                                            user,sysdate,
                                                            'SZAABXT');

                END;
                else
                    DBMS_OUTPUT.PUT_LINE('320' || ' ' || vSumSession || ' ' || vTRMTCode || ' ' || vABSPerc || ' ' || vLimAbs || ' ' || nCount);
                    BEGIN
                    update SZRAATR zr
                        set ZR.SZRAATR_EXT_ABS_IND = p_ext_abs_ind,
                                zr.SZRAATR_ABJR_CODE = p_abjr_code,
                                zr.SZRAATR_ABS_EXT = vLimAbs,
                            ZR.SZRAATR_ACTIVITY_DATE = sysdate,
                            ZR.SZRAATR_USER_ID = user,
                            ZR.SZRAATR_DATA_ORIGIN = 'SZAABXT'
                      where zr.SZRAATR_PIDM = p_pidm
                        and zr.SZRAATR_TERM_CODE = p_term_code
                        and zr.SZRAATR_CRN = p_crn;
                    COMMIT;
                    END;
        end if;
        return lv_message;

  END F_SZAABXT_SAVE_UPDATE_SZRAATR;
  -- EA MHI 14/NOV/2024 [MCLA:002.2.0]

  -- BA MHI 14/NOV/2024 [MCLA:002.2.0]
  -- Procedure F_SZAABXT_CALCULATE_SESSION: Helper function that calculates the session for Function F_SZAABXT_SAVE_UPDATE_SZRAATR

  FUNCTION F_SZAABXT_CALCULATE_SESSION(P_Term_Code      Stvterm.Stvterm_Code%Type,
                                       P_Crn            Ssbsect.Ssbsect_Crn%Type,
                                       p_ptrm_code      Stvptrm.Stvptrm_Code%type) RETURN NUMBER IS

    Cursor Get_Days_C Is
    Select sr.Ssrmeet_Sun_Day sun_day,
           sr.Ssrmeet_Mon_Day mon_day,
           sr.Ssrmeet_Tue_Day tue_day,
           sr.Ssrmeet_Wed_Day wed_day,
           sr.Ssrmeet_Thu_Day thu_day,
           sr.Ssrmeet_Fri_Day fri_day,
           sr.Ssrmeet_Sat_Day sat_day,
           sr.SSRMEET_START_DATE start_date,
           SR.SSRMEET_END_DATE end_date
      FROM SSRMEET sr
     Where sr.Ssrmeet_Term_Code = P_Term_Code
       AND sr.SSRMEET_CRN  = p_crn;

	vWeekDays					number;
	Vexcludedate		        Number;
	Vamount				        Number;

    vDateCurr                   DATE;
    vDOW                        varchar2(1);
    vDateReg                    varchar2(8);

    BEGIN
        vWeekDays := 0;
        vExcludeDate := 0;
        vAmount := 0;

        for rMeet in Get_Days_C loop
            vDateCurr := rMeet.START_DATE;


            while vDateCurr <= rMeet.END_DATE loop
                vDateReg := null;

                -- from 0 (Sunday) to 6 (saturday)
                vDOW := to_char(vDateCurr,'DAY',
                        'NLS_DATE_LANGUAGE=''numeric date language''') ;

                case
                    when vDOW = '0' and rMeet.SUN_DAY is not null then
                        vDateReg := to_char(vDateCurr, 'YYYYMMDD');

                    when vDOW = '1' and rMeet.MON_DAY is not null then
                        vDateReg := to_char(vDateCurr, 'YYYYMMDD');

                    when vDOW = '2' and rMeet.TUE_DAY is not null then
                        vDateReg := to_char(vDateCurr, 'YYYYMMDD');

                    when vDOW = '3' and rMeet.WED_DAY is not null then
                        vDateReg := to_char(vDateCurr, 'YYYYMMDD');

                    when vDOW = '4' and rMeet.THU_DAY is not null then
                        vDateReg := to_char(vDateCurr, 'YYYYMMDD');

                    when vDOW = '5' and rMeet.FRI_DAY is not null then
                        vDateReg := to_char(vDateCurr, 'YYYYMMDD');

                    when vDOW = '6' and rMeet.SAT_DAY is not null then
                        vDateReg := to_char(vDateCurr, 'YYYYMMDD');

                   else
                        vDateReg := null;
                end case;


                if vDateReg is not null   then
                    vExcludeDate := szkutil.F_SZAABXT_EXCLUDE_DAY(vDateCurr, p_ptrm_code);
                    vAmount := vAmount + 1 - vExcludeDate;
                end if;

                vDateCurr := vDateCurr + 1;

            end loop;
        end loop;


      return nvl(vAmount,0);
  END F_SZAABXT_CALCULATE_SESSION;
  -- EA MHI 14/NOV/2024 [MCLA:002.2.0]

  -- BA MHI 14/NOV/2024 [MCLA:002.2.0]
  -- Procedure F_SZAABXT_EXCLUDE_DAY: Helper function for function F_SZAABXT_SAVE_UPDATE_SZRAATR that calculates excluded dates
  FUNCTION F_SZAABXT_EXCLUDE_DAY(P_Date             Date,
                                 P_Ptrm_Code        Stvptrm.Stvptrm_Code%Type) RETURN NUMBER IS

    cursor count_exclude_day_c is
      select count(1)
        from ssrexcl sr
       Where Sr.Ssrexcl_Ptrm_Code = P_Ptrm_Code
         and SR.SSREXCL_EXCLUDE_DATE = p_date;


    vCount          number;

    BEGIN
        vCount := null;

        open count_exclude_day_c;
        fetch count_exclude_day_c into vCount;
        close count_exclude_day_c;


        return nvl(vCount,0);

  END F_SZAABXT_EXCLUDE_DAY;
  -- EA MHI 14/NOV/2024 [MCLA:002.2.0]

  -- BA MHI 14/NOV/2024 [MCLA:002.2.0]
  -- Procedure P_SZAANDL_CRN_LIST: Function that processes the list of CRN sent through the Admin Page SZAANDL and either makes the calculations for
  --                               abscence limits, underivable activities or both.

  FUNCTION P_SZAANDL_CRN_LIST(P_KB_PTRM_CODE   STVPTRM.STVPTRM_CODE%TYPE,
                               P_KB_TERM_CODE   STVTERM.STVTERM_CODE%TYPE,
                               P_RB_CALCULATE   VARCHAR2,
                               P_LIST_ITEM      LONG,
                               P_ABS_OVERRIDE   VARCHAR2,
                               P_UNDE_OVERRIDE  VARCHAR2) RETURN VARCHAR2 IS
    -- note: this allows to use ';',',','|' as separator
    cursor get_crn_c(cList	long) is
			SELECT Ssbsect_term_code, Ssbsect_ptrm_code, Ssbsect_crn
        FROM Ssbsect
		   where Ssbsect_ptrm_code = P_KB_PTRM_CODE
         and Ssbsect_term_code = P_KB_TERM_CODE
         and Ssbsect_crn in (SELECT regexp_substr(crn, separator, 1, LEVEL) crn
											  			FROM (SELECT cList crn, '[^;,|[:cntrl:][:space:]]+' separator FROM dual)
													   CONNECT BY regexp_substr(crn, separator, 1, LEVEL) IS NOT NULL);
    cursor get_TrmType_c(cTermCode varchar2) is
      select TM.STVTERM_TRMT_CODE
			  from stvterm tm
			 where TM.STVTERM_CODE = cTermCode;

	vTrmType	    stvterm.STVTERM_TRMT_CODE%type;
	vCount			number;
	vStatus			number;
    lv_message      varchar2(100);

    BEGIN
        vCount := 0;

        if P_RB_CALCULATE is null then
            lv_message := G$_NLS.Get('X', 'FORM','*ERROR* Must define a calculate type.');
            return lv_message;
        end if;

        if trim(P_LIST_ITEM) is null then
            lv_message := G$_NLS.Get('X', 'FORM','*ERROR* Must inform a list of valid CRNs separated by comma.');
            return lv_message;
        end if;

        open get_TrmType_c(P_KB_TERM_CODE);
        fetch get_TrmType_c into vTrmType;
        close get_TrmType_c;

        for r in get_crn_c(trim(P_LIST_ITEM)) loop
            vStatus := 0;
            IF P_RB_CALCULATE = 'A' THEN
                -- calculates absences limit
                P_SZAANDL_PROCESS_CRN(r.Ssbsect_term_code,
                                r.Ssbsect_ptrm_code,
                                r.Ssbsect_crn,
                                vTrmType,
                                P_ABS_OVERRIDE,
                                vStatus);

                vCount := vCount + vStatus;

                ELSIF P_RB_CALCULATE = 'U' THEN
                -- calculates undeliverable activities
                    P_SZAANDL_PROCESS_UNDELIV_CRN(r.Ssbsect_term_code,
                                          r.Ssbsect_ptrm_code	,
                                            r.Ssbsect_crn,
                                            P_UNDE_OVERRIDE,
                                            vStatus);

                    vCount := vCount + vStatus;
                    else
                        P_SZAANDL_PROCESS_CRN(r.Ssbsect_term_code,
                                        r.Ssbsect_ptrm_code,
                                                r.Ssbsect_crn,
                                                vTrmType,
                                                null,
                                                vStatus);

                        vCount := vCount + vStatus;

                        P_SZAANDL_PROCESS_UNDELIV_CRN(r.Ssbsect_term_code,
                                                r.Ssbsect_ptrm_code,
                                                r.Ssbsect_crn,
                                                null,
                                                vStatus);

                        vCount := vCount + vStatus;
            END IF;
          end loop;

          lv_message := G$_NLS.Get('X', 'FORM',to_char(vCount) || ' records have been updated.');
          return lv_message;
  END P_SZAANDL_CRN_LIST;
  -- EA MHI 14/NOV/2024 [MCLA:002.2.0]

  FUNCTION P_SZAANDL_SELECTED_CRN(P_KB_TERM_CODE    STVTERM.STVTERM_CODE%TYPE,
                          P_KB_PTRM_CODE    STVPTRM.STVPTRM_CODE%TYPE,
                          P_SEL_CAMPUS      STVCAMP.STVCAMP_CODE%TYPE,
                          P_SEL_SCHD        STVSCHD.STVSCHD_CODE%TYPE,
                          P_SEL_SUB         SSBSECT.SSBSECT_SUBJ_CODE%TYPE,
                          P_SEL_CRSE_NUM    SSBSECT.SSBSECT_CRSE_NUMB%TYPE,
                          P_RB_CALCULATE   VARCHAR2)  RETURN VARCHAR2 IS

  cursor get_crn_c is
	  select ssbsect_crn, ssbsect_term_code, ssbsect_ptrm_code
    from ssbsect
   where ssbsect_term_code = P_KB_TERM_CODE
     and ssbsect_ptrm_code = P_KB_PTRM_CODE
     and (ssbsect_camp_code = nvl(P_SEL_CAMPUS, ssbsect_camp_code) or P_SEL_CAMPUS is null  )
     and (ssbsect_schd_code =  nvl(P_SEL_SCHD, ssbsect_schd_code) or P_SEL_SCHD is null )
     and (ssbsect_subj_code =  nvl(P_SEL_SUB, ssbsect_subj_code) or P_SEL_SUB is null )
     and (ssbsect_crse_numb = nvl(P_SEL_CRSE_NUM, ssbsect_crse_numb) or P_SEL_CRSE_NUM is null );

  cursor get_TrmType_c(cTermCode varchar2) is
      select TM.STVTERM_TRMT_CODE
			  from stvterm tm
			 where TM.STVTERM_CODE = cTermCode;

	vTrmType			stvterm.STVTERM_TRMT_CODE%type;
  vCount				number;
  vStatus				number;
  lv_message            varchar2(100);
  BEGIN
      vCount := 0;
      vTrmType := null;
      if P_RB_CALCULATE is null then
        lv_message :=  G$_NLS.Get('X', 'FORM','*ERROR* Must define a calculate type.');
        return lv_message;
      end if;

      open get_TrmType_c(P_KB_TERM_CODE);
      fetch get_TrmType_c into vTrmType;
      close get_TrmType_c;

      for r in get_crn_c loop
        vStatus := 0;
        IF P_RB_CALCULATE in ('A','B') THEN
            -- calculates absences limit
            P_SZAANDL_PROCESS_CRN(r.ssbsect_term_code,
                                        r.ssbsect_ptrm_code,
                                        r.ssbsect_crn,
                                        vTrmType,
                                        null,
                                        vStatus);

            vCount := vCount + vStatus;
        end if;

        IF P_RB_CALCULATE in ('B', 'U') THEN
        -- calculates undeliverable activities
        P_SZAANDL_PROCESS_UNDELIV_CRN(r.ssbsect_term_code,
                                                  r.ssbsect_ptrm_code,
                                                    r.ssbsect_crn,
                                                    null,
                                                    vStatus);

        vCount := vCount + vStatus;
        END IF;

      end loop;
      lv_message := G$_NLS.Get('X', 'FORM',to_char(vCount) || ' records have been updated.');
      return lv_message;
  END P_SZAANDL_SELECTED_CRN;

  -- BA MHI 14/NOV/2024 [MCLA:002.2.0]
  -- Procedure P_SZAANDL_PROCESS_CRN: Helper function for P_SZAANDL_CRN_LIST that processes the CRN for abscence limits
  PROCEDURE P_SZAANDL_PROCESS_CRN(p_term_code     stvterm.stvterm_code%type,
                          p_ptrm_code	  stvptrm.stvptrm_code%type,
                          p_crn           ssbsect.ssbsect_crn%type,
                          p_term_type     STVTRMT.STVTRMT_CODE%type,
                          p_AbsValue      number,
                          pStatus     out number) IS

    cursor sum_sessions_c is
      select (x.dsun + x.dmon + x.dtue + x.dwed + x.dthu + x.dfri + x.dsat) tot_session
        from
        (
        SELECT COUNT(DISTINCT SSRMEET_SUN_DAY) dsun, COUNT(DISTINCT SSRMEET_MON_DAY) dmon, COUNT(DISTINCT Ssrmeet_Tue_Day) dtue, COUNT(DISTINCT Ssrmeet_Wed_Day ) dwed,
               COUNT(DISTINCT Ssrmeet_Thu_Day) dthu, COUNT(DISTINCT Ssrmeet_Fri_Day) dfri, COUNT(DISTINCT Ssrmeet_Sat_Day) dsat
          FROM SSRMEET
         WHERE SSRMEET_TERM_CODE = p_term_code
           AND SSRMEET_CRN  = p_crn) x;

    cursor get_crn_attribute_c is
        SELECT Ssbsect_subj_code, Ssbsect_crse_numb,
               Scrlevl_Levl_Code, Ssbsect_schd_code,
               Ssbsect_camp_code, Ssbsect_ptrm_code, Ssbsect_Ptrm_Weeks
          FROM   Ssbsect, scrlevl
         where Ssbsect_subj_code = scrlevl_subj_code
           and Ssbsect_crse_numb = scrlevl_crse_numb
           and scrlevl_eff_term = (select max(scrlevl_eff_term) from scrlevl x
                                      where x.scrlevl_subj_code = Ssbsect_subj_code
                                        and x.scrlevl_crse_numb = Ssbsect_crse_numb
                                        and scrlevl_eff_term <= Ssbsect_term_code )
          and Ssbsect_ptrm_code = p_ptrm_code
          and Ssbsect_crn = p_crn
          and Ssbsect_term_code = p_term_code;

    cursor get_subj_crse_c is
        SELECT Ssbsect_subj_code, Ssbsect_crse_numb
          FROM   Ssbsect
         where Ssbsect_ptrm_code = p_ptrm_code
           and Ssbsect_crn = p_crn
           and Ssbsect_term_code = p_term_code;

     cursor get_szrlfda_percentage_c(p_levl_code      varchar2,
                                    p_ptrm_code      stvptrm.stvptrm_code%type,
                                    p_schd_code      stvschd.stvschd_code%type
                                    ) is
         select szrlfda_abs_percentage, FD.SZRLFDA_ABS_LIMIT
           from szrlfda fd
					where fd.szrlfda_eff_term_code =(select max(x.szrlfda_eff_term_code)
                                           from szrlfda x
                                          where x.szrlfda_eff_term_code <= p_term_code
                                            and X.SZRLFDA_TRMT_CODE = (select T.STVTERM_TRMT_CODE
                                                                         from stvterm t
                                                                        where T.STVTERM_CODE = p_term_code)
                                            and x.szrlfda_levl_code = p_levl_code
                                            and x.szrlfda_ptrm_code = p_ptrm_code
                                            and x.szrlfda_schd_code = p_schd_code
                                            )
            and fd.SZRLFDA_TRMT_CODE = (select T.STVTERM_TRMT_CODE
                                         from stvterm t
                                        where T.STVTERM_CODE = p_term_code)
            and fd.szrlfda_levl_code = p_levl_code
            and fd.szrlfda_ptrm_code = p_ptrm_code
            and fd.szrlfda_schd_code = p_schd_code ;

    vSumSession             number(5);
    vLimAbs                 SZRATRK.SZRATRK_ABS_LIMIT%type;
    vAbsValue				szrlfda.SZRLFDA_ABS_LIMIT%type;
    vABSPerc                szrlfda.szrlfda_abs_percentage%type;
    vSSRec                  get_crn_attribute_c%rowtype;
    vSCRec					get_subj_crse_c%rowtype;

    BEGIN
        vSumSession := null;
        vABSPerc := null;
        vAbsValue := null;
        pStatus := 0;  --- fail

        /*
            if NVL(p_AbsValue,-1) < 0 then
                return;
            end if;
          */
        if p_AbsValue is null then
            -- sum sessions
            /*
                open sum_sessions_c;
                fetch sum_sessions_c into vSumSession;
                close sum_sessions_c;

                if vSumSession is null then
                    return;
                end if;
            */
             open  get_crn_attribute_c;
                loop
                    fetch get_crn_attribute_c into vSSRec;
                    exit when get_crn_attribute_c%notfound;

                    vABSPerc := null;
                    vAbsValue := null;

                    open get_szrlfda_percentage_c(vSSRec.Scrlevl_Levl_Code,
                                                    vSSRec.Ssbsect_ptrm_code,
                                                    vSSRec.Ssbsect_schd_code);
                    fetch get_szrlfda_percentage_c into  vABSPerc, vAbsValue;
                    close get_szrlfda_percentage_c;
                    exit when (vABSPerc is not null or vAbsValue is not null);

                end loop;
            close get_crn_attribute_c;

            if vABSPerc is null and vAbsValue is null then
                return;
            end if;

            if vABSPerc is not null then
                vSumSession := F_Calculate_Session(p_term_code, p_crn, vSSRec.Ssbsect_ptrm_code);
                vLimAbs := (vSumSession)*(vABSPerc/100);
            else
                vLimAbs := vAbsValue;
            end if;

            -- save
			P_SZAANDL_SAVE_SZRATRK(p_term_code,
                                 vSSRec.Ssbsect_ptrm_code,
                                 p_crn,
                                 vSSRec.Ssbsect_subj_code,
                                 vSSRec.Ssbsect_crse_numb,
                                 vLimAbs,
                                 null,
                                 'A',
                                 pStatus);
        ELSE
            vLimAbs :=  p_AbsValue;

		 	open get_subj_crse_c;
		 	fetch get_subj_crse_c into vSCRec;
            if get_subj_crse_c%notfound then
		 		close get_subj_crse_c;
		 		pStatus := 0;
		 		return;
		 	end if;
		 	close get_subj_crse_c;

            -- save
            P_SZAANDL_SAVE_SZRATRK(p_term_code,
                                 p_ptrm_code,
                                 p_crn,
                                 vSCRec.Ssbsect_subj_code,
                                 vSCRec.Ssbsect_crse_numb,
                                 vLimAbs,
                                 null,
                                 'A',
                                 pStatus);
        END IF;

  END P_SZAANDL_PROCESS_CRN;
  -- EA MHI 14/NOV/2024 [MCLA:002.2.0]

  -- BA MHI 14/NOV/2024 [MCLA:002.2.0]
  -- Procedure P_SZAANDL_CRN_LIST: Helper function for P_SZAANDL_CRN_LIST that calculates the underivable activities

  PROCEDURE P_SZAANDL_PROCESS_UNDELIV_CRN(p_term_code     stvterm.stvterm_code%type,
                                  p_ptrm_code	  stvptrm.stvptrm_code%type,
                                  p_crn           ssbsect.ssbsect_crn%type,
                                  p_Undeliv       number,
                                  pStatus     out number) IS

  cursor calculate_undeliv_c is
		select SZRSCHM_SCHM_SEQNO, SZBSCHM_NE_PERCENTAGE PNE, COUNT(1) TAE,
		        SUM(DECODE(SZRSCHM_DELIVER_IND,'N',1,0)) ANE
		  from Szbschm zb, SZRSCHM sm, SZRCRNS cr
		 where SZRSCHM_SCHM_SEQNO = SZBSCHM_SEQNO
		   and SZRSCHM_TERM_CODE = SZBSCHM_TERM_CODE
		   and SZRSCHM_PTRM_CODE = SZBSCHM_PTRM_CODE
		   and CR.SZRCRNS_SCHM_SEQNO = SM.SZRSCHM_SCHM_SEQNO
       and CR.SZRCRNS_TERM_CODE = SM.SZRSCHM_TERM_CODE
       and CR.SZRCRNS_PTRM_CODE = SM.SZRSCHM_PTRM_CODE
       and CR.SZRCRNS_CRN = p_crn
       and cr.SZRCRNS_CURRENT_IND = 'Y'
		   AND SZRSCHM_TERM_CODE = p_term_code
		   AND SZRSCHM_PTRM_CODE = p_ptrm_code
		 group by SZRSCHM_SCHM_SEQNO, SZBSCHM_NE_PERCENTAGE;

  cursor get_crn_attribute_c is
        SELECT Ssbsect_subj_code, Ssbsect_crse_numb,
               Ssbsect_camp_code, Ssbsect_ptrm_code
          FROM  Ssbsect
         where Ssbsect_crn = p_crn
          and Ssbsect_term_code = p_term_code
          and Ssbsect_ptrm_code = p_ptrm_code;

  vResult							SZRATRK.SZRATRK_NE_LIMIT%type;
  vSSRec              get_crn_attribute_c%rowtype;

  BEGIN
      pStatus := 0;  ---fail
      if p_Undeliv is null then
        vResult := 0;
        for r in calculate_undeliv_c loop
            vResult := round((r.tae - r.ane) * (r.pne/100),0);
        end loop;
      else
        vResult := p_Undeliv;
      end if;

      if vResult is null then
        return;
      end if;

      open get_crn_attribute_c;
      fetch get_crn_attribute_c into vSSRec;
      if get_crn_attribute_c%notfound then
        close get_crn_attribute_c;
        return;
      end if;
      close get_crn_attribute_c;

      -- save
      P_SZAANDL_SAVE_SZRATRK(p_term_code,
                             p_ptrm_code,
                             p_crn,
                             vSSRec.Ssbsect_subj_code,
                             vSSRec.Ssbsect_crse_numb,
                             null,
                             vResult,
                             'U',
                             pStatus);

  END P_SZAANDL_PROCESS_UNDELIV_CRN;
  -- EA MHI 14/NOV/2024 [MCLA:002.2.0]

  -- BA MHI 14/NOV/2024 [MCLA:002.2.0]
  -- Procedure P_SZAANDL_CRN_LIST: Helper function for P_SZAANDL_CRN_LIST that makes an insert into SZRATRK

  PROCEDURE P_SZAANDL_SAVE_SZRATRK(p_term_code stvterm.stvterm_code%type,
                                   p_ptrm_code stvptrm.stvptrm_code%type,
                                   p_crn       ssbsect.ssbsect_crn%type,
                                   p_Subj_Code soratrk.SORATRK_SUBJ_CODE%type,
                                   p_Crse_Numb soratrk.SORATRK_CRSE_NUMB%type,
                                   p_AbsValue  number,
                                   p_Undeliv   number,
                                   p_type	   varchar2,
                                   pStatus     out number) IS

  cursor get_soratrk_c is
	 		select SORATRK_SEQ_NO
			  from soratrk
			 where soratrk_term_code = p_term_code
			   and (soratrk_crn = p_crn or soratrk_crn is null)
			   and (SORATRK_SUBJ_CODE = p_Subj_Code or SORATRK_SUBJ_CODE is null)
			   and (SORATRK_CRSE_NUMB = p_Crse_Numb or SORATRK_CRSE_NUMB is null)
			   and (SORATRK_PTRM_CODE = p_ptrm_code or SORATRK_PTRM_CODE is null);

  cursor check_ATRK_SEQ_NO_exists(pSeqno  number) is
	   select 'Y'
		  from SZRATRK
		 where SZRATRK_ATRK_SEQ_NO= pSeqno;

   vATRKSeqno							SORATRK.SORATRK_SEQ_NO%TYPE;
   vDummy									varchar2(1);

  BEGIN
      vATRKSeqno := null;
      vDummy := null;
      pStatus := 0; --- fail
      --- search into SORATRK for this occurence
      open get_soratrk_c;
      fetch get_soratrk_c into vATRKSeqno;
      close get_soratrk_c;

      if vATRKSeqno is null then
         return;
      end if;

      open check_ATRK_SEQ_NO_exists(vATRKSeqno);
      fetch check_ATRK_SEQ_NO_exists into vDummy;
      close check_ATRK_SEQ_NO_exists;


      if vDummy is null then
            insert into SZRATRK(SZRATRK_ATRK_SEQ_NO,
                                SZRATRK_ABS_LIMIT,
                                SZRATRK_NE_LIMIT,
                                SZRATRK_USER_ID,
                                SZRATRK_ACTIVITY_DATE,
                                SZRATRK_DATA_ORIGIN)
             values(vATRKSeqno,
                    p_AbsValue,
                    p_Undeliv,
                    user,
                    sysdate,
                    'SZAANDL');
            pStatus := 1;
        else
            if p_type = 'A' then
                update SZRATRK
                   set SZRATRK_ABS_LIMIT = p_AbsValue,
                         SZRATRK_USER_ID = user,
                         SZRATRK_ACTIVITY_DATE = sysdate,
                         SZRATRK_DATA_ORIGIN = 'SZAANDL'
                 where SZRATRK_ATRK_SEQ_NO = vATRKSeqno;

                 pStatus := 1;
            else
				update SZRATRK
				   set SZRATRK_NE_LIMIT = p_Undeliv,
				   		 SZRATRK_USER_ID = user,
				   		 SZRATRK_ACTIVITY_DATE = sysdate,
				   		 SZRATRK_DATA_ORIGIN = 'SZAANDL'
				 where SZRATRK_ATRK_SEQ_NO = vATRKSeqno;

				 pStatus := 1;
			end if;
      END IF;
      commit;
      exception
        when others then
            rollback;
            pStatus := 0;

  END P_SZAANDL_SAVE_SZRATRK;
  -- EA MHI 14/NOV/2024 [MCLA:002.2.0]

  FUNCTION F_CALCULATE_SESSION(P_Term_Code      Stvterm.Stvterm_Code%Type,
                               P_Crn             Ssbsect.Ssbsect_Crn%Type,
                               p_ptrm_code      Stvptrm.Stvptrm_Code%type) RETURN NUMBER IS
  Cursor Get_Days_C Is
    Select sr.Ssrmeet_Sun_Day sun_day,
           sr.Ssrmeet_Mon_Day mon_day,
           sr.Ssrmeet_Tue_Day tue_day,
           sr.Ssrmeet_Wed_Day wed_day,
           sr.Ssrmeet_Thu_Day thu_day,
           sr.Ssrmeet_Fri_Day fri_day,
           sr.Ssrmeet_Sat_Day sat_day,
           sr.SSRMEET_START_DATE start_date,
           SR.SSRMEET_END_DATE end_date
      FROM SSRMEET sr
     Where sr.Ssrmeet_Term_Code = P_Term_Code
       AND sr.SSRMEET_CRN  = p_crn;

	vWeekDays					number;
	Vexcludedate		        Number;
	Vamount				        Number;

    vDateCurr                   DATE;
    vDOW                        varchar2(1);
    vDateReg                    varchar2(8);

    BEGIN
        vWeekDays := 0;
        vExcludeDate := 0;
        vAmount := 0;

        for rMeet in Get_Days_C loop
            vDateCurr := rMeet.START_DATE;


            while vDateCurr <= rMeet.END_DATE loop
                vDateReg := null;

                -- from 0 (Sunday) to 6 (saturday)
                vDOW := to_char(vDateCurr,'DAY',
                        'NLS_DATE_LANGUAGE=''numeric date language''') ;

                case
                    when vDOW = '0' and rMeet.SUN_DAY is not null then
                        vDateReg := to_char(vDateCurr, 'YYYYMMDD');

                    when vDOW = '1' and rMeet.MON_DAY is not null then
                        vDateReg := to_char(vDateCurr, 'YYYYMMDD');

                    when vDOW = '2' and rMeet.TUE_DAY is not null then
                        vDateReg := to_char(vDateCurr, 'YYYYMMDD');

                    when vDOW = '3' and rMeet.WED_DAY is not null then
                        vDateReg := to_char(vDateCurr, 'YYYYMMDD');

                    when vDOW = '4' and rMeet.THU_DAY is not null then
                        vDateReg := to_char(vDateCurr, 'YYYYMMDD');

                    when vDOW = '5' and rMeet.FRI_DAY is not null then
                        vDateReg := to_char(vDateCurr, 'YYYYMMDD');

                    when vDOW = '6' and rMeet.SAT_DAY is not null then
                        vDateReg := to_char(vDateCurr, 'YYYYMMDD');

                   else
                        vDateReg := null;
                end case;


                if vDateReg is not null   then
                    vExcludeDate := f_exclude_day(vDateCurr, p_ptrm_code);
                    vAmount := vAmount + 1 - vExcludeDate;
                end if;

                vDateCurr := vDateCurr + 1;

            end loop;
        end loop;


      return nvl(vAmount,0);

    END;

  FUNCTION F_EXCLUDE_DAY(P_Date             Date,
                         P_Ptrm_Code        Stvptrm.Stvptrm_Code%Type) return number is
  cursor count_exclude_day_c is
          select count(1)
            from ssrexcl sr
           Where Sr.Ssrexcl_Ptrm_Code = P_Ptrm_Code
             and SR.SSREXCL_EXCLUDE_DATE = p_date;


        vCount          number;
  begin
    vCount := null;


    open count_exclude_day_c;
    fetch count_exclude_day_c into vCount;
    close count_exclude_day_c;


    return nvl(vCount,0);

  End F_Exclude_Day;

  FUNCTION F_SZAMRKS_GET_GRADE( vGradeCode  IN VARCHAR2,
                                vPercentage OUT NUMBER) RETURN NUMBER IS

  CURSOR GET_GRDE_CODE IS
    SELECT DECODE( SHRGRSC_MEDIAN,
                   NULL, ROUND(SHRGRSC_PERCENTAGE),
                   SHRGRSC_MEDIAN
                 ),
           SHRGRSC_PERCENTAGE
      FROM SHRGRSC
     WHERE SHRGRSC_GSCH_NAME = 'UTM'
       AND SHRGRSC_GRDE_CODE = vGradeCode
       AND ROWNUM = 1;
  lv_grade NUMBER(7,2);

  BEGIN
      OPEN GET_GRDE_CODE;
      FETCH GET_GRDE_CODE
       INTO lv_grade,
            vPercentage;
      IF GET_GRDE_CODE%NOTFOUND THEN
        lv_grade := NULL;
        vPercentage := NULL;
      END IF;
      CLOSE GET_GRDE_CODE;
      RETURN lv_grade;
  END F_SZAMRKS_GET_GRADE;


  FUNCTION F_SZAMRKS_GET_SCORE( vGradeCode  IN VARCHAR2,
                                vPercentage OUT NUMBER) RETURN NUMBER IS

  CURSOR GET_GRDE_CODE IS
    -- BA 8.7 [UTM:002.1.1]
    -- SELECT SHRGRSC_PERCENTAGE
    SELECT DECODE( SHRGRSC_MEDIAN,
                   NULL, SHRGRSC_PERCENTAGE,
                   SHRGRSC_MEDIAN
                 ),
           SHRGRSC_PERCENTAGE
    -- EA 8.7 [UTM:002.1.1]
      FROM SHRGRSC
     WHERE SHRGRSC_GSCH_NAME = 'UTM'
       AND SHRGRSC_GRDE_CODE = vGradeCode
       AND ROWNUM = 1;
  lv_grade NUMBER(7,2);

  BEGIN
      OPEN GET_GRDE_CODE;
      FETCH GET_GRDE_CODE
       INTO lv_grade,
            vPercentage;
      IF GET_GRDE_CODE%NOTFOUND THEN
        lv_grade := NULL;
        vPercentage := NULL;
      END IF;
      CLOSE GET_GRDE_CODE;
      RETURN lv_grade;
  END F_SZAMRKS_GET_SCORE;

  FUNCTION F_SZAGSMA_NEW_ASSIGNS(P_SCHM_NUM SZBSCHM.SZBSCHM_SEQNO%TYPE,
                                 P_TERM_CODE  STVTERM.STVTERM_CODE%TYPE,
                                 P_PTRM_CODE  STVPTRM.STVPTRM_CODE%TYPE,
                                 P_GSCH_NAME  SSBSECT.SSBSECT_GSCH_NAME%TYPE,
                                 P_CRN        SSBSECT.SSBSECT_CRN%TYPE) RETURN VARCHAR2 IS

  lv_message    varchar2(100);
  lv_insert_shrgcom_message VARCHAR2(100);

  BEGIN
      BEGIN
        DELETE SHRGCOM
           WHERE SHRGCOM_TERM_CODE = P_TERM_CODE
             AND SHRGCOM_CRN       = P_CRN;

      EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        lv_message := G$_NLS.Get('X', 'FORM','*ERROR* An error occurred while deleting the table SHRGCOM.');
        return lv_message;

      END;

      
      BEGIN
        UPDATE SZBSCHM
             SET SZBSCHM_ASSIGNED_CRN = 'Y'
           WHERE SZBSCHM_SEQNO        = P_SCHM_NUM
             AND SZBSCHM_TERM_CODE    = P_TERM_CODE
             AND SZBSCHM_PTRM_CODE    = P_PTRM_CODE;

        IF SQL%ROWCOUNT = 0 THEN
            ROLLBACK;
            lv_message := G$_NLS.Get('X', 'FORM','*ERROR* The scheme does not match with Term or Part of Term to CRN %01% ', P_CRN) ;
            return lv_message;
        END IF;

        UPDATE SSBSECT
             SET SSBSECT_GSCH_NAME = P_GSCH_NAME
           WHERE SSBSECT_TERM_CODE = P_TERM_CODE
             AND SSBSECT_CRN       = P_CRN;

        EXCEPTION WHEN OTHERS THEN
          ROLLBACK;
           lv_message := G$_NLS.Get('X', 'FORM','*ERROR* An error occurred while updating the table SZBSCHM or SSBSECT.');
           return lv_message;
      END;

      BEGIN
        INSERT INTO  SZRCRNS( SZRCRNS_TERM_CODE,
                             SZRCRNS_PTRM_CODE ,
                             SZRCRNS_CRN,
                             SZRCRNS_SCHM_SEQNO,
                             SZRCRNS_FGRDE_ENTRY,
                             SZRCRNS_FGRDE_ENTRY_EXPT,
                             SZRCRNS_CURRENT_IND,
                             SZRCRNS_USER_ID,
                             SZRCRNS_ACTIVITY_DATE)
          VALUES (P_TERM_CODE,
                  P_PTRM_CODE,
                  P_CRN,
                  P_SCHM_NUM,
                  'N',
                  'N',
                  'Y',
                  USER,
                  SYSDATE);

        EXCEPTION
           WHEN OTHERS THEN
               ROLLBACK;
               lv_message := G$_NLS.Get('X', 'FORM','*ERROR* An error occurred while inserting the table SZRCRNS.');

      END;

      lv_insert_shrgcom_message := F_SZAGSMA_INSERT_SHRGCOM(P_SCHM_NUM,
                                                            P_TERM_CODE,
                                                            P_PTRM_CODE,
                                                            P_CRN,
                                                            P_GSCH_NAME);

      IF UPPER(SUBSTR(lv_insert_shrgcom_message, INSTR(lv_insert_shrgcom_message, '*ERROR*') + 7, 5)) = 'ERROR' THEN
          lv_message := lv_insert_shrgcom_message;
          return lv_message;
      END IF;

      COMMIT;
      lv_message := G$_NLS.Get('X', 'FORM','Assigned scheme %01% ',P_SCHM_NUM);
      return lv_message;

  END F_SZAGSMA_NEW_ASSIGNS;

  FUNCTION F_SZAGSMA_OVR_ASSIGNS(P_SCHM_NUM   SZBSCHM.SZBSCHM_SEQNO%TYPE,
                                 P_TERM_CODE    STVTERM.STVTERM_CODE%TYPE,
                                 P_PTRM_CODE    STVPTRM.STVPTRM_CODE%TYPE,
                                 P_GSCH_NAME    SSBSECT.SSBSECT_GSCH_NAME%TYPE,
                                 P_CRN          SSBSECT.SSBSECT_CRN%TYPE,
                                 P_OLD_SCHM_NUM SZBSCHM.SZBSCHM_SEQNO%TYPE) RETURN VARCHAR2 IS
  CURSOR GET_EXISTS_SZRCRNS_C IS
	     SELECT 'X'
         FROM SZRCRNS
        WHERE SZRCRNS_SCHM_SEQNO =  P_SCHM_NUM
          AND SZRCRNS_CRN        =  P_CRN
          AND SZRCRNS_TERM_CODE  =  P_TERM_CODE
          AND SZRCRNS_PTRM_CODE  =  P_PTRM_CODE;

  lv_exist_assig  VARCHAR2(1);
  lv_message      VARCHAR2(100);
  lv_insert_shrgcom_message VARCHAR2(100);
  BEGIN
      BEGIN
        UPDATE SZBSCHM
             SET SZBSCHM_ASSIGNED_CRN = 'Y'
           WHERE SZBSCHM_SEQNO        = P_SCHM_NUM
             AND SZBSCHM_TERM_CODE    = P_TERM_CODE
             AND SZBSCHM_PTRM_CODE    = P_PTRM_CODE;

        IF SQL%ROWCOUNT = 0 THEN
            ROLLBACK;
            lv_message := G$_NLS.Get('X', 'FORM','*ERROR* The scheme does not match with Term or Part of Term to CRN %01% ', P_CRN);
            return lv_message;
        END IF;

        UPDATE SSBSECT
             SET SSBSECT_GSCH_NAME = P_GSCH_NAME
           WHERE SSBSECT_TERM_CODE = P_TERM_CODE
             AND SSBSECT_CRN       = P_CRN;

      EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        lv_message := G$_NLS.Get('X', 'FORM','*ERROR* An error occurred while updating the table SZBSCHM or SSBSECT.');
        return lv_message;
      END;

      BEGIN
        delete szrmrks ks
            where Ks.Szrmrks_Crn = P_CRN
            and Ks.Szrmrks_Term_Code = P_TERM_CODE;

      exception when others then
         ROLLBACK;
         lv_message := G$_NLS.Get('X', 'FORM','*ERROR* An error occurred while deleting the table SZRMRKS.');
         return lv_message;
      END;

      BEGIN
        DELETE SHRMRKS
               WHERE SHRMRKS_TERM_CODE = P_TERM_CODE
                 AND SHRMRKS_CRN       = P_CRN;

      EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        lv_message := G$_NLS.Get('X', 'FORM','*ERROR* An error occurred while deleting the table SHRMRKS.');
        return lv_message;

      END;

      BEGIN
        DELETE SHRGCOM
           WHERE SHRGCOM_TERM_CODE = P_TERM_CODE
             AND SHRGCOM_CRN       = P_CRN;

      EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        lv_message := G$_NLS.Get('X', 'FORM','*ERROR* An error occurred while deleting the table SHRGCOM.');
        return lv_message;

      END;

      BEGIN
        UPDATE SZRCRNS
            SET SZRCRNS_CURRENT_IND  = 'N'
          WHERE SZRCRNS_TERM_CODE    = P_TERM_CODE
            AND SZRCRNS_PTRM_CODE    = P_PTRM_CODE
            AND SZRCRNS_CRN          = P_CRN
            AND SZRCRNS_SCHM_SEQNO   = P_OLD_SCHM_NUM;


      EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        lv_message := G$_NLS.Get('X', 'FORM','*ERROR* An error occurred while updating the table SZRCRNS.');
        return lv_message;

      END;

      OPEN GET_EXISTS_SZRCRNS_C;
      FETCH GET_EXISTS_SZRCRNS_C INTO lv_exist_assig;
      IF GET_EXISTS_SZRCRNS_C%NOTFOUND THEN
        lv_exist_assig := 'N';
      ELSE
        lv_exist_assig := 'Y';
      END IF;
      CLOSE GET_EXISTS_SZRCRNS_C;

      IF lv_exist_assig = 'N' THEN
        BEGIN
            INSERT INTO  SZRCRNS( SZRCRNS_TERM_CODE,
                      SZRCRNS_PTRM_CODE ,
                      SZRCRNS_CRN,
                      SZRCRNS_SCHM_SEQNO,
                      SZRCRNS_FGRDE_ENTRY,
                      SZRCRNS_FGRDE_ENTRY_EXPT,
                      SZRCRNS_CURRENT_IND,
                      SZRCRNS_USER_ID,
                      SZRCRNS_ACTIVITY_DATE
                    )
             VALUES (P_TERM_CODE,
                     P_PTRM_CODE,
                     P_CRN,
                     P_SCHM_NUM,
                     'N',
                     'N',
                     'Y',
                     USER,
                     SYSDATE);

        EXCEPTION WHEN OTHERS THEN
           ROLLBACK;
           lv_message :=  G$_NLS.Get('X', 'FORM','*ERROR* An error occurred while inserting the table SZRCRNS.');
           RETURN lv_message;


        END;
      ELSE
        BEGIN
           UPDATE SZRCRNS
                SET SZRCRNS_CURRENT_IND  = 'Y'
              WHERE SZRCRNS_TERM_CODE    = P_TERM_CODE
                AND SZRCRNS_PTRM_CODE    = P_PTRM_CODE
                AND SZRCRNS_CRN          = P_CRN
                AND SZRCRNS_SCHM_SEQNO   = P_SCHM_NUM;

        EXCEPTION WHEN OTHERS THEN
           ROLLBACK;
           lv_message := G$_NLS.Get('X', 'FORM','*ERROR* An error occurred while updating the table SZRCRNS.');
           RETURN lv_message;
       END;

      END IF;

      lv_insert_shrgcom_message := F_SZAGSMA_INSERT_SHRGCOM(P_SCHM_NUM,
                                                            P_TERM_CODE,
                                                            P_PTRM_CODE,
                                                            P_CRN,
                                                            P_GSCH_NAME);

      IF UPPER(SUBSTR(lv_insert_shrgcom_message, INSTR(lv_insert_shrgcom_message, '*ERROR*') + 7, 5)) = 'ERROR' THEN
          lv_message := lv_insert_shrgcom_message;
          return lv_message;
      END IF;


      COMMIT;
      lv_message := G$_NLS.Get('X', 'FORM','Overwritten scheme %01% ',P_SCHM_NUM);
      return lv_message;

  END F_SZAGSMA_OVR_ASSIGNS;




  FUNCTION F_SZAGSMA_INSERT_SHRGCOM(P_SCHM_NUM   SZBSCHM.SZBSCHM_SEQNO%TYPE,
                                    P_TERM_CODE  STVTERM.STVTERM_CODE%TYPE,
                                    P_PTRM_CODE  STVPTRM.STVPTRM_CODE%TYPE,
                                    P_CRN        SSBSECT.SSBSECT_CRN%TYPE,
                                    P_GSCH_NAME  SSBSECT.SSBSECT_GSCH_NAME%TYPE) RETURN VARCHAR2 IS

  CURSOR GET_ACTIVITIES_C IS
    SELECT SZRSCHM_SEQNO, SZRSCHM_ACAT_NAME, SZRSCHM_WEIGHT, SZVACAT_DESC
           ,SZRSCHM_INCLUDE_IND    -- 8.7 [UTM:002.1.3]
           ,SZRSCHM_START_DATE
           ,SZRSCHM_DUE_DATE
           ,SZVACAT_FINAL_TEST
           ,SZVACAT_FINAL_PROJ
      FROM SZRSCHM ,  SZVACAT
     WHERE szrschm_term_code  = P_TERM_CODE
       AND szrschm_schm_seqno = P_SCHM_NUM
       AND szrschm_ptrm_code  = P_PTRM_CODE
       AND SZRSCHM_ACAT_NAME  = SZVACAT_NAME;

  lv_seq        NUMBER;
  lv_acat_name  VARCHAR2(10);
  lv_weight     NUMBER;
  lv_desc_actv  VARCHAR2(200);
  lv_incl_ind   VARCHAR2(1);
  lv_message    VARCHAR2(100);
  lv_gcom_id    NUMBER;
  
  lv_start_date DATE;
  lv_due_date DATE;
  lv_final_test VARCHAR2(10);
  lv_final_proj VARCHAR2(10);

  lv_pr_message varchar2(100);
  BEGIN
      OPEN GET_ACTIVITIES_C;

      LOOP
        FETCH GET_ACTIVITIES_C INTO lv_seq , lv_acat_name, lv_weight, lv_desc_actv, lv_incl_ind, lv_start_date, lv_due_date, lv_final_test, lv_final_proj;

        BEGIN
            EXIT WHEN GET_ACTIVITIES_C%NOTFOUND;
            P_CREATE_EXAM_ID(lv_gcom_id);
            lv_pr_message := F_CHECK_SEQ_NO(P_TERM_CODE,
                               P_CRN,
                               '',
                               lv_gcom_id,
                               '',
                               'COMPONENT');

            IF UPPER(SUBSTR(lv_pr_message, INSTR(lv_pr_message, '*ERROR*') + 7, 5)) = 'ERROR' THEN
                lv_message := lv_pr_message;
                return lv_message;
            END IF;

            INSERT INTO SHRGCOM (SHRGCOM_TERM_CODE,
                               SHRGCOM_CRN,
                               SHRGCOM_ID,
                               SHRGCOM_NAME,
                               SHRGCOM_WEIGHT,
                               SHRGCOM_TOTAL_SCORE,
                               SHRGCOM_PASS_IND,
                               SHRGCOM_INCL_IND,
                               SHRGCOM_USER_ID,
                               SHRGCOM_ACTIVITY_DATE,
                               SHRGCOM_START_DATE,
                               SHRGCOM_END_DATE,
                               SHRGCOM_ACTF_TEST,
                               SHRGCOM_ACTF_PROJ,
                               SHRGCOM_DATE,
                               SHRGCOM_SEQ_NO,
                               SHRGCOM_DESCRIPTION,
                               SHRGCOM_GRADE_SCALE,
                               SHRGCOM_COMP_LATE_RULE,
                               SHRGCOM_COMP_RESIT_RULE,
                               SHRGCOM_MIN_PASS_SCORE,
                               SHRGCOM_BEST_OF_SUB,
                               SHRGCOM_SUBSET_OF_SUB,
                               SHRGCOM_SUB_SET,
                               SHRGCOM_ANDOR_SEQ_NO,
                               SHRGCOM_ANONYMOUS_IND,
                               SHRGCOM_DATA_ORIGIN,
                               SHRGCOM_VPDI_CODE
                              )
                      VALUES (P_TERM_CODE,
                              P_CRN,
                              lv_gcom_id,
                              lv_acat_name,
                              lv_weight,
                              100,
                              'N',
                              -- 'F',        -- 8.7 [UTM:002.1.3]
                              lv_incl_ind,   -- 8.7 [UTM:002.1.3]
                              USER,
                              SYSDATE,
                              lv_start_date,
                              lv_due_date,
                              lv_final_test,
                              lv_final_proj,
                              SYSDATE,
                              lv_seq,
                              lv_desc_actv,
                              P_GSCH_NAME,
                              NULL,
                              NULL,
                              70,
                              NULL,
                              NULL,
                              NULL,
                              NULL,
                             'N',
                              NULL,
                              NULL);

        /* BA 8.7 [UTM:002.1.1] */
        shkgcom.P_ShrgcomUpdateProc(P_TERM_CODE,
                                    P_CRN,
                                    lv_gcom_id,
                                    -- 'F',
                                    lv_incl_ind,   -- 8.7 [UTM:002.1.3]
                                    'N',
                                    'INSERT',
                                    SYSDATE);
          /* EA 8.7 [UTM:002.1.1] */
        EXCEPTION WHEN OTHERS THEN
           ROLLBACK;
           lv_message := G$_NLS.Get('X', 'FORM','*ERROR* An error occurred while inserting the table SHRGCOM.');
           return lv_message;
        END;
      END LOOP;
      CLOSE GET_ACTIVITIES_C;

      return lv_pr_message;
  END F_SZAGSMA_INSERT_SHRGCOM;

  PROCEDURE P_CREATE_EXAM_ID (id IN OUT NUMBER) IS
  BEGIN
       SELECT shbgseq.nextval
         INTO id
         FROM dual;

  END P_CREATE_EXAM_ID;


  FUNCTION F_CHECK_SEQ_NO (p_term    in shrgcom.shrgcom_term_code%type,
                           p_crn     in shrgcom.shrgcom_crn%type,
                           p_seq     in shrgcom.shrgcom_andor_seq_no%type,
                           p_gcom_id in shrgcom.shrgcom_id%type,
                           p_scom_id in shrscom.shrscom_id%type,
                           p_mode    in varchar2) RETURN VARCHAR2 IS

    cursor c_shrgcom is
        select 'Y' from shrgcom
        where shrgcom_term_code = p_term
        and shrgcom_crn = p_crn
        and shrgcom_id <> NVL( p_gcom_id, 999999)
        and shrgcom_andor_seq_no = p_seq;

    cursor c_shrscom is
        select 'Y' from shrscom
        where shrscom_term_code = p_term
        and shrscom_crn = p_crn
        and shrscom_gcom_id = p_gcom_id
        and shrscom_id <> NVL( p_scom_id, 999999)
        and shrscom_seq_no = p_seq;

    l_show_error varchar2(1) := 'N';
    lv_message   varchar2(100);
  BEGIN

    if p_mode = 'COMPONENT' then
        open  c_shrgcom;
        fetch c_shrgcom into l_show_error;
        close c_shrgcom;
    end if;

    if p_mode = 'SUB-COMPONENT' then
        open  c_shrscom;
        fetch c_shrscom into l_show_error;
        close c_shrscom;
    end if;


    if nvl(l_show_error,'N') = 'Y' then
        lv_message := G$_NLS.Get('X', 'FORM','*ERROR* Sequence already exists. Please re-enter.');
        return lv_message;
    end if;
    return lv_message;
  END F_CHECK_SEQ_NO;

  FUNCTION F_SZAFTOP_PROCESS_ALLOW_ENTRY(P_CRNS LONG,
                                         P_TERM_CODE STVTERM.STVTERM_CODE%TYPE,
                                         P_PTRM_CODE STVPTRM.STVPTRM_CODE%TYPE,
                                         P_FGRDE_ENTRY VARCHAR2) RETURN VARCHAR2 IS
  CURSOR LIST_CRN IS
	SELECT  TRIM(REGEXP_SUBSTR (P_CRNS, '[^,]+', 1, LEVEL)) CRN
    FROM dual
        CONNECT BY LEVEL < REGEXP_COUNT(P_CRNS, '[,]') + 2;

  CURSOR CHECK_IND(p_crn   VARCHAR2) IS
  SELECT DISTINCT 'Y'
    FROM SSBSECT,
	       SCBSUPP
   WHERE SCBSUPP_SUBJ_CODE  =  SSBSECT_SUBJ_CODE
     AND SSBSECT_CRSE_NUMB  =  SCBSUPP_CRSE_NUMB
  	 AND SSBSECT_TERM_CODE  >=  SCBSUPP_EFF_TERM
  	 AND ( SCBSUPP_CREDIT_CATEGORY_IND <> 'Y'
           OR SCBSUPP_CREDIT_CATEGORY_IND IS NULL )
     AND SSBSECT_TERM_CODE = P_TERM_CODE
	   AND SSBSECT_PTRM_CODE = P_PTRM_CODE
	   AND SSBSECT_CRN       = p_crn;

  lv_rows       NUMBER(6);
  temp_crn      VARCHAR2(20);
  lv_check      VARCHAR2(20);
  lv_flag       NUMBER(8);
  lv_message    VARCHAR2(100);

  BEGIN

	IF P_CRNS IS NULL THEN
        --MESSAGE(G$_NLS.GET('x', 'FORM', '0 rows affected.'));
        lv_message := G$_NLS.GET('x', 'FORM', '0 rows affected.');
        return lv_message;
	ELSIF P_CRNS = '%' THEN
	  UPDATE szrcrns
	     SET SZRCRNS_FGRDE_ENTRY = P_FGRDE_ENTRY,
         SZRCRNS_ACTIVITY_DATE = SYSDATE
	   WHERE szrcrns_term_code = P_TERM_CODE
	     AND szrcrns_ptrm_code = P_PTRM_CODE;
	  lv_rows := sql%rowcount;
      --MESSAGE(G$_NLS.GET('x', 'FORM', TRIM(TO_CHAR(lv_rows, '999G990')) || ' rows affected.'));
      lv_message := G$_NLS.GET('x', 'FORM', TRIM(TO_CHAR(lv_rows, '999G990')) || ' rows affected.');

      COMMIT;

      return lv_message;

	ELSE
		lv_flag := 0;
	  OPEN LIST_CRN;
	  LOOP
	  FETCH LIST_CRN INTO temp_crn;
      p_ban_debug(p_parm => 'F_SZAFTOP_PROCESS_ALLOW_ENTRY'
                ,p_text => 'temp_crn ' || temp_crn
                ,p_user => 'MHerrera');

      DBMS_OUTPUT.PUT_LINE('F_SZAFTOP_PROCESS_ALLOW_ENTRY temp_crn ' || temp_crn);

	  EXIT WHEN LIST_CRN%NOTFOUND;

    OPEN CHECK_IND(temp_crn);
	 FETCH CHECK_IND INTO lv_check;
	 CLOSE CHECK_IND;

	  IF (P_FGRDE_ENTRY = 'Y' OR P_FGRDE_ENTRY = 'N') THEN

	     IF lv_check = 'Y' THEN
             p_ban_debug(p_parm => 'F_SZAFTOP_PROCESS_ALLOW_ENTRY'
                ,p_text => 'lv_check ' || lv_check || ' ' || 'temp_crn ' || temp_crn || ' ' || 'fgrde entry ' || P_FGRDE_ENTRY
                ,p_user => 'MHerrera');

                DBMS_OUTPUT.PUT_LINE('F_SZAFTOP_PROCESS_ALLOW_ENTRY lv_check ' || lv_check || ' ' || 'temp_crn ' || temp_crn || ' ' || 'fgrde entry ' || P_FGRDE_ENTRY);
                 UPDATE szrcrns
                    SET SZRCRNS_FGRDE_ENTRY = P_FGRDE_ENTRY,
                    SZRCRNS_ACTIVITY_DATE = SYSDATE
                  WHERE szrcrns_term_code = P_TERM_CODE
                    AND szrcrns_ptrm_code = P_PTRM_CODE
                    AND szrcrns_crn        = temp_crn;
	            lv_rows := sql%rowcount;

	            lv_flag := lv_flag + lv_rows;
	     END IF;

	   END IF;

	   END LOOP;
	   CLOSE  LIST_CRN;

    COMMIT;
    --MESSAGE(G$_NLS.GET('x', 'FORM', TRIM(TO_CHAR(lv_flag, '999G990')) || ' rows affected.'));
    lv_message := G$_NLS.GET('x', 'FORM', TRIM(TO_CHAR(lv_flag, '999G990')) || ' rows affected.');
    return lv_message;
	END IF;

  END F_SZAFTOP_PROCESS_ALLOW_ENTRY;

  FUNCTION F_SZAFTOP_PROCESS_EXPT_ENTRY(P_CRNS LONG,
                                        P_TERM_CODE STVTERM.STVTERM_CODE%TYPE,
                                        P_PTRM_CODE STVPTRM.STVPTRM_CODE%TYPE,
                                        P_FGRDE_ENTRY_EXPT VARCHAR2) RETURN VARCHAR2 IS

  lv_rows NUMBER(6);
  lv_message VARCHAR2(100);

  BEGIN

	IF P_CRNS IS NULL THEN
        --MESSAGE(G$_NLS.GET('x', 'FORM', '0 rows affected.'));
        lv_message := G$_NLS.GET('x', 'FORM', '0 rows affected.');
        return lv_message;

        NULL;
	ELSIF P_CRNS = '%' THEN
	  UPDATE szrcrns
	     SET SZRCRNS_FGRDE_ENTRY_EXPT = P_FGRDE_ENTRY_EXPT,
         SZRCRNS_ACTIVITY_DATE = SYSDATE
	   WHERE szrcrns_term_code = P_TERM_CODE
	     AND szrcrns_ptrm_code = P_PTRM_CODE;
	    lv_rows := sql%rowcount;
      --MESSAGE(G$_NLS.GET('x', 'FORM', TRIM(TO_CHAR(lv_rows, '999G990')) || ' rows affected.'));
      lv_message := G$_NLS.GET('x', 'FORM', TRIM(TO_CHAR(lv_rows, '999G990')) || ' rows affected.');

      COMMIT; 
      return lv_message;

	ELSE
	  UPDATE szrcrns
	     SET SZRCRNS_FGRDE_ENTRY_EXPT = P_FGRDE_ENTRY_EXPT
	   WHERE (szrcrns_term_code, szrcrns_ptrm_code, szrcrns_crn) IN
           (SELECT P_TERM_CODE, P_PTRM_CODE, TRIM(REGEXP_SUBSTR (P_CRNS, '[^,]+', 1, LEVEL)) CRN
              FROM dual
           CONNECT BY LEVEL < REGEXP_COUNT(P_CRNS, '[,]') + 2);
	  lv_rows := sql%rowcount;
      --MESSAGE(G$_NLS.GET('x', 'FORM', TRIM(TO_CHAR(lv_rows, '999G990')) || ' rows affected.'));
      COMMIT;
      lv_message := G$_NLS.GET('x', 'FORM', TRIM(TO_CHAR(lv_rows, '999G990')) || ' rows affected.');
      return lv_message;

	END IF;

  END F_SZAFTOP_PROCESS_EXPT_ENTRY;

  ------------------------------------------------------------------------------
  -- Functions and Procedures for SSB9 Reports ---------------------------------
  ------------------------------------------------------------------------------


    FUNCTION F_ROLE_ADM_TABLE(p_table_name          ALL_TABLES.TABLE_NAME%TYPE,
                              p_column_name         ALL_TAB_COLUMNS.COLUMN_NAME%TYPE,
                              p_pidm                number,
                              p_term_code           STVTERM.STVTERM_CODE%TYPE,
                              p_value               varchar2,
                              p_role                SORADAS.SORADAS_RADM_CODE%TYPE DEFAULT NULL ) RETURN VARCHAR2 IS


        vDataType           ALL_TAB_COLUMNS.DATA_TYPE%TYPE;
        vDateFormat         varchar2(20);
        vReturn             varchar2(1);
        vOwner              ALL_TABLES.OWNER%TYPE;
        bDummy              BOOLEAN;
        vRule               SORADAS.SORADAS_RULE%type;
        vRAMDCode           SORADAS.SORADAS_RADM_CODE%type;
        bContinue           boolean;



    BEGIN
        vReturn := 'N';
        vRule := null;
        vRAMDCode := null;

       -- vOwner := f_get_owner(p_table_name);



        vDataType := 'VARCHAR2';
        FOR R IN get_rule_c(p_pidm, p_term_code, p_role) loop
            FOR z IN get_assignment_rules_c(p_pidm,
                                          r.SORADAS_RULE,
                                          p_table_name,
                                          p_column_name) LOOP
                bContinue := true;

                if bContinue then
                    IF vDataType = 'DATE' THEN
                        IF Z.SORADDA_OPERATOR = '=' THEN
                            IF to_date(p_value, vDateFormat)
                                    BETWEEN to_date(z.fromvalue, vDateFormat) AND
                                            to_date(z.tovalue, vDateFormat) THEN
                                vReturn := 'Y';
                            END IF;
                        ELSE
                            IF to_date(p_value, vDateFormat)
                                    NOT BETWEEN to_date(z.fromvalue, vDateFormat) AND
                                                to_date(z.tovalue, vDateFormat) THEN
                                vReturn := 'Y';
                            END IF;
                        END IF;
                    ELSE

                        IF Z.SORADDA_OPERATOR = '=' THEN
                            IF p_value BETWEEN z.fromvalue AND z.tovalue THEN
                                vReturn := 'Y';
                            END IF;
                        ELSE
                            IF p_value NOT BETWEEN z.fromvalue AND z.tovalue THEN
                                vReturn := 'Y';
                            END IF;
                        END IF;

                    END IF;

                END if;
            END LOOP;
        end loop;

        --dbms_output.put_line('Resultado: ' || vReturn);

        RETURN vReturn;

    END F_ROLE_ADM_TABLE;
    

    --MHI [LAET:002.2.2] Added Pro*C Funcionality from Banner 8 Package bwzkacrp 28/NOV/2025
    /*
    * BA MHI [LAET:002.2.2] 28/NOV/2025 Added procedure p_UpdateLetterScore for updating SFRSTCR for Pro*C SZPCASC. This procedure comes from Banner 8 Package bwzkacrp
    */
    
    PROCEDURE p_UpdateLetterScore( nPidm NUMBER,
                               nCrn VARCHAR2,
                               nTerm VARCHAR2
                             ) IS

    CURSOR VALID_SUM_SCORE IS
      SELECT SUM(TO_NUMBER(NVL(SHRMRKS_GRDE_CODE,0)))
        FROM SHRMRKS, SHRGCOM
       WHERE SHRGCOM_ID = SHRMRKS_GCOM_ID
         AND SHRMRKS_TERM_CODE = SHRGCOM_TERM_CODE
         AND SHRMRKS_CRN = SHRGCOM_CRN
         AND SHRMRKS_TERM_CODE = nTerm
         AND SHRMRKS_CRN = nCrn
         AND SHRMRKS_PIDM = nPidm;

    CURSOR COUNT_GRDE_CODE IS
      SELECT COUNT(*)
        FROM SHRMRKS, SHRGCOM
       WHERE SHRGCOM_ID = SHRMRKS_GCOM_ID
         AND SHRMRKS_TERM_CODE = SHRGCOM_TERM_CODE
         AND SHRMRKS_CRN = SHRGCOM_CRN
         AND SHRMRKS_TERM_CODE = nTerm
         AND SHRMRKS_CRN = nCrn
         AND SHRMRKS_PIDM = nPidm;

    CURSOR COUNT_GRDE_CODE_SC IS
      SELECT COUNT(*)
        FROM SHRMRKS, SHRGCOM
       WHERE SHRGCOM_ID = SHRMRKS_GCOM_ID
         AND SHRMRKS_TERM_CODE = SHRGCOM_TERM_CODE
         AND SHRMRKS_CRN = SHRGCOM_CRN
         AND SHRMRKS_TERM_CODE = nTerm
         AND SHRMRKS_CRN = nCrn
         AND SHRMRKS_PIDM = nPidm
         AND SHRMRKS_GRDE_CODE = 'SC';
 /*
    CURSOR COUNT_GRDE_CODE_DA IS
      SELECT COUNT(*)
        FROM SHRMRKS, SHRGCOM
       WHERE SHRGCOM_ID = SHRMRKS_GCOM_ID
         AND SHRMRKS_TERM_CODE = SHRGCOM_TERM_CODE
         AND SHRMRKS_CRN = SHRGCOM_CRN
         AND SHRMRKS_TERM_CODE = nTerm
         AND SHRMRKS_CRN = nCrn
         AND SHRMRKS_PIDM = nPidm
         AND SHRMRKS_GRDE_CODE = 'DA';

    CURSOR COUNT_GRDE_CODE_NE IS
      SELECT COUNT(*)
        FROM SHRMRKS, SHRGCOM
       WHERE SHRGCOM_ID = SHRMRKS_GCOM_ID
         AND SHRMRKS_TERM_CODE = SHRGCOM_TERM_CODE
         AND SHRMRKS_CRN = SHRGCOM_CRN
         AND SHRMRKS_TERM_CODE = nTerm
         AND SHRMRKS_CRN = nCrn
         AND SHRMRKS_PIDM = nPidm
         AND SHRMRKS_GRDE_CODE = 'NE';  */  

    CURSOR GET_SFRSTCR_GRDE_CODE IS
      SELECT SFRSTCR_GRDE_CODE
        FROM SFRSTCR
       WHERE SFRSTCR_TERM_CODE = nTerm
         AND SFRSTCR_PIDM      = nPidm
         AND SFRSTCR_CRN       = nCrn;
   
   -- BA 8.5.3 [UTM:002.1.4]       
    CURSOR GET_SHRGCOM_INCL_IND IS
    SELECT DISTINCT(SHRGCOM_INCL_IND) 
      FROM shrgcom
     WHERE shrgcom_crn = nCrn
       AND SHRGCOM_TERM_CODE = nTerm;
  -- EA 8.5.3 [UTM:002.1.4]  
         
    count_total      NUMBER(5) := 0;
    count_sc         NUMBER(5) := 0;
    count_da         NUMBER(5) := 0;
    count_ne         NUMBER(5) := 0;
    shrgcom_ind      VARCHAR2(1 CHAR);
    sum_score        NUMBER(6,2);
    new_grde_code    VARCHAR2(6);

  BEGIN
  
 /*   OPEN VALID_SUM_SCORE;
    FETCH VALID_SUM_SCORE INTO sum_score;
    CLOSE VALID_SUM_SCORE;
    
    EXCEPTION WHEN OTHERS THEN */
    
--   INSERT INTO BANINST1.SZTEST VALUES (nPidm, nCrn);
    
  commit;
  
      OPEN GET_SFRSTCR_GRDE_CODE;
      FETCH GET_SFRSTCR_GRDE_CODE INTO new_grde_code;
      CLOSE GET_SFRSTCR_GRDE_CODE;
      
      IF new_grde_code IS NOT NULL THEN
      
      UPDATE SFRSTCR
         SET SFRSTCR_GRDE_CODE_MID = NULL
       WHERE SFRSTCR_TERM_CODE = nTerm
         AND SFRSTCR_PIDM      = nPidm
         AND SFRSTCR_CRN       = nCrn;
         
      END IF;
      OPEN COUNT_GRDE_CODE;
      FETCH COUNT_GRDE_CODE INTO count_total;
      CLOSE COUNT_GRDE_CODE;

      OPEN COUNT_GRDE_CODE_SC;
      FETCH COUNT_GRDE_CODE_SC INTO count_sc;
      CLOSE COUNT_GRDE_CODE_SC;
 /*   
      OPEN COUNT_GRDE_CODE_DA;
      FETCH COUNT_GRDE_CODE_DA INTO count_da;
      CLOSE COUNT_GRDE_CODE_DA;
    
      OPEN COUNT_GRDE_CODE_NE;
      FETCH COUNT_GRDE_CODE_NE INTO count_ne;
      CLOSE COUNT_GRDE_CODE_NE; */ 
    
  --  IF (count_total = count_sc OR count_total = count_ne OR count_total = count_da) THEN   
   IF (count_total = count_sc ) THEN
   
      OPEN GET_SHRGCOM_INCL_IND;
      FETCH GET_SHRGCOM_INCL_IND INTO shrgcom_ind;
      CLOSE GET_SHRGCOM_INCL_IND;
      
      IF shrgcom_ind = 'M' THEN  --   -- BA 8.5.3 [UTM:002.1.4]  
         
        UPDATE SFRSTCR
           SET SFRSTCR_GRDE_CODE_MID = 0, SFRSTCR_GRDE_CODE = NULL
         WHERE SFRSTCR_TERM_CODE = nTerm
           AND SFRSTCR_PIDM      = nPidm
           AND SFRSTCR_CRN       = nCrn;
         
      ELSIF shrgcom_ind = 'F' THEN
      
        UPDATE SFRSTCR
           SET SFRSTCR_GRDE_CODE = 0, SFRSTCR_GRDE_CODE_MID = NULL
         WHERE SFRSTCR_TERM_CODE = nTerm
           AND SFRSTCR_PIDM      = nPidm
           AND SFRSTCR_CRN       = nCrn;
      
      ELSE
        NULL;
      END IF;
      
      COMMIT;
      
    END IF;
    
  END p_UpdateLetterScore;
   /*
    * EA MHI [LAET:002.2.2] 28/NOV/2025
    */
  
    /*
    * BA MHI [LAET:002.2.2] 28/NOV/2025 Added procedure p_calculateAbscense for calculating abscence value for Pro*C SZPCASD. This procedure comes from Banner 8 Package bwzkacrp
    */
     PROCEDURE p_calculateAbscense(pidm      NUMBER,
                                   pTerm     VARCHAR2,
                                   pCrn      VARCHAR2,
                                   pAbs OUT  NUMBER) IS
    
      CURSOR getStuAbsence_C IS
      SELECT NVL(SZRAATR_ABS_ACCUM, 0) - NVL(SZRAATR_ABS_JSTF, 0) + NVL(SZRAATR_ABS_TRANS, 0) Absence, NVL(SZRAATR_ABS_EXT, 0)
        FROM SZRAATR
       WHERE SZRAATR_CRN       = pCrn
         AND SZRAATR_TERM_CODE = pTerm
         AND SZRAATR_PIDM      = pidm;
    
      CURSOR getCrseSubjPterm IS
      SELECT SSBSECT_PTRM_CODE,
             SSBSECT_SUBJ_CODE,
             SSBSECT_CRSE_NUMB         
        FROM SSBSECT
       WHERE SSBSECT_CRN       = pCrn
         AND SSBSECT_TERM_CODE = pTerm;
         
      CURSOR getCrnAbsence_C(pSubject VARCHAR2, pCrseNumb VARCHAR2, pPartTerm VARCHAR2) IS
      SELECT NVL(SZRATRK_ABS_LIMIT, 0)
             FROM SORATRK, SZRATRK
            WHERE SORATRK_CRN         = pCrn
              AND SORATRK_TERM_CODE   = pTerm
              AND SORATRK_PTRM_CODE   = pPartTerm
              AND SORATRK_SUBJ_CODE   = pSubject
              AND SORATRK_CRSE_NUMB   = pCrseNumb
              AND SZRATRK_ATRK_SEQ_NO = SORATRK_SEQ_NO;
              
      lvPartTerm    VARCHAR2(3);
      lvSubject     VARCHAR2(4);
      lvCrseNumb    VARCHAR2(5);
      
      vStuAbsence   NUMBER(8);
      vCrnAbsence   NUMBER(8);
      vExtAbsence   NUMBER(8); 
      vLimitAbsence   NUMBER(8);
      vTotalAbsence   NUMBER(8);
     
     BEGIN
    
       OPEN getStuAbsence_C;
       FETCH getStuAbsence_C INTO vStuAbsence, vExtAbsence;
       CLOSE getStuAbsence_C;
    
       OPEN getCrseSubjPterm;
       FETCH getCrseSubjPterm INTO lvPartTerm, lvSubject, lvCrseNumb;
       CLOSE getCrseSubjPterm;
    
       OPEN getCrnAbsence_C(lvSubject, lvCrseNumb,  lvPartTerm);
       FETCH getCrnAbsence_C INTO vCrnAbsence;
       CLOSE getCrnAbsence_C;
       
       vLimitAbsence := NVL(vCrnAbsence,0) + ROUND( (NVL(vCrnAbsence,0) * (NVL(vExtAbsence,0) )));
       
       vTotalAbsence := vLimitAbsence - vStuAbsence;
       
       pAbs :=  NVL(vTotalAbsence, 0);
       
     END p_calculateAbscense;
    /*
    * EA MHI [LAET:002.2.2] 28/NOV/2025
    */

    /*
    * BA MHI [LAET:002.2.2] 28/NOV/2025 Added procedure p_calculateDelivery for calculating delivery value for Pro*C SZPCASD. This procedure comes from Banner 8 Package bwzkacrp
    */
     PROCEDURE p_calculateDelivery(pidm       NUMBER,
                                   pTerm      VARCHAR2,
                                   pCrn       VARCHAR2,
                                   pDevs OUT  NUMBER) IS
    
      CURSOR getNoDelivery_C(pPartTerm VARCHAR2) IS
      SELECT NVL(COUNT(*), 0)
              FROM SHRMRKS, SHRGCOM --, SZRCRNS, SZRSCHM BA 8.5.3 [UTM:004.1.7]
             WHERE SHRMRKS_TERM_CODE = pTerm
               AND SHRMRKS_CRN       = pCrn
               AND SHRMRKS_PIDM      = pidm
               AND SHRMRKS_GRDE_CODE = 'NE'
               AND SHRGCOM_TERM_CODE = SHRMRKS_TERM_CODE
               AND SHRGCOM_CRN       = SHRMRKS_CRN
               AND SHRGCOM_ID        = SHRMRKS_GCOM_ID;
          -- BA 8.5.3 [UTM:004.1.7]
          --     AND SZRCRNS_TERM_CODE = SHRMRKS_TERM_CODE
          --     AND SZRCRNS_PTRM_CODE = pPartTerm
          --     AND SZRCRNS_CRN       = SHRGCOM_CRN
          --     AND SZRSCHM_TERM_CODE   = SZRCRNS_TERM_CODE
          --     AND SZRSCHM_PTRM_CODE   = SZRCRNS_PTRM_CODE
          --     AND SZRSCHM_SCHM_SEQNO  = SZRCRNS_SCHM_SEQNO
          --     AND SZRSCHM_ACAT_NAME   = SHRGCOM_NAME
          --     AND SZRSCHM_DELIVER_IND = 'Y';
          -- EA 8.5.3 [UTM:004.1.7]
    
      CURSOR getCrseSubjPterm IS
      SELECT SSBSECT_PTRM_CODE,
             SSBSECT_SUBJ_CODE,
             SSBSECT_CRSE_NUMB         
        FROM SSBSECT
       WHERE SSBSECT_CRN       = pCrn
         AND SSBSECT_TERM_CODE = pTerm;
         
      CURSOR getCrnLimit_C(pSubject VARCHAR2, pCrseNumb VARCHAR2, pPartTerm VARCHAR2) IS
           SELECT NVL(SZRATRK_NE_LIMIT, 0)
             FROM SORATRK, SZRATRK
            WHERE SORATRK_CRN         = pCrn
              AND SORATRK_TERM_CODE   = pTerm
              AND SORATRK_PTRM_CODE   = pPartTerm
              AND SORATRK_SUBJ_CODE   = pSubject
              AND SORATRK_CRSE_NUMB   = pCrseNumb
              AND SZRATRK_ATRK_SEQ_NO = SORATRK_SEQ_NO;
              
      lvPartTerm    VARCHAR2(3);
      lvSubject     VARCHAR2(4);
      lvCrseNumb    VARCHAR2(5);
      
      vStuNoDelivery     NUMBER(8);
      vCrnNoDelivery     NUMBER(8);
      vTotalNoDelivery   NUMBER(8);
     
     BEGIN
    
       OPEN getCrseSubjPterm;
       FETCH getCrseSubjPterm INTO lvPartTerm, lvSubject, lvCrseNumb;
       CLOSE getCrseSubjPterm;
    
       OPEN getNoDelivery_C(lvPartTerm);
       FETCH getNoDelivery_C INTO vStuNoDelivery;
       CLOSE getNoDelivery_C;
    
       OPEN getCrnLimit_C(lvSubject, lvCrseNumb,  lvPartTerm);
       FETCH getCrnLimit_C INTO vCrnNoDelivery;
       CLOSE getCrnLimit_C;
       
       vTotalNoDelivery := NVL(vCrnNoDelivery,0) - NVL(vStuNoDelivery,0);
    
       pDevs :=  NVL(vTotalNoDelivery, 0);
       
     END p_calculateDelivery;
    /*
    * EA MHI [LAET:002.2.2] 28/NOV/2025
    */

     FUNCTION f_isNumber(vScore VARCHAR2)
       RETURN BOOLEAN
       IS
    
         score    NUMBER(8);
    
       BEGIN
       
         score := TO_NUMBER(vScore);
         return (TRUE);
         Exception WHEN OTHERS THEN
         return (FALSE);
    
     END f_isNumber;
 
    /*
    * BA MHI [LAET:002.2.2] 28/NOV/2025 Added procedure f_returnGrdeCode for calculating grade code and value for Pro*C SZPCASD. This procedure comes from Banner 8 Package bwzkacrp
    */
    
     FUNCTION f_returnGrdeCode(vgrde VARCHAR2)
       RETURN VARCHAR2
       IS
    
         score    NUMBER(8);
    
       BEGIN
       
         IF f_isNumber(vgrde) THEN   ---Si es numero regresa el mismo
              RETURN vgrde;
         ELSE
             RETURN '0';
         END IF;
    
     END f_returnGrdeCode;
    /*
    * EA MHI [LAET:002.2.2] 28/NOV/2025
    */
    

END SZKUTIL;

--
/
SHOW ERRORS
SET DEFINE ON