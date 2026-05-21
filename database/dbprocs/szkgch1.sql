/******************************************************************************/
/* szkgch1.sql Copyright 2015 Ellucian Company L.P. and its affiliates.       */
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
/* FILE NAME..: szkgch1.sql                                                   */
/*                                                                            */
/* RELEASE....: 8.7 [MCLA:002.1.0]                                            */
/*                                                                            */
/* OBJECT NAME: szkgchg                                                       */
/*                                                                            */
/* Massive process that upload file and changes grade on Academic History or  */
/* on registered course.                                                      */
/*                                                                            */
/******************************************************************************/
/*                                                                            */
/* AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                            */
/* --------------------------------------------------------  ---  ----------- */
/* 1. Initial Code                                           MKU  Jan/18/2016 */
/*                                                                            */
/* AUDIT TRAIL: 8.7 [MCLA:002.1.1]                                            */
/* --------------------------------------------------------  ---  ----------- */
/* 1. Functions were added for correct comparisons between   MSO  Nov/18/2016 */
/*    grades letters.                                                         */
/*                                                                            */
/* AUDIT TRAIL: 8.7 [MCLA:002.1.2]                                            */
/* --------------------------------------------------------  ---  ----------- */
/* 1. Se agrega asignacion de 0 como calificacion para aque- MSO  Dic/02/2016 */
/*   llas con nota no numerica                                                */
/*                                                                            */
/* --------------------------------------------------------  ---  ----------- */  
/* AUDIT TRAIL: 8.7 [MCLA:002.1.3]                                            */
/* --------------------------------------------------------  ---  ----------- */
/* 1. Se hacen ajustes para que no permita modificar califi- MSO  Dic/10/2016 */
/*   caciones si no estan en el rango.                                        */
/*                                                                            */
/* --------------------------------------------------------  ---  ----------- */  
/*  AUDIT TRAIL: 8.31.2 [MOD:02.2.0]                                          */
/*  -------------------------------------------------------  ---  ----------- */
/*  1. Student version updated from 8.7 to 8.31.2             LMR 07-NOV-2024 */
/*  -------------------------------------------------------  ---  ----------- */
/*                                                                            */
/* AUDIT TRAIL END                                                            */
/*                                                                            */
/* BEGIN COMMENT                                                              */
/*                                                                            */
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

create or replace PACKAGE BODY  SZKGCHG
IS
-- FILE NAME..: szkgch1.sql
-- RELEASE....: 8.7 [MCLA:002.1.3]
-- OBJECT NAME: szkgchg
-- PRODUCT....: STU
-- USAGE......: Massive process to change grades on Academic History or on registered courses.
-- COPYRIGHT..: Copyright 2015 Ellucian Company L.P. and its affiliates.
--
--
    -- define local variables
    gModeValidate               varchar2(1) := 'V';
    gModeManual                 varchar2(1) := 'M';
    gProcessAH                  varchar2(1) := 'H';
    gProcessRe                  varchar2(1) := 'R';
    gAHReasonExtra              GTVSDAX.GTVSDAX_EXTERNAL_CODE%type := 'EXAMEN_EX';
    gAHReasonLastCourse         GTVSDAX.GTVSDAX_EXTERNAL_CODE%type := 'EXAMEN_UM';
    gAHReasonDAGrade            GTVSDAX.GTVSDAX_EXTERNAL_CODE%type := 'DA_GRDE';
    gAHReasonDAMax              GTVSDAX.GTVSDAX_EXTERNAL_CODE%type := 'DA_MAX';
    gAHReasonExclGrade          GTVSDAX.GTVSDAX_EXTERNAL_CODE%type := 'EXCL_GRDE';
    gAHReasonNumEE              GTVSDAX.GTVSDAX_EXTERNAL_CODE%type := 'NUM';
    gAHReasonMinGrde            GTVSDAX.GTVSDAX_EXTERNAL_CODE%type := 'MIN_GRDE';
    gAHReasonMaxGrde            GTVSDAX.GTVSDAX_EXTERNAL_CODE%type := 'MAX_GRDE';

    cursor get_pidm_c(cStuID          varchar2) is
        select SP.SPRIDEN_PIDM
          from spriden sp
         where SP.SPRIDEN_ID = cStuID
           and SP.SPRIDEN_CHANGE_IND is null;

    cursor check_term_code_c(cTermCode      varchar2) is
        select 'Y'
          from stvterm st
         where ST.STVTERM_CODE = cTermCode;

    cursor check_course_c(cCourse       varchar2,
                          cCrn          varchar2,
                          cTermCode     varchar2) is
        Select 'Y'
          from ssbsect sb
         where SB.SSBSECT_CRN = cCrn
           and SB.SSBSECT_TERM_CODE = cTermCode
           and SB.SSBSECT_SUBJ_CODE || SB.SSBSECT_CRSE_NUMB =   cCourse;

    cursor check_crn_c(cCrn          varchar2,
                       cTermCode     varchar2) is
        Select 'Y'
          from ssbsect sb
         where SB.SSBSECT_CRN = cCrn
           and SB.SSBSECT_TERM_CODE = cTermCode;


    cursor check_grade_c(cGradeCode   varchar2,
                         cTermCode    varchar2) is
        SELECT 'Y'
          FROM SHRGRDE GR
         WHERE GR.SHRGRDE_CODE = cGradeCode
           AND GR.SHRGRDE_TERM_CODE_EFFECTIVE = (SELECT MAX(X.SHRGRDE_TERM_CODE_EFFECTIVE)
                                                   FROM SHRGRDE X
                                                  WHERE X.SHRGRDE_CODE = GR.SHRGRDE_CODE
                                                    AND X.SHRGRDE_TERM_CODE_EFFECTIVE <= cTermCode);

    cursor check_grade_comm(cGradeComm      varchar2) is
        select 'Y'
          from stvGCMT gc
         where GC.STVGCMT_CODE = cGradeComm;

    cursor check_change_reason(cChangeReason            varchar2) is
        SELECT 'Y'
          FROM STVGCHG
         WHERE STVGCHG_CODE = trim(cChangeReason);




    cursor check_course_registration(cPidm          number,
                                     cCrn           varchar2,
                                     cTermCode     varchar2) is
         SELECT  cr.SFRSTCR_LEVL_CODE, cr.SFRSTCR_GRDE_CODE_MID
           FROM sfrstcr cr
          WHERE CR.SFRSTCR_CRN = cCrn
            and CR.SFRSTCR_TERM_CODE = cTermCode
            and CR.SFRSTCR_PIDM = cPidm
            and (NVL(SFRSTCR_ERROR_FLAG,'N') <> 'F')
                AND (CR.SFRSTCR_ERROR_FLAG not in ('F','D')
                    or CR.SFRSTCR_ERROR_FLAG is null
                    or CR.SFRSTCR_RSTS_CODE in (select stvrsts_code
                                               from stvrsts
                                              where stvrsts_code = CR.SFRSTCR_RSTS_CODE
                                                and stvrsts_gradable_ind = 'Y'));


    cursor get_message_c(cFileName      SZRGCHG.SZRGCHG_LOAD_FILE_NAME%type,
                         cMessage       SZRGCHG.SZRGCHG_MESSAGE%type) is
        select *
          from szrgchg ch
         where CH.SZRGCHG_LOAD_FILE_NAME = cFileName
           and upper(CH.SZRGCHG_MESSAGE) like cMessage;

    cursor check_CRN_AH_c(cPidm          number,
                         cCrn           varchar2,
                         cTermCode     varchar2) is

        Select Kl.Shrtckl_Levl_Code, Kg.Shrtckg_Grde_Code_Final
          From Shrtckn Kn, Shrtckl Kl, Shrtckg Kg
          Where Kn.Shrtckn_Pidm = Kl.Shrtckl_Pidm
            And Kn.Shrtckn_Term_Code = Kl.Shrtckl_Term_Code
            And Kn.Shrtckn_Seq_No = Kl.Shrtckl_Tckn_Seq_No
            And Kn.Shrtckn_Pidm = Kg.Shrtckg_Pidm
            And Kn.Shrtckn_Term_Code = Kg.Shrtckg_Term_Code
            And Kn.Shrtckn_Seq_No = Kg.Shrtckg_Tckn_Seq_No
            And Kl.Shrtckl_Primary_Levl_Ind = 'Y'
            And Kn.Shrtckn_Crn = cCrn
            And Kn.Shrtckn_Term_Code = cTermCode
            And Kn.Shrtckn_Pidm = cPidm
            And Kg.Shrtckg_Seq_No =
                  (SELECT MAX(SHRTCKG_SEQ_NO)
                     FROM   SHRTCKG
                    WHERE  SHRTCKG_PIDM = cPidm
                      And  Shrtckg_Term_Code = cTermCode
                      And  SHRTCKG_TCKN_SEQ_NO = Kn.Shrtckn_Seq_No ) ;

  /* BA 8.7 [MCLA:002.1.1] */
  FUNCTION f_isLetter(vScore VARCHAR2)
   RETURN BOOLEAN
   IS

     score    NUMBER(8);

   BEGIN
   
     score := TO_NUMBER(vScore);
     return (FALSE);
     Exception WHEN OTHERS THEN
     return (TRUE);

  END f_isLetter;
  /* EA 8.7 [MCLA:002.1.1] */

    procedure p_save_szrgchg(p_id                   varchar2,
                             p_term_code            varchar2,
                             p_crn                  varchar2,
                             p_grade_ori            varchar2,
                             p_grade_upd            varchar2,
                             p_file_name            varchar2,
                             p_grade_comm           varchar2,
                             p_change_reason        varchar2,
                             p_Message              varchar2,
                             p_MensErro         out varchar2
                            ) is

        cursor check_exists_c is
            select nvl(max(ZC.SZRGCHG_SEQNO),0)+ 1
              from szrgchg zc
             where ZC.SZRGCHG_CRN = p_crn
               and ZC.SZRGCHG_ID = p_id
               and ZC.SZRGCHG_TERM_CODE = p_term_code
               and ZC.SZRGCHG_GRDE_CODE_ORIGINAL = p_grade_ori;

        vNextSeqno              number(5);
    begin
        p_MensErro := null;

        vNextSeqno := null;

        open check_exists_c;
        fetch check_exists_c into vNextSeqno;
        close check_exists_c;


        insert into szrgchg(SZRGCHG_TERM_CODE, /*BIEN*/
                            SZRGCHG_CRN,
                            SZRGCHG_ID,
                            SZRGCHG_GRDE_CODE_ORIGINAL,
                            SZRGCHG_SEQNO,
                            SZRGCHG_GRDE_CODE_UPDATE,
                            SZRGCHG_LOAD_FILE_NAME,
                            SZRGCHG_GCHG_CODE,
                            SZRGCHG_GCMT_CODE,
                            SZRGCHG_MESSAGE,
                            SZRGCHG_USER_ID,
                            SZRGCHG_ACTIVITY_DATE,
                            SZRGCHG_DATA_ORIGIN
                            )
                     values(p_term_code,
                            p_crn,
                            p_id,
                            nvl(p_grade_ori,'XX'),
                            vNextSeqno,
                            nvl(p_grade_upd,'XX'),
                            p_file_name,
                            NVL(p_change_reason,'XX'),
                            NVL(p_grade_comm, 'XX'),
                            p_Message,
                            user,
                            sysdate,
                            'SZKGCHG'
                            );
    exception
        when others then
            p_MensErro := substr(g$_nls.get('X','SQL','** Error: %01%.',sqlerrm),1,200);

    end p_save_szrgchg;


    function f_get_cred_hours(p_pidm        number,
                              p_crn         SSBSECT.SSBSECT_CRN%type,
                              p_term        SSBSECT.SSBSECT_TERM_CODE%type
                              ) return SCBCRSE.SCBCRSE_CREDIT_HR_LOW%type is
        cursor get_hours_c is
            select CB.SCBCRSE_CREDIT_HR_LOW
              from shrtckn kn, scbcrse cb
             where KN.SHRTCKN_CRSE_NUMB = CB.SCBCRSE_CRSE_NUMB
               and KN.SHRTCKN_SUBJ_CODE = CB.SCBCRSE_SUBJ_CODE
               and CB.SCBCRSE_EFF_TERM = (select max(X.SCBCRSE_EFF_TERM)
                                            from scbcrse x
                                           where X.SCBCRSE_CRSE_NUMB = CB.SCBCRSE_CRSE_NUMB
                                             and X.SCBCRSE_SUBJ_CODE = CB.SCBCRSE_SUBJ_CODE
                                             and X.SCBCRSE_EFF_TERM <= KN.SHRTCKN_TERM_CODE )
               and KN.SHRTCKN_PIDM = p_pidm
               and KN.SHRTCKN_CRN = p_crn
               and KN.SHRTCKN_TERM_CODE = p_term ;


        nDummy          SCBCRSE.SCBCRSE_CREDIT_HR_LOW%type;
    begin
        nDummy := null;
        open get_hours_c;
        fetch get_hours_c into nDummy;
        close get_hours_c;

        return nvl(nDummy, 0);
    end;

    function f_check_registered_rule(p_crn           SSBSECT.SSBSECT_CRN%type,
                                     p_term_code     SSBSECT.SSBSECT_TERM_CODE%type
                                    ) return SZRGCHG.SZRGCHG_MESSAGE%type is

      vMessage              SZRGCHG.SZRGCHG_MESSAGE%type;
      vDummy                varchar2(1);

      cursor check_corequisite_c is
        SELECT 'Y'
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
                     AND scrcorq_eff_term <= p_term_code);


    begin
        vDummy := null;
        vMessage := null;

        open check_corequisite_c;
        fetch check_corequisite_c into vDummy;
        close check_corequisite_c;

        if vDummy is null then
            vMessage := g$_nls.get('X','SQL','No corequisite course found for this CRN');
        else
            vMessage := g$_nls.get('X','SQL','Record has been validated');
        end if;

        return vMessage;


    end f_check_registered_rule;



    function f_get_AH_rule(p_internal           varchar2,
                           p_rule               varchar2,
                           p_seqno              number
                           )
                           return GTVSDAX.GTVSDAX_TRANSLATION_CODE%type is


        cursor get_AH_reason_rule_c is
            select GT.GTVSDAX_TRANSLATION_CODE
              from gtvsdax gt
             where GT.GTVSDAX_INTERNAL_CODE_GROUP = 'UTM002'
               AND GT.GTVSDAX_INTERNAL_CODE like trim(p_internal) || '%'
               AND GT.GTVSDAX_EXTERNAL_CODE = p_rule
               AND GT.GTVSDAX_INTERNAL_CODE_SEQNO = p_seqno ;

        vReturn             GTVSDAX.GTVSDAX_TRANSLATION_CODE%type;
    begin
        vReturn := null;

        open get_AH_reason_rule_c;
        fetch get_AH_reason_rule_c into vReturn;
        close get_AH_reason_rule_c;

        return vReturn;

    end f_get_AH_rule;


    function f_count_grade_szrgchg(pId              SPRIDEN.SPRIDEN_ID%type,
                                   pTermCode        STVTERM.STVTERM_CODE%type,
                                   pGrade           SZRGCHG.SZRGCHG_GRDE_CODE_UPDATE%type,
                                   pCrn             SZRGCHG.SZRGCHG_CRN%TYPE,
                                   pFileName        szrgchg.SZRGCHG_LOAD_FILE_NAME%type
                                   ) return number is
        cursor get_grade is
            select count(1)
              from szrgchg gh
             where GH.SZRGCHG_ID = pId
               and GH.SZRGCHG_TERM_CODE = pTermCode
               and GH.SZRGCHG_GRDE_CODE_UPDATE = pGrade
               and GH.SZRGCHG_LOAD_FILE_NAME = pFileName
               AND GH.SZRGCHG_CRN = pCrn
               and upper(GH.SZRGCHG_MESSAGE) like g$_nls.get('X','SQL','%HISTORY VALIDATE%');

        vCount              number;

    begin
        vCount := 0;
        open  get_grade;
        fetch get_grade into vCount;
        close get_grade;

        return nvl(vCount,0);

    end f_count_grade_szrgchg;


    function f_count_gchg_szrgchg(pId              SPRIDEN.SPRIDEN_ID%type,
                                  pTermCode        STVTERM.STVTERM_CODE%type,
                                  pGCHGCode        SZRGCHG.SZRGCHG_GCHG_CODE%type,
                                  pFileName        szrgchg.SZRGCHG_LOAD_FILE_NAME%type

                                  ) return number is
        cursor get_grade is
            select count(1)
              from szrgchg gh
             where GH.SZRGCHG_ID = pId
               and GH.SZRGCHG_TERM_CODE = pTermCode
               and GH.SZRGCHG_GCHG_CODE = pGCHGCode
               and GH.SZRGCHG_LOAD_FILE_NAME = pFileName
               and upper(GH.SZRGCHG_MESSAGE) like g$_nls.get('X','SQL','%HISTORY VALIDATE%');

        vCount              number;

    begin
        vCount := 0;
        open  get_grade;
        fetch get_grade into vCount;
        close get_grade;

        return nvl(vCount,0);

    end f_count_gchg_szrgchg;


    function f_count_grade_AH(p_pidm                number,
                              p_crn                 SSBSECT.SSBSECT_CRN%type,
                              p_term_code           STVTERM.STVTERM_CODE%type,
                              p_grade               SHRTCKG.SHRTCKG_GRDE_CODE_FINAL%type
                             ) return number is

        cursor count_grade_code_c is
            select count(1)
              from shrtckg kg, shrtckn kn
             where KG.SHRTCKG_TERM_CODE = KN.SHRTCKN_TERM_CODE
               and KG.SHRTCKG_PIDM = KN.SHRTCKN_PIDM
               and KG.SHRTCKG_TCKN_SEQ_NO = KN.SHRTCKN_SEQ_NO
               AND KG.SHRTCKG_SEQ_NO = (SELECT MAX(X.SHRTCKG_SEQ_NO)
                                          FROM SHRTCKG X
                                         WHERE X.SHRTCKG_PIDM = p_pidm
                                           AND X.SHRTCKG_TERM_CODE = p_term_code
                                           AND X.SHRTCKG_TCKN_SEQ_NO = KN.SHRTCKN_SEQ_NO)
               and nvl(KN.SHRTCKN_STSP_KEY_SEQUENCE,99) = (select MAX(nvl(X.SHRTCKN_STSP_KEY_SEQUENCE,99))
                                                             from shrtckn x
                                                            where X.SHRTCKN_PIDM = p_pidm
                                                              and X.SHRTCKN_TERM_CODE = p_term_code)
               and KG.SHRTCKG_PIDM = p_pidm
               and KG.SHRTCKG_GRDE_CODE_FINAL = p_grade
               and KG.SHRTCKG_TERM_CODE = p_term_code
               and KN.SHRTCKN_CRN = p_crn;

        vCount          number;
    begin
        vCount := null;

        open count_grade_code_c;
        fetch count_grade_code_c into vCount;
        close count_grade_code_c;

        return nvl(vCount, 0);

    end f_count_grade_AH;


    function f_count_gchg_AH(p_pidm                number,
                              p_term_code           STVTERM.STVTERM_CODE%type,
                              p_gchg_code           SHRTCKG.SHRTCKG_GCHG_CODE%type
                             ) return number is

        cursor count_grade_code_c is
            select count(1)
              from shrtckg kg, shrtckn kn
             where KG.SHRTCKG_TERM_CODE = KN.SHRTCKN_TERM_CODE
               and KG.SHRTCKG_PIDM = KN.SHRTCKN_PIDM
               and KG.SHRTCKG_TCKN_SEQ_NO = KN.SHRTCKN_SEQ_NO
               and nvl(KN.SHRTCKN_STSP_KEY_SEQUENCE,99) = (select MAX(nvl(X.SHRTCKN_STSP_KEY_SEQUENCE,99))
                                                             from shrtckn x
                                                            where X.SHRTCKN_PIDM = p_pidm
                                                              and X.SHRTCKN_TERM_CODE = p_term_code)
               and KG.SHRTCKG_PIDM = p_pidm
               and KG.SHRTCKG_GCHG_CODE = p_gchg_code
               and KG.SHRTCKG_TERM_CODE = p_term_code ;

        vCount          number;
    begin
        vCount := null;

        open count_grade_code_c;
        fetch count_grade_code_c into vCount;
        close count_grade_code_c;

        return nvl(vCount, 0);

    end f_count_gchg_AH;


    procedure p_check_parameters(p_id                   varchar2,
                                 p_term_code            varchar2,
                                 p_course               varchar2,
                                 p_crn                  varchar2,
                                 p_grade_comm           varchar2,
                                 p_process              varchar2,
                                 p_change_reason        varchar2 default null,
                                 p_ApprovedGrade        varchar2 default null,
                                 p_CheckReason          varchar2 default null,
                                 p_FileName             varchar2,
                                 p_grade_ori       out varchar2,
                                 p_grade_upd    in out SHRGRDE.SHRGRDE_CODE%type,
                                 p_MensErro         out varchar2
                                ) is
        vPidm           SPRIDEN.SPRIDEN_PIDM%type;
        vDummy          varchar2(1);
        vLevlCode       STVLEVL.STVLEVL_CODE%type;

        vLastCourse     GTVSDAX.GTVSDAX_TRANSLATION_CODE%type;
        vExtraExam      GTVSDAX.GTVSDAX_TRANSLATION_CODE%type;
        vDAGrade        GTVSDAX.GTVSDAX_TRANSLATION_CODE%type;
        vSDGrade        GTVSDAX.GTVSDAX_TRANSLATION_CODE%type;
        vNPGrade        GTVSDAX.GTVSDAX_TRANSLATION_CODE%type;
        vMinGrade       GTVSDAX.GTVSDAX_TRANSLATION_CODE%type;
        vMaxGrade       GTVSDAX.GTVSDAX_TRANSLATION_CODE%type;
        vGradeAH        SHRGRDE.SHRGRDE_CODE%type;

        vDAMax          number;
        vSDCount        number;
        vNPCount        number;
        vCount          number;
        vNumMax         number;
        vCountGCHG      number;

    begin
        p_MensErro := null;
        vPidm := NULL;
        vDummy := null;
        vLevlCode := null;
        vLastCourse := null;
        vExtraExam := null;
        vCount := null;
        p_grade_ori := 'XX';

        -- check student id
        open get_pidm_c(p_id);
        fetch get_pidm_c into vPidm;
        if get_pidm_c%notfound then
            close get_pidm_c;
            p_MensErro := g$_nls.get('X','SQL','Id not found.');
            return;
        end if;
        close get_pidm_c;

        -- check term code
        open check_term_code_c(p_term_code);
        fetch check_term_code_c into vDummy;
        if check_term_code_c%notfound then
            close check_term_code_c;
            p_MensErro := g$_nls.get('X','SQL','Term code %01% not found.', p_term_code);
            return;
        end if;
        close check_term_code_c;

        -- check grade code
        vDummy := null;
        open check_grade_c(p_grade_upd,
                            p_term_code
                            );
        fetch check_grade_c into vDummy;
        if check_grade_c%notfound then
            close check_grade_c;
            p_MensErro := g$_nls.get('X','SQL','Grade code %01% not found.', p_grade_upd);
            return;
        end if;
        close check_grade_c;

        -- check change reason
        
        if (p_process <> gProcessRe) then -- 8.7 [MCLA:002.1.1] 
          if p_change_reason is null then
              vDummy := null;
              open check_change_reason(p_change_reason);
              fetch check_change_reason into vDummy;
              if check_change_reason%notfound then
                  close check_change_reason;
                  p_MensErro := g$_nls.get('X','SQL','Change reason code %01% not found.', p_change_reason);
                  return;
              end if;
              close check_change_reason;
          end if;
        
       

        -- check grade comment

          vDummy := null;
          open check_grade_comm(p_grade_comm);
          fetch check_grade_comm into vDummy;
          if check_grade_comm%notfound then
            close check_grade_comm;
              p_MensErro := g$_nls.get('X','SQL','Grade comment %01% not found.', p_grade_comm);
              return;
          end if;
          close check_grade_comm;

        end if;  -- 8.7 [MCLA:002.1.1] 

        -- *******************   check process   *******************
        if p_process = gProcessRe then
            -- ******************  check rules applied for grades not rolled to AH
            -- check CRN
            vDummy := null;
            open check_crn_c(p_crn,
                             p_term_code);
            fetch check_crn_c into vDummy;
            if check_crn_c%notfound then
                close check_crn_c;
                p_MensErro := g$_nls.get('X','SQL','CRN %01% not found.', p_crn);
                return;
            end if;
            close check_crn_c;

            -- check course
            vDummy := null;
            open check_course_c(p_course,
                                p_crn,
                                p_term_code
                                );
            fetch check_course_c into vDummy;
            if check_course_c%notfound then
                close check_course_c;
                p_MensErro := g$_nls.get('X','SQL','Couse %01% not found.', p_course);
                return;
            end if;
            close check_course_c;

            -- check if student is registered on the course
            -- and return it level
             vLevlCode := null;
            open check_course_registration(vPidm,
                                           p_crn,
                                           p_term_code
                                          );
            fetch check_course_registration into vLevlCode, p_grade_ori;
            if check_course_registration%notfound then
                close check_course_registration;
                p_MensErro := g$_nls.get('X','SQL','Student is not registered on CRN %01%', p_crn);
                return;
            end if;
            close check_course_registration;

            p_MensErro := f_check_registered_rule(p_crn, p_term_code);
            return;
        else
            -- ****************** check rules applied for Academic History

            -- *******  check if CRN is in the AH
            vGradeAH := null;

            open check_CRN_AH_c(vPidm,
                               p_crn,
                               p_term_code);
            fetch check_CRN_AH_c into vLevlCode, vGradeAH;
            if check_CRN_AH_c%notfound then
                close check_CRN_AH_c;
                p_MensErro := g$_nls.get('X', 'SQL','No grade in History');
                return;
            end if;
            close check_CRN_AH_c;

            p_grade_ori := vGradeAH;

            -- get extraordinary examination's initials
            vLevlCode := trim(vLevlCode);

            vExtraExam := trim(f_get_AH_rule(vLevlCode || '_' , gAHReasonExtra,1));

            -- get last course's initials
            vLastCourse := trim(f_get_AH_rule(vLevlCode || '_', gAHReasonLastCourse,1));


            if p_CheckReason not in (nvl(vExtraExam,'xx'), nvl(vLastCourse,'xx')) then
                p_MensErro := g$_nls.get('X','SQL','History validated', vMaxGrade);
                return;

            end if;


            -- ****************** check rules for extraordinary examination
            if p_CheckReason = vExtraExam then
                -- get grade code that identifies DA
                vDAGrade := f_get_AH_rule(vLevlCode || '_' || vExtraExam || '%',
                                          gAHReasonDAGrade,
                                          1);

                /* IF p_grade_upd = vDAGrade then */
                    -- get max amount allowed of DA in AH
                    vDAMax := nvl(to_number(f_get_AH_rule(vLevlCode || '_' || vExtraExam || '%',
                                                      gAHReasonDAMax,
                                                      2)),0);

                    -- count the number of grades DA in the AH
                    vCount := f_count_grade_AH(vPidm,
                                               p_crn,
                                               p_term_code,
                                               vDAGrade);

                    -- verify if amount is greater than allowed
                    if vCount > vDAMax then
                        p_MensErro := g$_nls.get('X', 'SQL','It was exceeded the limit of DA grade');
                        return;
                    end if;

                    -- check DA in SZRGCHG
                    vCountGCHG := f_count_grade_szrgchg(p_id,
                                                        p_term_code,
                                                        vDAGrade,
                                                        p_Crn,
                                                        p_FileName
                                                        );
                    if vCount + vCountGCHG > vDAMax then
                        p_MensErro := g$_nls.get('X', 'SQL','It was exceeded the limit of DA grade');
                        return;
                    end if;
                /* end if; */

                -- get grade code that identifies SD
                vSDGrade := f_get_AH_rule(vLevlCode || '_' || vExtraExam || '%',
                                          gAHReasonExclGrade,
                                          2);

                vCount := f_count_grade_AH(vPidm,
                                           p_crn,
                                           p_term_code,
                                           vSDGrade);

                -- verify if it was found any occurrence of SD grade on AH
                if vCount > 0 then
                    p_MensErro := g$_nls.get('X', 'SQL','%01% found on AH',vSDGrade);
                    return;
                end if;

                -- check SD in SZRGCHG
                vCountGCHG := f_count_grade_szrgchg(p_id,
                                                    p_term_code,
                                                    vSDGrade,
                                                    p_Crn,
                                                    p_FileName
                                                    );
                if vCountGCHG > 0 then
                    p_MensErro := g$_nls.get('X', 'SQL','%01% found on SZRGCHG',vSDGrade);
                    return;
                end if;

                -- get grade code that identifies NP
                vNPGrade := f_get_AH_rule(vLevlCode || '_' || vExtraExam || '%',
                                          gAHReasonExclGrade,
                                          3);

                vCount := f_count_grade_AH(vPidm,
                                           p_crn,
                                           p_term_code,
                                           vNPGrade);

                -- verify if it was found any occurrence of NP grade on AH
                if vCount > 0 then
                    p_MensErro := g$_nls.get('X', 'SQL','%01% found on AH', vNPGrade);
                    return;
                end if;

                -- check NP in SZRGCHG
                vCountGCHG := f_count_grade_szrgchg(p_id,
                                                    p_term_code,
                                                    vNPGrade,
                                                    p_Crn,
                                                    p_FileName
                                                    );
                if vCountGCHG > 0 then
                    p_MensErro := g$_nls.get('X', 'SQL','%01% found on SZRGCHG',vNPGrade);
                    return;
                end if;

                -- check limit for extraordinary examination
                -- get max amount allowed of EE in AH
                vNumMax := to_number(f_get_AH_rule(vLevlCode || '_' || vExtraExam || '%',
                                                  gAHReasonNumEE,
                                                  1));

                vCount := f_count_gchg_AH(vPidm,
                                          p_term_code,
                                          vExtraExam);

                -- verify if it was found any occurrence of EE grade on AH
                if vCount >= vNumMax then
                    p_MensErro := g$_nls.get('X', 'SQL','It exceeds the limit of extraordinary examination');
                    return;
                end if;

                -- check EE in SZRGCHG
                vCountGCHG := f_count_gchg_szrgchg(p_id,
                                                   p_term_code,
                                                   vExtraExam,
                                                   p_FileName
                                                   );
                if vCountGCHG + vCount >= vNumMax then
                    p_MensErro := g$_nls.get('X', 'SQL','It exceeds the limit of extraordinary examination');
                    return;
                end if;

                -- check minimum grade
                vMinGrade := f_get_AH_rule(vLevlCode || '_' || vExtraExam || '%',
                                          gAHReasonMinGrde,
                                          1);

                -- check grade code
                vDummy := null;
                open check_grade_c(vMinGrade,
                                    p_term_code
                                    );
                fetch check_grade_c into vDummy;
                if check_grade_c%notfound then
                    close check_grade_c;
                    p_MensErro := g$_nls.get('X','SQL','Grade code %01% not found.', vMinGrade);
                    return;
                end if;
                close check_grade_c;

                /*
                if vGradeAH < vMinGrade or vGradeAH >= p_ApprovedGrade then
                    p_MensErro := g$_nls.get('X','SQL','Grade not valid in History');
                    return;
                end if;
                */
                /* 8.7 [MCLA:002.1.2] */
                if f_isLetter(vGradeAH) then
                    vGradeAH := '0';
                end if;

                if vGradeAH < vMinGrade then
                    p_MensErro := g$_nls.get('X','SQL','Grade below lower limit');
                    return;
                end if;

                /* 8.7 [MCLA:002.1.1] 
                if f_isLetter(vGradeAH) then
                    vGradeAH := '0';
                end if;  */
                
                if vGradeAH >= p_ApprovedGrade then
                    p_MensErro := g$_nls.get('X','SQL','Grade higher than upper limit');
                    return;
                end if;


                -- check maximum grade
                vMaxGrade := f_get_AH_rule(vLevlCode || '_' || vExtraExam || '%',
                                           gAHReasonMaxGrde,
                                           1);

                -- check grade code
                vDummy := null;
                open check_grade_c(vMaxGrade,
                                    p_term_code
                                    );
                fetch check_grade_c into vDummy;
                if check_grade_c%notfound then
                    close check_grade_c;
                    p_MensErro := g$_nls.get('X','SQL','Grade code %01% not found.', vMaxGrade);
                    return;
                end if;
                close check_grade_c;

                if p_grade_upd > vMaxGrade then
                    p_grade_upd := vMaxGrade;
                end if;

                p_MensErro := g$_nls.get('X','SQL','History validated', vMaxGrade);
                return;


           end if;   -- ****************** check rules for extraordinary examination



            -- ****************** check rules for last course
            if p_CheckReason = vLastCourse then
                -- get grade code that identifies DA
                vDAGrade := f_get_AH_rule(vLevlCode || '_' || vLastCourse || '%',
                                          gAHReasonDAGrade,
                                          1);
                /*IF p_grade_upd = vDAGrade then*/

                    -- get max amount allowed of DA in AH
                    vDAMax := nvl(to_number(f_get_AH_rule(vLevlCode || '_' || vLastCourse || '%',
                                                      gAHReasonDAMax,
                                                      2)),0);

                    -- count the number of grades DA in the AH
                    vCount := f_count_grade_AH(vPidm,
                                               p_crn,
                                               p_term_code,
                                               vDAGrade);

                    -- verify if amount is greater than allowed
                    if vCount > vDAMax then
                        p_MensErro := g$_nls.get('X', 'SQL','It was exceeded the limit of DA grade');
                        return;
                    end if;

                    -- check DA in SZRGCHG
                    vCountGCHG := f_count_grade_szrgchg(p_id,
                                                        p_term_code,
                                                        vDAGrade,
                                                        p_Crn,
                                                        p_FileName
                                                        );
                    if vCountGCHG + vCount > vDAMax then
                        p_MensErro := g$_nls.get('X', 'SQL','It was exceeded the limit of DA grade');
                        return;
                    end if;
                /*end if;*/

                -- get grade code that identifies SD
                vSDGrade := f_get_AH_rule(vLevlCode || '_' || vLastCourse || '%',
                                          gAHReasonExclGrade,
                                          2);

                vCount := f_count_grade_AH(vPidm,
                                           p_crn,
                                           p_term_code,
                                           vSDGrade);

                -- verify if it was found any occurrence of SD grade on AH
                if vCount > 0 then
                    p_MensErro := g$_nls.get('X', 'SQL','%01% found on AH',vSDGrade);
                    return;
                end if;

                -- check SD in SZRGCHG
                vCountGCHG := f_count_grade_szrgchg(p_id,
                                                    p_term_code,
                                                    vSDGrade,
                                                    p_Crn,
                                                    p_FileName
                                                    );
                if vCountGCHG > 0 then
                    p_MensErro := g$_nls.get('X', 'SQL','%01% found on SZRGCHG',vSDGrade);
                    return;
                end if;

                -- get grade code that identifies NP
                vNPGrade := f_get_AH_rule(vLevlCode || '_' || vLastCourse || '%',
                                          gAHReasonExclGrade,
                                          3);

                vCount := f_count_grade_AH(vPidm,
                                           p_crn,
                                           p_term_code,
                                           vNPGrade);

                -- verify if it was found any occurrence of NP grade on AH
                if vCount > 0 then
                    p_MensErro := g$_nls.get('X', 'SQL','%01% found on AH', vNPGrade);
                    return;
                end if;

                -- check NP in SZRGCHG
                vCountGCHG := f_count_grade_szrgchg(p_id,
                                                    p_term_code,
                                                    vNPGrade,
                                                    p_Crn,
                                                    p_FileName
                                                    );
                if vCountGCHG > 0 then
                    p_MensErro := g$_nls.get('X', 'SQL','%01% found on SZRGCHG',vNPGrade);
                    return;
                end if;

                p_MensErro := g$_nls.get('X', 'SQL','History validated');
                return;

            end if;  -- ****************** check rules for last course


        end if;

    end p_check_parameters;


    procedure p_load_file(p_id                   varchar2,
                          p_term_code            varchar2,
                          p_course               varchar2,
                          p_grade                varchar2,
                          p_crn                  varchar2,
                          p_grade_comm           varchar2,
                          p_file_name            varchar2,
                          p_process              varchar2,
                          p_change_reason        varchar2 default null,
                          p_ApprovedGrade        varchar2 default null,
                          p_CheckReason          varchar2 default null
                         ) is

        vMensErro           varchar2(200);
        vMessage            varchar2(200);
        vGradeOri           SFRSTCR.SFRSTCR_GRDE_CODE%type;
        vGradeUpdate        SFRSTCR.SFRSTCR_GRDE_CODE%type;
    begin
        vMensErro := null;
        vGradeOri := null;
        vGradeUpdate := p_grade;
        vMessage := null;

        p_check_parameters(p_id,
                           p_term_code,
                           p_course,
                           p_crn,
                           p_grade_comm,
                           p_process,
                           p_change_reason,
                           p_ApprovedGrade,
                           p_CheckReason,
                           p_file_name,
                           vGradeOri,
                           vGradeUpdate,
                           vMessage
                           );


        p_save_szrgchg(p_id,
                       p_term_code,
                       p_crn,
                       vGradeOri,
                       vGradeUpdate,
                       p_file_name,
                       p_grade_comm,
                       p_change_reason,
                       vMessage,
                       vMensErro
                       );

    end p_load_file;


    procedure p_process_registered(pFileName        varchar2) is

        vMessage                SZRGCHG.SZRGCHG_MESSAGE%type := g$_nls.get('X','SQL','RECORD%VALIDATED%');
        vPidm                   number;
        vletter                 SZRGCHG.SZRGCHG_GCMT_CODE%type;
        
       -- BA  8.7 [MCLA:002.1.3]
        CURSOR GET_GCMT_CODE(var_letter  SZRGCHG.SZRGCHG_GCMT_CODE%type) IS
        SELECT STVGCMT_CODE
          FROM STVGCMT
         WHERE STVGCMT_CODE LIKE '%' || var_letter || '%';
       -- EA  8.7 [MCLA:002.1.3]         
    begin
        for r in get_message_c(pFileName, vMessage) loop
            vPidm := gb_common.f_get_pidm(r.SZRGCHG_ID); /*BIEN*/
            
            -- BA  8.7 [MCLA:002.1.3]
            OPEN GET_GCMT_CODE(r.SZRGCHG_GCMT_CODE);
            FETCH GET_GCMT_CODE INTO vletter;
            CLOSE GET_GCMT_CODE;
            -- EA  8.7 [MCLA:002.1.3]
            
            -- update grade and grade comment code on SFRSTCR
            update sfrstcr cr /*BIEN*/
               set CR.SFRSTCR_GRDE_CODE_MID = r.SZRGCHG_GRDE_CODE_UPDATE,
                   CR.SFRSTCR_GCMT_CODE = vletter, -- BA  8.7 [MCLA:002.1.3]
                   CR.SFRSTCR_ACTIVITY_DATE = SYSDATE,
                   CR.SFRSTCR_USER = user
             where CR.SFRSTCR_CRN = r.SZRGCHG_CRN
               and CR.SFRSTCR_TERM_CODE = r.SZRGCHG_TERM_CODE
               and CR.SFRSTCR_PIDM = vPidm
               and (NVL(cr.SFRSTCR_ERROR_FLAG,'N') <> 'F')
               AND (CR.SFRSTCR_ERROR_FLAG not in ('F','D')
                    or CR.SFRSTCR_ERROR_FLAG is null
                    or CR.SFRSTCR_RSTS_CODE in (select stvrsts_code
                                               from stvrsts
                                              where stvrsts_code = CR.SFRSTCR_RSTS_CODE
                                                and stvrsts_gradable_ind = 'Y'));

            -- update message with 'Reco rd loaded' status
            update SZRGCHG ch /*BIEN*/
               set CH.SZRGCHG_MESSAGE = g$_nls.get('X','SQL','RECORD LOADED'),
                   CH.SZRGCHG_ACTIVITY_DATE = SYSDATE,
                   CH.SZRGCHG_USER_ID = USER
             WHERE CH.SZRGCHG_CRN = R.SZRGCHG_CRN
               AND CH.SZRGCHG_TERM_CODE = R.SZRGCHG_TERM_CODE
               AND CH.SZRGCHG_ID = R.SZRGCHG_ID
               AND CH.SZRGCHG_GRDE_CODE_ORIGINAL = R.SZRGCHG_GRDE_CODE_ORIGINAL
               and CH.SZRGCHG_SEQNO = r.SZRGCHG_SEQNO;

        end loop;

    end p_process_registered;


    procedure p_process_AH(pFileName                varchar2,
                           p_approved_grade         varchar2) is

      cursor get_shatckn_seq_c(cPidm          number,
                                 cTermCode      STVTERM.STVTERM_CODE%type,
                                 cCrn           SSBSECT.SSBSECT_CRN%type
                                ) is
        select KN.SHRTCKN_SEQ_NO
          from shrtckn kn
         where KN.SHRTCKN_PIDM = cPidm
           and KN.SHRTCKN_TERM_CODE = cTermCode
           and KN.SHRTCKN_CRN = cCrn;

      cursor get_shrtckg_next_seqno_c(cPidm             number,
                                      cTermCode         STVTERM.STVTERM_CODE%type,
                                      cSeqno            number
                                     ) is
        select nvl(max(KG.SHRTCKG_SEQ_NO),0) + 1
          from shrtckg kg
         where KG.SHRTCKG_TCKN_SEQ_NO = cSeqno
           and KG.SHRTCKG_PIDM = cPidm
           and KG.SHRTCKG_TERM_CODE = cTermCode;

      cursor get_gmod_code(cGradeCode       shrgrdo.shrgrdo_grde_code%type,
                           cLevelCode       shrgrdo.shrgrdo_levl_code%type,
                           cTermCode        shrgrdo.shrgrdo_term_code_effective%type
                           )is
        select DO.SHRGRDO_GMOD_CODE
          from shrgrdo do
         where do.shrgrdo_grde_code = cGradeCode
           and do.shrgrdo_levl_code = cLevelCode
           and do.shrgrdo_term_code_effective in (select x.SHRGRDO_TERM_CODE_EFFECTIVE
                                                 from shrgrdo x
                                                where X.SHRGRDO_GRDE_CODE = do.shrgrdo_grde_code
                                                  and X.SHRGRDO_LEVL_CODE = do.shrgrdo_levl_code
                                                  and X.SHRGRDO_TERM_CODE_EFFECTIVE <= cTermCode);

      cursor get_level_c(cPidm             number,
                         cTermCode         STVTERM.STVTERM_CODE%type,
                         cTcknSeqno        number
                         )is
        select KL.SHRTCKL_LEVL_CODE
          from SHRTCKL kl
         where KL.SHRTCKL_PIDM = cPidm
           and KL.SHRTCKL_TERM_CODE = cTermCode
           and KL.SHRTCKL_TCKN_SEQ_NO = cTcknSeqno
           and KL.SHRTCKL_PRIMARY_LEVL_IND = 'Y';

    cursor get_shtckg_attr_c(cPidm             number,
                             cTermCode         STVTERM.STVTERM_CODE%type,
                             cTcknSeqno        number
                             ) is
        SELECT SHRTCKG_GRDE_CODE_FINAL, SHRTCKG_HOURS_ATTEMPTED,
               SHRTCKG_CREDIT_HOURS
          FROM  SHRTCKG
         WHERE  SHRTCKG_PIDM = cPidm
           AND  SHRTCKG_TERM_CODE = cTermCode
           AND  SHRTCKG_TCKN_SEQ_NO = cTcknSeqno
           AND  SHRTCKG_SEQ_NO =  (
               SELECT MAX(SHRTCKG_SEQ_NO)
               FROM   SHRTCKG
               WHERE  SHRTCKG_PIDM = cPidm
                 AND  SHRTCKG_TERM_CODE = cTermCode
                 AND  SHRTCKG_TCKN_SEQ_NO = cTcknSeqno)  ;

        vMessage                SZRGCHG.SZRGCHG_MESSAGE%type := g$_nls.get('X','SQL','HISTORY%VALIDATED%');
        vPidm                   number;
        vTCKNSeqno              number;
        vTCKGNext               number;
        vGmodCode               SHRGRDO.SHRGRDO_GMOD_CODE%TYPE;
        vLevlCode               STVLEVL.STVLEVL_CODE%type;
        vCredHours              SCBCRSE.SCBCRSE_CREDIT_HR_LOW%type;
        vHourAtt                SHRTCKG.SHRTCKG_HOURS_ATTEMPTED%type;
        vGradeAH                    SHRTCKG.SHRTCKG_GRDE_CODE_FINAL%type;
    begin
        for r in get_message_c(pFileName, vMessage) loop
            vPidm := gb_common.f_get_pidm(r.SZRGCHG_ID); /*BIEN*/

            vTCKNSeqno := null;

            open get_shatckn_seq_c(vPidm, r.SZRGCHG_TERM_CODE, r.SZRGCHG_CRN);
            fetch get_shatckn_seq_c into vTCKNSeqno;
            close get_shatckn_seq_c;

            if vTCKNSeqno is not null then
                vTCKGNext := null;

                -- get next sequence number of SHRTCKG
                open get_shrtckg_next_seqno_c(vPidm, r.SZRGCHG_TERM_CODE, vTCKNSeqno);
                fetch get_shrtckg_next_seqno_c into vTCKGNext;
                close get_shrtckg_next_seqno_c;

                -- get level code
                vLevlCode := null;

                open get_level_c(vPidm, r.SZRGCHG_TERM_CODE, vTCKNSeqno);
                fetch get_level_c into vLevlCode;
                close get_level_c;

                -- get gmod_code
                vGmodCode := null;

                open get_gmod_code(r.SZRGCHG_GRDE_CODE_UPDATE, vLevlCode, r.SZRGCHG_TERM_CODE);
                fetch get_gmod_code into vGmodCode;
                close get_gmod_code;

                -- get SHRTCKG's attribute
                vGradeAH := null;
                vHourAtt := null;
                vCredHours := null;

                open get_shtckg_attr_c(vPidm, r.SZRGCHG_TERM_CODE, vTCKNSeqno);
                fetch get_shtckg_attr_c into vGradeAH, vHourAtt, vCredHours;
                close get_shtckg_attr_c;

                if vCredHours is null then
                    -- get credit hours
                    vCredHours := f_get_cred_hours(vPidm,
                                                   r.SZRGCHG_CRN,
                                                   r.SZRGCHG_TERM_CODE
                                                    );
                    vHourAtt := nvl(vHourAtt, vCredHours);
                END if;

                insert into shrtckg(SHRTCKG_PIDM, SHRTCKG_TERM_CODE, SHRTCKG_TCKN_SEQ_NO, SHRTCKG_SEQ_NO, /*BIEN*/
                                    SHRTCKG_GRDE_CODE_FINAL, SHRTCKG_GMOD_CODE,
                                    SHRTCKG_CREDIT_HOURS, SHRTCKG_GCHG_CODE,
                                    SHRTCKG_GCMT_CODE, SHRTCKG_HOURS_ATTEMPTED,
                                    SHRTCKG_FINAL_GRDE_CHG_DATE, SHRTCKG_FINAL_GRDE_CHG_USER,
                                    SHRTCKG_ACTIVITY_DATE, SHRTCKG_DATA_ORIGIN,
                                    SHRTCKG_USER_ID)
                            values (vPidm, r.SZRGCHG_TERM_CODE, vTCKNSeqno, vTCKGNext,
                                    r.SZRGCHG_GRDE_CODE_UPDATE, vGmodCode,
                                    vCredHours, r.SZRGCHG_GCHG_CODE,
                                    r.SZRGCHG_GCMT_CODE, vHourAtt,
                                    sysdate, user,
                                    sysdate, 'SZPGCHG',
                                    user
                                    );

                -- update message with 'History loaded' status
                update SZRGCHG ch /*BIEN*/
                   set CH.SZRGCHG_MESSAGE = g$_nls.get('X','SQL','HISTORY LOADED'),
                       CH.SZRGCHG_ACTIVITY_DATE = SYSDATE,
                       CH.SZRGCHG_USER_ID = USER
                 WHERE CH.SZRGCHG_CRN = R.SZRGCHG_CRN
                   AND CH.SZRGCHG_TERM_CODE = R.SZRGCHG_TERM_CODE
                   AND CH.SZRGCHG_ID = R.SZRGCHG_ID
                   AND CH.SZRGCHG_GRDE_CODE_ORIGINAL = R.SZRGCHG_GRDE_CODE_ORIGINAL
                   and CH.SZRGCHG_SEQNO = r.SZRGCHG_SEQNO;


            end if;

        end loop;

    end p_process_AH;



    /*
     *************************************************************************

                        Public procedures/functions

     *************************************************************************
    */


    /*
     *************************************************************************

        p_process_file: get parameters of the process and call the routine to save
                        or to process

        p_id:               student's ID
        p_term_code:        term code
        p_course:           subject code concatenated with course number
        p_grade:            grade code (SHAGRDE)
        p_crn:              crn (ssbsect_crn)
        p_grade_comm:       grade comment code (STVGCMT_CODE)
        p_file_name:        file name
        p_process:          process type: H or R
        p_change_reason:    change reason code (STVGCHG_CODE)
        p_ApprovedGrade:    parameter to validate grade on AH be lower than this value
        p_CheckReason:      parameter to validated rules for AH.

     *************************************************************************
    */

    procedure p_process_file(p_id                   varchar2,
                             p_term_code            varchar2,
                             p_course               varchar2,
                             p_grade                varchar2,
                             p_crn                  varchar2,
                             p_grade_comm           varchar2,
                             p_run_mode             varchar2,
                             p_process              varchar2,
                             p_filename             varchar2,
                             p_change_reason        varchar2 default null,
                             p_approved_grade       varchar2 default null,
                             p_CheckReason          varchar2 default null
                            ) is

        vChangeReason           STVGCHG.STVGCHG_CODE%type;
    begin


        if p_run_mode not in (gModeValidate,gModeManual) or
           p_process not in (gProcessAH, gProcessRe) then
            return;
        end if;

        if p_id is null or
            p_term_code is null or
            p_course is null or
            p_grade is null or
            p_crn is null or
            p_filename is null or
            (p_process = gProcessAH and
               (p_CheckReason is null or
                p_approved_grade is null))
                  then

            return;

        end if;

        vChangeReason := REGEXP_replace(p_change_reason,'[[:space:]]');

        if p_run_mode = gModeValidate then


            p_load_file(p_id,
                        p_term_code,
                        p_course,
                        p_grade,
                        p_crn,
                        p_grade_comm,
                        p_filename,
                        p_process,
                        vChangeReason,
                        p_approved_grade,
                        p_CheckReason);

        else
            if p_process = gProcessRe then
                p_process_registered(p_filename);
            else
                p_process_AH(p_filename, p_approved_grade);
            end if;

        end if;

    end p_process_file;


    procedure p_delete_szrgchg(p_FileName   varchar2,
                               p_RunMode    varchar2) is
        vLoad           varchar2(10);
        vValidate       varchar2(10);
    begin
        if p_RunMode = gModeValidate then
            vLoad := g$_nls.get('X','SQL','LOAD');
            vValidate := g$_nls.get('X','SQL','VALIDATE');

            delete szrgchg zr
             where (instr(upper(ZR.SZRGCHG_MESSAGE), vLoad) = 0 and
                        instr(upper(ZR.SZRGCHG_MESSAGE), vValidate) = 0);
        end if;

    end p_delete_szrgchg;


END SZKGCHG;
/

SHOW ERRORS
SET DEFINE ON
