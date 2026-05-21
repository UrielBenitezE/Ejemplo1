/******************************************************************************/
/* szkrol1.sql Copyright 2015 Ellucian Company L.P. and its affiliates.       */
/******************************************************************************/

/******************************************************************************/
/*                                                                            */
/*                    CONFIDENTIAL BUSINESS INFORMATION                       */
/*                                                                            */
/******************************************************************************/
/*                                                                            */
/*  THIS PROGRAM IS PROPRIETARY INFORMATION OF ELLUCIAN AND ITS AFFILIATES AND*/
/*  IS NOT TO BE COPIED, REPRODUCED, LENT OR DISPOSED OF, NOR USED FOR ANY    */
/*  PURPOSE OTHER THAN THAT FOR WHICH IT IS SPECIFICALLY PROVIDED WITHOUT THE */
/*  WRITTEN PERMISSION OF SAID COMPANY.                                       */
/*                                                                            */
/******************************************************************************/
/*                                                                            */
/* FILE NAME..: szkrol1.sql                                                  */
/*                                                                            */
/* RELEASE....: 8.7 [MCLA:002.1.0]                                            */
/*                                                                            */
/* OBJECT NAME: szkrols                                                       */
/*                                                                            */
/* Grade Roll package for BannerStudent System.                               */
/*                                                                            */
/******************************************************************************/
/*                                                                            */
/* AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                            */
/* --------------------------------------------------------  ---  ----------- */
/* 1. Initial Code                                           MKU  Jan/04/2016 */
/*                                                                            */
/*  MOD002- Mejora a la asistencia, HA                                        */
/*  Grade Roll package for BannerStudent System.                              */
/*  Package modified from SHKROLS's original source                           */
/*                                                                            */
/* --------------------------------------------------------  ---  ----------- */
/* AUDIT TRAIL: 8.7 [MCLA:002.1.1]                           INI      Date    */
/* --------------------------------------------------------  ---  ----------- */
/* 1. Se agrega validacion de materia reprobada marcada en   GGR  30-JUN-2017 */
/*     la tabla STVRSTS en la columna STVRSTS_WITHDRAW_IND                    */
/*     Valor 'Y' significa que es un estado de reprobacion                    */
/*     en otro caso, dependera si es evaluable para entrar                    */
/*     a proceso                                                              */
/*                                                                            */
/* --------------------------------------------------------  ---  ----------- */
/*  AUDIT TRAIL: 8.31.2 [MOD:02.2.0]                                          */
/*  -------------------------------------------------------  ---  ----------- */
/*  1. Student version updated from 8.7 to 8.31.2            LMR 07-NOV-2024  */
/*  -------------------------------------------------------  ---  ----------- */
/*                                                                            */
/* AUDIT TRAIL END                                                            */
/*                                                                            */
/* BEGIN COMMENT                                                              */
/*                                                                            */
/*  Grade Roll package for BannerStudent System.                              */
/*                                                                            */
/* END COMMENT                                                                */
/******************************************************************************/


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

CREATE OR REPLACE PACKAGE BODY szkrols AS
  -- FILE NAME..: szkrol1.sql
  -- RELEASE....: 8.7 [MCLA:002.1.1]
  -- OBJECT NAME: szkrols
  -- PRODUCT....: STUDENT
  -- USAGE......: Grade Roll package for BannerStudent System.
  -- COPYRIGHT..: Copyright 2015 Ellucian Company L.P. and its affiliates.
  --
-- DESCRIPTION:
--
-- Grade Roll package for BannerStudent System.
--
  -- Global private variables
  --
/* BA 8.7 [MCLA:002.1.1] GGR 30-JUN-2017 */
/*
  TYPE roll_record IS RECORD(
    pidm                  sfrstcr.sfrstcr_pidm%TYPE,
    term                  sfrstcr.sfrstcr_term_code%TYPE,
    ptrm                  ssbsect.ssbsect_ptrm_code%TYPE,
    crn                   sfrstcr.sfrstcr_crn%TYPE,
    roll_name             VARCHAR2(30),
    roll_id               spriden.spriden_id%TYPE,
    subject               ssbsect.ssbsect_subj_code%TYPE,
    crse_numb             ssbsect.ssbsect_crse_numb%TYPE,
    campus                ssbsect.ssbsect_camp_code%TYPE,
    ctitle                ssbsect.ssbsect_crse_title%TYPE,
    sect_seq              ssbsect.ssbsect_seq_numb%TYPE,
    sess                  ssbsect.ssbsect_sess_code%TYPE,
    grade                 sfrstcr.sfrstcr_grde_code%TYPE,
    regseq                sfrstcr.sfrstcr_reg_seq%TYPE,
    gmod                  sfrstcr.sfrstcr_gmod_code%TYPE,
    attempt_hr            sfrstcr.sfrstcr_credit_hr_hold%TYPE,
    credits               sfrstcr.sfrstcr_credit_hr%TYPE,
    credit_hr_hold        sfrstcr.sfrstcr_credit_hr_hold%TYPE,
    attempt_hr_ind        stvrsts.stvrsts_attempt_hr_ind%TYPE,
    college               ssbovrr.ssbovrr_coll_code%TYPE,
    divs                  ssbovrr.ssbovrr_divs_code%TYPE,
    dept                  ssbovrr.ssbovrr_dept_code%TYPE,
    graddate              sgbstdn.sgbstdn_exp_grad_date%TYPE,
    gradterm              sgbstdn.sgbstdn_term_code_grad%TYPE,
    gradyear              sgbstdn.sgbstdn_acyr_code%TYPE,
    stuterm               sgbstdn.sgbstdn_term_code_eff%TYPE,
    reg_levl              sfrstcr.sfrstcr_levl_code%TYPE,
    acyr_code             stvterm.stvterm_acyr_code%TYPE,
    ptrm_start_date       ssbsect.ssbsect_ptrm_start_date%TYPE,
    ptrm_end_date         ssbsect.ssbsect_ptrm_end_date%TYPE,
    tckn_cont             ssbsect.ssbsect_cont_hr%TYPE,
    schd_code             ssbsect.ssbsect_schd_code%TYPE,
    sdegc_dual            sgbstdn.sgbstdn_degc_code_dual%TYPE,
    slevl_dual            sgbstdn.sgbstdn_levl_code_dual%TYPE,
    sdept_dual            sgbstdn.sgbstdn_dept_code_dual%TYPE,
    scoll_dual            sgbstdn.sgbstdn_coll_code_dual%TYPE,
    smajr_dual            sgbstdn.sgbstdn_majr_code_dual%TYPE,
    compare_sdegc_dual    sgbstdn.sgbstdn_degc_code_dual%TYPE,
    compare_slevl_dual    sgbstdn.sgbstdn_levl_code_dual%TYPE,
    compare_scoll_dual    sgbstdn.sgbstdn_coll_code_dual%TYPE,
    compare_sdept_dual    sgbstdn.sgbstdn_dept_code_dual%TYPE,
    compare_smajr_dual    sgbstdn.sgbstdn_majr_code_dual%TYPE,
    gcmt_code             sfrstcr.sfrstcr_gcmt_code%TYPE,
    number_of_extensions  sfrareg.sfrareg_extension_number%TYPE,
    reg_start_date        sfrareg.sfrareg_start_date%TYPE,
    reg_completion_date   sfrareg.sfrareg_completion_date%TYPE,
    instructor_pidm       sfrareg.sfrareg_instructor_pidm%TYPE,
    long_course_title     ssrsyln.ssrsyln_long_course_title%TYPE,
    grde_code_incmp_final sfrstcr.sfrstcr_grde_code_incmp_final%TYPE,
    incomplete_ext_date   sfrstcr.sfrstcr_incomplete_ext_date%TYPE,
    reg_stsp_key_sequence sfrstcr.sfrstcr_stsp_key_sequence%TYPE);
*/
TYPE roll_record IS RECORD(
     pidm                    NUMBER(8)          
    ,term                    VARCHAR2(6  CHAR)
    ,ptrm                    VARCHAR2(3  CHAR)
    ,crn                     VARCHAR2(5  CHAR)
    ,roll_name               VARCHAR2(30 CHAR)
    ,roll_id                 VARCHAR2(9  CHAR)
    ,subject                 VARCHAR2(4  CHAR)
    ,crse_numb               VARCHAR2(5  CHAR)
    ,campus                  VARCHAR2(3  CHAR)
    ,ctitle                  VARCHAR2(30 CHAR)
    ,sect_seq                VARCHAR2(3  CHAR)
    ,sess                    VARCHAR2(1  CHAR)
    ,grade                   VARCHAR2(6  CHAR)
    ,regseq                  NUMBER(4)
    ,gmod                    VARCHAR2(1  CHAR)
    ,attempt_hr              NUMBER(7,3)
    ,credits                 NUMBER(7,3)
    ,credit_hr_hold          NUMBER(7,3)
    ,attempt_hr_ind          VARCHAR2(1  CHAR)
    ,college                 VARCHAR2(2  CHAR)
    ,divs                    VARCHAR2(4  CHAR)
    ,dept                    VARCHAR2(4  CHAR)
    ,graddate                DATE
    ,gradterm                VARCHAR2(6  CHAR) 
    ,gradyear                VARCHAR2(4  CHAR)
    ,stuterm                 VARCHAR2(6  CHAR)
    ,reg_levl                VARCHAR2(2  CHAR)   
    ,acyr_code               VARCHAR2(4  CHAR)
    ,ptrm_start_date         DATE
    ,ptrm_end_date           DATE
    ,tckn_cont               NUMBER(9,3)
    ,schd_code               VARCHAR2(3 CHAR)
    ,sdegc_dual              VARCHAR2(6 CHAR)
    ,slevl_dual              VARCHAR2(2 CHAR)
    ,sdept_dual              VARCHAR2(4 CHAR)
    ,scoll_dual              VARCHAR2(2 CHAR)
    ,smajr_dual              VARCHAR2(4 CHAR)
    ,compare_sdegc_dual      VARCHAR2(6 CHAR)
    ,compare_slevl_dual      VARCHAR2(2 CHAR)
    ,compare_scoll_dual      VARCHAR2(2 CHAR)
    ,compare_sdept_dual      VARCHAR2(4 CHAR)
    ,compare_smajr_dual      VARCHAR2(4 CHAR)
    ,gcmt_code               VARCHAR2(7 CHAR)
    ,number_of_extensions    NUMBER(3)
    ,reg_start_date          DATE
    ,reg_completion_date     DATE
    ,instructor_pidm         NUMBER(8)
    ,long_course_title       VARCHAR2(100 CHAR)
    ,grde_code_incmp_final   VARCHAR2(6   CHAR)
    ,incomplete_ext_date     DATE
    ,reg_stsp_key_sequence   NUMBER(2) 
);
/* EA 8.7 [MCLA:002.1.1] GGR 30-JUN-2017 */
  --
  grdroll_rec       roll_record;
  gradapp_date      DATE := NULL;
  grst_code         stvgrst.stvgrst_code%type := NULL;
  fee_ind           VARCHAR2(1) := NULL;
  fee_date          DATE := NULL;
  complete_term     stvterm.stvterm_code%type;
  sfrstcr_row       sfrstcr%ROWTYPE;
  sgrchrt_row       sgrchrt%ROWTYPE;
  shbcgpa_row       shbcgpa%ROWTYPE;
  shrattc_row       shrattc%ROWTYPE;
  shrchrt_row       shrchrt%ROWTYPE;
  shrdgmr_row       shrdgmr%ROWTYPE;
  shrgcol_row       shrgcol%ROWTYPE;
  shrgpac_row       shrgpac%ROWTYPE;
  shrgpal_i_row     shrgpal%ROWTYPE;
  shrgpal_o_row     shrgpal%ROWTYPE;
  shrgrdo_row       shrgrdo%ROWTYPE;
  shrgrds_row       shrgrds%ROWTYPE;
  shrinst_row       sirasgn%ROWTYPE; -- change for vpd
  shrlgpa_i_row     shrlgpa%ROWTYPE;
  shrlgpa_o_row     shrlgpa%ROWTYPE;
  shrtckd_row       shrtckd%ROWTYPE;
  shrtckg_row       shrtckg%ROWTYPE;
  shrtckl_row       shrtckl%ROWTYPE;
  shrtckn_row       shrtckn%ROWTYPE;
  shrtgpa_row       shrtgpa%ROWTYPE;
  shrttrm_row       shrttrm%ROWTYPE;
  sotprnt_row       sotprnt%ROWTYPE;
  sobctrl_row       sobctrl%ROWTYPE;
  gv_update_mode    VARCHAR2(1);
  gv_grade_roll_ind VARCHAR2(1) := NULL;
  smajr             sorlfos.sorlfos_majr_code%TYPE;
  slevl             sorlcur.sorlcur_levl_code%TYPE;
  sdegc             sorlcur.sorlcur_degc_code%TYPE;
  scampus           sorlcur.sorlcur_camp_code%TYPE;
  scoll             sorlcur.sorlcur_coll_code%TYPE;
  sprogram          sorlcur.sorlcur_program%TYPE;
  schange           VARCHAR2(1) := 'N';
  default_status    stvcact.stvcact_code%TYPE;
  lv_cact_code      stvcact.stvcact_code%TYPE;
  lv_csts_code      stvcsts.stvcsts_code%TYPE;
  lv_curriculum_rec sb_curriculum.curriculum_rec; /*BIEN*/
  api_error         VARCHAR2(1) := 'N';
  api_lfst_error    VARCHAR2(1) := 'N';
  api_err_msg       VARCHAR2(120) := '';
  --
  commit_count     PLS_INTEGER := 0;
  dgmr_seq         shrdgmr.shrdgmr_seq_no%TYPE;
  dgmr_seq1        sotprnt.sotprnt_seqno_1%TYPE;
  dgmr_seq2        sotprnt.sotprnt_seqno_2%TYPE;
  next_dgmr_seqno  shrdgmr.shrdgmr_seq_no%TYPE;
  gradapp_seqno    shbgapp.shbgapp_seqno%TYPE := NULL;
  dgmr_stsp        shrdgmr.shrdgmr_stsp_key_sequence%type := NULL;
  tckg_seq         shrtckg.shrtckg_seq_no%TYPE;
  tckn_seq         shrtckn.shrtckn_seq_no%TYPE;
  attr_code        ssrattr.ssrattr_attr_code%TYPE;
  deg1_created     sotprnt.sotprnt_deg1_created_ind%TYPE;
  deg2_created     sotprnt.sotprnt_deg2_created_ind%TYPE;
  deg1_updated     sotprnt.sotprnt_deg1_updated_ind%TYPE;
  deg2_updated     sotprnt.sotprnt_deg2_updated_ind%TYPE;
  grade_sub        shrtckg.shrtckg_grde_code_final%TYPE;
  attempt_hr_sub   shrtckg.shrtckg_hours_attempted%TYPE;
  cgpa_ind         shbcgpa.shbcgpa_camp_gpa_ind%TYPE;
  sect_crn         ssbsect.ssbsect_crn%TYPE;
  sect_ptrm        ssbsect.ssbsect_ptrm_code%TYPE;
  ptrm_parm        ssbsect.ssbsect_ptrm_code%TYPE;
  term_parm        ssbsect.ssbsect_term_code%TYPE;
  from_date_parm   DATE; --Defect 1-DOUZX: Change to Date from VARCHAR
  to_date_parm     DATE; --Defect 1-DOUZX: Change to Date From VARCHAR
  grade_term_parm  shrtckg.shrtckg_term_code_grade%TYPE;
  roll_title_parm  VARCHAR2(1);
  crn_parm         ssbsect.ssbsect_crn%TYPE;
  user_parm        shrtckg.shrtckg_final_grde_chg_user%TYPE;
  sessionid_parm   sprcolr.sprcolr_sessionid%TYPE;
  print_sel_parm   VARCHAR2(1);
  report_mode_parm VARCHAR2(1);
  gv_err_msg       VARCHAR2(4000);
   gradebook_reroll_pidm_parm sfrstcr.sfrstcr_pidm%TYPE;
  insert_new_degr  VARCHAR2(1) := 'N';
  insert_new_curr  VARCHAR2(1) := 'N';

  -- BA 8.7 [MCLA:002.1.0]
  level_parm       STVLEVL.STVLEVL_CODE%type;
  campus_parm      STVCAMP.STVCAMP_CODE%type;
    -- BA 8.7 [MCLA:002.1.0]
  --
  row_found  BOOLEAN;
  holdgcol   BOOLEAN;
  holdgcol_p BOOLEAN;
  holdgpac   BOOLEAN;
  holdgpal_i BOOLEAN;
  holdgpal_o BOOLEAN;
  holdgrdo   BOOLEAN;
  holdgrds   BOOLEAN;
  holdinst   BOOLEAN;
  holdlgpa_i BOOLEAN;
  holdlgpa_o BOOLEAN;
  holdtckg   BOOLEAN;
  holdtckn   BOOLEAN;
  holdtgpa   BOOLEAN;
  --
  --
  --
  -- global variable to allow printing of debug messages
  gv_print varchar2(1) := 'x';

  /* ******************************************************************* */
  /* Procedure to print debug messages                                   */
  /* ******************************************************************* */
  PROCEDURE p_print_dbms(dbms_msg_in IN VARCHAR2) IS
  BEGIN
    -- execute with this statement gb_common.p_set_context('szkrols','PRINT', 'Y,'N');
    --  proceeding the szkrols  to get all dbms messages to display

    gv_print := 'n'; --- := NVL(gb_common.f_get_context('szkrols', 'PRINT'), 'N');


    IF gv_print = 'Y' THEN
      dbms_output.put_line(dbms_msg_in);
    END IF;

  END p_print_dbms;

  -- Return a grade change code from stvgchg for the given grade change attribute code.
  FUNCTION f_select_stvgcat_gchg( stvgcat_code IN stvgcat.stvgcat_code%TYPE
                                ) RETURN stvgchg.stvgchg_code%TYPE
  IS
    gchg_code stvgchg.stvgchg_code%TYPE;
    CURSOR stvgchg_c IS
      SELECT stvgchg_code
          FROM stvgchg
      WHERE stvgchg_gcat_code = stvgcat_code;
  BEGIN
      OPEN stvgchg_c;
      FETCH stvgchg_c INTO gchg_code;
      CLOSE stvgchg_c;
      RETURN gchg_code;
  END f_select_stvgcat_gchg;

  PROCEDURE p_init_sotprnt IS
  BEGIN
    sotprnt_row.sotprnt_rectype          := '';
    sotprnt_row.sotprnt_id               := '';
    sotprnt_row.sotprnt_name             := '';
    sotprnt_row.sotprnt_crn              := '';
    sotprnt_row.sotprnt_term_code        := '';
    sotprnt_row.sotprnt_ptrm_code        := '';
    sotprnt_row.sotprnt_subj_code        := '';
    sotprnt_row.sotprnt_crse_numb        := '';
    sotprnt_row.sotprnt_crse_title       := '';
    sotprnt_row.sotprnt_levl_code_1      := '';
    sotprnt_row.sotprnt_degc_code_1      := '';
    sotprnt_row.sotprnt_coll_code_1      := '';
    sotprnt_row.sotprnt_majr_code_1      := '';
    sotprnt_row.sotprnt_camp_code        := '';
    sotprnt_row.sotprnt_seqno_1          := '';
    sotprnt_row.sotprnt_levl_code_2      := '';
    sotprnt_row.sotprnt_degc_code_2      := '';
    sotprnt_row.sotprnt_coll_code_2      := '';
    sotprnt_row.sotprnt_majr_code_2      := '';
    sotprnt_row.sotprnt_seqno_2          := '';
    sotprnt_row.sotprnt_deg1_updated_ind := '';
    sotprnt_row.sotprnt_deg1_created_ind := '';
    sotprnt_row.sotprnt_deg2_updated_ind := '';
    sotprnt_row.sotprnt_deg2_created_ind := '';
    sotprnt_row.sotprnt_recnum           := sotprnt_row.sotprnt_recnum + 1;
  END p_init_sotprnt;
  --
  --

    -- check corequisite rules
    procedure p_check_corequisite_crn(p_pidm              number,
                                    p_crn               SSBSECT.SSBSECT_CRN%type,
                                    p_term_code         SSBSECT.SSBSECT_TERM_CODE%type,
                                    p_grade_code        sfrstcr.sfrstcr_grde_code%TYPE,
                                    p_mode          out varchar2,
                                    p_mens_error    out varchar2) is

      cursor get_grade_crn(pSubjCode        varchar2,
                           pCrseNum         varchar2) is
         SELECT  trim(CR.SFRSTCR_GRDE_CODE)
           FROM ssbsect sb, sfrstcr cr
          WHERE CR.SFRSTCR_CRN = SB.SSBSECT_CRN
            and CR.SFRSTCR_TERM_CODE = SB.SSBSECT_TERM_CODE
            and CR.SFRSTCR_PIDM = p_pidm
            and SB.SSBSECT_TERM_CODE = p_term_code
            and SB.SSBSECT_CRSE_NUMB = pCrseNum
            and SB.SSBSECT_SUBJ_CODE = pSubjCode
            /* BA 8.7 [MCLA:002.1.1] GGR 30-JUN-2017 */
            /*
            and (NVL(SFRSTCR_ERROR_FLAG,'N') <> 'F')
                AND (CR.SFRSTCR_ERROR_FLAG not in ('F','D')
                    or CR.SFRSTCR_ERROR_FLAG is null
                    or CR.SFRSTCR_RSTS_CODE in (select stvrsts_code
                                               from stvrsts
                                              where stvrsts_code = CR.SFRSTCR_RSTS_CODE
                                                and stvrsts_gradable_ind = 'Y'));
            */
            and ( NVL(SFRSTCR_ERROR_FLAG,'N') <> 'F' )
            and CR.SFRSTCR_RSTS_CODE in (select stvrsts_code
                                           from stvrsts
                                          where stvrsts_code = CR.SFRSTCR_RSTS_CODE
                                            and stvrsts_gradable_ind = 'Y'
                                            and stvrsts_withdraw_ind = 'N'
                                            and stvrsts_code Not In ('BG','BM','DW','WL')
                                        );
            /* EA 8.7 [MCLA:002.1.1] GGR 30-JUN-2017 */

      cursor get_corequisite is
        SELECT CO.SCRCORQ_CRSE_NUMB_CORQ, CO.SCRCORQ_SUBJ_CODE_CORQ
           FROM scrcorq co, ssbsect sb
          WHERE SB.SSBSECT_CRSE_NUMB = CO.SCRCORQ_CRSE_NUMB
            and SB.SSBSECT_SUBJ_CODE = CO.SCRCORQ_SUBJ_CODE
            and SB.SSBSECT_TERM_CODE = p_term_code
            and SB.SSBSECT_CRN = p_crn
            AND co.scrcorq_eff_term =
                 (SELECT MAX (scrcorq_eff_term)
                    FROM scrcorq
                   WHERE scrcorq_subj_code = co.scrcorq_subj_code
                     AND scrcorq_crse_numb = co.scrcorq_crse_numb
                     AND scrcorq_eff_term <= p_term_code)
          ORDER BY co.scrcorq_subj_code_corq, co.scrcorq_crse_numb_corq;

        vGrade          SFRSTCR.SFRSTCR_GRDE_CODE%type;
        vMensMiss       varchar2(200);
        vMensDiff       varchar2(200);
    begin
        p_mode := 'NATIVE';
        p_mens_error := null;
        vMensMiss := null;
        vMensDiff := null;

        for r in get_corequisite loop
            -- get co-req's grade
            vGrade := null;

            open get_grade_crn(r.SCRCORQ_SUBJ_CODE_CORQ, r.SCRCORQ_CRSE_NUMB_CORQ);
            fetch get_grade_crn into vGrade;
            close get_grade_crn;

            if vGrade is null then
                vMensMiss := g$_nls.get('X','SQL','Corequisite grade missing');
            elsif vGrade <> p_grade_code then
                vMensDiff := g$_nls.get('X','SQL','Different corequisite grades');
            end if;


        end loop;

        if vMensMiss is not null then
            p_mens_error := vMensMiss;
            p_mode := 'CRQGDM';

        elsif vMensDiff is not null then
            p_mens_error := vMensDiff;
            p_mode := 'CRQGDF';

        end if;


    end p_check_corequisite_crn;

  -- BA 8.7 [MCLA:002.1.0]  -- Addendum   MKU  17/FEB/2016
  procedure p_check_optative(p_pidm              number,
                             p_crn               SSBSECT.SSBSECT_CRN%type,
                             p_term_code         SSBSECT.SSBSECT_TERM_CODE%type,
                             p_study_path        SGRSTSP.SGRSTSP_KEY_SEQNO%type,
                             p_mens_error    out varchar2) is

    cursor get_study_path_program_c is
        SELECT SOVLCUR_PROGRAM
          FROM sovlcur, sgvstsp
         WHERE sgvstsp_pidm = p_pidm
           AND (sgvstsp_astd_code IS NULL OR EXISTS
                (SELECT 'X'
                   FROM stvastd
                  WHERE stvastd_code = sgvstsp_astd_code
                    AND NVL(stvastd_prevent_reg_ind, 'N') = 'N'))
           AND (sgvstsp_cast_code IS NULL OR EXISTS
                (SELECT 'X'
                   FROM stvcast
                  WHERE stvcast_code = sgvstsp_cast_code
                    AND stvcast_prevent_reg_ind = 'N'))
           AND sgvstsp_term_code_eff =
               (SELECT MAX(m.sgrstsp_term_code_eff)
                  FROM sgrstsp m
                 WHERE m.sgrstsp_pidm = sgvstsp_pidm
                   AND m.sgrstsp_key_seqno = sgvstsp_key_seqno
                   AND m.sgrstsp_term_code_eff <= p_term_code)
           AND sgvstsp_enroll_ind = 'Y'
           AND sovlcur_current_ind = 'Y'
           AND sovlcur_active_ind = 'Y'
           AND sovlcur_pidm = sgvstsp_pidm
           AND sovlcur_key_seqno = sgvstsp_key_seqno
           AND sovlcur_lmod_code = sb_curriculum_str.f_learner /*BIEN*/
           and sgvstsp_key_seqno = p_study_path
           AND NOT EXISTS (SELECT 'X'
                  FROM stvests, sfrensp
                 WHERE sfrensp_pidm = sgvstsp_pidm
                   AND sfrensp_term_code = p_term_code
                   AND sfrensp_key_seqno = sgvstsp_key_seqno
                   AND sfrensp_ests_code = stvests_code
                   AND stvests_prev_reg = 'Y');

    cursor check_szrelec_c(cProgram     varchar2) is
       SELECT ec.SZRELEC_ATTR_CODE
         FROM szrelec ec
         where EC.SZRELEC_PIDM = p_pidm
           and EC.SZRELEC_CRN = p_crn
           and EC.SZRELEC_TERM_CODE = p_term_code
           and ec.SZRELEC_PROGRAM = cProgram
           and nvl(EC.SZRELEC_AH_STATUS,'X') <> 'Y' ;

    cursor check_shrtckn_c is
        SELECT KN.SHRTCKN_SEQ_NO
          FROM SHRTCKN KN
         where KN.SHRTCKN_PIDM = p_pidm
           and KN.SHRTCKN_TERM_CODE = p_term_code
           and KN.SHRTCKN_CRN = p_crn
           and nvl(KN.SHRTCKN_STSP_KEY_SEQUENCE, p_study_path) = p_study_path;

    vProgram            SMRPRLE.SMRPRLE_PROGRAM%type;
    vDummy              varchar2(1);
    vTCKNSeqno          SHRTCKN.SHRTCKN_SEQ_NO%type;
    vAttrCode           SHRATTR.SHRATTR_ATTR_CODE%type;
  begin

    vProgram := null;
    p_mens_error := null;
    vDummy := null;
    vTCKNSeqno := null;
    vAttrCode := null;

    open get_study_path_program_c;
    fetch get_study_path_program_c into vProgram;
    close get_study_path_program_c;

    -- check if it exists on SZRELEC table and SZRELEC_AH_STATUS <> 'Y'
    -- and get attr_code
    open check_szrelec_c(vProgram);
    fetch check_szrelec_c into vAttrCode;
    close check_szrelec_c;

    if vAttrCode is null then
        return;
    end if;

    open check_shrtckn_c;
    fetch check_shrtckn_c into vTCKNSeqno;
    close check_shrtckn_c;

    if vTCKNSeqno is not null then
        begin
            insert into SHRATTR(SHRATTR_PIDM, /*BIEN*/
                                SHRATTR_TERM_CODE,
                                SHRATTR_TCKN_SEQ_NO,
                                SHRATTR_ATTR_CODE,
                                SHRATTR_ACTIVITY_DATE,
                                SHRATTR_SURROGATE_ID,
                                SHRATTR_VERSION,
                                SHRATTR_USER_ID,
                                SHRATTR_DATA_ORIGIN
                                )
                         values(p_pidm,
                                p_term_code,
                                vTCKNSeqno,
                                vAttrCode,
                                sysdate,
                                SHRATTR_SURROGATE_ID_SEQUENCE.nextval,
                                0,
                                user,
                                'SZKROLS'
                                );
        exception
            when others then
                p_mens_error := 'NOHIST';

        end;

    else
        p_mens_error := 'NOHIST';
    end if;


  end p_check_optative;
  -- EA 8.7 [MCLA:002.1.0]  -- Addendum   MKU  17/FEB/2016


  PROCEDURE p_generate_api_error(p_err VARCHAR2) IS
  BEGIN
    IF (NVL(report_mode_parm, 'N') <> 'O') AND
       (upper(NVL(print_sel_parm, 'X')) <> 'E') THEN
      p_init_sotprnt;
      sotprnt_row.sotprnt_rectype := 'APIERR';
      sotprnt_row.sotprnt_id      := grdroll_rec.roll_id;
      sotprnt_row.sotprnt_name    := grdroll_rec.roll_name;
      INSERT INTO sotprnt /*BIEN*/
        (sotprnt_sessionid,
         sotprnt_activity_date,
         sotprnt_job,
         sotprnt_rectype,
         sotprnt_id,
         sotprnt_name,
         sotprnt_crn,
         sotprnt_recnum,
         sotprnt_err_msg,
         sotprnt_term_code)
      VALUES
        (sotprnt_row.sotprnt_sessionid,
         sotprnt_row.sotprnt_activity_date,
         sotprnt_row.sotprnt_job,
         sotprnt_row.sotprnt_rectype,
         sotprnt_row.sotprnt_id,
         sotprnt_row.sotprnt_name,
         sotprnt_row.sotprnt_crn,
         sotprnt_row.sotprnt_recnum,
         SUBSTR(REPLACE(REPLACE(REPLACE(REPLACE(p_err, ';', ''), ':', ''),
                                gb_event.APP_ERROR,
                                ''),
                        'ORA',
                        ''),
                1,
                120),
         sotprnt_row.sotprnt_term_code);
    ELSE
      gv_err_msg := gv_err_msg ||
                    SUBSTR(REPLACE(REPLACE(REPLACE(REPLACE(p_err, ';', ''),
                                                   ':',
                                                   ''),
                                           gb_event.APP_ERROR,
                                           ''),
                                   'ORA',
                                   ''),
                           1,
                           120);
    END IF;
  END p_generate_api_error;
  --
  --
  PROCEDURE p_generate_report IS
    lv_fieldofstudy_cur sb_fieldofstudy.fieldofstudy_ref; /*BIEN*/
    lv_fieldofstudy_rec sb_fieldofstudy.fieldofstudy_rec; /*BIEN*/
  BEGIN
    IF (NVL(report_mode_parm, 'N') <> 'O') AND
       (upper(NVL(print_sel_parm, 'X')) <> 'E') THEN
      IF smajr IS NULL AND lv_curriculum_rec.r_seqno IS NOT NULL THEN
        lv_fieldofstudy_cur := sb_fieldofstudy.f_query_current(p_pidm       => grdroll_rec.pidm, /*BIEN*/
                                                               p_lfst_code  => sb_fieldofstudy_str.f_major, /*BIEN*/
                                                               p_lcur_seqno => lv_curriculum_rec.r_seqno, /*BIEN*/
                                                               p_active_ind => 'Y');
        FETCH lv_fieldofstudy_cur
          INTO lv_fieldofstudy_rec;
        IF lv_fieldofstudy_cur%NOTFOUND THEN
          smajr := '';
        ELSE
          smajr := lv_fieldofstudy_rec.r_majr_code;
        END IF;
        CLOSE lv_fieldofstudy_cur;
      END IF;
      p_init_sotprnt;
      sotprnt_row.sotprnt_rectype          := 'STUDNT';
      sotprnt_row.sotprnt_id               := grdroll_rec.roll_id;
      sotprnt_row.sotprnt_name             := grdroll_rec.roll_name;
      sotprnt_row.sotprnt_degc_code_1      := sdegc;
      --sotprnt_row.sotprnt_levl_code_1      := slevl;              --  8.7 [MCLA:002.1.0] Changed
      sotprnt_row.sotprnt_levl_code_1      := grdroll_rec.reg_levl; --  8.7 [MCLA:002.1.0] Added
      sotprnt_row.sotprnt_coll_code_1      := scoll;
      sotprnt_row.sotprnt_majr_code_1      := smajr;
      sotprnt_row.sotprnt_crse_title       := sprogram;
      sotprnt_row.sotprnt_seqno_1          := dgmr_seq;
      --sotprnt_row.sotprnt_camp_code        := scampus;            --  8.7 [MCLA:002.1.0] Changed
      sotprnt_row.sotprnt_camp_code        := grdroll_rec.campus;   --  8.7 [MCLA:002.1.0] Added
      sotprnt_row.sotprnt_degc_code_2      := NULL;
      sotprnt_row.sotprnt_levl_code_2      := NULL;
      sotprnt_row.sotprnt_coll_code_2      := NULL;
      sotprnt_row.sotprnt_majr_code_2      := NULL;
      sotprnt_row.sotprnt_seqno_2          := NULL;
      sotprnt_row.sotprnt_deg1_updated_ind := deg1_updated;
      sotprnt_row.sotprnt_deg1_created_ind := deg1_created;
      sotprnt_row.sotprnt_deg2_updated_ind := deg2_updated;
      sotprnt_row.sotprnt_deg2_created_ind := deg2_created;
      shkmods.p_insert_sotprnt(sotprnt_row);
    END IF;
    sdegc    := '';
    slevl    := '';
    scoll    := '';
    smajr    := '';
    scampus  := '';
    sprogram := '';
  END p_generate_report;
  --
  --
  PROCEDURE p_insert_shrtckd(p_tckn_term  stvterm.stvterm_code%type,
                             p_tckn_seqno shrtckd.shrtckd_tckn_seq_no%TYPE) IS
    CURSOR find_tckd(p_pidm shrtckd.shrtckd_pidm%TYPE, p_dgmr_seqno shrtckd.shrtckd_dgmr_seq_no%TYPE, p_tckn_seqno shrtckd.shrtckd_tckn_seq_no%TYPE, p_term_code shrtckd.shrtckd_term_code%TYPE) IS
      SELECT 'x'
        FROM shrtckd
       WHERE shrtckd_pidm = p_pidm
         AND shrtckd_term_code = p_term_code
         AND shrtckd_tckn_seq_no = p_tckn_seqno
         AND shrtckd_dgmr_seq_no = p_dgmr_seqno;
    dummy VARCHAR2(1) := NULL;
  BEGIN
    p_print_dbms('start of apply tckd: ' || dgmr_seq || ' stsp: ' ||
                 dgmr_stsp || ' crse stsp ' ||
                 grdroll_rec.reg_stsp_key_sequence || ' crn: ' ||
                 grdroll_rec.crn);
    -- only roll if there is no study path,  or the course has the same study path as the degree
    IF (shbcgpa_row.shbcgpa_roll_study_path_ind = 'Y' AND
       ((grdroll_rec.reg_stsp_key_sequence IS NULL AND dgmr_stsp IS NULL) OR
       (grdroll_rec.reg_stsp_key_sequence IS NOT NULL AND
       dgmr_stsp IS NOT NULL AND
       grdroll_rec.reg_stsp_key_sequence = dgmr_stsp))) OR
       (shbcgpa_row.shbcgpa_roll_study_path_ind = 'N') THEN
      OPEN find_tckd(p_pidm       => grdroll_rec.pidm,
                     p_term_code  => p_tckn_term,
                     p_dgmr_seqno => dgmr_seq,
                     p_tckn_seqno => p_tckn_seqno);
      FETCH find_tckd
        INTO dummy;
      IF find_tckd%NOTFOUND THEN
        p_print_dbms('insert tckd : ' || dgmr_seq || ' tckn: ' ||
                     p_tckn_seqno || ' term: ' || p_tckn_term || ' sp: ' ||
                     grdroll_rec.reg_stsp_key_sequence);
        shrtckd_row.shrtckd_pidm          := grdroll_rec.pidm;
        shrtckd_row.shrtckd_term_code     := p_tckn_term;
        shrtckd_row.shrtckd_tckn_seq_no   := p_tckn_seqno;
        shrtckd_row.shrtckd_dgmr_seq_no   := dgmr_seq;
        shrtckd_row.shrtckd_activity_date := SYSDATE;
        shrtckd_row.shrtckd_applied_ind   := 'Y';
        shkmods.p_insert_shrtckd(shrtckd_row);
      END IF;
      CLOSE find_tckd;
    END IF;
  END p_insert_shrtckd;
  --
  --
  --
  --     P_grst_code       stvgrst.stvgrst_code%type default null,
  --       P_graduation_date   date  default null,
  --        P_acyr_code       stvacyr.stvacyr_code%type default null,
  --        P_fee_ind           shrdgmr.shrdgmr_fee_ind%type default null,
  --        p_fee_date         date  default null,
  --        P_term_code_grad  stvterm.stvterm_code%type default null,
  --       p_term_code_completed stvterm.stvterm_code%type default null,
  PROCEDURE p_insert_degree(p_acyr_code           stvacyr.stvacyr_code%TYPE,
                            p_term_code_grad      stvterm.stvterm_code%TYPE,
                            p_expected_grad_date  DATE,
                            P_grst_code           stvgrst.stvgrst_code%type DEFAULT NULL,
                            P_fee_ind             shrdgmr.shrdgmr_fee_ind%type DEFAULT NULL,
                            p_fee_date            DATE DEFAULT NULL,
                            p_term_code_completed stvterm.stvterm_code%type DEFAULT NULL) IS
    degc_row          VARCHAR2(18);
    Lv_acyr_code      stvacyr.stvacyr_code%type := NULL;
    Lv_grad_term      stvterm.stvterm_code%type := NULL;
    Lv_grad_date      DATE := NULL;
    stvgrst_rec       stvgrst%rowtype;
    stvdegs_rec       stvdegs%rowtype;
    new_degs_code     stvdegs.stvdegs_code%type := 'SO';
    default_degs_code stvdegs.stvdegs_code%type := 'SO';
  BEGIN
    --- use the graduation fields from sorlcur first, and if null use the ones
    --- from sgbstdn
    lv_grad_term := p_term_code_grad;
    lv_acyr_code := p_acyr_code;
    lv_grad_date := p_expected_grad_date;
    p_print_dbms('in insert degree: ' || next_dgmr_seqno || ' stsp: ' ||
                 dgmr_stsp || ' grst ' || grst_code || ' app date ' ||
                 gradapp_date || ' grad date ' || lv_grad_date || ' fee ' ||
                 fee_ind || ' fee date ' || fee_date);
    ---  move degs code to the next value if the grad status rules require it
    --- 8.2.1 progress degree to next status based on grst code
    IF p_grst_code IS NOT NULL THEN
      OPEN sb_stvgrst.stvgrst_c(p_code => p_grst_code);
      FETCH sb_stvgrst.stvgrst_c
        INTO stvgrst_rec;
      CLOSE sb_stvgrst.stvgrst_c;
      IF stvgrst_rec.stvgrst_updt_nxt_stat_ind = 'Y' THEN
        OPEN sb_stvdegs.stvdegs_c(p_code => default_degs_code);
        FETCH sb_stvdegs.stvdegs_c
          INTO stvdegs_rec;
        CLOSE sb_stvdegs.stvdegs_c;
        IF stvdegs_rec.stvdegs_next_status IS NOT NULL THEN
          new_degs_code := stvdegs_rec.stvdegs_next_status;
        END IF;
      END IF;
    END IF;
    Sb_learneroutcome.p_create(p_pidm                => grdroll_rec.pidm, /*BIEN*/
                               p_seq_no              => next_dgmr_seqno,
                               p_degs_code           => new_degs_code,
                               p_grad_date           => lv_grad_date, --- grdroll_rec.graddate,
                               p_acyr_code_bulletin  => grdroll_rec.acyr_code,
                               p_appl_date           => NVL(gradapp_date,
                                                            SYSDATE),
                               p_data_origin         => gb_common.data_origin,
                               p_user_id             => user_parm,
                               p_term_code_sturec    => grdroll_rec.stuterm,
                               p_term_code_grad      => lv_grad_term, --- lv_grdroll_rec.gradterm,
                               p_acyr_code           => lv_acyr_code, --- grdroll_rec.gradyear,
                               p_grst_code           => p_grst_code,
                               p_fee_ind             => p_fee_ind,
                               p_fee_date            => p_fee_date,
                               p_authorized          => NULL,
                               p_term_code_completed => p_term_code_completed,
                               p_degc_code_dual      => grdroll_rec.sdegc_dual,
                               p_levl_code_dual      => grdroll_rec.slevl_dual,
                               p_dept_code_dual      => grdroll_rec.sdept_dual,
                               p_coll_code_dual      => grdroll_rec.scoll_dual,
                               p_majr_code_dual      => grdroll_rec.smajr_dual,
                               p_rowid_out           => degc_row,
                               p_stsp_key_sequence   => dgmr_stsp);
    dgmr_seq        := next_dgmr_seqno;
    next_dgmr_seqno := next_dgmr_seqno + 1;
    p_print_dbms('new degree seqno in p_insert_degree: ' || dgmr_seq);
    --  IF report_mode_parm in ('U','0') OR report_mode_parm is null THEN
    deg1_created    := 'Y';
    insert_new_degr := 'Y';
    --    ELSE
    --      deg1_created := 'N';
    --      insert_new_degr := 'N';
    --   END IF;
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = gb_event.APP_ERROR THEN
        deg1_created    := 'N';
        insert_new_degr := 'N';
        dgmr_seq        := NULL;
        api_error       := 'Y';
        api_err_msg     := SQLERRM;
        p_generate_api_error(p_err => api_err_msg);
      END IF;
  END p_insert_degree;
  --
  --
  --
  PROCEDURE p_update_degree IS
    lv_learneroutcome_rec sb_learneroutcome.learneroutcome_rec; /*BIEN*/
    lv_learneroutcome_cur sb_learneroutcome.learneroutcome_ref; /*BIEN*/
  BEGIN
    lv_learneroutcome_cur := sb_learneroutcome.f_query_one(p_pidm   => grdroll_rec.pidm, /*BIEN*/
                                                           p_seq_no => dgmr_seq);
    FETCH lv_learneroutcome_cur
      INTO lv_learneroutcome_rec;
    IF lv_learneroutcome_cur%FOUND THEN
      IF (lv_learneroutcome_rec.r_degc_code_dual <>
         grdroll_rec.compare_sdegc_dual OR lv_learneroutcome_rec.r_levl_code_dual <>
         grdroll_rec.compare_slevl_dual OR lv_learneroutcome_rec.r_coll_code_dual <>
         grdroll_rec.compare_scoll_dual OR lv_learneroutcome_rec.r_dept_code_dual <>
         grdroll_rec.compare_sdept_dual OR lv_learneroutcome_rec.r_majr_code_dual <>
         grdroll_rec.compare_smajr_dual) THEN
        BEGIN
          sb_learneroutcome.p_update(p_pidm           => grdroll_rec.pidm, /*PENDIENTE*/
                                     p_SEQ_NO         => dgmr_seq,
                                     p_DEGC_CODE_DUAL => grdroll_rec.sdegc_dual,
                                     p_LEVL_CODE_DUAL => grdroll_rec.slevl_dual,
                                     p_DEPT_CODE_DUAL => grdroll_rec.sdept_dual,
                                     p_COLL_CODE_DUAL => grdroll_rec.scoll_dual,
                                     p_MAJR_CODE_DUAL => grdroll_rec.smajr_dual,
                                     p_DATA_ORIGIN    => gb_common.data_origin,
                                     p_USER_ID        => NVL(goksels.f_get_ssb_id_context, USER)); /*BIEN*/
        EXCEPTION
          WHEN OTHERS THEN
            IF SQLCODE = gb_event.APP_ERROR THEN /*BIEN*/
              api_error := 'Y';
              p_generate_api_error(p_err => sqlerrm);
            END IF;
        END;
        --
        IF report_mode_parm IN ('U', '0') THEN
          deg1_updated := 'Y';
        ELSE
          deg1_updated := 'N';
        END IF;
        schange := 'Y';
      END IF;
    END IF;
    CLOSE lv_learneroutcome_cur;
  END p_update_degree;
  --
  --
  --
  --
  --
  PROCEDURE p_process_fieldofstudy(p_lcur_seqno     sorlcur.sorlcur_seqno%TYPE,
                                   p_new_lcur_seqno sorlcur.sorlcur_seqno%TYPE,
                                   p_new_lcur_ind   VARCHAR2,
                                   p_new_csts       stvcsts.stvcsts_code%TYPE,
                                   p_default_status stvcact.stvcact_code%TYPE,
                                   p_reroll_ind     VARCHAR2) IS
    -- This is a new procedure to read thru the fields of study and copy and
    -- update the rolled seqno on the learner side
    major_cnt            NUMBER := 0;
    lv_fieldofstudy_rec  sb_fieldofstudy.fieldofstudy_rec; /*BIEN*/
    lv_fieldofstudy_cur  sb_fieldofstudy.fieldofstudy_ref; /*BIEN*/
    lv_fieldofstudy_rec2 sb_fieldofstudy.fieldofstudy_rec; /*BIEN*/
    lv_fieldofstudy_cur2 sb_fieldofstudy.fieldofstudy_ref; /*BIEN*/
    lv_fieldofstudy_rec3 sb_fieldofstudy.fieldofstudy_rec; /*BIEN*/
    lv_fieldofstudy_cur3 sb_fieldofstudy.fieldofstudy_ref; /*BIEN*/
    severity_out         VARCHAR2(1) := NULL;
    lfos_seqno           sorlfos.sorlfos_seqno%type;
    lfos_rowId           VARCHAR2(18) := NULL;
    curr_error           NUMBER := 0;
    lv_active_ind        VARCHAR2(1) := 'Y';
    lv_cnt_active_lfos   PLS_INTEGER := 0;
    lv_cnt_rolled_lfos   PLS_INTEGER := 0;
    lv_rolled_seqno      sorlfos.sorlfos_rolled_seqno%TYPE;
    lv_cact_code         stvcact.stvcact_code%TYPE;
    default_status       stvcact.stvcact_code%TYPE;
    new_inactive_csts    stvcsts.stvcsts_code%TYPE;
    lv_csts_code         stvcsts.stvcsts_code%TYPE;
    degc_code            stvdegs.stvdegs_code%TYPE;
    degc_seqno           shrdgmr.shrdgmr_seq_no%TYPE;
    degc_term            stvterm.stvterm_code%TYPE;
    lcur_status          VARCHAR2(1) := NULL;
    CURSOR ROLLED_LFOS(p_pidm sorlfos.sorlfos_pidm%TYPE, p_lfst_code gtvlfst.gtvlfst_code%TYPE, p_priority_no sorlfos.sorlfos_priority_no%TYPE, p_lcur_seqno sorlfos.sorlfos_lcur_seqno%TYPE, p_seqno sorlfos.sorlfos_seqno%TYPE) IS
      SELECT sovlfos_rolled_seqno
        FROM sovlfos
       WHERE sovlfos_pidm = p_pidm
         AND sovlfos_lfst_code = p_lfst_code
         AND sovlfos_priority_no = p_priority_no
         AND sovlfos_lcur_seqno = p_lcur_seqno
         AND sovlfos_rolled_seqno IS NOT NULL
         AND sovlfos_seqno < p_seqno;
    CURSOR select_degs_c(p_pidm sorlcur.sorlcur_pidm%TYPE, p_seqno sorlcur.sorlcur_seqno%TYPE) IS
      SELECT shrdgmr_degs_code, shrdgmr_seq_no, shrdgmr_term_code_sturec
        FROM shrdgmr, sorlcur
       WHERE shrdgmr_pidm = sorlcur_pidm
         AND shrdgmr_seq_no = sorlcur_key_seqno
         AND sorlcur_pidm = p_pidm
         AND sorlcur_seqno = p_seqno;
    CURSOR f_query_all(p_pidm sorlfos.sorlfos_pidm%type, p_lcur_seqno sorlfos.sorlfos_lcur_seqno%type) IS
      SELECT sorlfos_pidm,
             sorlfos_lcur_seqno,
             sorlfos_seqno,
             sorlfos_lfst_code,
             sorlfos_term_code,
             sorlfos_priority_no,
             sorlfos_csts_code,
             sorlfos_cact_code,
             sorlfos_data_origin,
             sorlfos_user_id,
             sorlfos_majr_code,
             sorlfos_term_code_ctlg,
             sorlfos_term_code_end,
             sorlfos_dept_code,
             sorlfos_lfos_rule,
             sorlfos_conc_attach_rule,
             sorlfos_start_date,
             sorlfos_end_date,
             sorlfos_tmst_code,
             sorlfos_majr_code_attach,
             sorlfos_rolled_seqno,
             sorlfos.ROWID,
             sorlfos_user_id_update,
             sorlfos_current_cde
        FROM sorlfos
       WHERE sorlfos_pidm = p_pidm
         AND sorlfos_lcur_seqno = p_lcur_seqno
       ORDER BY DECODE(sorlfos_lfst_code,
                       sb_fieldofstudy_str.f_major, /*BIEN*/
                       '1',
                       sb_fieldofstudy_str.f_minor, /*BIEN*/
                       '2',
                       sb_fieldofstudy_str.f_concentration, /*BIEN*/
                       '3',
                       '4'),
                sorlfos_priority_no,
                sorlfos_seqno;
  BEGIN
    IF sb_curriculum.f_exists(p_pidm  => grdroll_rec.pidm, /*BIEN*/
                              p_seqno => p_new_lcur_seqno) = 'N' THEN  /*BIEN*/
      RETURN;
    END IF;
    --  get the default status for inserting into the lfos table
    OPEN select_degs_c(p_pidm  => grdroll_rec.pidm,
                       p_seqno => p_new_lcur_seqno);
    FETCH select_degs_c
      INTO degc_code, degc_seqno, degc_term;
    IF select_degs_c%notfound THEN
      CLOSE select_degs_c;
      p_print_dbms('degree doesnt exist in p insert lfos');
      RETURN;
    END IF;
    CLOSE select_degs_c;
    p_print_dbms('degs for lfos: ' || degc_code);
    IF sb_learneroutcome_rules.f_degree_awarded(p_pidm   => grdroll_rec.pidm, /*BIEN*/
                                                p_seq_no => degc_seqno) = 'Y' THEN
      --  p_print_dbms('found out degree is awarded in process lfos: ' || degc_seqno);
      RETURN;
    END IF;
    --- get the fields of study for the curriculum
    --- select active fields of study if a new degree, else select all
    lcur_status := sb_learnercurricstatus.f_is_active(p_default_status); /*BIEN*/
    IF p_new_lcur_ind = 'N' OR lcur_status = 'N' THEN
      lv_active_ind := '%';
    END IF;
    IF lcur_status = 'Y' THEN
      --  get the default status for inserting into the lfos table
      soklcur.p_default_status(grdroll_rec.pidm, /*BIEN*/
                               sb_curriculum_str.f_outcome, /*BIEN*/
                               degc_term,
                               degc_seqno,
                               NULL,
                               degc_code,
                               NULL,
                               lv_cact_code,
                               lv_csts_code);
    END IF;
    -- read all lfos from learner record, they will be
    -- copied to the outcome curriculum
    -- we need to read even non current because they could be
    -- part of a non destructive update to inactivate a lfos
    OPEN f_query_all(p_pidm       => grdroll_rec.pidm,
                     p_lcur_seqno => p_lcur_seqno);
    LOOP
      FETCH f_query_all
        INTO lv_fieldofstudy_rec;
      EXIT WHEN f_query_all%NOTFOUND;
      api_lfst_error := 'N';
      ---- save the primary major for the sotprnt report
      IF lv_fieldofstudy_rec.r_lfst_code = sb_fieldofstudy_str.MAJOR THEN /*BIEN*/
        major_cnt := major_cnt + 1;
        IF major_cnt = 1 THEN
          smajr := lv_fieldofstudy_rec.r_majr_code; /*BIEN*/
        END IF;
      END IF;
      IF lv_fieldofstudy_rec.r_rolled_seqno IS NULL OR p_reroll_ind = 'Y' THEN /*BIEN*/
        lv_cnt_active_lfos := 0;
        lv_cnt_rolled_lfos := 0;
        IF sb_learnercurricstatus.f_is_active(p_cact_code => lv_fieldofstudy_rec.r_cact_code) = 'N' AND /*BIEN*/
           lcur_status = 'Y' THEN
          -- roll only if same priority for lfst was previously rolled
          OPEN ROLLED_LFOS(p_pidm        => grdroll_rec.pidm,
                           p_lfst_code   => lv_fieldofstudy_rec.r_lfst_code, /*BIEN*/
                           p_priority_no => lv_fieldofstudy_rec.r_priority_no, /*BIEN*/
                           p_lcur_seqno  => lv_fieldofstudy_rec.r_lcur_seqno, /*BIEN*/
                           p_seqno       => lv_fieldofstudy_rec.r_seqno); /*BIEN*/
          LOOP
            FETCH ROLLED_LFOS
              INTO lv_rolled_seqno;
            EXIT WHEN ROLLED_LFOS%NOTFOUND;
            lv_cnt_rolled_lfos := lv_cnt_rolled_lfos + 1;
          END LOOP;
          CLOSE ROLLED_LFOS;
          -- if status is inactive and a major,  do not roll unless there is one other
          -- active major with different priority
          IF lv_fieldofstudy_rec.r_lfst_code = sb_fieldofstudy_str.f_major AND /*BIEN*/
             lcur_status = 'Y' THEN
            lv_fieldofstudy_cur2 := sb_fieldofstudy.f_query_current(p_pidm       => grdroll_rec.pidm, /*BIEN*/
                                                                    p_lcur_seqno => p_new_lcur_seqno,
                                                                    p_active_ind => 'Y');
            LOOP
              FETCH lv_fieldofstudy_cur2
                INTO lv_fieldofstudy_rec2;
              EXIT WHEN lv_fieldofstudy_cur2%NOTFOUND;
              IF lv_fieldofstudy_rec2.r_lfst_code =
                 sb_fieldofstudy_str.f_major AND
                 lv_fieldofstudy_rec2.r_priority_no <>
                 lv_fieldofstudy_rec.r_priority_no THEN
                lv_cnt_active_lfos := lv_cnt_active_lfos + 1;
              END IF;
            END LOOP;
          ELSE
            lv_cnt_active_lfos := 1;
          END IF;
        ELSE
          -- status is active
          lv_cnt_active_lfos := 1;
          lv_cnt_rolled_lfos := 1;
        END IF;
        IF lv_cnt_active_lfos > 0 AND lv_cnt_rolled_lfos > 0 THEN
          --- copy priorities from learner
          -- if lmod counts have been reached, insert inactive lfos
          IF lcur_status = 'Y' AND
             sb_learnercurricstatus.f_is_active(lv_fieldofstudy_rec.r_cact_code) = 'Y' THEN /*BIEN*/
            new_inactive_csts := lv_csts_code;
            default_status    := soklcur.f_lfos_count_status(p_pidm           => grdroll_rec.pidm, /*BIEN*/
                                                             p_lcur_seqno     => p_new_lcur_seqno,
                                                             p_lfst_code      => lv_fieldofstudy_rec.r_lfst_code,
                                                             p_priority_no    => lv_fieldofstudy_rec.r_priority_no,
                                                             p_lmod_code      => sb_curriculum_str.f_outcome, /*BIEN*/
                                                             p_default_status => lv_cact_code,
                                                             p_new_csts       => new_inactive_csts);
          ELSE
            default_status    := lv_fieldofstudy_rec.r_cact_code; /*BIEN*/
            new_inactive_csts := lv_fieldofstudy_rec.r_csts_code; /*BIEN*/
          END IF;
          p_print_dbms('lfst ' || lv_fieldofstudy_rec.r_lfst_code || /*BIEN*/
                       ' code ' || lv_fieldofstudy_rec.r_majr_code); /*BIEN*/
          BEGIN
            SB_FIELDOFSTUDY.P_CREATE(P_PIDM              => grdroll_rec.pidm, /*BIEN*/
                                     P_LCUR_SEQNO        => p_new_lcur_seqno,
                                     P_SEQNO             => NULL,
                                     P_LFST_CODE         => lv_fieldofstudy_rec.r_lfst_code,
                                     P_TERM_CODE         => lv_fieldofstudy_rec.r_term_code,
                                     P_PRIORITY_NO       => lv_fieldofstudy_rec.r_priority_no,
                                     P_CSTS_CODE         => new_inactive_csts,
                                     P_CACT_CODE         => default_status,
                                     P_DATA_ORIGIN       => gb_common.data_origin,
                                     P_USER_ID           => user_parm,
                                     P_MAJR_CODE         => lv_fieldofstudy_rec.r_majr_code,
                                     p_dept_code         => lv_fieldofstudy_rec.r_dept_code,
                                     P_TERM_CODE_CTLG    => lv_fieldofstudy_rec.r_term_code_ctlg,
                                     P_LFOS_RULE         => lv_fieldofstudy_rec.r_lfos_rule,
                                     P_CONC_ATTACH_RULE  => lv_fieldofstudy_rec.r_conc_attach_rule,
                                     p_rolled_seqno      => NULL,
                                     p_start_date        => lv_fieldofstudy_rec.r_start_date,
                                     p_end_date          => lv_fieldofstudy_rec.r_end_date,
                                     p_term_code_end     => NULL,
                                     p_tmst_code         => lv_fieldofstudy_rec.r_tmst_code,
                                     p_majr_code_attach  => lv_fieldofstudy_rec.r_majr_code_attach,
                                     P_ROWID_OUT         => lfos_rowid,
                                     P_CURR_ERROR_OUT    => curr_error,
                                     P_override_severity => 'N',
                                     p_severity_out      => severity_out,
                                     p_lfos_seqno_out    => lfos_seqno,
                                     p_user_id_update    => user_parm);
          EXCEPTION
            WHEN OTHERS THEN
              IF SQLCODE = gb_event.APP_ERROR THEN /*BIEN*/
                p_generate_api_error(p_err => sqlerrm || ' ' ||
                                              lv_fieldofstudy_rec.r_lfst_code || ' ' || /*BIEN*/
                                              lv_fieldofstudy_rec.r_majr_code); /*BIEN*/
                IF lv_fieldofstudy_rec.r_lfst_code = /*BIEN*/
                   sb_fieldofstudy_str.MAJOR AND major_cnt = 1 THEN  /*BIEN*/
                  major_cnt := major_cnt - 1;
                END IF;
                api_error      := 'Y';
                api_lfst_error := 'Y';
                IF insert_new_degr = 'Y' THEN
                  sb_learneroutcome.p_delete(p_pidm   => grdroll_rec.pidm,
                                             p_seq_no => dgmr_seq); /*BIEN*/
                  deg1_created    := 'N';
                  insert_new_curr := 'N';
                  insert_new_degr := 'N';
                  dgmr_seq        := NULL;
                  -- undo marking learner curriculum as rolled
                  dml_sorlcur.p_update(p_pidm         => grdroll_rec.pidm, /*BIEN*/
                                       p_seqno        => p_lcur_seqno,
                                       p_user_id      => user_parm,
                                       p_data_origin  => gb_common.data_origin, /*BIEN*/
                                       p_rolled_seqno => NULL);
                  lv_fieldofstudy_cur3 := sb_fieldofstudy.f_query_current(p_pidm       => grdroll_rec.pidm, /*BIEN*/
                                                                          p_lcur_seqno => p_lcur_seqno,
                                                                          p_active_ind => lv_active_ind);
                  LOOP
                    FETCH lv_fieldofstudy_cur3
                      INTO lv_fieldofstudy_rec3;
                    EXIT WHEN lv_fieldofstudy_cur3%NOTFOUND;
                    dml_sorlfos.p_update(p_pidm         => grdroll_rec.pidm, /*BIEN*/
                                         p_lcur_seqno   => p_lcur_seqno,
                                         p_seqno        => lv_fieldofstudy_rec3.r_seqno,
                                         p_user_id      => user_parm,
                                         p_data_origin  => gb_common.data_origin, /*BIEN*/
                                         p_rolled_seqno => NULL,
                                         p_rowid        => lv_fieldofstudy_rec3.r_internal_record_id);
                  END LOOP;
                  CLOSE lv_fieldofstudy_cur3;
                ELSE
                  IF insert_new_curr = 'Y' THEN
                    sb_curriculum.p_delete(p_pidm  => grdroll_rec.pidm, /*BIEN*/
                                           p_seqno => p_new_lcur_seqno);
                    insert_new_curr := 'N';
                    -- undo marking learner curriculum as rolled
                    dml_sorlcur.p_update(p_pidm         => grdroll_rec.pidm,
                                         p_seqno        => p_lcur_seqno,
                                         p_user_id      => user_parm,
                                         p_data_origin  => gb_common.data_origin, /*BIEN*/
                                         p_rolled_seqno => NULL); /*BIEN*/
                    lv_fieldofstudy_cur3 := sb_fieldofstudy.f_query_current(p_pidm       => grdroll_rec.pidm, /*BIEN*/
                                                                            p_lcur_seqno => p_lcur_seqno,
                                                                            p_active_ind => lv_active_ind);
                    LOOP
                      FETCH lv_fieldofstudy_cur3
                        INTO lv_fieldofstudy_rec3;
                      EXIT WHEN lv_fieldofstudy_cur3%NOTFOUND;
                      dml_sorlfos.p_update(p_pidm         => grdroll_rec.pidm, /*BIEN*/
                                           p_lcur_seqno   => p_lcur_seqno,
                                           p_seqno        => lv_fieldofstudy_rec3.r_seqno,
                                           p_user_id      => user_parm,
                                           p_data_origin  => gb_common.data_origin, /*BIEN*/
                                           p_rolled_seqno => NULL,
                                           p_rowid        => lv_fieldofstudy_rec3.r_internal_record_id);
                    END LOOP;
                    CLOSE lv_fieldofstudy_cur3;
                  END IF;
                END IF;
                EXIT; -- do not process any more of curriculum if
                -- and lfst is invalid
              END IF;
          END;
          IF api_error = 'N' AND api_lfst_error = 'N' THEN
            --- update the rolled seqno on the learners field of study
            schange := 'Y';
            dml_sorlfos.p_update(p_pidm         => grdroll_rec.pidm,
                                 p_lcur_seqno   => p_lcur_seqno,
                                 p_seqno        => lv_fieldofstudy_rec.r_seqno, /*BIEN*/
                                 p_user_id      => user_parm,
                                 p_data_origin  => gb_common.data_origin, /*BIEN*/
                                 p_rolled_seqno => lfos_seqno,
                                 p_rowid        => lv_fieldofstudy_rec.r_internal_record_id); /*BIEN*/
          END IF;
        END IF;
      END IF;
    END LOOP;
    CLOSE f_query_all;
    IF major_cnt = 0 THEN
      api_error   := 'Y';
      api_err_msg := g$_nls.get('SHKROL1-0000',
                                'SQL',
                                'Primary Major Not Added');
      p_generate_api_error(p_err => api_err_msg);
      api_err_msg := '';
    END IF;
  END p_process_fieldofstudy;
  --
  PROCEDURE p_process_curriculum IS
    degs_code    stvdegs.stvdegs_code%TYPE;
    severity_out VARCHAR2(1) := NULL;
    lcur_seqno   sorlcur.sorlcur_seqno%type;
    lcur_row     VARCHAR2(18) := NULL;
    curr_error   NUMBER := 0;
    CURSOR lv_degs_c(p_pidm shrdgmr.shrdgmr_pidm%TYPE, p_dgmr_seq shrdgmr.shrdgmr_seq_no%TYPE) IS
      SELECT shrdgmr_degs_code
        FROM shrdgmr
       WHERE shrdgmr_pidm = p_pidm
         AND shrdgmr_seq_no = p_dgmr_seq;
    lv_grdapp_lcur_rec sb_curriculum.curriculum_rec; /*BIEN*/
    lv_grdapp_lcur_ref sb_curriculum.curriculum_ref; /*BIEN*/
  BEGIN
    -- p_print_dbms('In pprocess curriculum: ' || lv_curriculum_rec.r_seqno || ' ' || lv_curriculum_rec.r_program);
    IF sb_learnercurricstatus.f_is_active(lv_curriculum_rec.r_cact_code) = 'Y' THEN /*BIEN*/
      -- get the degree status for the degree which is used to
      -- determine the csts
      OPEN lv_degs_c(p_pidm => grdroll_rec.pidm, p_dgmr_seq => dgmr_seq);
      FETCH lv_degs_c
        INTO degs_code;
      CLOSE lv_degs_c;
      -- get the default cact code and csts for the degree
      soklcur.p_default_status(p_pidm      => grdroll_rec.pidm,
                               p_lmod_code => sb_curriculum_str.f_outcome, /*BIEN*/
                               p_term_code => grdroll_rec.stuterm,
                               p_keyseqno  => dgmr_seq,
                               p_degs_code => degs_code,
                               p_cact_out  => lv_cact_code,
                               p_csts_out  => lv_csts_code); /*BIEN*/
      --- verify count of existing lcur and change status to inactive
      -- if this new entry will make rec count exceed the counts
      default_status := soklcur.f_lcur_count_status(p_pidm           => grdroll_rec.pidm,
                                                    p_lmod           => sb_curriculum_str.f_outcome, /*BIEN*/
                                                    p_term_code      => grdroll_rec.stuterm,
                                                    p_keyseqno       => dgmr_seq,
                                                    p_priority_no    => lv_curriculum_rec.r_priority_no, /*BIEN*/
                                                    p_default_status => lv_cact_code,
                                                    p_new_csts       => lv_csts_code); /*BIEN*/
    ELSE
      -- cact is inactive so use the ones that came from the learner rec
      default_status := lv_curriculum_rec.r_cact_code; /*BIEN*/
    END IF;
    --- get the grad app seq from the learner curric, and if that doesnt exist
    -- get it from the existing outcome lcur
    IF lv_curriculum_rec.r_gapp_seqno IS NOT NULL THEN  /*BIEN*/
      gradapp_seqno := lv_curriculum_rec.r_gapp_seqno;  /*BIEN*/
      --- update the other outcome curriculum with the learner's gapp seqno
      lv_grdapp_lcur_ref := sb_curriculum.f_query_current(p_pidm       => grdroll_rec.pidm, /*BIEN*/
                                                          p_keyseqno   => dgmr_seq,
                                                          p_lmod_code  => sb_curriculum_str.f_outcome, /*BIEN*/
                                                          p_active_ind => 'Y');
      LOOP
        FETCH lv_grdapp_lcur_ref
          INTO lv_grdapp_lcur_rec;
        EXIT WHEN lv_grdapp_lcur_ref%notfound;
        IF lv_grdapp_lcur_rec.r_gapp_seqno IS NULL THEN
          dml_sorlcur.p_update_gapp(p_pidm        => grdroll_rec.pidm,
                                    p_seqno       => lv_grdapp_lcur_rec.r_seqno,
                                    p_user_id     => user_parm,
                                    p_data_origin => gb_common.data_origin, /*BIEN*/
                                    p_gapp_seqno  => gradapp_seqno); /*BIEN*/
        END IF;
      END LOOP;
      CLOSE lv_grdapp_lcur_ref;
    ELSE
      lv_grdapp_lcur_ref := sb_curriculum.f_query_current(p_pidm       => grdroll_rec.pidm,
                                                          p_keyseqno   => dgmr_seq,
                                                          p_lmod_code  => sb_curriculum_str.f_outcome, /*BIEN*/
                                                          p_active_ind => 'Y'); /*BIEN*/
      gradapp_seqno      := NULL;
      LOOP
        FETCH lv_grdapp_lcur_ref
          INTO lv_grdapp_lcur_rec;
        EXIT WHEN lv_grdapp_lcur_ref%notfound;
        IF lv_grdapp_lcur_rec.r_gapp_seqno IS NOT NULL THEN
          gradapp_seqno := lv_grdapp_lcur_rec.r_gapp_seqno;
          EXIT;
        END IF;
      END LOOP;
      CLOSE lv_grdapp_lcur_ref;
    END IF;
    --- begin insert process
    BEGIN
      p_print_dbms('insert new curriculum ' || dgmr_seq || ' prior ' ||
                   lv_curriculum_rec.r_priority_no || ' cact ' || /*BIEN*/
                   default_status || ' gradapp seqno ' || gradapp_seqno);
      sb_curriculum.p_create(P_PIDM              => grdroll_rec.pidm, /*BIEN*/
                             P_SEQNO             => NULL,
                             P_LMOD_CODE         => sb_curriculum_str.f_outcome, /*BIEN*/
                             P_TERM_CODE         => lv_curriculum_rec.r_term_code,
                             P_KEY_SEQNO         => dgmr_seq,
                             P_PRIORITY_NO       => lv_curriculum_rec.r_priority_no, /*BIEN*/
                             P_ROLL_IND          => 'D', -- send default value
                             P_CACT_CODE         => default_status,
                             P_USER_ID           => user_parm,
                             P_DATA_ORIGIN       => gb_common.data_origin, /*BIEN*/
                             P_LEVL_CODE         => lv_curriculum_rec.r_levl_code, /*BIEN*/
                             P_COLL_CODE         => lv_curriculum_rec.r_coll_code, /*BIEN*/
                             P_DEGC_CODE         => lv_curriculum_rec.r_degc_code, /*BIEN*/
                             P_TERM_CODE_CTLG    => lv_curriculum_rec.r_term_code_ctlg, /*BIEN*/
                             P_CAMP_CODE         => lv_curriculum_rec.r_camp_code, /*BIEN*/
                             P_PROGRAM           => lv_curriculum_rec.r_program, /*BIEN*/
                             p_start_date        => lv_curriculum_rec.r_start_date, /*BIEN*/
                             p_end_date          => lv_curriculum_rec.r_end_date, /*BIEN*/
                             P_CURR_RULE         => NULL,
                             p_rolled_seqno      => NULL,
                             p_gapp_seqno        => gradapp_seqno,
                             P_ROWID_OUT         => lcur_row,
                             P_CURR_ERROR_OUT    => curr_error,
                             p_seqno_out         => lcur_seqno,
                             P_override_severity => 'N',
                             p_severity_out      => severity_out,
                             p_user_id_update    => user_parm);
    EXCEPTION
      WHEN OTHERS THEN
        IF SQLCODE = gb_event.APP_ERROR THEN /*BIEN*/
          api_error := 'Y';
          p_generate_api_error(p_err => sqlerrm);
          insert_new_curr := 'N';
          IF insert_new_degr = 'Y' THEN
            sb_learneroutcome.p_delete(p_pidm   => grdroll_rec.pidm, /*BIEN*/
                                       p_seq_no => dgmr_seq);
            deg1_created    := 'N';
            insert_new_degr := 'N';
            dgmr_seq        := NULL;
          END IF;
        END IF;
    END;
    ---- save the curriculum values for the sotprnt report which
    --- is produced in SZRROLL.pc
    sdegc    := lv_curriculum_rec.r_degc_code; /*BIEN*/
    slevl    := lv_curriculum_rec.r_levl_code; /*BIEN*/
    scoll    := lv_curriculum_rec.r_coll_code; /*BIEN*/
    scampus  := lv_curriculum_rec.r_camp_code; -- added for 7212 /*BIEN*/
    sprogram := lv_curriculum_rec.r_program; /*BIEN*/
    ---  update the rolled seqno on the learners curriculum row
    IF api_error <> 'Y' THEN
      schange         := 'Y';
      insert_new_curr := 'Y';
      dml_sorlcur.p_update(p_pidm         => lv_curriculum_rec.r_pidm, /*BIEN*/ /*BIEN*/
                           p_seqno        => lv_curriculum_rec.r_seqno, /*BIEN*/
                           p_user_id      => user_parm,
                           p_data_origin  => gb_common.data_origin, /*BIEN*/
                           p_rolled_seqno => lcur_seqno,
                           p_rowid        => lv_curriculum_rec.r_internal_record_id); /*BIEN*/
      --- get the fields of study for the curriculum
      --- select active fields of study
      p_process_fieldofstudy(p_lcur_seqno     => lv_curriculum_rec.r_seqno, /*BIEN*/
                             p_new_lcur_seqno => lcur_seqno,
                             p_new_lcur_ind   => 'Y',
                             p_new_csts       => lv_csts_code,
                             p_default_status => default_status,
                             p_reroll_ind     => 'Y');
    END IF;
  END p_process_curriculum;
  --
  PROCEDURE p_update_sfrstcr IS
  BEGIN
    sfksels.p_select_sfrstcr_by_multi(grdroll_rec.pidm, /*BIEN*/
                                      grdroll_rec.term,
                                      grdroll_rec.crn,
                                      sfrstcr_row,
                                      row_found);
    IF row_found THEN
      sfrstcr_row.sfrstcr_grde_date := SYSDATE;
      sfkmods.p_update_sfrstcr(sfrstcr_row); /*BIEN*/
      -- MJR 11/29/01 Start --
      /*
      -- commented out this code to resolve defect 1-32XH5V in 8.0
      -- developer MJR wanted to update sysdate on the gradebook tables
      -- but did not realize that that caused an update trigger on
      -- these 2 tables to fire and reset sfrstcr_grde_code to the composite grade
      -- when an sfrstcr record is rolled.
      sfkmods.p_update_shrcmrk (
      grdroll_rec.crn,
      grdroll_rec.term,
      grdroll_rec.pidm);
      sfkmods.p_update_shrmrks (
      grdroll_rec.crn,
      grdroll_rec.term,
      grdroll_rec.pidm);
      */
      -- MJR 11/29/01 End --
      commit_count := commit_count + 1;
      IF commit_count > 99 THEN
        IF gv_update_mode IN ('0', 'U') THEN
          gb_common.p_COMMIT; /*BIEN*/
        END IF;
        commit_count := 0;
      END IF;
    END IF;
  END p_update_sfrstcr;
  --
  --
  --
  PROCEDURE p_get_new_sect IS
    CURSOR get_ssrattr_c(p_term_code stvterm.stvterm_code%TYPE, p_crn ssrattr.ssrattr_crn%TYPE) IS
      SELECT ssrattr_attr_code
        FROM ssrattr
       WHERE ssrattr_term_code = p_term_code
         AND ssrattr_crn = p_crn;
  BEGIN
    sect_crn  := grdroll_rec.crn;
    sect_ptrm := grdroll_rec.ptrm;
    IF report_mode_parm <> 'O' THEN
      p_init_sotprnt;
      sotprnt_row.sotprnt_rectype    := 'COURSE';
      sotprnt_row.sotprnt_crn        := grdroll_rec.crn;
      sotprnt_row.sotprnt_term_code  := grdroll_rec.term;
      sotprnt_row.sotprnt_ptrm_code  := grdroll_rec.ptrm;
      sotprnt_row.sotprnt_subj_code  := grdroll_rec.subject;
      sotprnt_row.sotprnt_crse_numb  := grdroll_rec.crse_numb;
      sotprnt_row.sotprnt_crse_title := grdroll_rec.ctitle;
      shkmods.p_insert_sotprnt(sotprnt_row); /*BIEN*/
    END IF;
    --
    shksels.p_select_shrinst_sirasgn(grdroll_rec.term, /*BIEN*/
                                     grdroll_rec.crn,
                                     shrinst_row,
                                     row_found);
    IF row_found THEN
      LOCK TABLE shrinst IN SHARE UPDATE MODE;
      shkmods.p_insert_shrinst_from_sirasgn(grdroll_rec.term, /*BIEN*/
                                            grdroll_rec.crn);
    END IF;
    --
    -- Get section attributes and insert where
    -- they do not exist at course level.
    --
    OPEN get_ssrattr_c(p_term_code => grdroll_rec.term,
                       p_crn       => grdroll_rec.crn);
    FETCH get_ssrattr_c
      INTO attr_code;
    WHILE get_ssrattr_c%FOUND LOOP
      shksels.p_select_shrattc_by_multi(grdroll_rec.term,
                                        grdroll_rec.crn,
                                        attr_code,
                                        shrattc_row,
                                        row_found);
      IF NOT row_found THEN
        LOCK TABLE shrattc IN SHARE UPDATE MODE;
        shrattc_row.shrattc_term_code     := grdroll_rec.term;
        shrattc_row.shrattc_crn           := grdroll_rec.crn;
        shrattc_row.shrattc_attr_code     := attr_code;
        shrattc_row.shrattc_activity_date := SYSDATE;
        shkmods.p_insert_shrattc(shrattc_row); /*BIEN*/
        IF gv_update_mode IN ('0', 'U') THEN
          gb_common.p_COMMIT; /*BIEN*/
        END IF;
      END IF;
      FETCH get_ssrattr_c
        INTO attr_code;
    END LOOP;
    CLOSE get_ssrattr_c;
  END p_get_new_sect;
  --
  --
  --
  PROCEDURE p_insert_shrchrt IS
    CURSOR get_sgrchrt_c(p_pidm sgrchrt.sgrchrt_pidm%TYPE, p_term_code stvterm.stvterm_code%TYPE) IS
      SELECT *
        FROM sgrchrt a
       WHERE a.sgrchrt_pidm = p_pidm
         AND a.sgrchrt_term_code_eff =
             (SELECT MAX(b.sgrchrt_term_code_eff)
                FROM sgrchrt b
               WHERE b.sgrchrt_pidm = p_pidm
                 AND b.sgrchrt_term_code_eff <= p_term_code)
         AND a.sgrchrt_chrt_code IS NOT NULL
         AND a.sgrchrt_chrt_code NOT IN
             (SELECT c.shrchrt_chrt_code
                FROM shrchrt c
               WHERE c.shrchrt_pidm = p_pidm
                 AND c.shrchrt_term_code = p_term_code);
  BEGIN
    OPEN get_sgrchrt_c(p_pidm      => grdroll_rec.pidm,
                       p_term_code => grdroll_rec.term);
    FETCH get_sgrchrt_c
      INTO sgrchrt_row;
    WHILE get_sgrchrt_c%FOUND LOOP
      shrchrt_row.shrchrt_pidm          := grdroll_rec.pidm;
      shrchrt_row.shrchrt_term_code     := grdroll_rec.term;
      shrchrt_row.shrchrt_chrt_code     := sgrchrt_row.sgrchrt_chrt_code;
      shrchrt_row.shrchrt_active_ind    := sgrchrt_row.sgrchrt_active_ind;
      shrchrt_row.shrchrt_crea_code     := sgrchrt_row.sgrchrt_crea_code;
      shrchrt_row.shrchrt_activity_date := SYSDATE;
      shkmods.p_insert_shrchrt(shrchrt_row); /*BIEN*/
      FETCH get_sgrchrt_c
        INTO sgrchrt_row;
    END LOOP;
    CLOSE get_sgrchrt_c;
  END p_insert_shrchrt;
  --
  --
  --
  PROCEDURE p_process_graderoll IS
    -- cannot use sb_curriculum.f_query_module because we need it
    -- sorted in seqno order, not seqno desc order
    --
    CURSOR lv_curriculum_cur(p_pidm sorlcur.sorlcur_pidm%TYPE, p_lmod_code stvlmod.stvlmod_code%TYPE, p_end_term stvterm.stvterm_code%type) IS
      SELECT sorlcur_pidm,
             sorlcur_seqno,
             sorlcur_lmod_code,
             sorlcur_term_code,
             sorlcur_key_seqno,
             sorlcur_priority_no,
             sorlcur_roll_ind,
             sorlcur_cact_code,
             sorlcur_user_id,
             sorlcur_data_origin,
             sorlcur_levl_code,
             sorlcur_coll_code,
             sorlcur_degc_code,
             sorlcur_term_code_ctlg,
             sorlcur_term_code_end,
             sorlcur_term_code_matric,
             sorlcur_term_code_admit,
             sorlcur_admt_code,
             sorlcur_camp_code,
             sorlcur_program,
             sorlcur_start_date,
             sorlcur_end_date,
             sorlcur_curr_rule,
             sorlcur_rolled_seqno,
             sorlcur_styp_code,
             sorlcur_exp_grad_date,
             sorlcur_leav_code,
             sorlcur_leav_from_date,
             sorlcur_leav_to_date,
             sorlcur_rate_code,
             sorlcur_term_code_grad,
             sorlcur_acyr_code,
             sorlcur_site_code,
             sorlcur_appl_key_seqno,
             sorlcur_appl_seqno,
             ROWID,
             sorlcur_user_id_update,
             sorlcur_gapp_seqno,
             sorlcur_current_cde
        FROM sorlcur
       WHERE sorlcur_pidm = p_pidm
         AND sorlcur_lmod_code = p_lmod_code
         AND sorlcur_term_code < p_end_term
       ORDER BY sorlcur_priority_no, sorlcur_seqno;
    -- new cursor to fetch the latest final CMRK gradechangecode (instead of using RR all the time) for a re-roll
    last_compositegchg_code  stvgchg.stvgchg_code%TYPE;
    cursor find_composite_gchg_c (p_pidm  spriden.spriden_pidm%type,
                                  p_term   stvterm.stvterm_code%TYPE,
                                  p_crn     ssbsect.ssbsect_crn%type)
    is
       select shrcmrk_gchg_code  from shrcmrk
       where SHRCMRK_PIDM = p_pidm
       and SHRCMRK_TERM_CODE = p_term
       and SHRCMRK_CRN = p_crn
       and SHRCMRK_RECTYPE_IND='F';

    print_happened_ind VARCHAR2(1) := 'N';
    current_ind        VARCHAR2(1) := NULL;
    endterm            stvterm.stvterm_code%type;
    convert_learner    VARCHAR2(1) := NULL;
    convert_outcome    VARCHAR2(1) := NULL;
    lv_dgmr_seqno      NUMBER := NULL;
    --- 8.1.1
    TYPE cur_typ IS REF CURSOR;
    c               cur_typ;
    -- 8.5.4.1
    degrees_string  VARCHAR2(1000) := '';
    degree_cnt      pls_integer := 0;
    dgmr_seq_manual shrdgmr.shrdgmr_seq_no%type;
    -- 8.5.4.1
    degree_sql      VARCHAR2(1500) := 'select shrdgmr_seq_no, shrdgmr_stsp_key_sequence ' ||
                                     'from stvdegs, shrdgmr  ' ||
                                     'where stvdegs_code = shrdgmr_degs_code ' ||
                                     'and nvl(stvdegs_award_status_ind,''N'') <> ''A'' ' ||
                                     'and shrdgmr_pidm =  :pidm ' ||
                                     ' and shrdgmr_seq_no not in ';
    CURSOR degree_sql2_c IS
      SELECT shrdgmr_seq_no, shrdgmr_stsp_key_sequence
        FROM stvdegs, shrdgmr
       WHERE stvdegs_code = shrdgmr_degs_code
         AND NVL(stvdegs_award_status_ind, 'N') <> 'A'
         AND shrdgmr_pidm = grdroll_rec.pidm;
    CURSOR degree_pgm_c IS
      SELECT sovlcur_degc_code,
             sovlcur_levl_code,
             sovlcur_coll_code,
             sovlcur_camp_code,
             sovlcur_program,
             sovlcur_seqno
        FROM sovlcur
       WHERE sovlcur_pidm = grdroll_rec.pidm
         AND sovlcur_key_seqno = dgmr_seq
         AND sovlcur_lmod_code = sb_curriculum_str.f_outcome /*BIEN*/
         AND sovlcur_current_ind = 'Y'
         AND sovlcur_active_ind = 'Y'
       ORDER BY sovlcur_priority_no;

    gtvsdax_rec        gtvsdax%ROWTYPE;
    default_gchg_code  stvgchg.stvgchg_code%TYPE := 'OE';
  BEGIN

    gv_grade_roll_ind := 'Y';
    api_error         := 'N';
    LOCK TABLE shrgcol, shrtckg, shrtckl, shrtckn, shrtgpa, shrttrm, sfrstcr, shrtckd, shrlgpa, shrgpac, shrgpal IN SHARE UPDATE MODE;
    --
    -- Many SELECTs that are needed elsewhere in this procedure are done at the
    -- top, and a hold field is used to store the results of the query.
    -- This is done for two reasons: 1) The results of some queries are used at
    -- multiple places in the code below, and the query only has to be done once.
    -- 2) Having them all at the top keeps some of the code below easier to read,
    -- by not embedding SELECTs in nested IF statements.
    --
    -- Select SHRGCOL for pidm and term, where print_status is null
    --
    shksels.p_select_shrgcol_by_pidm_term(grdroll_rec.pidm, /*BIEN*/
                                          grdroll_rec.term,
                                          shrgcol_row,
                                          row_found);
    holdgcol := row_found;
    --
    -- If SHRGCOL not found, select SHRGCOL for pidm, term, and print_status = 'P'
    --
    IF NOT holdgcol THEN
      shksels.p_select_shrgcol_by_multi(grdroll_rec.pidm, /*BIEN*/
                                        grdroll_rec.term,
                                        'P',
                                        shrgcol_row,
                                        row_found);
      holdgcol_p := row_found;
    END IF;
    --
    -- Select shrgpac for pidm, term, levl, and campus.
    --
    shksels.p_select_shrgpac_by_multi(grdroll_rec.pidm, /*BIEN*/
                                      grdroll_rec.term,
                                      grdroll_rec.reg_levl,
                                      grdroll_rec.campus,
                                      shrgpac_row,
                                      row_found);
    holdgpac := row_found;
    --
    -- Select MAX(shrdgmr_seq_no) by pidm
    --
    shksels.p_select_shrdgmr_seqno_by_pidm(grdroll_rec.pidm, /*BIEN*/
                                           next_dgmr_seqno);
    --
    -- Select SHRGPAL for pidm, reg_levl, campus, and gpa_type_ind = 'I'
    --
    shksels.p_select_shrgpal_by_multi(grdroll_rec.pidm, /*BIEN*/
                                      grdroll_rec.reg_levl,
                                      'I',
                                      grdroll_rec.campus,
                                      shrgpal_i_row,
                                      row_found);
    holdgpal_i := row_found;
    --
    -- Select SHRGPAL for pidm, reg_levl, campus, and gpa_type_ind = 'O'
    --
    shksels.p_select_shrgpal_by_multi(grdroll_rec.pidm, /*BIEN*/
                                      grdroll_rec.reg_levl,
                                      'O',
                                      grdroll_rec.campus,
                                      shrgpal_o_row,
                                      row_found);
    holdgpal_o := row_found;
    --
    -- Select SHRLGPA for pidm, reg_levl and gpa_type_ind = 'I'
    --
    shksels.p_select_shrlgpa_by_multi(grdroll_rec.pidm, /*BIEN*/
                                      grdroll_rec.reg_levl,
                                      'I',
                                      shrlgpa_i_row,
                                      row_found);
    holdlgpa_i := row_found;
    --
    -- Select SHRLGPA for pidm, reg_levl and gpa_type_ind = 'O'
    --
    shksels.p_select_shrlgpa_by_multi(grdroll_rec.pidm, /*BIEN*/
                                      grdroll_rec.reg_levl,
                                      'O',
                                      shrlgpa_o_row,
                                      row_found);
    holdlgpa_o := row_found;
    --
    -- Select SHRTGPA for pidm, term, and reg_levl
    --
    shksels.p_select_shrtgpa_by_multi(grdroll_rec.pidm, /*BIEN*/
                                      grdroll_rec.term,
                                      grdroll_rec.reg_levl,
                                      shrtgpa_row,
                                      row_found);
    holdtgpa := row_found;
    --
    -- Insert rows into SHRTTRM and SHRCHRT only if
    -- SHRTTRM does not already exist for this pidm and term
    --
    shksels.p_select_shrttrm_by_pidm_term(grdroll_rec.pidm, /*BIEN*/
                                          grdroll_rec.term,
                                          shrttrm_row,
                                          row_found);
    IF NOT row_found THEN
      shrttrm_row.shrttrm_pidm                  := grdroll_rec.pidm;
      shrttrm_row.shrttrm_term_code             := grdroll_rec.term;
      shrttrm_row.shrttrm_update_source_ind     := 'S';
      shrttrm_row.shrttrm_pre_catalog_ind       := 'N';
      shrttrm_row.shrttrm_record_status_ind     := 'G';
      shrttrm_row.shrttrm_record_status_date    := SYSDATE;
      shrttrm_row.shrttrm_grade_mailing_date    := '';
      shrttrm_row.shrttrm_grade_mailer_chg_date := '';
      shrttrm_row.shrttrm_grade_mailer_dup      := '';
      shrttrm_row.shrttrm_grade_mailer_dup_date := '';
      shrttrm_row.shrttrm_exam_code             := '';
      shrttrm_row.shrttrm_code_transcript_dist  := '';
      shrttrm_row.shrttrm_astd_code_end_of_term := '';
      shrttrm_row.shrttrm_astd_date_end_of_term := '';
      shrttrm_row.shrttrm_activity_date         := SYSDATE;
      shrttrm_row.shrttrm_astd_code_dl          := '';
      shrttrm_row.shrttrm_astd_date_dl          := '';
      shrttrm_row.shrttrm_wrsn_code             := '';
      shrttrm_row.shrttrm_sbgi_code_trans       := '';
      IF NVL(GOKEACC.F_GETGTVSDAXEXTCODE('PROCESSSCP', 'CENTRICPERIODS'), /*BIEN*/
             'N') = 'Y' THEN
        shrttrm_row.shrttrm_scps_code := sb_centricperiod.f_get_student_scps_code(grdroll_rec.pidm, /*BIEN*/
                                                                                  grdroll_rec.term);
      ELSE
        shrttrm_row.shrttrm_scps_code := NULL;
      END IF;
      shkmods.p_insert_shrttrm(shrttrm_row); /*BIEN*/
      --
      p_insert_shrchrt;
    END IF;
    --
    -- Select MAX(shrtckn_seq_no)
    --
   -- If this is a Gradebook Reroll then we retain the existing SHRTCKN record.
   IF gradebook_reroll_pidm_parm IS NULL THEN
      -- Standard Roll so pick up the highest Seq TCKN rec for the Pidm/Term
      shksels.p_select_shrtckn_by_pidm_term( grdroll_rec.pidm /*BIEN*/
                                            ,grdroll_rec.term
                                            ,shrtckn_row
                                            ,row_found);

    shksels.p_select_shrtckn_by_pidm_term(grdroll_rec.pidm, /*BIEN*/
                                          grdroll_rec.term,
                                          shrtckn_row,
                                          row_found);
    IF NOT row_found THEN
      tckn_seq := 1;
    ELSE
      tckn_seq := shrtckn_row.shrtckn_seq_no + 1;
    END IF;
   ELSE
      -- Gradebook Reroll, pick up the seqno for the TCKN rec for the current Pidm/Term/Crn
      shksels.p_select_shrtckn_by_multi( grdroll_rec.pidm /*BIEN*/
                                        ,grdroll_rec.term
                                        ,grdroll_rec.crn
                                        ,shrtckn_row
                                        ,row_found);
      IF NOT row_found THEN
         tckn_seq := 1;
     dbms_output.put_line( 'SIMON- p_process_graderoll - reroll - no shrtckn');
      ELSE
         tckn_seq := shrtckn_row.shrtckn_seq_no;
     dbms_output.put_line( 'SIMON- p_process_graderoll - reroll - Use shrtcknseq: '||to_char(tckn_seq));
      END IF;
   END IF;
    --
    -- Insert row into SHRTCKN
    --
    shrtckn_row.shrtckn_pidm                 := grdroll_rec.pidm;
    shrtckn_row.shrtckn_term_code            := grdroll_rec.term;
    shrtckn_row.shrtckn_seq_no               := tckn_seq;
    shrtckn_row.shrtckn_crn                  := grdroll_rec.crn;
    shrtckn_row.shrtckn_subj_code            := grdroll_rec.subject;
    shrtckn_row.shrtckn_crse_numb            := grdroll_rec.crse_numb;
    shrtckn_row.shrtckn_coll_code            := grdroll_rec.college;
    shrtckn_row.shrtckn_camp_code            := grdroll_rec.campus;
    shrtckn_row.shrtckn_dept_code            := grdroll_rec.dept;
    shrtckn_row.shrtckn_divs_code            := grdroll_rec.divs;
    shrtckn_row.shrtckn_sess_code            := grdroll_rec.sess;
    shrtckn_row.shrtckn_crse_title           := grdroll_rec.ctitle;
    shrtckn_row.shrtckn_reg_seq              := grdroll_rec.regseq;
    shrtckn_row.shrtckn_course_comment       := '';
    shrtckn_row.shrtckn_repeat_course_ind    := '';
    shrtckn_row.shrtckn_activity_date        := SYSDATE;
    shrtckn_row.shrtckn_ptrm_code            := grdroll_rec.ptrm;
    shrtckn_row.shrtckn_seq_numb             := grdroll_rec.sect_seq;
    shrtckn_row.shrtckn_ptrm_start_date      := grdroll_rec.ptrm_start_date;
    shrtckn_row.shrtckn_ptrm_end_date        := grdroll_rec.ptrm_end_date;
    shrtckn_row.shrtckn_cont_hr              := grdroll_rec.tckn_cont;
    shrtckn_row.shrtckn_schd_code            := grdroll_rec.schd_code;
    shrtckn_row.shrtckn_repeat_sys_ind       := '';
    shrtckn_row.shrtckn_reg_start_date       := grdroll_rec.reg_start_date;
    shrtckn_row.shrtckn_reg_completion_date  := grdroll_rec.reg_completion_date;
    shrtckn_row.shrtckn_number_of_extensions := grdroll_rec.number_of_extensions;
    shrtckn_row.shrtckn_stsp_key_sequence    := grdroll_rec.reg_stsp_key_sequence;
    IF roll_title_parm = 'Y' THEN
      shrtckn_row.shrtckn_long_course_title := grdroll_rec.long_course_title;
    ELSE
      shrtckn_row.shrtckn_long_course_title := NULL;
    END IF;
   -- If this is a Gradebook Reroll then we retain the existing SHRTCKN record. Update it incase of changes
   --      shkmods.p_insert_shrtckn(shrtckn_row);
   IF gradebook_reroll_pidm_parm IS NOT NULL THEN
      shkmods.p_update_shrtckn(shrtckn_row); /*BIEN*/
      default_gchg_code := NVL(f_select_stvgcat_gchg('RR'),goksels.f_get_gtvsdax_row('EGBDEFAULTGCHG', 'REROLL').gtvsdax_external_code); /*BIEN*/
        open  find_composite_gchg_c (p_pidm  => grdroll_rec.pidm,
                 p_term  => grdroll_rec.term,
                 p_crn     => grdroll_rec.crn)  ;
         fetch find_composite_gchg_c into last_compositegchg_code;
          if find_composite_gchg_c%found and last_compositegchg_code is NOT NULL then
            default_gchg_code := last_compositegchg_code;
          end if;
          close find_composite_gchg_c;
   ELSE
    shkmods.p_insert_shrtckn(shrtckn_row); /*BIEN*/
   END IF;

    --
    -- Select MAX(shrtckg_seq_no)
    --
    shksels.p_select_shrtckg_by_multi(grdroll_rec.pidm, /*BIEN*/
                                      grdroll_rec.term,
                                      tckn_seq,
                                      shrtckg_row,
                                      row_found);
    IF NOT row_found THEN
      tckg_seq := 1;
    ELSE
      tckg_seq := shrtckg_row.shrtckg_seq_no + 1;
    END IF;
    --
    -- Insert row into SHRTCKG
    --
    shrtckg_row.shrtckg_pidm                  := grdroll_rec.pidm;
    shrtckg_row.shrtckg_term_code             := grdroll_rec.term;
    shrtckg_row.shrtckg_tckn_seq_no           := tckn_seq;
    shrtckg_row.shrtckg_seq_no                := tckg_seq;
    shrtckg_row.shrtckg_grde_code_final       := grdroll_rec.grade;
    shrtckg_row.shrtckg_gmod_code             := grdroll_rec.gmod;
    shrtckg_row.shrtckg_credit_hours          := grdroll_rec.credits;
    shrtckg_row.shrtckg_gchg_code             := default_gchg_code;
    shrtckg_row.shrtckg_final_grde_chg_date   := SYSDATE;
    shrtckg_row.shrtckg_final_grde_chg_user   := user_parm;
    shrtckg_row.shrtckg_activity_date         := SYSDATE;
    shrtckg_row.shrtckg_gcmt_code             := grdroll_rec.gcmt_code;
    shrtckg_row.shrtckg_term_code_grade       := grade_term_parm;
    shrtckg_row.shrtckg_hours_attempted       := grdroll_rec.attempt_hr;
    shrtckg_row.shrtckg_grde_code_incmp_final := grdroll_rec.grde_code_incmp_final;
    shrtckg_row.shrtckg_incomplete_ext_date   := grdroll_rec.incomplete_ext_date;
    shkmods.p_insert_shrtckg(shrtckg_row); /*BIEN*/
    --
    IF NOT holdgrdo THEN
      Tckg_seq                                  := tckg_seq + 1;
      shrtckg_row.shrtckg_pidm                  := grdroll_rec.pidm;
      shrtckg_row.shrtckg_term_code             := grdroll_rec.term;
      shrtckg_row.shrtckg_tckn_seq_no           := tckn_seq;
      shrtckg_row.shrtckg_seq_no                := tckg_seq;
      shrtckg_row.shrtckg_grde_code_final       := grade_sub;
      shrtckg_row.shrtckg_gmod_code             := grdroll_rec.gmod;
      shrtckg_row.shrtckg_credit_hours          := grdroll_rec.credits;
      shrtckg_row.shrtckg_gchg_code             := 'SG';
      shrtckg_row.shrtckg_final_grde_chg_date   := SYSDATE;
      shrtckg_row.shrtckg_gcmt_code             := grdroll_rec.gcmt_code;
      shrtckg_row.shrtckg_final_grde_chg_user   := user_parm;
      shrtckg_row.shrtckg_activity_date         := SYSDATE;
      shrtckg_row.shrtckg_term_code_grade       := grade_term_parm;
      shrtckg_row.shrtckg_hours_attempted       := attempt_hr_sub;
      shrtckg_row.shrtckg_grde_code_incmp_final := grdroll_rec.grde_code_incmp_final;
      shrtckg_row.shrtckg_incomplete_ext_date   := grdroll_rec.incomplete_ext_date;
      shkmods.p_insert_shrtckg(shrtckg_row); /*BIEN*/
    END IF;
    --
    -- Insert row into SHRTCKL
    --
   -- If this is a Gradebook Reroll then we retain the existing SHRTCKL record. Added IF statement only.
   IF gradebook_reroll_pidm_parm IS NULL THEN
    shrtckl_row.shrtckl_pidm             := grdroll_rec.pidm;
    shrtckl_row.shrtckl_term_code        := grdroll_rec.term;
    shrtckl_row.shrtckl_tckn_seq_no      := tckn_seq;
    shrtckl_row.shrtckl_levl_code        := grdroll_rec.reg_levl;
    shrtckl_row.shrtckl_activity_date    := SYSDATE;
    shrtckl_row.shrtckl_primary_levl_ind := 'Y';
    shkmods.p_insert_shrtckl(shrtckl_row); /*BIEN*/
   END IF;
    --
    -- If SHRGCOL doesn't exist with null print_status, insert row.
    -- Request_type will be based on whether SHRGCOL row was found
    -- with print_status = 'P'.
    -- If so, update SHRTTRM record_status to 'R' (revised).
    --
    IF NOT holdgcol THEN
      shrgcol_row.shrgcol_term_code     := grdroll_rec.term;
      shrgcol_row.shrgcol_pidm          := grdroll_rec.pidm;
      shrgcol_row.shrgcol_activity_date := SYSDATE;
      shrgcol_row.shrgcol_print_status  := '';
      shrgcol_row.shrgcol_error_ind     := '';
      IF NOT holdgcol_p THEN
        shrgcol_row.shrgcol_request_type := 'O';
        shkmods.p_insert_shrgcol(shrgcol_row); /*BIEN*/
      ELSE
        shrgcol_row.shrgcol_request_type := 'R';
        shkmods.p_insert_shrgcol(shrgcol_row); /*BIEN*/
        shrttrm_row.shrttrm_record_status_ind  := 'R';
        shrttrm_row.shrttrm_record_status_date := SYSDATE;
        shkmods.p_update_shrttrm(shrttrm_row); /*BIEN*/
      END IF;
    END IF;
    --
    -- If SHRTGPA doesn't exist where GPA_TYPE = 'I'
    -- and TRAM_SEQ and TRIT_SEQ are null, insert a row.
    --
    IF NOT holdtgpa THEN
      shrtgpa_row.shrtgpa_pidm            := grdroll_rec.pidm;
      shrtgpa_row.shrtgpa_term_code       := grdroll_rec.term;
      shrtgpa_row.shrtgpa_levl_code       := grdroll_rec.reg_levl;
      shrtgpa_row.shrtgpa_gpa_type_ind    := 'I';
      shrtgpa_row.shrtgpa_trit_seq_no     := '';
      shrtgpa_row.shrtgpa_tram_seq_no     := '';
      shrtgpa_row.shrtgpa_hours_attempted := 0;
      shrtgpa_row.shrtgpa_hours_earned    := 0;
      shrtgpa_row.shrtgpa_gpa_hours       := 0;
      shrtgpa_row.shrtgpa_quality_points  := 0;
      shrtgpa_row.shrtgpa_gpa             := 0;
      shrtgpa_row.shrtgpa_activity_date   := SYSDATE;
      shrtgpa_row.shrtgpa_hours_passed    := 0;
      shkmods.p_insert_shrtgpa(shrtgpa_row); /*BIEN*/
    END IF;
    --
    -- Insert into SHRGPAC if SHBCGPA_CAMP_GPA_IND = 'Y'
    -- and SHRGPAC not found for student
    --
    IF cgpa_ind = 'Y' THEN
      IF NOT holdgpac THEN
        shrgpac_row.shrgpac_pidm            := grdroll_rec.pidm;
        shrgpac_row.shrgpac_term_code       := grdroll_rec.term;
        shrgpac_row.shrgpac_levl_code       := grdroll_rec.reg_levl;
        shrgpac_row.shrgpac_camp_code       := grdroll_rec.campus;
        shrgpac_row.shrgpac_gpa_type_ind    := 'I';
        shrgpac_row.shrgpac_trit_seq_no     := '';
        shrgpac_row.shrgpac_tram_seq_no     := '';
        shrgpac_row.shrgpac_hours_attempted := 0;
        shrgpac_row.shrgpac_hours_earned    := 0;
        shrgpac_row.shrgpac_gpa_hours       := 0;
        shrgpac_row.shrgpac_quality_points  := 0;
        shrgpac_row.shrgpac_gpa             := 0;
        shrgpac_row.shrgpac_activity_date   := SYSDATE;
        shrgpac_row.shrgpac_hours_passed    := 0;
        IF report_mode_parm <> 'O' THEN
          shrgpac_row.shrgpac_gcol_ind := 'N';
        ELSE
          shrgpac_row.shrgpac_gcol_ind := 'Y';
        END IF;
        shkmods.p_insert_shrgpac(shrgpac_row); /*BIEN*/
      END IF;
    END IF;
    --
    -- If SHRLGPA rows not found, insert.  Else, update.
    --
    IF NOT holdlgpa_i THEN
      shrlgpa_i_row.shrlgpa_pidm            := grdroll_rec.pidm;
      shrlgpa_i_row.shrlgpa_levl_code       := grdroll_rec.reg_levl;
      shrlgpa_i_row.shrlgpa_gpa_type_ind    := 'I';
      shrlgpa_i_row.shrlgpa_hours_attempted := 0;
      shrlgpa_i_row.shrlgpa_hours_earned    := 0;
      shrlgpa_i_row.shrlgpa_gpa_hours       := 0;
      shrlgpa_i_row.shrlgpa_quality_points  := 0;
      shrlgpa_i_row.shrlgpa_gpa             := 0;
      shrlgpa_i_row.shrlgpa_activity_date   := SYSDATE;
      shrlgpa_i_row.shrlgpa_hours_passed    := 0;
      shrlgpa_i_row.shrlgpa_gpa_calc        := 'N';
      shkmods.p_insert_shrlgpa(shrlgpa_i_row); /*BIEN*/
    ELSE
      shrlgpa_i_row.shrlgpa_activity_date := SYSDATE;
      shrlgpa_i_row.shrlgpa_gpa_calc      := 'N';
      shkmods.p_update_shrlgpa(shrlgpa_i_row); /*BIEN*/
    END IF;
    --
    IF NOT holdlgpa_o THEN
      shrlgpa_o_row.shrlgpa_pidm            := grdroll_rec.pidm;
      shrlgpa_o_row.shrlgpa_levl_code       := grdroll_rec.reg_levl;
      shrlgpa_o_row.shrlgpa_gpa_type_ind    := 'O';
      shrlgpa_o_row.shrlgpa_hours_attempted := 0;
      shrlgpa_o_row.shrlgpa_hours_earned    := 0;
      shrlgpa_o_row.shrlgpa_gpa_hours       := 0;
      shrlgpa_o_row.shrlgpa_quality_points  := 0;
      shrlgpa_o_row.shrlgpa_gpa             := 0;
      shrlgpa_o_row.shrlgpa_activity_date   := SYSDATE;
      shrlgpa_o_row.shrlgpa_hours_passed    := 0;
      shrlgpa_o_row.shrlgpa_gpa_calc        := 'N';
      shkmods.p_insert_shrlgpa(shrlgpa_o_row); /*BIEN*/
    ELSE
      shrlgpa_o_row.shrlgpa_activity_date := SYSDATE;
      shrlgpa_o_row.shrlgpa_gpa_calc      := 'N';
      shkmods.p_update_shrlgpa(shrlgpa_o_row); /*BIEN*/
    END IF;
    --
    -- If SHRGPAL rows not found, insert.  Else, update.
    --
    IF cgpa_ind = 'Y' THEN
      IF NOT holdgpal_i THEN
        shrgpal_i_row.shrgpal_pidm            := grdroll_rec.pidm;
        shrgpal_i_row.shrgpal_levl_code       := grdroll_rec.reg_levl;
        shrgpal_i_row.shrgpal_camp_code       := grdroll_rec.campus;
        shrgpal_i_row.shrgpal_gpa_type_ind    := 'I';
        shrgpal_i_row.shrgpal_hours_attempted := 0;
        shrgpal_i_row.shrgpal_hours_earned    := 0;
        shrgpal_i_row.shrgpal_gpa_hours       := 0;
        shrgpal_i_row.shrgpal_quality_points  := 0;
        shrgpal_i_row.shrgpal_gpa             := 0;
        shrgpal_i_row.shrgpal_activity_date   := SYSDATE;
        shrgpal_i_row.shrgpal_hours_passed    := 0;
        shrgpal_i_row.shrgpal_gpa_calc        := 'N';
        shkmods.p_insert_shrgpal(shrgpal_i_row); /*BIEN*/
      ELSE
        shrgpal_i_row.shrgpal_activity_date := SYSDATE;
        shrgpal_i_row.shrgpal_gpa_calc      := 'N';
        shkmods.p_update_shrgpal(shrgpal_i_row); /*BIEN*/
      END IF;
      IF NOT holdgpal_o THEN
        shrgpal_o_row.shrgpal_pidm            := grdroll_rec.pidm;
        shrgpal_o_row.shrgpal_levl_code       := grdroll_rec.reg_levl;
        shrgpal_o_row.shrgpal_camp_code       := grdroll_rec.campus;
        shrgpal_o_row.shrgpal_gpa_type_ind    := 'O';
        shrgpal_o_row.shrgpal_hours_attempted := 0;
        shrgpal_o_row.shrgpal_hours_earned    := 0;
        shrgpal_o_row.shrgpal_gpa_hours       := 0;
        shrgpal_o_row.shrgpal_quality_points  := 0;
        shrgpal_o_row.shrgpal_gpa             := 0;
        shrgpal_o_row.shrgpal_activity_date   := SYSDATE;
        shrgpal_o_row.shrgpal_hours_passed    := 0;
        shrgpal_o_row.shrgpal_gpa_calc        := 'N';
        shkmods.p_insert_shrgpal(shrgpal_o_row); /*BIEN*/
      ELSE
        shrgpal_o_row.shrgpal_activity_date := SYSDATE;
        shrgpal_o_row.shrgpal_gpa_calc      := 'N';
        shkmods.p_update_shrgpal(shrgpal_o_row); /*BIEN*/
      END IF;
    END IF;
    lv_curriculum_rec := NULL;
    --- convert curriculum before starting the roll process
    BEGIN
      convert_learner := soklcur.f_convert_learner(grdroll_rec.pidm); /*BIEN*/
      convert_outcome := soklcur.f_convert_outcome(grdroll_rec.pidm); /*BIEN*/
    EXCEPTION
      WHEN OTHERS THEN
        IF SQLCODE = gb_event.APP_ERROR THEN /*BIEN*/
          api_error := 'Y';
          P_generate_api_error(p_err => sqlerrm);
        END IF;
    END;
    IF api_error = 'N' THEN
      --- populate temp table with student current term for selecting the
      --  curricula.  Learner curricula are selected if term is less than
      --  the end term of the sgbstdn to term.
      soklcur.p_create_sotvcur(p_pidm      => grdroll_rec.pidm, /*BIEN*/
                               p_term_code => grdroll_rec.stuterm,
                               p_lmod_code => sb_curriculum_str.f_learner); /*BIEN*/
      endterm := sb_learner.f_query_end(p_pidm          => grdroll_rec.pidm,
                                        p_term_code_eff => grdroll_rec.stuterm);   /*BIEN*/
      p_print_dbms('---------------------');
      p_print_dbms(gb_common.f_get_id(grdroll_rec.pidm) || ' Stuterm: ' ||  /*BIEN*/
                   grdroll_rec.stuterm || 'End term: ' || endterm ||
                   ' crn: ' || grdroll_rec.crn);
      -- open cursor for learner  curriculum
      -- we need to roll even non current curriculum so non destructive updates
      -- make it to the outcome in case priorities are switched
      -- read in priority, seqno order to get youngest first
      OPEN lv_curriculum_cur(p_pidm      => grdroll_rec.pidm,
                             p_lmod_code => sb_curriculum_str.f_learner, /*BIEN*/
                             p_end_term  => endterm);
      LOOP
        FETCH lv_curriculum_cur
          INTO lv_curriculum_rec;
        EXIT WHEN lv_curriculum_cur%NOTFOUND;
        -- initialize a few variables for the curriculum processing
        current_ind := sb_curriculum.f_find_current_all_ind(p_pidm                 => lv_curriculum_rec.r_pidm,
                                                            p_lmod_code            => lv_curriculum_rec.r_lmod_code,
                                                            p_term_code            => lv_curriculum_rec.r_term_code,
                                                            p_keyseqno             => lv_curriculum_rec.r_key_seqno,
                                                            p_priority_no          => lv_curriculum_rec.r_priority_no,
                                                            p_seqno                => lv_curriculum_rec.r_seqno,
                                                            p_eff_term             => grdroll_rec.stuterm,
                                                            p_current_cde          => lv_curriculum_rec.r_current_cde,
                                                            p_override_current_ind => 'Y',
                                                            p_end_term             => lv_curriculum_rec.r_term_code_end); /*BIEN*/
        p_print_dbms('********');
        p_print_dbms('start of roll for id ' || grdroll_rec.roll_id ||
                     ' curric ;' || lv_curriculum_rec.r_seqno || ' prior ' ||
                     lv_curriculum_rec.r_priority_no || ' rolled ' ||
                     lv_curriculum_rec.r_rolled_seqno || ' stsp: ' ||
                     lv_curriculum_rec.r_key_seqno || '  cact: ' ||
                     lv_curriculum_rec.r_cact_code || ' current ' ||
                     current_ind || ' term ' ||
                     lv_curriculum_rec.r_term_code || ' grd term: ' ||
                     grdroll_rec.stuterm || ' end term ' || endterm ||
                     ' grd term: ' || grdroll_rec.term);

        dgmr_seq      := '';
        lv_dgmr_seqno := '';
        dgmr_stsp     := '';
        --  make sure the roll indicator is Y on the learner curriculum
        --- take out processing to roll the curriculum and put in a separate procedure
        --  insert the sgbstdn   grad info if it doesnt exist on the learner curriculum
        P_roll_outcome(p_pidm            => lv_curriculum_rec.r_pidm,
                       P_term_code       => grdroll_rec.stuterm,
                       P_lcur_seqno      => lv_curriculum_rec.r_seqno,
                       P_lcur_rec        => lv_curriculum_rec,
                       p_roll_ind        => lv_curriculum_rec.r_roll_ind,
                       P_degree_seqno    => lv_dgmr_seqno,
                       p_current_ind     => current_ind,
                       p_graduation_date => NVL(lv_curriculum_rec.r_exp_grad_date,
                                                grdroll_rec.graddate),
                       p_acyr_code       => NVL(lv_curriculum_rec.r_acyr_code,
                                                grdroll_rec.gradyear),
                       p_term_code_grad  => NVL(lv_curriculum_rec.r_term_code_grad,
                                                grdroll_rec.gradterm));
        p_print_dbms('returned from roll deg seqno ' || dgmr_seq ||
                     ' lv dgmr: ' || lv_dgmr_seqno || ' stsp: ' ||
                     dgmr_stsp || ' is the degree awarded:  ' ||
                     sb_learneroutcome_rules.f_degree_awarded(p_pidm   => grdroll_rec.pidm, /*BIEN*/
                                                              p_seq_no => dgmr_seq)); 
        --  insert course into history for degree
        --  insert only if the degree has not been awarded
        IF dgmr_seq IS NOT NULL THEN
          IF sb_learneroutcome_rules.f_degree_awarded(p_pidm   => grdroll_rec.pidm, /*BIEN*/
                                                      p_seq_no => dgmr_seq) = 'N' THEN
            p_insert_shrtckd(p_tckn_term  => grdroll_rec.term,
                             p_tckn_seqno => tckn_seq);
            ---  need to save the curriculum in the batch report table sotprnt
            --- if this is the batch run,  save record in sotprnt
            print_happened_ind := 'Y';
            p_generate_report;
          END IF;
          degree_cnt := degree_cnt + 1;
          IF degree_cnt = 1 THEN
            degrees_string := '( ' || dgmr_seq;
          ELSE
            degrees_string := degrees_string || ', ' || dgmr_seq;
          END IF;
        END IF;
      END LOOP;
      /* end of reading learner curriculum */
      CLOSE lv_curriculum_cur;
    END IF; -- no api errors from conversion
    --- find manually added degrees not awarded and award the course to that degree
    IF degree_cnt > 0 THEN
      degrees_string := degrees_string || ' ) ';
      degree_sql     := degree_sql || ' ' || degrees_string;
      p_print_dbms('Degree sql: ' || degree_sql);
      OPEN c FOR degree_sql
        USING grdroll_rec.pidm;
      LOOP
        FETCH c
          INTO dgmr_seq, dgmr_stsp;
        EXIT WHEN c%NOTFOUND;
        p_print_dbms('manually added degree: ' || dgmr_seq ||
                     ' tckn seq: ' || tckn_seq);
        p_insert_shrtckd(p_tckn_term  => grdroll_rec.term,
                         p_tckn_seqno => tckn_seq);
        print_happened_ind := 'Y';
        -- get the degree info for the report
        OPEN degree_pgm_c;
        FETCH degree_pgm_c
          INTO sdegc, slevl, scoll, scampus, sprogram, lv_curriculum_rec.r_seqno;
        CLOSE degree_pgm_c;
        p_generate_report;
      END LOOP;
      CLOSE c;
    ELSE
      --- degrees found is 0
      OPEN degree_sql2_c;
      LOOP
        FETCH degree_sql2_c
          INTO dgmr_seq, dgmr_stsp;
        EXIT WHEN degree_sql2_c%notfound;
        p_insert_shrtckd(p_tckn_term  => grdroll_rec.term,
                         p_tckn_seqno => tckn_seq);
        print_happened_ind := 'Y';
        -- get the degree info for the report
        OPEN degree_pgm_c;
        FETCH degree_pgm_c
          INTO sdegc, slevl, scoll, scampus, sprogram, lv_curriculum_rec.r_seqno;
        CLOSE degree_pgm_c;
        p_generate_report;
      END LOOP;
      CLOSE degree_sql2_c;
    END IF;
    IF print_happened_ind = 'N' THEN
      lv_curriculum_rec.r_seqno := NULL;
      sdegc                     := NULL;
      slevl                     := NULL;
      scoll                     := NULL;
      smajr                     := NULL;
      scampus                   := NULL;
      sprogram                  := NULL;
      p_generate_report;
    END IF;
    -- update rolled ind on sfrstcr
    p_update_sfrstcr;
    gv_grade_roll_ind := '';
  END p_process_graderoll;
  --
  --
  --
  PROCEDURE p_report_grade_error IS
  BEGIN
    p_init_sotprnt;
    sotprnt_row.sotprnt_rectype := 'GRDERR';
    sotprnt_row.sotprnt_id      := grdroll_rec.roll_id;
    sotprnt_row.sotprnt_name    := grdroll_rec.roll_name;

    sotprnt_row.SOTPRNT_LEVL_CODE_1 := grdroll_rec.reg_levl;
    sotprnt_row.SOTPRNT_CAMP_CODE  :=  grdroll_rec.campus;
    shkmods.p_insert_sotprnt(sotprnt_row); /*BIEN*/
  END p_report_grade_error;
  --
  --
  --

  PROCEDURE p_report_history_error IS
  BEGIN
    p_init_sotprnt;
    sotprnt_row.sotprnt_rectype := 'HSTERR';
    sotprnt_row.sotprnt_id      := grdroll_rec.roll_id;
    sotprnt_row.sotprnt_name    := grdroll_rec.roll_name;

    sotprnt_row.SOTPRNT_LEVL_CODE_1 := grdroll_rec.reg_levl;
    sotprnt_row.SOTPRNT_CAMP_CODE  :=  grdroll_rec.campus;

    shkmods.p_insert_sotprnt(sotprnt_row); /*BIEN*/
  END p_report_history_error;
  --
  --


  PROCEDURE p_report_coreq_error(lv_mode      varchar2) IS
  BEGIN
    p_init_sotprnt;
    sotprnt_row.sotprnt_rectype := lv_mode;
    sotprnt_row.sotprnt_id      := grdroll_rec.roll_id;
    sotprnt_row.sotprnt_name    := grdroll_rec.roll_name;
    sotprnt_row.SOTPRNT_LEVL_CODE_1 := grdroll_rec.reg_levl;
    sotprnt_row.SOTPRNT_CAMP_CODE  :=  grdroll_rec.campus;
    shkmods.p_insert_sotprnt(sotprnt_row); /*BIEN*/
  END p_report_coreq_error;


  PROCEDURE p_roll_body IS
    CURSOR shrgrde_grade_sub_c(p_grade_sub shrgrde.shrgrde_code%TYPE, p_levl_code shrgrde.shrgrde_levl_code%TYPE, p_term_code shrgrde.shrgrde_term_code_effective%TYPE) IS
      SELECT shrgrde_attempted_ind
        FROM shrgrde
       WHERE shrgrde_code = p_grade_sub
         AND shrgrde_levl_code = p_levl_code
         AND shrgrde_grde_status_ind = 'A'
         AND shrgrde_term_code_effective =
             (SELECT MAX(Y.shrgrde_term_code_effective)
                FROM shrgrde Y
               WHERE Y.shrgrde_code = p_grade_sub
                 AND Y.shrgrde_levl_code = p_levl_code
                 AND Y.shrgrde_grde_status_ind = 'A'
                 AND Y.shrgrde_term_code_effective <= p_term_code);
    lv_attempted_ind shrgrde.shrgrde_attempted_ind%TYPE;

    lv_mode             varchar2(10);
    lv_MensErro         varchar2(200);

  BEGIN
    lv_mode := null;
    lv_MensErro := null;


    sotprnt_row.sotprnt_count_processed := sotprnt_row.sotprnt_count_processed + 1;
    --
    IF (sect_crn <> grdroll_rec.crn) OR (sect_ptrm <> grdroll_rec.ptrm) THEN
      p_get_new_sect;
    END IF;
    --
    shksels.p_select_shrgrdo_by_multi(grdroll_rec.grade, /*BIEN*/
                                      grdroll_rec.reg_levl,
                                      grdroll_rec.gmod,
                                      grdroll_rec.term,
                                      shrgrdo_row,
                                      row_found);
    holdgrdo := row_found;
    --
    shksels.p_select_shrgrds_by_multi(grdroll_rec.grade, /*BIEN*/
                                      grdroll_rec.reg_levl,
                                      grdroll_rec.gmod,
                                      grdroll_rec.term,
                                      shrgrds_row,
                                      row_found);
    holdgrds := row_found;
    IF row_found THEN
      grade_sub := shrgrds_row.shrgrds_grde_code_substitute;
      OPEN shrgrde_grade_sub_c(p_grade_sub => grade_sub,
                               p_levl_code => grdroll_rec.reg_levl,
                               p_term_code => grdroll_rec.term);
      FETCH shrgrde_grade_sub_c
        INTO lv_attempted_ind;
      IF shrgrde_grade_sub_c%NOTFOUND THEN
        RAISE sokexps.system_problem;
      END IF;
      CLOSE shrgrde_grade_sub_c;
      IF (lv_attempted_ind = 'Y') AND (grdroll_rec.attempt_hr_ind = 'Y') THEN
        attempt_hr_sub := grdroll_rec.credit_hr_hold;
      ELSE
        attempt_hr_sub := 0;
      END IF;
    END IF;
    --
    shksels.p_select_shrtckn_by_multi(grdroll_rec.pidm, /*BIEN*/
                                      grdroll_rec.term,
                                      grdroll_rec.crn,
                                      shrtckn_row,
                                      row_found);
    holdtckn := row_found;
    --
    -- report_mode_parm:  A = Audit,  U = Update (from SZRROLL.pc)
    --                    O = Online (from SFAALST.fmb or SFASLST.fmb)
    --
    -- print_sel_parm: E = Error report only
    --
    IF holdgrdo OR holdgrds THEN
      IF (   NOT holdtckn
          OR gradebook_reroll_pidm_parm IS NOT NULL
         ) THEN

        p_check_corequisite_crn(grdroll_rec.pidm,
                                grdroll_rec.crn,
                                grdroll_rec.term,
                                grdroll_rec.grade,
                                lv_mode,
                                lv_MensErro
                                );
        if lv_mode = 'CRQGDM' then
            p_report_coreq_error(lv_mode);

        elsif lv_mode = 'CRQGDF' then
            p_report_coreq_error(lv_mode);
        else
            -- BA 8.7 [MCLA:002.1.0]  -- Addendum   MKU  17/FEB/2016
            -- check for occurrence on SZRELEC
            lv_MensErro := null;

            p_check_optative(grdroll_rec.pidm,
                             grdroll_rec.crn,
                             grdroll_rec.term,
                             grdroll_rec.reg_stsp_key_sequence,
                             lv_MensErro
                              );

            if lv_MensErro = 'NOHIST' then
                IF (report_mode_parm <> 'O') THEN
                    p_report_history_error;
                END IF;
            else
                p_process_graderoll;
            end if;

            -- EA 8.7 [MCLA:002.1.0]  -- Addendum   MKU  17/FEB/2016

            -- 8.7 [MCLA:002.1.0]  -- Addendum   MKU  17/FEB/2016 - Commented
            -- p_process_graderoll;
        end if;
      ELSE
        IF (report_mode_parm <> 'O') THEN
          p_report_history_error;
        END IF;
      END IF;
    ELSE
      IF (report_mode_parm <> 'O') THEN
        p_report_grade_error;
      END IF;
    END IF;
  END p_roll_body;
  --
  --
  --
  PROCEDURE p_init_fields IS
  BEGIN
    grade_sub     := ' ';
    deg1_updated  := 'N';
    deg1_created  := 'N';
    deg2_updated  := 'N';
    deg2_created  := 'N';
    holdgcol      := FALSE;
    holdgcol_p    := FALSE;
    holdgpac      := FALSE;
    holdgpal_i    := FALSE;
    holdgpal_o    := FALSE;
    holdgrdo      := FALSE;
    holdgrds      := FALSE;
    holdinst      := FALSE;
    holdlgpa_i    := FALSE;
    holdlgpa_o    := FALSE;
    holdtckg      := FALSE;
    holdtckn      := FALSE;
    holdtgpa      := FALSE;
    dgmr_seq      := 0;
    dgmr_seq1     := 0;
    dgmr_seq2     := 0;
    gradapp_date  := NULL;
    grst_code     := NULL;
    complete_term := NULL;
    fee_ind       := NULL;
    fee_date      := NULL;
  END p_init_fields;
  --
  --
  PROCEDURE p_get_student_course_continue IS
    CURSOR get_reg_completion_date_c(p_crn sfrareg.sfrareg_crn%TYPE, p_term_code stvterm.stvterm_code%TYPE, p_pidm sfrareg.sfrareg_pidm%TYPE) IS
      SELECT A.sfrareg_completion_date, A.sfrareg_extension_number
        FROM sfrareg A
       WHERE A.sfrareg_extension_number =
             (SELECT MAX(B.sfrareg_extension_number)
                FROM stvrsts, sfrareg B
               WHERE stvrsts_code = B.sfrareg_rsts_code
                 /* BA 8.7 [MCLA:002.1.1] GGR 30-JUN-2017 */
                 --AND stvrsts_withdraw_ind = 'N'
                 AND stvrsts_gradable_ind  = 'Y'
                 AND stvrsts_withdraw_ind  = 'N'
                 AND stvrsts_code Not In ('BG','BM','DW','WL')
                 /* EA 8.7 [MCLA:002.1.1] GGR 30-JUN-2017 */
                 AND B.sfrareg_crn = A.sfrareg_crn
                 AND B.sfrareg_term_code = A.sfrareg_term_code
                 AND B.sfrareg_pidm = A.sfrareg_pidm)
         AND A.sfrareg_crn = p_crn
         AND A.sfrareg_term_code = p_term_code
         AND A.sfrareg_pidm = p_pidm;
  BEGIN
    IF grdroll_rec.ptrm IS NULL THEN
      OPEN get_reg_completion_date_c(p_crn       => grdroll_rec.crn,
                                     p_term_code => grdroll_rec.term,
                                     p_pidm      => grdroll_rec.pidm);
      FETCH get_reg_completion_date_c
        INTO grdroll_rec.reg_completion_date, grdroll_rec.number_of_extensions;
      IF get_reg_completion_date_c%NOTFOUND THEN
        grdroll_rec.reg_completion_date  := NULL;
        grdroll_rec.number_of_extensions := 0;
      END IF;
      CLOSE get_reg_completion_date_c;
    END IF;
    p_roll_body;
    p_init_fields;
  END p_get_student_course_continue;
  --
  --
  --
  PROCEDURE p_get_student_course IS
    --
    -- This cursor contains a UNION. The first SELECT gets OLR courses (those
    -- where SSBSECT_PTRM_CODE IS NULL and SFRAREG rows exist).  The second
    -- SELECT gets traditional courses (those where SSBSECT_PTRM_CODE IS NOT NULL.
    -- No SFRAREG data is selected for traditional courses).
    --
    CURSOR get_student_course_by_term_c(p_term_code sfrstcr.sfrstcr_term_code%TYPE, p_crn sfrstcr.sfrstcr_crn%TYPE, p_ptrm_code stvptrm.stvptrm_code%TYPE) RETURN roll_record IS
      SELECT sfrstcr_pidm,
             sfrstcr_term_code,
             NULL,
             sfrstcr_crn,
             SUBSTR(spriden_last_name || ', ' || spriden_first_name || ' ' ||
                    spriden_mi,
                    1,
                    30),
             spriden_id,
             ssbsect_subj_code,
             ssbsect_crse_numb,
             ssbsect_camp_code,
             NVL(ssbsect_crse_title, scbcrse_title),
             ssbsect_seq_numb,
             ssbsect_sess_code,
             sfrstcr_grde_code,
             sfrstcr_reg_seq,
             sfrstcr_gmod_code,
             DECODE(stvrsts_attempt_hr_ind,
                    'Y',
                    DECODE(shrgrde_attempted_ind,
                           'Y',
                           sfrstcr_credit_hr_hold,
                           0),
                    0),
             sfrstcr_credit_hr,
             sfrstcr_credit_hr_hold,
             stvrsts_attempt_hr_ind,
             NVL(ssbovrr_coll_code, scbcrse_coll_code),
             NVL(ssbovrr_divs_code, scbcrse_divs_code),
             NVL(ssbovrr_dept_code, scbcrse_dept_code),
             sgbstdn_exp_grad_date,
             sgbstdn_term_code_grad,
             sgbstdn_acyr_code,
             sgbstdn_term_code_eff,
             sfrstcr_levl_code,
             stvterm_acyr_code,
             NULL,
             NULL,
             DECODE(scbcrse_ceu_ind,
                    'Y',
                    NVL(ssbsect_cont_hr, scbcrse_cont_hr_low),
                    ''),
             ssbsect_schd_code,
             sgbstdn_degc_code_dual,
             sgbstdn_levl_code_dual,
             sgbstdn_dept_code_dual,
             sgbstdn_coll_code_dual,
             sgbstdn_majr_code_dual,
             NVL(sgbstdn_degc_code_dual, 'X'),
             NVL(sgbstdn_levl_code_dual, 'X'),
             NVL(sgbstdn_coll_code_dual, 'X'),
             NVL(sgbstdn_dept_code_dual, 'X'),
             NVL(sgbstdn_majr_code_dual, 'X'),
             sfrstcr_gcmt_code,
             NULL,
             sfrareg_start_date,
             NULL,
             sfrareg_instructor_pidm,
             ssrsyln_long_course_title,
             sfrstcr_grde_code_incmp_final,
             sfrstcr_incomplete_ext_date,
             sfrstcr_stsp_key_sequence
        FROM sgbstdn,
             stvterm,
             stvrsts,
             scbcrse,
             ssbovrr,
             sfrareg,
             shrgrde,
             ssrsyln,
             spriden,
             sfrstcr,
             ssbsect
       WHERE scbcrse_subj_code = ssbsect_subj_code
         AND scbcrse_crse_numb = ssbsect_crse_numb
         AND scbcrse_eff_term =
             (SELECT MAX(b.scbcrse_eff_term)
                FROM scbcrse b
               WHERE b.scbcrse_subj_code = ssbsect_subj_code
                 AND b.scbcrse_crse_numb = ssbsect_crse_numb
                 AND b.scbcrse_eff_term <= term_parm)
         AND ssbovrr_term_code(+) = ssbsect_term_code
         AND ssbovrr_crn(+) = ssbsect_crn
         AND ssrsyln_term_code(+) = ssbsect_term_code
         AND ssrsyln_crn(+) = ssbsect_crn
         AND sgbstdn_pidm = sfrstcr_pidm
         AND sgbstdn_term_code_eff =
             (SELECT MAX(c.sgbstdn_term_code_eff)
                FROM sgbstdn c
               WHERE c.sgbstdn_pidm = sfrstcr_pidm
                 AND c.sgbstdn_term_code_eff <= term_parm)
         AND spriden_change_ind IS NULL
         AND spriden_pidm = sfrstcr_pidm
         AND sfrstcr_pidm = NVL( gradebook_reroll_pidm_parm, sfrstcr_pidm)
         AND sfrareg_extension_number =
             (SELECT MIN(X.sfrareg_extension_number)
                FROM sfrareg X
               WHERE X.sfrareg_crn = sfrstcr_crn
                 AND X.sfrareg_term_code = sfrstcr_term_code
                 AND X.sfrareg_pidm = sfrstcr_pidm)
         AND sfrareg_crn = sfrstcr_crn
         AND sfrareg_term_code = sfrstcr_term_code
         AND sfrareg_pidm = sfrstcr_pidm
    -- AND sfrstcr_pidm = NVL( gradebook_reroll_pidm_parm, sfrstcr_pidm)  --NJ Jun-2014. Defect CR-000103537. Moved below UNION.
         AND sfrstcr_term_code = ssbsect_term_code
         AND sfrstcr_crn = ssbsect_crn
         AND sfrstcr_grde_date IS NULL
         AND sfrstcr_grde_code IS NOT NULL
         AND shrgrde_code = sfrstcr_grde_code
         AND shrgrde_levl_code = sfrstcr_levl_code
         AND shrgrde_grde_status_ind = 'A'
         AND shrgrde_term_code_effective =
             (SELECT MAX(Y.shrgrde_term_code_effective)
                FROM shrgrde Y
               WHERE Y.shrgrde_code = sfrstcr_grde_code
                 AND Y.shrgrde_levl_code = sfrstcr_levl_code
                 AND Y.shrgrde_grde_status_ind = 'A'
                 AND Y.shrgrde_term_code_effective <= sfrstcr_term_code)
         AND stvrsts_code = sfrstcr_rsts_code
         /* BA 8.7 [MCLA:002.1.1] GGR 30-JUN-2017 */
         AND stvrsts_gradable_ind  = 'Y'
         AND stvrsts_withdraw_ind  = 'N'
         AND stvrsts_code Not In ('BG','BM','DW','WL')
         /* EA 8.7 [MCLA:002.1.1] GGR 30-JUN-2017 */
         AND stvterm_code = ssbsect_term_code
         AND ssbsect_ptrm_code IS NULL
         AND ssbsect_crn LIKE p_crn
         AND ssbsect_term_code = p_term_code
         and (sfrstcr_levl_code in (SELECT sprcolr_value_atyp
                                     FROM sprcolr
                                    WHERE sprcolr_sessionid = sessionid_parm
                                      AND sprcolr_parm_number = '11'
                                      AND sprcolr_job = 'SZRROLL')
               or  nvl(trim(level_parm),'%') = '%')      -- 8.7 [MCLA:002.1.0]  added
         and (SSBSECT_CAMP_CODE = trim(campus_parm) or trim(campus_parm) is null)    -- 8.7 [MCLA:002.1.0]  added

      UNION ALL
      SELECT sfrstcr_pidm,
             sfrstcr_term_code,
             ssbsect_ptrm_code,
             sfrstcr_crn,
             SUBSTR(spriden_last_name || ', ' || spriden_first_name || ' ' ||
                    spriden_mi,
                    1,
                    30),
             spriden_id,
             ssbsect_subj_code,
             ssbsect_crse_numb,
             ssbsect_camp_code,
             NVL(ssbsect_crse_title, scbcrse_title),
             ssbsect_seq_numb,
             ssbsect_sess_code,
             sfrstcr_grde_code,
             sfrstcr_reg_seq,
             sfrstcr_gmod_code,
             DECODE(stvrsts_attempt_hr_ind,
                    'Y',
                    DECODE(shrgrde_attempted_ind,
                           'Y',
                           sfrstcr_credit_hr_hold,
                           0),
                    0),
             sfrstcr_credit_hr,
             sfrstcr_credit_hr_hold,
             stvrsts_attempt_hr_ind,
             NVL(ssbovrr_coll_code, scbcrse_coll_code),
             NVL(ssbovrr_divs_code, scbcrse_divs_code),
             NVL(ssbovrr_dept_code, scbcrse_dept_code),
             sgbstdn_exp_grad_date,
             sgbstdn_term_code_grad,
             sgbstdn_acyr_code,
             sgbstdn_term_code_eff,
             sfrstcr_levl_code,
             stvterm_acyr_code,
             NVL(sgrcoop_begin_date, ssbsect_ptrm_start_date),
             NVL(sgrcoop_end_date, ssbsect_ptrm_end_date),
             DECODE(scbcrse_ceu_ind,
                    'Y',
                    NVL(ssbsect_cont_hr, scbcrse_cont_hr_low),
                    ''),
             ssbsect_schd_code,
             sgbstdn_degc_code_dual,
             sgbstdn_levl_code_dual,
             sgbstdn_dept_code_dual,
             sgbstdn_coll_code_dual,
             sgbstdn_majr_code_dual,
             NVL(sgbstdn_degc_code_dual, 'X'),
             NVL(sgbstdn_levl_code_dual, 'X'),
             NVL(sgbstdn_coll_code_dual, 'X'),
             NVL(sgbstdn_dept_code_dual, 'X'),
             NVL(sgbstdn_majr_code_dual, 'X'),
             sfrstcr_gcmt_code,
             NULL,
             NULL,
             NULL,
             NULL,
             ssrsyln_long_course_title,
             sfrstcr_grde_code_incmp_final,
             sfrstcr_incomplete_ext_date,
             sfrstcr_stsp_key_sequence
        FROM sgbstdn,
             stvterm,
             stvrsts,
             scbcrse,
             ssbovrr,
             ssrsyln,
             shrgrde,
             sgrcoop,
             spriden,
             sfrstcr,
             ssbsect
       WHERE scbcrse_subj_code = ssbsect_subj_code
         AND scbcrse_crse_numb = ssbsect_crse_numb
         AND scbcrse_eff_term =
             (SELECT MAX(b.scbcrse_eff_term)
                FROM scbcrse b
               WHERE b.scbcrse_subj_code = ssbsect_subj_code
                 AND b.scbcrse_crse_numb = ssbsect_crse_numb
                 AND b.scbcrse_eff_term <= term_parm)
         AND ssbovrr_term_code(+) = ssbsect_term_code
         AND ssbovrr_crn(+) = ssbsect_crn
         AND ssrsyln_term_code(+) = ssbsect_term_code
         AND ssrsyln_crn(+) = ssbsect_crn
         AND sgrcoop_pidm(+) = sfrstcr_pidm
         AND sgrcoop_term_code(+) = sfrstcr_term_code
         AND sgrcoop_crn(+) = sfrstcr_crn
         AND sgbstdn_pidm = sfrstcr_pidm
         AND sgbstdn_term_code_eff =
             (SELECT MAX(c.sgbstdn_term_code_eff)
                FROM sgbstdn c
               WHERE c.sgbstdn_pidm = sfrstcr_pidm
                 AND c.sgbstdn_term_code_eff <= term_parm)
         AND spriden_change_ind IS NULL
         AND spriden_pidm = sfrstcr_pidm
         AND sfrstcr_term_code = ssbsect_term_code
         AND sfrstcr_crn = ssbsect_crn
         AND sfrstcr_grde_date IS NULL
         AND sfrstcr_grde_code IS NOT NULL
     AND sfrstcr_pidm = NVL( gradebook_reroll_pidm_parm, sfrstcr_pidm)  -- NJ Jun-2014 Defect CR-000103537. Moved below UNION.
         AND shrgrde_code = sfrstcr_grde_code
         AND shrgrde_levl_code = sfrstcr_levl_code
         AND shrgrde_grde_status_ind = 'A'
         AND shrgrde_term_code_effective =
             (SELECT MAX(Y.shrgrde_term_code_effective)
                FROM shrgrde Y
               WHERE Y.shrgrde_code = sfrstcr_grde_code
                 AND Y.shrgrde_levl_code = sfrstcr_levl_code
                 AND Y.shrgrde_grde_status_ind = 'A'
                 AND Y.shrgrde_term_code_effective <= sfrstcr_term_code)
         AND stvrsts_code = sfrstcr_rsts_code
         /* BA 8.7 [MCLA:002.1.1] GGR 30-JUN-2017 */
         AND stvrsts_gradable_ind  = 'Y'
         AND stvrsts_withdraw_ind  = 'N'
         AND stvrsts_code Not In ('BG','BM','DW','WL')
         /* EA 8.7 [MCLA:002.1.1] GGR 30-JUN-2017 */
         AND stvterm_code = ssbsect_term_code
         AND ssbsect_crn LIKE p_crn
         AND ssbsect_ptrm_code LIKE p_ptrm_code
         AND ssbsect_term_code = p_term_code
         and (sfrstcr_levl_code in (SELECT sprcolr_value_atyp
                                     FROM sprcolr
                                    WHERE sprcolr_sessionid = sessionid_parm
                                      AND sprcolr_parm_number = '11'
                                      AND sprcolr_job = 'SZRROLL')
               or   nvl(trim(level_parm),'%') = '%')        -- 8.7 [MCLA:002.1.0]  added
         and (SSBSECT_CAMP_CODE = trim(campus_parm) or trim(campus_parm) is null)    -- 8.7 [MCLA:002.1.0]  added

       ORDER BY 9,4, 5;

    CURSOR get_student_course_by_date_c(p_term_code sfrstcr.sfrstcr_term_code%TYPE, p_crn sfrstcr.sfrstcr_crn%TYPE, p_ptrm_code stvptrm.stvptrm_code%TYPE, p_from_date sfrareg.sfrareg_start_date%TYPE, p_to_date sfrareg.sfrareg_start_date%TYPE) RETURN
 roll_record IS

    --
    -- This cursor contains a UNION. The first SELECT gets OLR courses (those
    -- where SSBSECT_PTRM_CODE IS NULL and SFRAREG rows exist).  The second
    -- SELECT gets traditional courses (those where SSBSECT_PTRM_CODE IS NOT NULL.
    -- No SFRAREG data is selected for traditional courses).
    --
      SELECT sfrstcr_pidm,
             sfrstcr_term_code,
             ssbsect_ptrm_code,
             sfrstcr_crn,
             SUBSTR(spriden_last_name || ', ' || spriden_first_name || ' ' ||
                    spriden_mi,
                    1,
                    30),
             spriden_id,
             ssbsect_subj_code,
             ssbsect_crse_numb,
             ssbsect_camp_code,
             NVL(ssbsect_crse_title, scbcrse_title),
             ssbsect_seq_numb,
             ssbsect_sess_code,
             sfrstcr_grde_code,
             sfrstcr_reg_seq,
             sfrstcr_gmod_code,
             DECODE(stvrsts_attempt_hr_ind,
                    'Y',
                    DECODE(shrgrde_attempted_ind,
                           'Y',
                           sfrstcr_credit_hr_hold,
                           0),
                    0),
             sfrstcr_credit_hr,
             sfrstcr_credit_hr_hold,
             stvrsts_attempt_hr_ind,
             NVL(ssbovrr_coll_code, scbcrse_coll_code),
             NVL(ssbovrr_divs_code, scbcrse_divs_code),
             NVL(ssbovrr_dept_code, scbcrse_dept_code),
             sgbstdn_exp_grad_date,
             sgbstdn_term_code_grad,
             sgbstdn_acyr_code,
             sgbstdn_term_code_eff,
             sfrstcr_levl_code,
             stvterm_acyr_code,
             NULL, -- No PTRM start date exists for OLR course
             NULL, -- No PTRM end date exists for OLR course
             DECODE(scbcrse_ceu_ind,
                    'Y',
                    NVL(ssbsect_cont_hr, scbcrse_cont_hr_low),
                    ''),
             ssbsect_schd_code,
             sgbstdn_degc_code_dual,
             sgbstdn_levl_code_dual,
             sgbstdn_dept_code_dual,
             sgbstdn_coll_code_dual,
             sgbstdn_majr_code_dual,
             NVL(sgbstdn_degc_code_dual, 'X'),
             NVL(sgbstdn_levl_code_dual, 'X'),
             NVL(sgbstdn_coll_code_dual, 'X'),
             NVL(sgbstdn_dept_code_dual, 'X'),
             NVL(sgbstdn_majr_code_dual, 'X'),
             sfrstcr_gcmt_code,
             NULL,
             sfrareg_start_date,
             NULL,
             sfrareg_instructor_pidm,
             ssrsyln_long_course_title,
             sfrstcr_grde_code_incmp_final,
             sfrstcr_incomplete_ext_date,
             sfrstcr_stsp_key_sequence
        FROM sgbstdn,
             stvterm,
             stvrsts,
             scbcrse,
             ssbovrr,
             ssrsyln,
             shrgrde,
             sgrcoop,
             spriden,
             ssbsect,
             sfrstcr,
             sfrareg A
       WHERE scbcrse_subj_code = ssbsect_subj_code
         AND scbcrse_crse_numb = ssbsect_crse_numb
         AND scbcrse_eff_term =
             (SELECT MAX(b.scbcrse_eff_term)
                FROM scbcrse b
               WHERE b.scbcrse_subj_code = ssbsect_subj_code
                 AND b.scbcrse_crse_numb = ssbsect_crse_numb
                 AND b.scbcrse_eff_term <= ssbsect_term_code)
         AND ssbovrr_term_code(+) = sfrareg_term_code
         AND ssbovrr_crn(+) = sfrareg_crn
         AND ssrsyln_term_code(+) = sfrareg_term_code
         AND ssrsyln_crn(+) = sfrareg_crn
         AND sgrcoop_pidm(+) = sfrareg_pidm
         AND sgrcoop_term_code(+) = sfrareg_term_code
         AND sgrcoop_crn(+) = sfrareg_crn
         AND sgbstdn_pidm = sfrareg_pidm
         AND sgbstdn_term_code_eff =
             (SELECT MAX(c.sgbstdn_term_code_eff)
                FROM sgbstdn c
               WHERE c.sgbstdn_pidm = sfrareg_pidm
                 AND c.sgbstdn_term_code_eff <= sfrareg_term_code)
         AND spriden_change_ind IS NULL
         AND spriden_pidm = sfrareg_pidm
         AND stvterm_code = sfrareg_term_code
         AND ssbsect_crn = sfrareg_crn
         AND ssbsect_term_code = sfrareg_term_code
         AND ssbsect_ptrm_code IS NULL -- Get OLR courses only
         AND stvrsts_code = sfrstcr_rsts_code
         /* BA 8.7 [MCLA:002.1.1] GGR 30-JUN-2017 */
         AND stvrsts_gradable_ind  = 'Y'
         AND stvrsts_withdraw_ind  = 'N'
         AND stvrsts_code Not In ('BG','BM','DW','WL')
         /* EA 8.7 [MCLA:002.1.1] GGR 30-JUN-2017 */
         AND sfrstcr_grde_date IS NULL
         AND sfrstcr_grde_code IS NOT NULL
         AND shrgrde_code = sfrstcr_grde_code
         AND shrgrde_levl_code = sfrstcr_levl_code
         AND shrgrde_grde_status_ind = 'A'
         AND shrgrde_term_code_effective =
             (SELECT MAX(Y.shrgrde_term_code_effective)
                FROM shrgrde Y
               WHERE Y.shrgrde_code = sfrstcr_grde_code
                 AND Y.shrgrde_levl_code = sfrstcr_levl_code
                 AND Y.shrgrde_grde_status_ind = 'A'
                 AND Y.shrgrde_term_code_effective <= sfrstcr_term_code)
         AND sfrstcr_crn = sfrareg_crn
         AND sfrstcr_term_code = sfrareg_term_code
         AND sfrstcr_pidm = sfrareg_pidm
         AND A.sfrareg_extension_number =
             (SELECT MIN(X.sfrareg_extension_number)
                FROM sfrareg X
               WHERE X.sfrareg_crn = A.sfrareg_crn
                 AND X.sfrareg_term_code = A.sfrareg_term_code
                 AND X.sfrareg_pidm = A.sfrareg_pidm)
         AND sfrareg_crn LIKE p_crn
         AND sfrareg_term_code LIKE p_term_code
         AND sfrareg_start_date BETWEEN
             TO_DATE(p_from_date,
                     '' || G$_DATE.GET_NLS_DATE_FORMAT || 'HH24:MI:SS') AND
             TO_DATE(p_to_date,
                     '' || G$_DATE.GET_NLS_DATE_FORMAT || 'HH24:MI:SS')
         and (sfrstcr_levl_code in (SELECT sprcolr_value_atyp
                                     FROM sprcolr
                                    WHERE sprcolr_sessionid = sessionid_parm
                                      AND sprcolr_parm_number = '11'
                                      AND sprcolr_job = 'SZRROLL')
               or   nvl(trim(level_parm),'%') = '%')                   -- 8.7 [MCLA:002.1.0]  added
         and (SSBSECT_CAMP_CODE = TRIM(campus_parm) or TRIM(campus_parm) is null)    -- 8.7 [MCLA:002.1.0]  added

      UNION ALL
      SELECT sfrstcr_pidm,
             sfrstcr_term_code,
             ssbsect_ptrm_code,
             sfrstcr_crn,
             SUBSTR(spriden_last_name || ', ' || spriden_first_name || ' ' ||
                    spriden_mi,
                    1,
                    30),
             spriden_id,
             ssbsect_subj_code,
             ssbsect_crse_numb,
             ssbsect_camp_code,
             NVL(ssbsect_crse_title, scbcrse_title),
             ssbsect_seq_numb,
             ssbsect_sess_code,
             sfrstcr_grde_code,
             sfrstcr_reg_seq,
             sfrstcr_gmod_code,
             DECODE(stvrsts_attempt_hr_ind,
                    'Y',
                    DECODE(shrgrde_attempted_ind,
                           'Y',
                           sfrstcr_credit_hr_hold,
                           0),
                    0),
             sfrstcr_credit_hr,
             sfrstcr_credit_hr_hold,
             stvrsts_attempt_hr_ind,
             NVL(ssbovrr_coll_code, scbcrse_coll_code),
             NVL(ssbovrr_divs_code, scbcrse_divs_code),
             NVL(ssbovrr_dept_code, scbcrse_dept_code),
             sgbstdn_exp_grad_date,
             sgbstdn_term_code_grad,
             sgbstdn_acyr_code,
             sgbstdn_term_code_eff,
             sfrstcr_levl_code,
             stvterm_acyr_code,
             NVL(sgrcoop_begin_date, ssbsect_ptrm_start_date),
             NVL(sgrcoop_end_date, ssbsect_ptrm_end_date),
             DECODE(scbcrse_ceu_ind,
                    'Y',
                    NVL(ssbsect_cont_hr, scbcrse_cont_hr_low),
                    ''),
             ssbsect_schd_code,
             sgbstdn_degc_code_dual,
             sgbstdn_levl_code_dual,
             sgbstdn_dept_code_dual,
             sgbstdn_coll_code_dual,
             sgbstdn_majr_code_dual,
             NVL(sgbstdn_degc_code_dual, 'X'),
             NVL(sgbstdn_levl_code_dual, 'X'),
             NVL(sgbstdn_coll_code_dual, 'X'),
             NVL(sgbstdn_dept_code_dual, 'X'),
             NVL(sgbstdn_majr_code_dual, 'X'),
             sfrstcr_gcmt_code,
             NULL,
             NULL,
             NULL,
             NULL, --These fields not rolled for NON-OLR course
             ssrsyln_long_course_title,
             sfrstcr_grde_code_incmp_final,
             sfrstcr_incomplete_ext_date,
             sfrstcr_stsp_key_sequence
        FROM sgbstdn,
             stvterm,
             stvrsts,
             scbcrse,
             ssbovrr,
             ssrsyln,
             shrgrde,
             sgrcoop,
             spriden,
             sfrstcr,
             ssbsect
       WHERE scbcrse_subj_code = ssbsect_subj_code
         AND scbcrse_crse_numb = ssbsect_crse_numb
         AND scbcrse_eff_term =
             (SELECT MAX(b.scbcrse_eff_term)
                FROM scbcrse b
               WHERE b.scbcrse_subj_code = ssbsect_subj_code
                 AND b.scbcrse_crse_numb = ssbsect_crse_numb
                 AND b.scbcrse_eff_term <= ssbsect_term_code)
         AND ssbovrr_term_code(+) = ssbsect_term_code
         AND ssbovrr_crn(+) = ssbsect_crn
         AND ssrsyln_term_code(+) = ssbsect_term_code
         AND ssrsyln_crn(+) = ssbsect_crn
         AND sgrcoop_pidm(+) = sfrstcr_pidm
         AND sgrcoop_term_code(+) = sfrstcr_term_code
         AND sgrcoop_crn(+) = sfrstcr_crn
         AND sgbstdn_pidm = sfrstcr_pidm
         AND sgbstdn_term_code_eff =
             (SELECT MAX(c.sgbstdn_term_code_eff)
                FROM sgbstdn c
               WHERE c.sgbstdn_pidm = sfrstcr_pidm
                 AND c.sgbstdn_term_code_eff <= sfrstcr_term_code)
         AND spriden_change_ind IS NULL
         AND spriden_pidm = sfrstcr_pidm
         AND stvterm_code = sfrstcr_term_code
         AND stvrsts_code = sfrstcr_rsts_code
         /* BA 8.7 [MCLA:002.1.1] GGR 30-JUN-2017 */
         AND stvrsts_gradable_ind  = 'Y'
         AND stvrsts_withdraw_ind  = 'N'
         AND stvrsts_code Not In ('BG','BM','DW','WL')
         /* EA 8.7 [MCLA:002.1.1] GGR 30-JUN-2017 */
         AND sfrstcr_grde_date IS NULL
         AND sfrstcr_grde_code IS NOT NULL
         AND shrgrde_code = sfrstcr_grde_code
         AND shrgrde_levl_code = sfrstcr_levl_code
         AND shrgrde_grde_status_ind = 'A'
         AND shrgrde_term_code_effective =
             (SELECT MAX(Y.shrgrde_term_code_effective)
                FROM shrgrde Y
               WHERE Y.shrgrde_code = sfrstcr_grde_code
                 AND Y.shrgrde_levl_code = sfrstcr_levl_code
                 AND Y.shrgrde_grde_status_ind = 'A'
                 AND Y.shrgrde_term_code_effective <= sfrstcr_term_code)
         AND sfrstcr_crn = ssbsect_crn
         AND sfrstcr_term_code = ssbsect_term_code
         AND ssbsect_crn LIKE p_crn
         AND ssbsect_ptrm_code LIKE p_ptrm_code
         AND ssbsect_term_code LIKE p_term_code
         AND ssbsect_ptrm_start_date BETWEEN
             TO_DATE(p_from_date,
                     '' || G$_DATE.GET_NLS_DATE_FORMAT || 'HH24:MI:SS') AND
             TO_DATE(p_to_date,
                     '' || G$_DATE.GET_NLS_DATE_FORMAT || 'HH24:MI:SS')
         and (sfrstcr_levl_code in (SELECT sprcolr_value_atyp
                                     FROM sprcolr
                                    WHERE sprcolr_sessionid = sessionid_parm
                                      AND sprcolr_parm_number = '11'
                                      AND sprcolr_job = 'SZRROLL')
               or   nvl(trim(level_parm),'%') = '%')  -- 8.7 [MCLA:002.1.0]  added
         and (SSBSECT_CAMP_CODE = TRIM(campus_parm) or TRIM(campus_parm) is null)    -- 8.7 [MCLA:002.1.0]  added

       ORDER BY 2, 9, 4, 5;
  BEGIN
    sect_crn  := ' ';
    sect_ptrm := '-';
    --
    -- Process each student found for the input CRN and TERM,
    -- where grade exists and grade date is null
    --
    p_init_fields;
    IF (from_date_parm IS NOT NULL AND to_date_parm IS NOT NULL) THEN
      OPEN get_student_course_by_date_c(p_term_code => term_parm,
                                        p_crn       => crn_parm,
                                        p_ptrm_code => ptrm_parm,
                                        p_from_date => from_date_parm,
                                        p_to_date   => to_date_parm);
      FETCH get_student_course_by_date_c
        INTO grdroll_rec;
      WHILE get_student_course_by_date_c%FOUND LOOP
        p_get_student_course_continue;
        FETCH get_student_course_by_date_c
          INTO grdroll_rec;
      END LOOP;
      CLOSE get_student_course_by_date_c;
    ELSE
      OPEN get_student_course_by_term_c(p_term_code => term_parm,
                                        p_crn       => crn_parm,
                                        p_ptrm_code => ptrm_parm);
      FETCH get_student_course_by_term_c
        INTO grdroll_rec;
      WHILE get_student_course_by_term_c%FOUND LOOP
        p_get_student_course_continue;
        FETCH get_student_course_by_term_c
          INTO grdroll_rec;
      END LOOP;
      CLOSE get_student_course_by_term_c;
    END IF;
  END p_get_student_course;
  --
  --
  --


  PROCEDURE p_get_sprcolr_crn IS
    CURSOR get_crn_c(p_session sprcolr.sprcolr_sessionid%TYPE, p_parm_number sprcolr.sprcolr_parm_number%TYPE, p_job sprcolr.sprcolr_job%TYPE) IS
      SELECT sprcolr_value_atyp
        FROM sprcolr
       WHERE sprcolr_sessionid = p_session
         AND sprcolr_parm_number = p_parm_number
         AND sprcolr_job = p_job;
  BEGIN
   gradebook_reroll_pidm_parm := NULL;
    OPEN get_crn_c(p_session     => sessionid_parm,
                   p_parm_number => '05',
                   p_job         => 'SZRROLL');
    FETCH get_crn_c
      INTO crn_parm;
    WHILE get_crn_c%FOUND LOOP
      p_get_student_course;
      FETCH get_crn_c
        INTO crn_parm;
    END LOOP;
    CLOSE get_crn_c;
  END p_get_sprcolr_crn;

  --
  --
  --




  PROCEDURE p_do_batch_graderoll IS
    CURSOR get_ptrm_c(p_session sprcolr.sprcolr_sessionid%TYPE, p_parm_number sprcolr.sprcolr_parm_number%TYPE, p_job sprcolr.sprcolr_job%TYPE) IS
      SELECT sprcolr_value_atyp
        FROM sprcolr
       WHERE sprcolr_sessionid = p_session
         AND sprcolr_parm_number = p_parm_number
         AND sprcolr_job = p_job;
  BEGIN
    sotprnt_row.sotprnt_sessionid       := sessionid_parm;
    sotprnt_row.sotprnt_activity_date   := SYSDATE;
    sotprnt_row.sotprnt_job             := 'SZRROLL';
    sotprnt_row.sotprnt_count_processed := 0;
    sotprnt_row.sotprnt_recnum          := 0;
    --
    OPEN get_ptrm_c(p_session     => sessionid_parm,
                    p_parm_number => '04',
                    p_job         => 'SZRROLL');
    FETCH get_ptrm_c
      INTO ptrm_parm;
    WHILE get_ptrm_c%FOUND LOOP
      p_get_sprcolr_crn;
      FETCH get_ptrm_c
        INTO ptrm_parm;
    END LOOP;
    CLOSE get_ptrm_c;
    --
    p_init_sotprnt;
    sotprnt_row.sotprnt_rectype := 'FOOTER';
    shkmods.p_insert_sotprnt(sotprnt_row); /*BIEN*/
    --
    IF gv_update_mode IN ('0', 'U') THEN
      gb_common.p_COMMIT; /*BIEN*/
    END IF;
  END p_do_batch_graderoll;
  --
  --
  --
  PROCEDURE p_do_online_graderoll IS
  BEGIN
    ptrm_parm       := '%';
    roll_title_parm := 'Y';
   gradebook_reroll_pidm_parm := NULL;
    p_get_student_course;
    IF gv_update_mode IN ('0', 'U') THEN
      gb_common.p_COMMIT; /*BIEN*/
    END IF;
  END p_do_online_graderoll;
  --
  --
  --

  PROCEDURE p_do_graderoll(term_in            IN ssbsect.ssbsect_term_code%TYPE,
                           crn_in             IN ssbsect.ssbsect_crn%TYPE,
                           user_in            IN shrtckg.shrtckg_final_grde_chg_user%TYPE,
                           sessionid_in       IN sprcolr.sprcolr_sessionid%TYPE,
                           print_sel_in       IN VARCHAR2,
                           report_mode_in     IN VARCHAR2,
                           start_from_date_in IN VARCHAR2,
                           start_to_date_in   IN VARCHAR2,
                           grade_term_in      IN shrtckg.shrtckg_term_code_grade%TYPE,
                           roll_title_in      IN VARCHAR2,
                           p_campus_in        IN STVCAMP.STVCAMP_CODE%type,         -- 8.7 [MCLA:002.1.0]
                           p_level_in         IN STVLEVL.STVLEVL_CODE%TYPE          -- 8.7 [MCLA:002.1.0]
                            ) IS
  BEGIN

    --
    -- Select SHBCGPA_CAMP_GPA_IND. This only has to be done once,
    -- not for each student, so it is not part of the main loop.
    --
    shksels.p_select_shbcgpa(shbcgpa_row, row_found); /*BIEN*/
    IF row_found THEN
      cgpa_ind := shbcgpa_row.shbcgpa_camp_gpa_ind;
    ELSE
      cgpa_ind := ' ';
    END IF;
    --
    term_parm := term_in;
    -- added a check to append the time stamp only
    -- when start_from_date_in is not null
    IF start_from_date_in IS NOT NULL THEN
      --Defect 1-DOUZX: Use TO_DATE conversion
      from_date_parm := TO_DATE(start_from_date_in || '00:00:00',
                                '' || G$_DATE.GET_NLS_DATE_FORMAT ||
                                'HH24:MI:SS');
    END IF;
    -- added a check to append the time stamp only
    -- when start_to_date_in is not null
    IF start_to_date_in IS NOT NULL THEN
      --Defect 1-DOUZX: Use TO_DATE conversion
      to_date_parm := TO_DATE(start_to_date_in || '23:59:59',
                              '' || G$_DATE.GET_NLS_DATE_FORMAT ||
                              'HH24:MI:SS');
    END IF;
    crn_parm         := crn_in;
    user_parm        := user_in;
    sessionid_parm   := sessionid_in;
    print_sel_parm   := print_sel_in;
    report_mode_parm := report_mode_in;
    grade_term_parm  := grade_term_in;
    roll_title_parm  := roll_title_in;
    commit_count     := 0;

    -- BA 8.7 [MCLA:002.1.0]
    level_parm := p_level_in;
    campus_parm := p_campus_in;
    -- EA 8.7 [MCLA:002.1.0]

    --
    -- From BATCH, processing is as follows:
    -- read sprcolr_ptrm;
    -- while have sprcolr_ptrm LOOP
    --    read sprcolr_crn;
    --    while have sprcolr_crn LOOP
    --            while have students for term, ptrm, and crn
    --          process_students;
    --            END LOOP;
    --         read sprcolr_crn;
    --         END crn LOOP;
    -- read sprcolr_ptrm;
    -- END ptrm LOOP;
    --
    -- From ONLINE, processing is as follows:
    -- while have students for term and crn LOOP
    --       process_students;
    -- END LOOP;
    IF report_mode_parm <> 'O' THEN
      gv_update_mode := report_mode_parm;
      p_do_batch_graderoll;
    ELSE
      gv_update_mode := '0';
      /* on line always update */
      p_do_online_graderoll;
    END IF;
  END p_do_graderoll;
  -- this procedure is executed from the curriculum tab icon,  the grad app or shrrout
  -- it only rolls the curriculum being sent
  PROCEDURE p_roll_manual_degree(p_pidm                spriden.spriden_pidm%type,
                                 P_term_code           stvterm.stvterm_code%type,
                                 P_lcur_seqno          sorlcur.sorlcur_seqno%type,
                                 p_term_code_eff       stvterm.stvterm_code%type,
                                 p_current_ind         VARCHAR2,
                                 p_user_id             VARCHAR2,
                                 P_grst_code           stvgrst.stvgrst_code%type DEFAULT NULL,
                                 P_award_courses       VARCHAR2,
                                 P_graduation_date     DATE DEFAULT NULL,
                                 P_acyr_code           stvacyr.stvacyr_code%type DEFAULT NULL,
                                 P_fee_ind             shrdgmr.shrdgmr_fee_ind%type DEFAULT NULL,
                                 p_fee_date            DATE DEFAULT NULL,
                                 P_term_code_grad      stvterm.stvterm_code%type DEFAULT NULL,
                                 p_gradapp_date        DATE DEFAULT NULL,
                                 P_roll_ind            VARCHAR2 DEFAULT 'Y',
                                 p_term_code_completed stvterm.stvterm_code%type DEFAULT NULL,
                                 P_degree_seqno        IN OUT shrdgmr.shrdgmr_seq_no%TYPE,
                                 p_err_msg             OUT VARCHAR2) IS
    lv_term_rec       gb_stvterm.stvterm_rec;
    lv_term_ref       gb_stvterm.stvterm_ref;
    lv_learner_rec    sgbstdn%rowtype;
    lv_curriculum_rec sb_curriculum.curriculum_rec; /*BIEN*/
    lv_curriculum_ref sb_curriculum.curriculum_ref; /*BIEN*/
    shrtckn_rec       shrtckn%rowtype;
    lv_degree_seqno   shrdgmr.shrdgmr_seq_no%type;
    CURSOR shrtckn_c(p_pidm spriden.spriden_pidm%type, p_levl_code stvlevl.stvlevl_code%type, p_deg_seq shrdgmr.shrdgmr_seq_no%type) IS
      SELECT *
        FROM shrtckn
       WHERE shrtckn_pidm = p_pidm
         AND EXISTS
       (SELECT 'x'
                FROM shrtckl
               WHERE shrtckl_pidm = p_pidm
                 AND shrtckl_tckn_seq_no = shrtckn.shrtckn_seq_no
                 AND shrtckl_term_code = shrtckn.shrtckn_term_code
                 AND shrtckl_levl_code = p_levl_code);
    effterm stvterm.stvterm_code%type;
    CURSOR sgbstdn_current_c(p_pidm sgbstdn.sgbstdn_pidm%TYPE, p_term_code_eff sgbstdn.sgbstdn_term_code_eff%TYPE) IS
      SELECT *
        FROM sgbstdn
       WHERE sgbstdn.sgbstdn_pidm = p_pidm
         AND sgbstdn.sgbstdn_term_code_eff = p_term_code_eff;
    --    ( select max(m.sgbstdn_term_code_eff)
    --       from sgbstdn m
    --      where m.sgbstdn_pidm = sgbstdn.sgbstdn_pidm
    --      and m.sgbstdn_term_code_eff <= p_term_code_eff);
  BEGIN
    --- set up the variables used for saving and printing
    crn_parm         := '';
    user_parm        := p_user_id;
    sessionid_parm   := '';
    print_sel_parm   := 'E';
    report_mode_parm := 'O';
    grade_term_parm  := p_term_code;
    roll_title_parm  := '';
    commit_count     := 0;
    user_parm        := p_user_id;
    gv_err_msg       := '';
    --- get the highest seq assigned to a degree if one isnt sent in by study path conversion
    IF P_degree_seqno IS NULL THEN
      BEGIN
        shksels.p_select_shrdgmr_seqno_by_pidm(p_pidm, next_dgmr_seqno); /*BIEN*/
        -- lv_degree_seqno := next_dgmr_seqno;
      EXCEPTION
        WHEN OTHERS THEN
          p_err_msg := g$_nls.get('SHKROL1-0001',
                                  'SQL',
                                  'Degree sequence is at the maximum number, no more are allowed.');
          RETURN;
      END;
    ELSE
      --- reuse existing degree seqno so that the new study path lcur is rolled to the same degree
      lv_degree_seqno := p_degree_seqno;
    END IF;
    --- get the term record for the acyr code
    lv_term_ref := gb_stvterm.f_query_one(p_code => p_term_code_eff); /*BIEN*/
    FETCH lv_term_ref
      INTO lv_term_rec;
    CLOSE lv_term_ref;
    --- get the learner record to populate the grdroll_rec
    effterm := sb_learner.f_query_current(p_pidm          => p_pidm,
                                          p_term_code_eff => p_term_code_eff); /*BIEN*/
    OPEN sgbstdn_current_c(p_pidm => p_pidm, p_term_code_eff => effterm); ---   p_term_code_eff);
    FETCH sgbstdn_current_c
      INTO lv_learner_rec;
    IF sgbstdn_current_c%notfound THEN
      p_err_msg := g$_nls.get('SHKROL1-0002',
                              'SQL',
                              'Learner record could not be found.');
      p_print_dbms('learner record error message: ' || p_err_msg);
      CLOSE sgbstdn_current_c;
      RETURN;
    END IF;
    p_print_dbms('term from sga: ' || lv_learner_rec.sgbstdn_term_code_eff);
    CLOSE sgbstdn_current_c;
    grdroll_rec.pidm := p_pidm;
    -- the term is needed to insert the award, the outcome curriculum.
    -- if the input term is null use the effective term on the learner record
    IF p_term_code IS NULL THEN
      grdroll_rec.term := lv_learner_rec.sgbstdn_term_code_eff;
    ELSE
      grdroll_rec.term := p_term_code;
    END IF;
    grdroll_rec.stuterm := p_term_code_eff;
    p_print_dbms('stuterm: ' || grdroll_rec.stuterm || ' term: ' ||
                 grdroll_rec.term);
    gradapp_date           := p_gradapp_date;
    grst_code              := p_grst_code;
    fee_ind                := p_fee_ind;
    fee_date               := p_fee_date;
    complete_term          := p_term_code_completed;
    grdroll_rec.acyr_code  := lv_learner_rec.sgbstdn_acyr_code;
    grdroll_rec.graddate   := lv_learner_rec.sgbstdn_exp_grad_date;
    grdroll_rec.gradterm   := lv_learner_rec.sgbstdn_term_code_grad;
    grdroll_rec.gradyear   := lv_learner_rec.sgbstdn_acyr_code;
    grdroll_rec.sdegc_dual := lv_learner_rec.sgbstdn_degc_code_dual;
    grdroll_rec.scoll_dual := lv_learner_rec.sgbstdn_coll_code_dual;
    grdroll_rec.smajr_dual := lv_learner_rec.sgbstdn_majr_code_dual;
    grdroll_rec.slevl_dual := lv_learner_rec.sgbstdn_levl_code_dual;
    grdroll_rec.sdept_dual := lv_learner_rec.sgbstdn_dept_code_dual;
    p_print_dbms('in manual gradroll grst ' || grst_code || ' app date ' ||
                 gradapp_date || ' grad date ' || grdroll_rec.graddate ||
                 ' fee ' || fee_ind);
    -- fetch the curriculum record we need to roll
    lv_curriculum_ref := sb_curriculum.f_query_one(p_pidm  => p_pidm, /*BIEN*/
                                                   p_seqno => p_lcur_seqno);
    FETCH lv_curriculum_ref
      INTO lv_curriculum_rec;
    IF lv_curriculum_ref%notfound THEN
      CLOSE lv_curriculum_ref;
      RETURN;
    END IF;
    CLOSE lv_curriculum_ref;
    p_print_dbms('curriculum for ' || p_pidm || ' lcur ' || p_lcur_seqno ||
                 ' priority ' || lv_curriculum_rec.r_priority_no);
    --- call the process to roll the curriculum
    p_roll_outcome(p_pidm            => p_pidm,
                   P_term_code       => p_term_code,
                   P_lcur_seqno      => p_lcur_seqno,
                   P_lcur_rec        => lv_curriculum_rec,
                   P_grst_code       => p_grst_code,
                   p_current_ind     => p_current_ind,
                   P_graduation_date => NVL(p_graduation_date,
                                            lv_learner_rec.sgbstdn_exp_grad_date),
                   P_acyr_code       => NVL(p_acyr_code,
                                            lv_learner_rec.sgbstdn_acyr_code),
                   P_fee_ind         => p_fee_ind,
                   p_fee_date        => p_fee_date,
                   p_roll_ind        => p_roll_ind,
                   P_term_code_grad  => NVL(p_term_code_grad,
                                            lv_learner_rec.sgbstdn_term_code_grad),
                   P_degree_seqno    => lv_degree_seqno);
    lv_degree_seqno := dgmr_seq;
    --- return the degree
    p_degree_seqno := lv_degree_seqno;
    p_err_msg      := gv_err_msg;
    --  insert the shrtckd
    p_print_dbms('degree: ' || p_degree_seqno || ' error: ' || p_err_msg ||
                 ' p award courses: ' || p_award_courses ||
                 '  studypath: ' || dgmr_stsp);
    IF NVL(p_award_courses, 'N') = 'Y' AND p_degree_seqno IS NOT NULL AND
       p_err_msg IS NULL THEN
      IF sb_learneroutcome_rules.f_degree_awarded(p_pidm   => p_pidm, /*BIEN*/
                                                  p_seq_no => p_degree_seqno) = 'N' THEN
        OPEN shrtckn_c(p_pidm      => p_pidm,
                       p_levl_code => lv_curriculum_rec.r_levl_code,
                       p_deg_seq   => p_degree_seqno);
        LOOP
          FETCH shrtckn_c
            INTO shrtckn_rec;
          EXIT WHEN shrtckn_c%notfound;
          tckn_seq                          := shrtckn_rec.shrtckn_seq_no;
          grdroll_rec.reg_stsp_key_sequence := shrtckn_rec.shrtckn_stsp_key_sequence;
          --p_print_dbms('found tckn seqno: ' || tckn_seq || ' crn: ' ||
          --  shrtckn_rec.shrtckn_crn || ' term: ' || shrtckn_rec.shrtckn_term_code
          --   || ' stsp: ' || shrtckn_rec.shrtckn_stsp_key_sequence );
          p_insert_shrtckd(p_tckn_term  => shrtckn_rec.shrtckn_term_code,
                           p_tckn_seqno => tckn_seq);
        END LOOP;
        CLOSE shrtckn_c;
      END IF;
    END IF;
  END p_roll_manual_degree;
  ---- manual roll and update degree and diploma for grad app
  PROCEDURE p_gradapp_roll(p_pidm            spriden.spriden_pidm%type,
                           p_gapp_seqno      shbgapp.shbgapp_seqno%TYPE,
                           p_roll_curriculum VARCHAR2 DEFAULT 'Y',
                           p_apply_courses   VARCHAR2, --needs to allow null so the value on shactrl will be picked up
                           p_err_msg         OUT VARCHAR2) IS
    dgmr_seqno          shrdgmr.shrdgmr_seq_no%type := NULL;
    lv_lcur_seqno       sorlcur.sorlcur_seqno%type := NULL;
    gradapp_rec         sb_gradapp.gradapp_rec; /*BIEN*/
    gradapp_ref         sb_gradapp.gradapp_ref; /*BIEN*/
    lcur_rec            sb_curriculum.curriculum_rec; /*BIEN*/
    lcur_ref            sb_curriculum.curriculum_ref; /*BIEN*/
    lcur_outcome_rec    sb_curriculum.curriculum_rec; /*BIEN*/
    lcur_outcome_ref    sb_curriculum.curriculum_ref; /*BIEN*/
    learneroutcome_rec  sb_learneroutcome.learneroutcome_rec; /*BIEN*/
    learneroutcome_ref  sb_learneroutcome.learneroutcome_ref; /*BIEN*/
    lv_graduation_date  DATE := NULL;
    lv_acyr_code        stvacyr.stvacyr_code%type := NULL;
    lv_fee_ind          shrdgmr.shrdgmr_fee_ind%type := NULL;
    lv_term_code_grad   stvterm.stvterm_code%type := NULL;
    lv_application_date DATE := NULL;
    lv_grst_code        stvgrst.stvgrst_code%type := NULL;
    lv_fee_date         DATE := NULL;
    lv_complete_term    stvterm.stvterm_code%type := NULL;
    lv_apply_ind        shbcgpa.shbcgpa_award_prev_ind%type := NULL;
    lv_outcome_exists   VARCHAR2(1) := 'N';
    CURSOR outcome_curric_exists_c IS
      SELECT 'Y'
        FROM sovlcur
       WHERE sovlcur_pidm = p_pidm
         AND sovlcur_gapp_seqno = p_gapp_seqno
         AND sovlcur_lmod_code = sb_curriculum_str.f_outcome /*BIEN*/
         AND sovlcur_current_ind = 'Y'
         AND sovlcur_active_ind = 'Y';
    PROCEDURE lv_manual_roll IS
    BEGIN
      szkrols.p_roll_manual_degree(p_pidm                => gradapp_rec.r_pidm, /*BIEN*/
                                   P_term_code           => gradapp_rec.r_grad_term_code,
                                   P_lcur_seqno          => lcur_rec.r_seqno,
                                   p_term_code_eff       => lcur_rec.r_term_code,
                                   p_current_ind         => 'Y',
                                   p_user_id             => NVL(goksels.f_get_ssb_id_context, gb_common.f_sct_user), /*BIEN*/ /*BIEN*/
                                   P_award_courses       => lv_apply_ind,
                                   P_graduation_date     => lv_graduation_date,
                                   p_gradapp_date        => lv_application_date,
                                   P_acyr_code           => lv_acyr_code,
                                   P_fee_ind             => lv_fee_ind,
                                   p_roll_ind            => 'Y',
                                   p_fee_date            => lv_fee_date,
                                   p_term_code_completed => lv_complete_term,
                                   P_term_code_grad      => lv_term_code_grad,
                                   P_grst_code           => lv_grst_code,
                                   P_degree_seqno        => dgmr_seqno,
                                   p_err_msg             => p_err_msg);
      IF dgmr_seqno IS NULL THEN
        p_err_msg := g$_nls.get('SHKROL1-0003',
                                'SQL',
                                'The curriculum could not be rolled and the degree was not inserted.');
      END IF;
    END lv_manual_roll;
    PROCEDURE lv_insert_diploma IS
      dipl_name shbdipl.shbdipl_name%type;
    BEGIN
      IF gradapp_rec.r_first_name IS NULL THEN
        dipl_name := gradapp_rec.r_last_name;
      ELSE
        IF gradapp_rec.r_mi IS NOT NULL THEN
          dipl_name := gradapp_rec.r_first_name || ' ' || gradapp_rec.r_mi || ' ' ||
                       gradapp_rec.r_last_name;
        ELSE
          dipl_name := gradapp_rec.r_first_name || ' ' ||
                       gradapp_rec.r_last_name;
        END IF;
      END IF;
      IF dipl_name IS NOT NULL AND gradapp_rec.r_name_suffix IS NOT NULL THEN
        dipl_name := dipl_name || ' ' || gradapp_rec.r_name_suffix;
      END IF;
      IF dipl_name IS NOT NULL OR gradapp_rec.r_street1 IS NOT NULL OR
         gradapp_rec.r_street2 IS NOT NULL OR
         gradapp_rec.r_street3 IS NOT NULL OR
         gradapp_rec.r_street4 IS NOT NULL --- future
         OR gradapp_rec.r_stat_code IS NOT NULL OR
         gradapp_rec.r_city IS NOT NULL OR gradapp_rec.r_zip IS NOT NULL OR
         gradapp_rec.r_natn_code IS NOT NULL OR
         gradapp_rec.r_house_number IS NOT NULL --- future
       THEN
        IF dgmr_seqno IS NOT NULL THEN
          ---  if the diploma does not exist insert it
          IF shksels.f_shbdipl_exists(p_pidm   => gradapp_rec.r_pidm,  /*BIEN*/
                                      p_SEQ_NO => dgmr_seqno) = 'N' THEN
            INSERT INTO shbdipl
              (shbdipl_pidm, /*BIEN*/
               shbdipl_dgmr_seq_no,
               shbdipl_fee_ind,
               shbdipl_fee_date,
               shbdipl_order_date,
               shbdipl_name,
               shbdipl_street1,
               shbdipl_street2,
               shbdipl_street3,
               shbdipl_street_line4, -- future
               shbdipl_city,
               shbdipl_stat_code,
               shbdipl_zip,
               shbdipl_natn_code,
               shbdipl_house_number, -- future
               shbdipl_innm_code,
               shbdipl_cert_code,
               shbdipl_term_code_cert,
               shbdipl_activity_date)
            VALUES
              (gradapp_rec.r_pidm,
               dgmr_seqno,
               NULL, -- fee ind
               NULL, -- fee date
               NULL, -- dipl order date
               dipl_name,
               gradapp_rec.r_street1,
               gradapp_rec.r_street2,
               gradapp_rec.r_street3,
               gradapp_rec.r_street4, -- future
               gradapp_rec.r_city,
               gradapp_rec.r_stat_code,
               gradapp_rec.r_zip,
               gradapp_rec.r_natn_code,
               gradapp_rec.r_house_number, -- future
               NULL, -- innm code
               NULL, -- cert code
               NULL, -- term code cert
               sysdate); --- activity date
          ELSE
            --- update the diploma
            IF dipl_name IS NOT NULL THEN
              UPDATE shbdipl /*BIEN*/
                 SET shbdipl_name          = dipl_name,
                     shbdipl_activity_date = sysdate
               WHERE shbdipl_pidm = gradapp_rec.r_pidm
                 AND shbdipl_dgmr_seq_no = dgmr_seqno;
            END IF;
            IF gradapp_rec.r_street1 IS NOT NULL OR
               gradapp_rec.r_street2 IS NOT NULL OR
               gradapp_rec.r_street3 IS NOT NULL OR
               gradapp_rec.r_street4 IS NOT NULL OR
               gradapp_rec.r_city IS NOT NULL OR
               gradapp_rec.r_stat_code IS NOT NULL OR
               gradapp_rec.r_zip IS NOT NULL OR
               gradapp_rec.r_natn_code IS NOT NULL OR
               gradapp_rec.r_house_number IS NOT NULL THEN
              UPDATE shbdipl
                 SET shbdipl_street1       = gradapp_rec.r_street1, /*BIEN*/
                     shbdipl_street2       = gradapp_rec.r_street2,
                     shbdipl_street3       = gradapp_rec.r_street3,
                     shbdipl_street_line4  = gradapp_rec.r_street4, -- future
                     shbdipl_city          = gradapp_rec.r_city,
                     shbdipl_stat_code     = gradapp_rec.r_stat_code,
                     shbdipl_zip           = gradapp_rec.r_zip,
                     shbdipl_natn_code     = gradapp_rec.r_natn_code,
                     shbdipl_house_number  = gradapp_rec.r_house_number, -- future
                     shbdipl_activity_date = sysdate
               WHERE shbdipl_pidm = gradapp_rec.r_pidm
                 AND shbdipl_dgmr_seq_no = dgmr_seqno;
            END IF; --- changes were made to the address
          END IF; --- diploma already exists
        END IF; -- dgmr seqno is not null
      END IF; --- there is information on the diploma
    END lv_insert_diploma;
    PROCEDURE lv_update_degree IS
      stvgrst_rec   stvgrst%rowtype;
      stvdegs_rec   stvdegs%rowtype;
      new_degs_code stvdegs.stvdegs_code%type;
    BEGIN
      IF learneroutcome_rec.r_fee_ind IS NOT NULL THEN  /*BIEN*/
        lv_fee_ind  := learneroutcome_rec.r_fee_ind; /*BIEN*/
        lv_fee_date := learneroutcome_rec.r_fee_date; /*BIEN*/
      END IF;
      -- need to add some logic in here to compare values, we don't want to update
      --- if there is no change to any of the data
      --  p_print_dbms('update the degree:  grad date: ' ||
      --      learneroutcome_rec.r_grad_date  || ' appl date: ' || lv_graduation_date ||
      --      ' ' || lv_grst_code || ' old: ' || learneroutcome_rec.r_grst_code );
      IF NVL(lv_application_date,
             NVL(learneroutcome_rec.r_appl_date, sysdate)) <> /*BIEN*/
         NVL(learneroutcome_rec.r_appl_date, sysdate) OR /*BIEN*/
         NVL(lv_term_code_grad,
             NVL(learneroutcome_rec.r_term_code_grad, '*')) <> /*BIEN*/
         NVL(learneroutcome_rec.r_term_code_grad, '*') OR /*BIEN*/
         NVL(lv_acyr_code, NVL(learneroutcome_rec.r_acyr_code, '*')) <> /*BIEN*/
         NVL(learneroutcome_rec.r_acyr_code, '*') OR /*BIEN*/
         NVL(lv_grst_code, NVL(learneroutcome_rec.r_grst_code, '*')) <> /*BIEN*/
         NVL(learneroutcome_rec.r_grst_code, '*') OR /*BIEN*/
         NVL(lv_graduation_date,
             NVL(learneroutcome_rec.r_grad_date, sysdate)) <> /*BIEN*/
         NVL(learneroutcome_rec.r_grad_date, sysdate) OR /*BIEN*/
         NVL(lv_complete_term,
             NVL(learneroutcome_rec.r_term_code_completed, '*')) <> /*BIEN*/
         NVL(learneroutcome_rec.r_term_code_completed, '*') THEN /*BIEN*/
        BEGIN
          new_degs_code := learneroutcome_rec.r_degs_code; 
          ---  move degs code to the next value if the grad status rules require it
          IF NVL(lv_grst_code, '*') <>
             NVL(learneroutcome_rec.r_grst_code, '*') THEN  /*BIEN*/
            OPEN sb_stvgrst.stvgrst_c(p_code => lv_grst_code);
            FETCH sb_stvgrst.stvgrst_c
              INTO stvgrst_rec;
            CLOSE sb_stvgrst.stvgrst_c;
            IF stvgrst_rec.stvgrst_updt_nxt_stat_ind = 'Y' THEN
              OPEN sb_stvdegs.stvdegs_c(p_code => learneroutcome_rec.r_degs_code); /*BIEN*/
              FETCH sb_stvdegs.stvdegs_c
                INTO stvdegs_rec;
              CLOSE sb_stvdegs.stvdegs_c;
              IF stvdegs_rec.stvdegs_next_status IS NOT NULL THEN
                new_degs_code := stvdegs_rec.stvdegs_next_status;
              END IF;
            END IF;
          END IF;
          sb_learneroutcome.p_update(p_pidm                => gradapp_rec.r_pidm, /*BIEN*/
                                     p_degs_code           => new_degs_code,
                                     p_appl_date           => NVL(lv_application_date,
                                                                  learneroutcome_rec.r_appl_date), /*BIEN*/
                                     p_term_code_grad      => NVL(lv_term_code_grad,
                                                                  learneroutcome_rec.r_term_code_grad), --- lv_grdroll_rec.gradterm, /*BIEN*/
                                     p_acyr_code           => NVL(lv_acyr_code,
                                                                  learneroutcome_rec.r_acyr_code), --- grdroll_rec.gradyear, /*BIEN*/
                                     p_grst_code           => NVL(lv_grst_code,
                                                                  learneroutcome_rec.r_grst_code), /*BIEN*/
                                     p_fee_ind             => lv_fee_ind,
                                     p_fee_date            => lv_fee_date,
                                     p_grad_date           => NVL(lv_graduation_date,
                                                                  learneroutcome_rec.r_grad_date), /*BIEN*/
                                     p_term_code_completed => NVL(lv_complete_term,
                                                                  learneroutcome_rec.r_term_code_completed), /*BIEN*/
                                     p_SEQ_NO              => dgmr_seqno,
                                     p_DATA_ORIGIN         => gb_common.data_origin, /*BIEN*/
                                     p_USER_ID             => NVL(goksels.f_get_ssb_id_context, gb_common.f_sct_user)); /*BIEN*/ /*BIEN*/
        EXCEPTION
          WHEN OTHERS THEN
            IF SQLCODE = gb_event.APP_ERROR THEN
              p_err_msg := SQLERRM;
            ELSE
              p_err_msg := G$_NLS.Get('SHKROL1-0004',
                                      'SQL',
                                      'Error occurred while creating the degree from a graduation application.');
            END IF;
        END;
      END IF;
    END lv_update_degree;
  BEGIN
    -- 1. Insert the degree and diploma
    --    a. If the curriculum attached to the graduation application is not from the OUTCOME module, and has not been rolled
    --         execute the manual roll process.
    --         This will create the degree and roll the learner curriculum to the outcome.
    --         Insert the diploma information from graduation application.
    -- 2. Update the degree and insert the diploma
    --   a. The curriculum is from the outcome, or the curriculum is from the learner and
    --   has been rolled.
    --   b. The diploma exists on the grad app but does not on for the degree on SHADIPL.
    -- 3. Update the degree and update the diploma
    --   a. The curriculum is from the outcome, or the curriculum is from the learner and
    --   has been rolled.
    --   b. The diploma exists on the grad app and also for the degree on SHADIPL, and the user has responded yes to a prompt to update the diploma
    -- if the p_apply_courses is null we need to get what was coded on shactrl
    IF p_apply_courses IS NULL THEN
      shksels.p_select_shbcgpa(shbcgpa_row, row_found);
      lv_apply_ind := shbcgpa_row.shbcgpa_award_prev_ind;
    ELSE
      lv_apply_ind := p_apply_courses;
    END IF;
    OPEN outcome_curric_exists_c;
    FETCH outcome_curric_exists_c
      INTO lv_outcome_exists;
    IF outcome_curric_exists_c%notfound THEN
      lv_outcome_exists := 'N';
    END IF;
    CLOSE outcome_curric_exists_c;
    gradapp_ref := sb_gradapp.f_query_one(p_pidm  => p_pidm, /*BIEN*/
                                          p_seqno => p_gapp_seqno);
    FETCH gradapp_ref
      INTO gradapp_rec;
    IF gradapp_ref%notfound THEN
      CLOSE gradapp_ref;
      p_err_msg := g$_nls.get('SHKROL1-0005',
                              'SQL',
                              'The graduation application does not exist.');
      RETURN;
    END IF;
    CLOSE gradapp_ref;
    --- set up the update values based on the input parms
    lv_grst_code        := gradapp_rec.r_dgmr_upd_grst_code;
    lv_graduation_date  := gradapp_rec.r_grad_date;
    lv_acyr_code        := gradapp_rec.r_grad_acyr_code;
    lv_term_code_grad   := gradapp_rec.r_grad_term_code;
    lv_complete_term    := gradapp_rec.r_grad_term_code;
    lv_application_date := gradapp_rec.r_request_date;
    p_print_dbms('fee ind: ' || gradapp_rec.r_chrg || '  fee date: ' ||
                 gradapp_rec.r_fee_date || ' detl: ' ||
                 gradapp_rec.r_detc_detail_code || ' graddate: ' ||
                 lv_graduation_date);
    IF gradapp_rec.r_detc_detail_code IS NOT NULL AND
       gradapp_rec.r_chrg IS NOT NULL THEN
      lv_fee_ind  := 'Y';
      lv_fee_date := gradapp_rec.r_fee_date;
    ELSE
      lv_fee_ind  := NULL;
      lv_fee_date := NULL;
    END IF;
    IF lv_outcome_exists = 'Y' THEN
      --- find degree the grad app is for
      lcur_ref := sb_curriculum.f_query_all(p_pidm       => p_pidm,
                                            p_gapp_seqno => p_gapp_seqno,
                                            p_lmod_code  => sb_curriculum_str.f_outcome); /*BIEN*/
      LOOP
        FETCH lcur_ref
          INTO lcur_rec;
        EXIT WHEN lcur_ref%notfound;
        IF sb_learnercurricstatus.f_is_active(lcur_rec.r_cact_code) = 'Y' AND
           sb_curriculum.f_find_current_all_ind(p_pidm                 => lcur_rec.r_pidm, /*BIEN*/
                                                p_lmod_code            => sb_curriculum_str.f_outcome, /*BIEN*/
                                                p_term_code            => lcur_rec.r_term_code,
                                                p_keyseqno             => lcur_rec.r_key_seqno,
                                                p_priority_no          => lcur_rec.r_priority_no,
                                                p_seqno                => lcur_rec.r_seqno,
                                                p_current_cde          => lcur_rec.r_current_cde,
                                                p_override_current_ind => 'Y') = 'Y' THEN
          dgmr_seqno         := lcur_rec.r_key_seqno;
          lv_lcur_seqno      := lcur_rec.r_seqno;
          learneroutcome_ref := sb_learneroutcome.f_query_one(p_pidm   => gradapp_rec.r_pidm, /*BIEN*/
                                                              p_seq_no => lcur_rec.r_key_seqno);
          FETCH learneroutcome_ref
            INTO learneroutcome_rec;
          IF learneroutcome_ref%FOUND THEN
            lv_update_degree;
            lv_insert_diploma;
          ELSE
            p_err_msg := g$_nls.get('SHKROL1-0006',
                                    'SQL',
                                    'The outcome record does not exist.');
          END IF;
          CLOSE learneroutcome_ref;
        END IF; -- only process current and active
      END LOOP;
      CLOSE lcur_ref;
    ELSE
      --- process the learner curriculum
      lcur_ref := sb_curriculum.f_query_all(p_pidm       => p_pidm,
                                            p_gapp_seqno => p_gapp_seqno,
                                            p_lmod_code  => sb_curriculum_str.f_learner); /*BIEN*/
      LOOP
        FETCH lcur_ref
          INTO lcur_rec;
        EXIT WHEN lcur_ref%notfound;
        dgmr_seqno := NULL;
        IF sb_learnercurricstatus.f_is_active(lcur_rec.r_cact_code) = 'Y' AND /*BIEN*/
           sb_curriculum.f_find_current_all_ind(p_pidm                 => lcur_rec.r_pidm, /*BIEN*/
                                                p_lmod_code            => sb_curriculum_str.f_learner, /*BIEN*/
                                                p_term_code            => lcur_rec.r_term_code,
                                                p_keyseqno             => lcur_rec.r_key_seqno,
                                                p_priority_no          => lcur_rec.r_priority_no,
                                                p_seqno                => lcur_rec.r_seqno,
                                                p_eff_term             => lcur_rec.r_term_code,
                                                p_override_current_ind => 'Y') = 'Y' THEN
          ---- reset for each curriculum in case update needs to change
          --- value because exists on shrdgmr already '
          IF lcur_rec.r_rolled_seqno IS NULL THEN
            --- we can roll the learner
            IF p_roll_curriculum = 'Y' THEN
              lv_manual_roll;
              IF p_err_msg IS NOT NULL THEN
                -- return right away
                EXIT; -- leave loop if there is an error
              END IF;
              -- insert the diploma
              lv_insert_diploma;
            END IF;
          ELSE
            --- we need to update the degree and maybe insert the diploma
            -- find out what the outcome seqno is
            lcur_outcome_ref := sb_curriculum.f_query_one(p_pidm  => p_pidm, /*BIEN*/
                                                          p_seqno => lcur_rec.r_rolled_seqno);
            FETCH lcur_outcome_ref
              INTO lcur_outcome_rec;
            IF lcur_outcome_ref%notfound THEN
              --- we can roll the learner
              CLOSE lcur_outcome_ref;
              IF p_roll_curriculum = 'Y' THEN
                lv_manual_roll;
                IF p_err_msg IS NOT NULL THEN
                  EXIT; --- don't process anymore if we get an api or other type of error
                END IF;
              ELSE
                dgmr_seqno := lcur_outcome_rec.r_key_seqno;
              END IF;
              -- insert the diploma
              lv_insert_diploma;
            ELSE
              CLOSE lcur_outcome_ref;
              learneroutcome_ref := sb_learneroutcome.f_query_one(p_pidm   => gradapp_rec.r_pidm, /*BIEN*/
                                                                  p_seq_no => lcur_outcome_rec.r_seqno);
              FETCH learneroutcome_ref
                INTO learneroutcome_rec;
              IF learneroutcome_ref%FOUND THEN
                dgmr_seqno := lcur_rec.r_key_seqno;
                lv_update_degree;
                CLOSE learneroutcome_ref;
              ELSE
                CLOSE learneroutcome_ref;
                IF p_roll_curriculum = 'Y' THEN
                  lv_manual_roll;
                  IF p_err_msg IS NOT NULL THEN
                    EXIT; --- don't process anymore if we get an api or other type of error
                  END IF;
                END IF;
              END IF;
              --- do not update diploma
              lv_insert_diploma;
            END IF; --- outcome not found
          END IF; -- lcur  rolled seqno was null
        END IF; --- lcur is active
      END LOOP;
      CLOSE lcur_ref;
    END IF; --- learner lcur
  END p_gradapp_roll;
  --- procedure to match the curriculum to existing outcome records and then
  --- create degree and outcome curriculum and field of study
  PROCEDURE P_roll_outcome(p_pidm                spriden.spriden_pidm%type,
                           P_term_code           stvterm.stvterm_code%type,
                           P_lcur_seqno          sorlcur.sorlcur_seqno%type,
                           P_lcur_rec            sb_curriculum.curriculum_rec, /*BIEN*/
                           p_current_ind         VARCHAR2,
                           p_roll_ind            VARCHAR2,
                           P_grst_code           stvgrst.stvgrst_code%type DEFAULT NULL,
                           P_graduation_date     DATE DEFAULT NULL,
                           P_acyr_code           stvacyr.stvacyr_code%type DEFAULT NULL,
                           P_fee_ind             shrdgmr.shrdgmr_fee_ind%type DEFAULT NULL,
                           p_fee_date            DATE DEFAULT NULL,
                           P_term_code_grad      stvterm.stvterm_code%type DEFAULT NULL,
                           p_term_code_completed stvterm.stvterm_code%type DEFAULT NULL,
                           P_degree_seqno        IN OUT shrdgmr.shrdgmr_seq_no%TYPE) IS
    -- 8.5.0.3 add order by so seqno is in desc order
    CURSOR lv_curriculum_mod_rec(p_pidm sorlcur.sorlcur_pidm%TYPE,
         p_lmod_code stvlmod.stvlmod_code%TYPE,
         p_priority_no sorlcur.sorlcur_priority_no%TYPE,
         p_seqno sorlcur.sorlcur_seqno%TYPE) IS
      SELECT *
        FROM sorlcur
       WHERE sorlcur_pidm = p_pidm
         AND sorlcur_lmod_code = p_lmod_code
         AND sorlcur_priority_no = p_priority_no
         AND sorlcur_seqno < p_seqno
       ORDER BY sorlcur_seqno DESC;
    lv_curriculum_mod_rec_data sorlcur%rowtype;

    lv_curriculum_rec2       sb_curriculum.curriculum_rec; /*BIEN*/
    lv_curriculum_cur2       sb_curriculum.curriculum_ref; /*BIEN*/
    lv_curriculum_rolled_rec sb_curriculum.curriculum_rec; /*BIEN*/
    lv_curriculum_rolled_cur sb_curriculum.curriculum_ref; /*BIEN*/
    lv_curr_read2roll_rec    sb_curriculum.curriculum_rec; /*BIEN*/
    lv_curr_read2roll_cur    sb_curriculum.curriculum_ref; /*BIEN*/
    lv_fieldofstudy_cur      sb_fieldofstudy.fieldofstudy_ref; /*BIEN*/
    lv_fieldofstudy_rec      sb_fieldofstudy.fieldofstudy_rec; /*BIEN*/
    lv_old_priority          sorlcur.sorlcur_priority_no%TYPE;
    lv_old_seqno             sorlcur.sorlcur_seqno%TYPE;
    lv_old_rolled_seqno      sorlcur.sorlcur_seqno%TYPE;
    lv_cnt_other_active      PLS_INTEGER := 0;
    lv_cnt_pending_other     PLS_INTEGER := 0;
    lv_bypass_lcur           VARCHAR2(1) := NULL;
    lv_degree_awarded        VARCHAR2(1) := NULL;
    lv_curric_active         VARCHAR2(1) := NULL;
    severity_out             VARCHAR2(1) := NULL;
    lcur_seqno               sorlcur.sorlcur_seqno%type;
    lcur_row                 VARCHAR2(18) := NULL;
    curr_error               PLS_INTEGER := 0;
    degc_row                 VARCHAR2(18) := NULL;
    old_degr_seqno           sorlcur.sorlcur_key_seqno%TYPE := 0;
    degree_found             VARCHAR2(1) := NULL;
    rolled_seqno             sorlcur.sorlcur_seqno%type;
    change_found             VARCHAR2(1) := NULL;
    cnt_outcome              PLS_INTEGER := 0;
    cnt_pending              PLS_INTEGER := 0;
    endterm                  stvterm.stvterm_code%type;
    -- cursor to see if the rolled seq is still current and active for the degree
    isCurrent varchar2(1) := null ;
    CURSOR isCurrentActive (p_pidm spriden.spriden_pidm%type, p_rolled_seqno sorlcur.sorlcur_seqno%type) is
      SELECT 'Y'
      from sovlcur
      where sovlcur_pidm = p_pidm
      and sovlcur_seqno = p_rolled_seqno
      and sovlcur_lmod_code = sb_curriculum_str.f_outcome /*BIEN*/
      and sovlcur_active_ind  = 'Y'
      and sovlcur_current_ind = 'Y' ;
    ---- new cursor to see if the degree is the same
    outcome_degc shrdgmr.shrdgmr_seq_no%type := NULL;
    CURSOR find_outcome_degc_c(p_pidm spriden.spriden_pidm%type, p_rolled_seqno sorlcur.sorlcur_seqno%type, p_lmod_code stvlmod.stvlmod_code%type) IS
      SELECT sorlcur_key_seqno
        FROM sorlcur
       WHERE sorlcur_pidm = p_pidm
         AND sorlcur_seqno = p_rolled_seqno
         AND sorlcur_lmod_code = p_lmod_code;
    ---- 8.1.1 new cursor to find max term on outcome  lcur
    outcome_lcur_term stvterm.stvterm_code%type := NULL;
    CURSOR find_outcome_term_c(p_pidm spriden.spriden_pidm%type, p_key_seqno sorlcur.sorlcur_key_seqno%type, p_lmod_code stvlmod.stvlmod_code%type, p_priority_no sorlcur.sorlcur_priority_no%type) IS
      SELECT sovlcur_term_code
        FROM sovlcur
       WHERE sovlcur_pidm = p_pidm
         AND sovlcur_key_seqno = p_key_seqno
         AND sovlcur_lmod_code = p_lmod_code
         AND sovlcur_current_ind = 'Y'
         AND sovlcur_active_ind = 'Y'
         AND sovlcur_priority_no = p_priority_no;
    ---- new cursor to see if the curriculum exists as an outcome module
    outcome_lcur_found VARCHAR2(1) := NULL;
    CURSOR find_outcome_curric_c(p_pidm spriden.spriden_pidm%type, p_rolled_seqno sorlcur.sorlcur_seqno%type, p_lmod_code stvlmod.stvlmod_code%type) IS
      SELECT 'Y'
        FROM sorlcur
       WHERE sorlcur_pidm = p_pidm
         AND sorlcur_seqno = p_rolled_seqno
         AND sorlcur_lmod_code = p_lmod_code;
    CURSOR ctrl_c IS
      SELECT * FROM sobctrl;
  BEGIN
    IF shbcgpa_row.shbcgpa_roll_study_path_ind IS NULL THEN
      shksels.p_select_shbcgpa(shbcgpa_row, row_found);
    END IF;
    IF sobctrl_row.sobctrl_study_path_ind IS NULL THEN
      OPEN ctrl_c;
      FETCH ctrl_c
        INTO sobctrl_row;
      CLOSE ctrl_c;
    END IF;
    api_error         := 'N';
    insert_new_degr   := 'N';
    insert_new_curr   := 'N';
    api_lfst_error    := 'N';
    lv_degree_awarded := NULL;
    lv_bypass_lcur    := NULL;
    schange           := 'N';
    lv_degree_awarded := NULL;
    degree_found      := NULL;
    gradapp_seqno     := NULL;
    dgmr_stsp         := NULL;
    p_print_dbms('is the pidm numm: ' || grdroll_rec.pidm || ' term: ' ||
                 grdroll_rec.term);
    lv_curriculum_rec := p_lcur_rec;
    IF grdroll_rec.pidm IS NULL THEN
      grdroll_rec.pidm := lv_curriculum_rec.r_pidm;
    END IF;
    IF grdroll_rec.term IS NULL THEN
      grdroll_rec.term := lv_curriculum_rec.r_term_code;
    END IF;
    ---- save the curriculum values for the sotprnt report which
    --- is produced in SZRROLL.pc
    sdegc    := lv_curriculum_rec.r_degc_code;
    slevl    := lv_curriculum_rec.r_levl_code;
    scoll    := lv_curriculum_rec.r_coll_code;
    scampus  := lv_curriculum_rec.r_camp_code;
    sprogram := lv_curriculum_rec.r_program;
    p_print_dbms('pgm: ' || sprogram || '  deg: ' || sdegc || ' col: ' || scoll || ' lev: ' || slevl);
    IF NVL(p_roll_ind, 'Y') = 'Y' THEN
      --  different processing is done if the learner curriculum is not active
      lv_curric_active := sb_learnercurricstatus.f_is_active(p_cact_code => lv_curriculum_rec.r_cact_code);  /*BIEN*/
      --- need to find the degree for the curriculum
      --- outcome must have curriculum with same degree,
      --  level, pgm, college.  If both have a gapp seqno then
      --  they must match.
      --  If the learner curriculum has a grad app, it is always considered new
      --  8.3 creating study paths requires we roll new version of lcur to existing degree
      p_print_dbms('degree seqno before the find degree: ' || dgmr_seq);
      IF P_degree_seqno IS NOT NULL THEN
        degree_found := 'Y';
        dgmr_seq     := p_degree_seqno;
      elsif lv_curriculum_rec.r_gapp_seqno IS NOT NULL THEN
        degree_found := 'N';
      ELSE
        degree_found := soklcur.f_find_rolled_degree(p_pidm           => grdroll_rec.pidm, /*BIEN*/
                                                     p_coll_code      => lv_curriculum_rec.r_coll_code,
                                                     p_degc_code      => lv_curriculum_rec.r_degc_code,
                                                     p_levl_code      => lv_curriculum_rec.r_levl_code,
                                                     p_program        => lv_curriculum_rec.r_program,
                                                     p_lcur_seqno_out => rolled_seqno,
                                                     p_key_seqno_out  => dgmr_seq,
                                                     p_gapp_seqno     => lv_curriculum_rec.r_gapp_seqno,
                                                     p_study_path     => lv_curriculum_rec.r_key_seqno,
                                                     p_shbcgpa_row    => shbcgpa_row,
                                                     p_learner_seqno  => lv_curriculum_rec.r_seqno,
                                                     p_dgmr_stsp      => dgmr_stsp);
        p_print_dbms('find degree: ' || degree_found || ' dgmr: ' ||  dgmr_seq || ' stsp: ' || dgmr_stsp);
      END IF;
      ---  8.1.1 if degree found,  and roll ind is null,  do not roll if the term is less than the term
      --   on the degree, do only for graderoll and not manual roll
      outcome_lcur_term := NULL;
      IF lv_curriculum_rec.r_rolled_seqno IS NULL AND degree_found = 'Y' AND
         NVL(gv_grade_roll_ind, 'N') = 'Y' THEN
        outcome_lcur_term := NULL;
        OPEN find_outcome_term_c(p_pidm        => grdroll_rec.pidm,
                                 p_key_seqno   => dgmr_seq, 
                                 p_lmod_code   => sb_curriculum_str.f_outcome, /*BIEN*/
                                 p_priority_no => lv_curriculum_rec.r_priority_no);
        FETCH find_outcome_term_c
          INTO outcome_lcur_term;
        IF find_outcome_term_c%notfound THEN
          outcome_lcur_term := NULL;
        ELSE
          IF outcome_lcur_term > lv_curriculum_rec.r_term_code THEN
            NULL;
          ELSE
            outcome_lcur_term := NULL;
          END IF;
        END IF;
        CLOSE find_outcome_term_c;
      END IF;
      -- does the curriculum already exist as an outcome curriculum
      outcome_lcur_found := 'N';
      IF lv_curriculum_rec.r_rolled_seqno IS NOT NULL THEN
        OPEN find_outcome_curric_c(p_pidm         => grdroll_rec.pidm,
                                   p_rolled_seqno => lv_curriculum_rec.r_rolled_seqno,
                                   p_lmod_code    => sb_curriculum_str.f_outcome); /*BIEN*/
        FETCH find_outcome_curric_c
          INTO outcome_lcur_found;
        IF find_outcome_curric_c%notfound THEN
          outcome_lcur_found := 'N';
        END IF;
        CLOSE find_outcome_curric_c;
      END IF;
      p_print_dbms(lv_curriculum_rec.r_seqno || ' inside roll outcome ' ||
                   p_current_ind || ' active ' || lv_curric_active ||
                   ' degree found ' || degree_found || ' degree: ' ||
                   dgmr_seq || ' outcome found ' || outcome_lcur_found ||
                   ' term: ' || lv_curriculum_rec.r_term_code ||
                   ' grdroll: ' || grdroll_rec.term || '  rolled: ' ||
                   lv_curriculum_rec.r_rolled_seqno || ' lcur found: ' ||
                   outcome_lcur_found || ' curr: ' || p_current_ind);
      --- reject all learner records with term < grdroll_rec.term
      --  except if it was previously rolled but the degree was deleted
      --  or if the lcur has a term that is less than greatest term on outcome lcur
      IF (lv_curriculum_rec.r_term_code >= grdroll_rec.term
        OR (lv_curriculum_rec.r_term_code < grdroll_rec.term AND  outcome_lcur_found = 'N'))
         AND (outcome_lcur_term IS NULL) THEN
        -- check to see if the outcome curriculum was deleted,  we need to
        -- reroll the curriculum
        p_print_dbms('pass the term test and outcome lcur term null test ' || lv_curriculum_rec.r_rolled_seqno);
        IF lv_curriculum_rec.r_rolled_seqno IS NULL OR
           outcome_lcur_found = 'N' THEN
          -- process if the curriculum is active
          -- the curriculum may be inactive if there was a non destructive update
          -- to end a curriculum for the priority
          p_print_dbms('before current,active check: ' || lv_curric_active);
          IF lv_curric_active = 'Y' AND p_current_ind = 'Y' THEN
            -- first check if a previous curriculum exists for the same priority that
            -- has been previously rolled.  Compare degree, level and college
            -- and programs.  the program can be null, the degree, level and college
            -- are required.
            IF degree_found = 'N' THEN
              -- create shrdgmr if degree was previously created for
              -- same lv,coll,pgm, degree
              IF sobctrl_row.sobctrl_study_path_ind = 'Y' AND
                 shbcgpa_row.shbcgpa_roll_study_path_ind = 'Y' AND
                 lv_curriculum_rec.r_key_seqno <> 99 THEN
                dgmr_stsp := lv_curriculum_rec.r_key_seqno;
              END IF;
              p_insert_degree(p_acyr_code           => p_acyr_code,
                              p_term_code_grad      => p_term_code_grad,
                              p_expected_grad_date  => p_graduation_date,
                              p_fee_ind             => p_fee_ind,
                              p_fee_date            => p_fee_date,
                              p_term_code_completed => p_term_code_completed,
                              p_grst_code           => p_grst_code);
              p_print_dbms('afer insert degree1: ' || dgmr_seq ||  '  api error: ' || api_error);
              IF api_error = 'Y' THEN
                RETURN; --- goto end_of_curriculum;
              END IF;
            ELSE
              -- make sure the degree was not previously awarded,
              -- create new if awarded
              lv_degree_awarded := sb_learneroutcome_rules.f_degree_awarded(p_pidm   => grdroll_rec.pidm, /*BIEN*/
                                                                            p_seq_no => dgmr_seq);
              IF lv_degree_awarded = 'Y' THEN
                -- create shrdgmr if  degree was previously awarded for
                -- same lv,coll,pgm, degree and program
                IF sobctrl_row.sobctrl_study_path_ind = 'Y' AND
                   shbcgpa_row.shbcgpa_roll_study_path_ind = 'Y' AND
                   lv_curriculum_rec.r_key_seqno <> 99 THEN
                  dgmr_stsp := lv_curriculum_rec.r_key_seqno;
                END IF;
                p_insert_degree(p_acyr_code           => p_acyr_code,
                                p_term_code_grad      => p_term_code_grad,
                                p_expected_grad_date  => p_graduation_date,
                                p_fee_ind             => p_fee_ind,
                                p_fee_date            => p_fee_date,
                                p_term_code_completed => p_term_code_completed,
                                p_grst_code           => p_grst_code);
                p_print_dbms('afer insert degree2: ' || dgmr_seq ||  '  api error: ' || api_error);
                IF api_error = 'Y' THEN
                  p_generate_report;
                  RETURN;
                END IF;
              ELSE
                p_update_degree;
                IF api_error = 'Y' THEN
                  RETURN;
                END IF;
              END IF; -- end for if degree awarded
            END IF; -- degree is found
          ELSE
            -- if curric is not active but is current
            -- we do not want to include any that are not current and active
            -- find last rolled lcur for that priority, if none exists
            -- do not process lcur
            -- else update the shrdgmr and insert lcur if the degree is not
            -- awarded and has the same curriculum info
            lv_bypass_lcur      := NULL;
            lv_old_rolled_seqno := NULL;
            OPEN lv_curriculum_mod_rec(p_pidm        => lv_curriculum_rec.r_pidm,
                                       p_lmod_code   => sb_curriculum_str.f_learner, /*BIEN*/
                                       p_priority_no => lv_curriculum_rec.r_priority_no,
                                       p_seqno       => lv_curriculum_rec.r_seqno);
            LOOP
              FETCH lv_curriculum_mod_rec  INTO lv_curriculum_mod_rec_data;
              EXIT WHEN lv_curriculum_mod_rec%NOTFOUND;
              --- 8.5.0.3 add check for like curriculum on already rolled but we also need to make sure its current and active
              IF lv_curriculum_mod_rec_data.sorlcur_rolled_seqno IS NOT NULL
              AND (   (  lv_curriculum_mod_rec_data.sorlcur_key_seqno =  lv_curriculum_rec.r_key_seqno
                       AND lv_curriculum_mod_rec_data.sorlcur_key_seqno <> 99)
                   OR ( lv_curriculum_mod_rec_data.sorlcur_coll_code =  lv_curriculum_rec.r_coll_code
                          AND lv_curriculum_mod_rec_data.sorlcur_degc_code =  lv_curriculum_rec.r_degc_code
                          AND lv_curriculum_mod_rec_data.sorlcur_levl_code = lv_curriculum_rec.r_levl_code
                          AND nvl(lv_curriculum_mod_rec_data.sorlcur_program, '%') like nvl(lv_curriculum_rec.r_program,'%')))
              THEN
                -- 8.5.0.3 verify that this is current and active still, we don't want to roll to match to non current
                 isCurrent := null ;
                 p_print_dbms('check if this outcome lcur is still c/a: ' || lv_curriculum_mod_rec_data.sorlcur_rolled_seqno);
                 open isCurrentActive(p_pidm => lv_curriculum_rec.r_pidm,
                       p_rolled_seqno => lv_curriculum_mod_rec_data.sorlcur_rolled_seqno);
                 fetch isCurrentActive into isCurrent;
                 close isCurrentActive;
                 if isCurrent = 'Y' then
                   lv_old_rolled_seqno := lv_curriculum_mod_rec_data.sorlcur_rolled_seqno;
                   p_print_dbms('found the rolled lcur is   current so we cant match to it:' || lv_old_rolled_seqno);
                else
                   lv_old_rolled_seqno   := null ;
                   p_print_dbms('found the rolled lcur is no longer current so we cant match to it ' || lv_old_rolled_seqno);
                end if;
                EXIT;
              END IF;
            END LOOP;
            CLOSE lv_curriculum_mod_rec;
            p_print_dbms('did we find the lcur from lv_curriculum_mod_rec : ' ||   lv_old_seqno || ' dgmr: ' || dgmr_seq
             || ' old rolled sq: ' || lv_old_rolled_seqno);
            IF lv_old_rolled_seqno IS NULL THEN
              lv_bypass_lcur := 'Y';
              dgmr_seq       := NULL;
              p_print_dbms('not rolled, not found from lv_curriculum_mod_rec' || lv_bypass_lcur || ' dgmr: ' || dgmr_seq);
            ELSE

              p_print_dbms('found the lcur from lv_curriculum_mod_rec : ' ||   lv_old_seqno || ' dgmr: ' || dgmr_seq
                || ' old rolled: ' ||  lv_old_rolled_seqno);
              --- find the degree record for the previously rolled lcur
              --- if it was but awarded,  do not process
              lv_curriculum_rolled_cur := sb_curriculum.f_query_one(p_pidm  => grdroll_rec.pidm, /*BIEN*/
                                                                    p_seqno => lv_old_rolled_seqno);
              FETCH lv_curriculum_rolled_cur
                INTO lv_curriculum_rolled_rec;
              dgmr_seq := lv_curriculum_rolled_rec.r_key_seqno;
              CLOSE lv_curriculum_rolled_cur;
              lv_degree_awarded := sb_learneroutcome_rules.f_degree_awarded(p_pidm   => grdroll_rec.pidm, /*BIEN*/
                                                                            p_seq_no => dgmr_seq);
              -- 7201 change,  was lv_degree_awarded = N so was bypassing
              -- if degree was not awarded, which is opposite to what it needs to do
              IF lv_degree_awarded = 'Y' THEN
                lv_bypass_lcur := 'Y';
                dgmr_seq       := NULL;
              END IF;
            END IF;
          END IF; -- end check if curric is active
          p_print_dbms('after the lv_curriculum_mod_rec, by pass lcur =' || lv_bypass_lcur || ' dgmr: ' || dgmr_seq);
          IF lv_bypass_lcur IS NULL THEN
            -- first check that if the status in not active, than at least one other
            -- lcur exists on the degree that is active, and has a different priority
            -- If we add this inactive lcur we want at least one active,
            -- current curriculum for the priority remaining
            -- 8.5.0.3 capture pending rolls and already rolled in separate counters and
            -- if one is > 0 go ahead and insert the lcur
            p_print_dbms('current active: ' || lv_curric_active || ' degree: ' || dgmr_seq);
            IF lv_curric_active = 'N' THEN
              lv_cnt_other_active := 0;
              lv_cnt_pending_other := 0 ;
              -- first check is if there is another curriculum with a different priority
              lv_curriculum_cur2 := sb_curriculum.f_query_current(p_pidm       => grdroll_rec.pidm, /*BIEN*/
                                                                  p_lmod_code  => sb_curriculum_str.f_outcome,/*BIEN*/
                                                                  p_keyseqno   => dgmr_seq,
                                                                  p_active_ind => 'Y');
              LOOP
                FETCH lv_curriculum_cur2
                  INTO lv_curriculum_rec2;
                EXIT WHEN lv_curriculum_cur2%NOTFOUND;
                IF lv_curriculum_rec2.r_priority_no <> lv_curriculum_rec.r_priority_no AND
                   sb_learnercurricstatus.f_is_active(p_cact_code => lv_curriculum_rec2.r_cact_code) = 'Y' THEN /*BIEN*/
                  lv_cnt_other_active := lv_cnt_other_active + 1;
                  p_print_dbms('lv current other: ' || lv_cnt_other_active);
                END IF;
              END LOOP;
              CLOSE lv_curriculum_cur2;
              p_print_dbms('cnt of current active outcome curric for diff prior ' ||     lv_cnt_other_active);
              -- add the following to check if another is going to be rolled with diff prior


              lv_curr_read2roll_cur := sb_curriculum.f_query_module(p_pidm      => grdroll_rec.pidm, /*BIEN*/
                                                                      p_lmod_code => sb_curriculum_str.f_learner); /*BIEN*/
                LOOP
                  FETCH lv_curr_read2roll_cur
                    INTO lv_curr_read2roll_rec;
                  EXIT WHEN lv_curr_read2roll_cur%notfound;
                  p_print_dbms('** keyseqno: ' ||
                               lv_curr_read2roll_rec.r_key_seqno ||  ' old one: ' ||
                               lv_curriculum_rec.r_key_seqno || ' dgmr stsp: ' || dgmr_stsp || ' dmgr: ' || dgmr_seq ||
                                ' rolled: ' || lv_curr_read2roll_rec.r_rolled_seqno ||
                                ' prior: ' || lv_curr_read2roll_rec.r_priority_no || ' to ' ||
                                 lv_curriculum_rec.r_priority_no || ' seq: ' ||
                                 lv_curr_read2roll_rec.r_seqno  || ' > ' ||  lv_curriculum_rec.r_seqno ||
                                 ' act: ' ||sb_learnercurricstatus.f_is_active(p_cact_code => lv_curr_read2roll_rec.r_cact_code)   ); /*BIEN*/
                  IF lv_curr_read2roll_rec.r_rolled_seqno IS NULL
                    AND  lv_curr_read2roll_rec.r_roll_ind = 'Y'
                    AND (( dgmr_stsp IS NOT NULL
                         AND lv_curr_read2roll_rec.r_key_seqno =  lv_curriculum_rec.r_key_seqno
                         AND lv_curriculum_rec.r_key_seqno <> 99)
                      OR (dgmr_seq is not null
                          AND lv_curr_read2roll_rec.r_coll_code =  lv_curriculum_rec.r_coll_code
                          AND lv_curr_read2roll_rec.r_degc_code =  lv_curriculum_rec.r_degc_code
                          AND lv_curr_read2roll_rec.r_levl_code = lv_curriculum_rec.r_levl_code
                          AND lv_curr_read2roll_rec.r_program = lv_curriculum_rec.r_program))
                     AND lv_curr_read2roll_rec.r_priority_no <> lv_curriculum_rec.r_priority_no
                     --add 8.5.0.3 make sure the lcur seq is > then the one being tested this one is yet to be rolled
                     AND lv_curr_read2roll_rec.r_seqno > lv_curriculum_rec.r_seqno
                     and  sb_learnercurricstatus.f_is_active(p_cact_code => lv_curr_read2roll_rec.r_cact_code) = 'Y' then /*BIEN*/

                       lv_cnt_pending_other := lv_cnt_pending_other + 1;

                       p_print_dbms('lv current other in read2roll: ' ||  lv_cnt_pending_other  || ' seq: ' ||
                           lv_curr_read2roll_rec.r_seqno   );
                   END IF;
                END LOOP;
                CLOSE lv_curr_read2roll_cur;

              p_print_dbms('cnt of current active learner curric for diff prior ' ||  lv_cnt_other_active
                 || ' pending ' || lv_cnt_pending_other);
              -- second check if that total current and active lcur for outome
              -- and learner evens out so one current and active lcur is left on the outcome
              -- 8.5.0.3 capture pending rolls and already rolled in separate counters and
              -- if one is > 0 go ahead and insert the lcur
              IF lv_cnt_other_active = 0 and lv_cnt_pending_other = 0  THEN
                cnt_outcome := 0;
               --- cnt existing outcome curric
                 lv_curriculum_cur2 := sb_curriculum.f_query_module(p_pidm      => grdroll_rec.pidm, /*BIEN*/
                                                                   p_lmod_code => sb_curriculum_str.f_outcome); /*BIEN*/
                LOOP
                  FETCH lv_curriculum_cur2
                    INTO lv_curriculum_rec2;
                  EXIT WHEN lv_curriculum_cur2%NOTFOUND;
                  IF lv_curriculum_rec2.r_key_seqno = dgmr_seq
                    AND lv_curriculum_rec2.r_priority_no =  lv_curriculum_rec.r_priority_no THEN
                    IF sb_learnercurricstatus.f_is_active(p_cact_code => lv_curriculum_rec2.r_cact_code) = 'Y' THEN /*BIEN*/
                      cnt_outcome := cnt_outcome - 1;
                    ELSE
                      cnt_outcome := cnt_outcome + 1;
                    END IF;
                  END IF;
                 END LOOP;
                 CLOSE lv_curriculum_cur2;
                 p_print_dbms('cnt of  outcome curric for same prior ' ||    cnt_outcome);
                ---- count unrolled curric with same priority
                cnt_pending := 0;
                lv_curr_read2roll_cur := sb_curriculum.f_query_module(p_pidm      => grdroll_rec.pidm, /*BIEN*/
                                                                      p_lmod_code => sb_curriculum_str.f_learner); /*BIEN*/
                LOOP
                  FETCH lv_curr_read2roll_cur  INTO lv_curr_read2roll_rec;
                  EXIT WHEN lv_curr_read2roll_cur%notfound;
                  p_print_dbms('*2 keyseqno: ' || lv_curr_read2roll_rec.r_key_seqno ||  ' old one: ' ||
                               lv_curriculum_rec.r_key_seqno || ' dgmr stsp: ' || dgmr_stsp || ' dmgr: ' || dgmr_seq ||
                                ' rolled: ' || lv_curr_read2roll_rec.r_rolled_seqno ||
                                ' prior: ' || lv_curr_read2roll_rec.r_priority_no || ' to ' ||
                                 lv_curriculum_rec.r_priority_no || ' seq: ' ||
                                 lv_curr_read2roll_rec.r_seqno  || ' > ' ||  lv_curriculum_rec.r_seqno ||
                                 ' act: ' ||sb_learnercurricstatus.f_is_active(p_cact_code => lv_curr_read2roll_rec.r_cact_code)   ); /*BIEN*/
                  IF lv_curr_read2roll_rec.r_rolled_seqno IS NULL
                     AND lv_curr_read2roll_rec.r_internal_record_id <>  lv_curriculum_rec.r_internal_record_id
-- 8.5.0.5
--                   AND lv_curr_read2roll_rec.r_term_code >= grdroll_rec.term
                     AND lv_curr_read2roll_rec.r_term_code <= grdroll_rec.term
                     AND NVL(lv_curr_read2roll_rec.r_term_code_end,grdroll_rec.term) >= grdroll_rec.term
                     AND lv_curr_read2roll_rec.r_roll_ind = 'Y'
                     AND lv_curr_read2roll_rec.r_seqno > lv_curriculum_rec.r_seqno
                     AND (  (dgmr_stsp IS NOT NULL
                          AND lv_curr_read2roll_rec.r_key_seqno =  lv_curriculum_rec.r_key_seqno
                          AND  lv_curriculum_rec.r_key_seqno <> 99)
                         OR (dgmr_seq IS NOT NULL
                          AND lv_curr_read2roll_rec.r_coll_code =  lv_curriculum_rec.r_coll_code
                          AND lv_curr_read2roll_rec.r_degc_code =  lv_curriculum_rec.r_degc_code
                          AND lv_curr_read2roll_rec.r_levl_code =  lv_curriculum_rec.r_levl_code
                          AND lv_curr_read2roll_rec.r_program = lv_curriculum_rec.r_program) )
                     AND lv_curr_read2roll_rec.r_priority_no = lv_curriculum_rec.r_priority_no
                     THEN
                     p_print_dbms('matched future lcur found: ' ||  lv_curr_read2roll_rec.r_seqno || ' active: ' ||
                        lv_curr_read2roll_rec.r_cact_code );
                    IF sb_learnercurricstatus.f_is_active(p_cact_code => lv_curr_read2roll_rec.r_cact_code) = 'Y' THEN /*BIEN*/
                      cnt_pending := cnt_pending + 1;
                    ELSE
                      cnt_pending := cnt_pending - 1;
                    END IF;
                  END IF;
                END LOOP;
                CLOSE lv_curr_read2roll_cur;
                p_print_dbms('cnt of  unrolled learner  for same prior ' ||    cnt_pending);
                IF cnt_outcome > 0 or cnt_pending > 0 THEN
                  lv_cnt_other_active := 1;
                END IF;
              ELSE

                  lv_cnt_other_active := 1;

              END IF; --- cnt other active is 0 for other prior, what about same prior

              -- end of adds to check for curriculum that is going to roll to this degree
            ELSE
              --- 8.5.0.3
              -- else the lcur is not active, need to set flag so it will roll if
              --  1)  degree found
              --  2)  is current and degree not found and it was previously rolled
              --  3)  is current and active and no degree was found
              if (degree_found = 'Y') OR
                 (p_current_ind = 'Y' and degree_found = 'N') or
                 (p_current_ind = 'Y' and degree_found = 'N' and
                 lv_curriculum_rec.r_rolled_seqno is not null) then
                lv_cnt_other_active := 1;
              end if;
              p_print_dbms('lv current other at end set it to 1: ' ||
                           lv_cnt_other_active || ' current: ' ||
                           p_current_ind || ' degree found: ' ||
                           degree_found);
            END IF;
            -- create the curriculum record with same priority thats on the learner
            -- only create if there is an active curriculum

            IF lv_cnt_other_active > 0 THEN
              p_process_curriculum;
              IF api_error = 'Y' THEN
                RETURN;
              END IF;
            END IF; -- bypass if not active and no other active curric exists
          END IF; -- bypass lcur check
          ---  the sorlcur for the learner has the rolled seqno filled in,
          --   check for any fields of study that need to be rolled
        ELSE
          -- lcur was already rolled
          --- check existing shrdgmr to see if  the dual degree info
          --  needs to be updated
          --  query the previously rolled curriculum to get the degree seqno and grad app
          --  find lcur already rolled
          lv_curriculum_cur2 := sb_curriculum.f_query_one(p_pidm  => grdroll_rec.pidm, /*BIEN*/
                                                          p_seqno => lv_curriculum_rec.r_rolled_seqno);
          FETCH lv_curriculum_cur2
            INTO lv_curriculum_rec2;
          dgmr_seq := lv_curriculum_rec2.r_key_seqno;
          CLOSE lv_curriculum_cur2;
          lv_degree_awarded := sb_learneroutcome_rules.f_degree_awarded(p_pidm   => grdroll_rec.pidm, /*BIEN*/
                                                                        p_seq_no => dgmr_seq);
          IF lv_degree_awarded = 'N' AND
             sb_learneroutcome.f_exists(p_pidm   => grdroll_rec.pidm, /*BIEN*/
                                        p_seq_no => dgmr_seq) = 'Y' THEN
            p_update_degree;
            IF api_error = 'Y' THEN
              RETURN;
            END IF;
            --- read the fields of study and roll to AH any that are outstanding
            p_process_fieldofstudy(p_lcur_seqno     => lv_curriculum_rec.r_seqno,
                                   p_new_lcur_seqno => lv_curriculum_rec.r_rolled_seqno,
                                   p_new_lcur_ind   => 'N',
                                   p_new_csts       => lv_csts_code,
                                   p_default_status => default_status,
                                   p_reroll_ind     => 'N');
          ELSE
            --- there was a field of study change
            --  made after the degree was awarded,
            --- add a new degree and curriculum.
            lv_fieldofstudy_cur := sb_fieldofstudy.f_query_all(p_pidm       => grdroll_rec.pidm, /*BIEN*/
                                                               p_lcur_seqno => lv_curriculum_rec.r_seqno);
            LOOP
              FETCH lv_fieldofstudy_cur
                INTO lv_fieldofstudy_rec;
              EXIT WHEN lv_fieldofstudy_cur%NOTFOUND;
              IF lv_fieldofstudy_rec.r_rolled_seqno IS NULL OR
                 (lv_fieldofstudy_rec.r_rolled_seqno IS NOT NULL AND
                 sb_learneroutcome.f_exists(p_pidm   => grdroll_rec.pidm, /*BIEN*/
                                             p_seq_no => dgmr_seq) = 'N') THEN
                change_found := 'Y';
                EXIT; --- no need to continue because we are only ready to see if there is a change
              END IF;
            END LOOP;
            CLOSE lv_fieldofstudy_cur;
            IF change_found = 'Y' THEN
              p_print_dbms('isert degree, change found is Y');
              IF sobctrl_row.sobctrl_study_path_ind = 'Y' AND
                 shbcgpa_row.shbcgpa_roll_study_path_ind = 'Y' AND
                 lv_curriculum_rec.r_key_seqno <> 99 THEN
                dgmr_stsp := lv_curriculum_rec.r_key_seqno;
              END IF;
              p_insert_degree(p_acyr_code           => p_acyr_code,
                              p_term_code_grad      => p_term_code_grad,
                              p_expected_grad_date  => p_graduation_date,
                              p_fee_ind             => p_fee_ind,
                              p_fee_date            => p_fee_date,
                              p_term_code_completed => p_term_code_completed,
                              p_grst_code           => p_grst_code);
              IF api_error <> 'Y' THEN
                p_process_curriculum;
              ELSE
                RETURN;
              END IF;
            END IF;
          END IF;
        END IF; --- curriculum wasnt rolled so it needs to be rolled again
      ELSE
        --  examine any lfos and reroll if they were deleted
        -- process lfos if the rolled lcur exists and the degree has not
        -- been awarded.  we may need to reroll learner lfst that were
        --  deleted
        -- process lfos if the rolled lcur exists and the degree has not
        -- been awarded.  we may need to reroll learner lfst that were
        --  deleted
        IF sb_curriculum.f_exists(p_pidm  => grdroll_rec.pidm, /*BIEN*/
                                  p_seqno => lv_curriculum_rec.r_rolled_seqno) = 'Y' THEN
          --- verify that the degree is correct
          outcome_degc := NULL;
          OPEN find_outcome_degc_c(p_pidm         => grdroll_rec.pidm,
                                   p_rolled_seqno => lv_curriculum_rec.r_rolled_seqno,
                                   p_lmod_code    => sb_curriculum_str.f_outcome); /*BIEN*/
          FETCH find_outcome_degc_c
            INTO outcome_degc;
          IF find_outcome_degc_c%notfound THEN
            outcome_degc := NULL;
            dgmr_seq     := NULL;
          END IF;
          CLOSE find_outcome_degc_c;
          IF outcome_degc IS NOT NULL AND dgmr_seq <> outcome_degc THEN
            dgmr_seq := outcome_degc;
          END IF;
          ---- need to find the degree here
          IF dgmr_seq IS NOT NULL AND
             sb_learneroutcome_rules.f_degree_awarded(p_pidm   => grdroll_rec.pidm, /*BIEN*/
                                                      p_seq_no => dgmr_seq) = 'N' THEN
            p_print_dbms('update lfos2 : ' || dgmr_seq || ' rolled seq: ' ||
                         lv_curriculum_rec.r_rolled_seqno ||
                         ' p_lcur_seqno: ' || lv_curriculum_rec.r_seqno);
            p_process_fieldofstudy(p_lcur_seqno     => lv_curriculum_rec.r_seqno,
                                   p_new_lcur_seqno => lv_curriculum_rec.r_rolled_seqno,
                                   p_new_lcur_ind   => 'N',
                                   p_new_csts       => lv_csts_code,
                                   p_default_status => default_status,
                                   p_reroll_ind     => 'N');
            --   ELSE --- degree is awarded , need to add it
            --       p_print_dbms('insert degree if awarded #3');
            --
            --         p_insert_degree(p_acyr_code => lv_curriculum_rec.r_acyr_code,
            --             p_term_code_grad => lv_curriculum_rec.r_term_code_grad,
            --             p_expected_grad_date => lv_curriculum_rec.r_exp_grad_date);
            --         if api_error <> 'Y' then
            --             p_process_curriculum;
            --         ELSE
            --           return;
            --        end if;
          END IF; --- degree not awarded
        END IF; --- rolled seqo exists
      END IF; --- reject if term is < grdroll or the degree was deleted
      --
      -- at end of processing curriculum,  run backfill process and
      -- insert degree apply ind
      p_print_dbms('near the end, before the backfill ' || dgmr_seq);
      IF dgmr_seq IS NOT NULL THEN
        --- back fill the curriculum data to the degree
        IF schange = 'Y' THEN
          -- schange tracks if there was an update to the curriculum, we
          -- don't want to do the backfill unless there was a change
          -- p_print_dbms('backfill '|| dgmr_seq || ' term ' || grdroll_rec.stuterm);
          Soklcur.P_backload_curr(p_lmod      => sb_curriculum_str.f_outcome, /*BIEN*/ /*BIEN*/
                                  p_term_code => grdroll_rec.stuterm,
                                  p_keyseqno  => dgmr_seq,
                                  p_pidm      => grdroll_rec.pidm);
        END IF;
      END IF; -- dgmr seq is not null insert shrtckd and backfill
    END IF; --- roll ind is Y
  END p_roll_outcome;

--------------------------------------------------------------------------
  -- Perform a reroll for a single pidm from Gradebook
  PROCEDURE p_do_graderoll_pidm ( p_term IN ssbsect.ssbsect_term_code%TYPE
                                 ,p_crn IN ssbsect.ssbsect_crn%TYPE
                                 ,p_pidm IN sfrstcr.sfrstcr_pidm%TYPE
                                 ,p_user IN shrtckg.shrtckg_final_grde_chg_user%TYPE
                                )
  IS
  BEGIN
    -- Select SHBCGPA_CAMP_GPA_IND. This only has to be done once,
    -- not for each student, so it is not part of the main loop.
    shksels.p_select_shbcgpa(shbcgpa_row, row_found); /*BIEN*/
    IF row_found THEN
       cgpa_ind := shbcgpa_row.shbcgpa_camp_gpa_ind;
    ELSE
       cgpa_ind := ' ';
    END IF;

    term_parm := p_term;
    crn_parm :=  p_crn;
    user_parm := p_user;
    sessionid_parm := '1';
    print_sel_parm := '1';
    report_mode_parm := 'O';
    grade_term_parm := '';
    roll_title_parm := '';
    commit_count := 0;
    gv_update_mode := '0';
    ptrm_parm := '%';
    roll_title_parm := 'Y';
    gradebook_reroll_pidm_parm := p_pidm;
    p_get_student_course;
  END p_do_graderoll_pidm;

END szkrols;
/
SHOW ERRORS
SET DEFINE ON
