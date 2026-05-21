/******************************************************************************/
/* szksec1.sql Copyright 2015 Ellucian Company L.P. and its affiliates.       */
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
/* FILE NAME..: szksec1.sql                                                   */
/*                                                                            */
/* RELEASE....: 8.7 [MCLA:002.1.0]                                            */
/*                                                                            */
/* OBJECT NAME: szksecg                                                       */
/*                                                                            */
/* These procedures prepare an email to be send to students when their grades */
/* are changed by the professor. The body of the email is based on            */
/* configurations in the SOALETR forms.                                       */
/*                                                                            */
/******************************************************************************/
/*                                                                            */
/* AUDIT TRAIL: 8.7 [MCLA:002.1.0]                                            */
/* --------------------------------------------------------  ---  ----------- */
/* 1. Initial Code                                           MKU  Nov/30/2015 */
/*                                                                            */
/*  MOD002- Mejora a la asistencia, HA                                        */
/*  This package send email to notify student about changing on their grades. */
/*                                                                            */
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
/*  This package send email to notify student about changing on their grades. */
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

create or replace PACKAGE BODY SZKSECG
IS
-- FILE NAME..: szksec1.sql
-- RELEASE....: 8.7 [MCLA:002.1.0]
-- OBJECT NAME: szksecg
-- PRODUCT....: STU
-- USAGE......: To prepare and send email to students.
-- COPYRIGHT..: Copyright 2015 Ellucian Company L.P. and its affiliates.
--
-- DESCRIPTION:
-- These procedures prepare an email to be send to students when their grades
-- are changed by the professor. The body of the email is based on
-- configurations in the SOAELTR forms.
--
--
    cursor get_gtvsdax_comment_c(cInternal       GTVSDAX.GTVSDAX_INTERNAL_CODE%type,
                                 cGrupo          GTVSDAX.GTVSDAX_INTERNAL_CODE_GROUP%type) is
        select GT.GTVSDAX_COMMENTS
          from gtvsdax gt
         where gt.GTVSDAX_INTERNAL_CODE_GROUP = cGrupo
           and GT.GTVSDAX_INTERNAL_CODE = cInternal;

    cursor get_gtvsdax_att_c(cInternal       GTVSDAX.GTVSDAX_INTERNAL_CODE%type,
                             cGrupo         GTVSDAX.GTVSDAX_INTERNAL_CODE_GROUP%type) is
        select GT.GTVSDAX_TRANSLATION_CODE
          from gtvsdax gt
         where gt.GTVSDAX_INTERNAL_CODE_GROUP = cGrupo
           and GT.GTVSDAX_INTERNAL_CODE = cInternal;

    cursor get_email_c(cPidm            number,
                       cEmailCode       GOREMAL.GOREMAL_EMAL_CODE%type
                        ) is
        select GE.GOREMAL_EMAIL_ADDRESS
          from GOREMAL ge
         where GE.GOREMAL_PIDM = cPidm
           and GE.GOREMAL_EMAL_CODE = cEmailCode
           and GE.GOREMAL_STATUS_IND = 'A'
         ORDER BY goremal_preferred_ind DESC;


    crlf VARCHAR2( 2 ):= CHR( 13 ) || CHR( 10 );

     function f_get_term_desc(p_term_code         SCBCRSE.SCBCRSE_EFF_TERM%type,
                             p_crse_num          SCBCRSE.SCBCRSE_CRSE_NUMB%type
                              ) return varchar2 is


        cursor get_term_desc_c is
            select trim(ST.STVTERM_DESC ||
                    decode(SB.SSBSECT_PTRM_CODE,'1',null, ' ' || PT.STVPTRM_DESC))
                  from ssbsect sb, stvterm st, stvptrm pt
                 where SB.SSBSECT_TERM_CODE = ST.STVTERM_CODE
                   and SB.SSBSECT_PTRM_CODE = PT.STVPTRM_CODE
                   and SB.SSBSECT_CRN = p_crse_num
                   and SB.SSBSECT_TERM_CODE = p_term_code;

        vTermDesc           varchar2(100);

    begin
        vTermDesc := null;

        open get_term_desc_c;
        fetch get_term_desc_c into vTermDesc;
        close get_term_desc_c;

        return vTermDesc;
    end f_get_term_desc;


    -- this function returns a string with a long/short description of the course
    function f_get_course_title(p_term_code         SCBCRSE.SCBCRSE_EFF_TERM%type,
                                p_crn               SSBSECT.SSBSECT_CRN%type
                                 ) return SCRSYLN.SCRSYLN_LONG_COURSE_TITLE%type is

        cursor get_subject_code_c is
            select SB.SSBSECT_SUBJ_CODE, sb.SSBSECT_CRSE_NUMB
              from ssbsect sb
             where SB.SSBSECT_CRN = p_crn
               and SB.SSBSECT_TERM_CODE = p_term_code;

        cursor get_long_title_c(cSubjCode    varchar2,
                                cCrseNum     SSBSECT.SSBSECT_CRSE_NUMB%type) is
            select SY.SCRSYLN_LONG_COURSE_TITLE
              from SCRSYLN sy
             where SY.SCRSYLN_SUBJ_CODE = cSubjCode
               and SY.SCRSYLN_CRSE_NUMB = cCrseNum
               and SY.SCRSYLN_TERM_CODE_EFF =
                    (select (X.SCRSYLN_TERM_CODE_EFF)
                        from SCRSYLN x
                       where X.SCRSYLN_SUBJ_CODE = sy.SCRSYLN_SUBJ_CODE
                         and X.SCRSYLN_CRSE_NUMB = SY.SCRSYLN_CRSE_NUMB
                         and X.SCRSYLN_TERM_CODE_EFF = p_term_code);

        cursor get_short_title_c(cSubjCode    varchar2,
                                 cCrseNum     SSBSECT.SSBSECT_CRSE_NUMB%type) is
            select CR.SCBCRSE_TITLE
              from scbcrse cr
             where CR.SCBCRSE_SUBJ_CODE = cSubjCode
               and CR.SCBCRSE_CRSE_NUMB = cCrseNum
               and CR.SCBCRSE_EFF_TERM = (SELECT max(X.SCBCRSE_EFF_TERM)
                                          FROM scbcrse x
                                         WHERE X.SCBCRSE_CRSE_NUMB = CR.SCBCRSE_CRSE_NUMB
                                           AND X.SCBCRSE_SUBJ_CODE = CR.SCBCRSE_SUBJ_CODE
                                           AND X.SCBCRSE_EFF_TERM <= p_term_code);

        vReturn         SCRSYLN.SCRSYLN_LONG_COURSE_TITLE%type;
        vSubjCode       STVSUBJ.STVSUBJ_CODE%type;
        vCrseNum        SSBSECT.SSBSECT_CRSE_NUMB%type;

    begin
        vReturn := null;
        vSubjCode := null;
        vCrseNum := null;

        open get_subject_code_c;
        fetch get_subject_code_c into vSubjCode, vCrseNum;
        close get_subject_code_c;

        open get_long_title_c(vSubjCode, vCrseNum);
        fetch get_long_title_c into vReturn;
        close get_long_title_c;

        if vReturn is null then
            open get_short_title_c(vSubjCode, vCrseNum);
            fetch get_short_title_c into vReturn;
            close get_short_title_c;
        end if;

        return vReturn;

    end f_get_course_title;


    function f_replace_text(p_text      varchar2,
                            p_pidm             number,
                            p_term_code        varchar2,
                            p_crn              varchar2,
                            p_gcom_id          varchar2,
                            p_grde_new         varchar2,
                             p_grde_old         varchar2
                            ) return varchar2 is
                            
       CURSOR C_GET_GCOM_ACT(P_TERM_CODE STVTERM.STVTERM_CODE%TYPE, P_CRN SSBSECT.SSBSECT_CRN%TYPE, P_GCOM_CODE SHRGCOM.SHRGCOM_ID%TYPE) IS
            select (SHRGCOM_NAME || ' ' || SHRGCOM_DESCRIPTION) AS GCOM_NAME
                from shrgcom 
                where SHRGCOM_TERM_CODE = P_TERM_CODE 
                and SHRGCOM_CRN = P_CRN and shrgcom_id = P_GCOM_CODE;
        
        CURSOR C_GET_FAC_PIDM(P_TERM_CODE STVTERM.STVTERM_CODE%TYPE, P_CRN SSBSECT.SSBSECT_CRN%TYPE) IS
            SELECT SIRASGN_PIDM 
                FROM SIRASGN
                WHERE SIRASGN_TERM_CODE = P_TERM_CODE
                AND SIRASGN_CRN = P_CRN
                AND SIRASGN_PRIMARY_IND = 'Y';
        
        CURSOR C_GET_FULL_NAME(P_PIDM SPRIDEN.SPRIDEN_PIDM%TYPE) IS
            SELECT (SPRIDEN_FIRST_NAME || ' ' || SPRIDEN_LAST_NAME) AS FULL_NAME
                FROM SPRIDEN WHERE SPRIDEN_PIDM = P_PIDM
                AND SPRIDEN_CHANGE_IND IS NULL;
                
        CURSOR C_GET_STU_ID(P_PIDM SPRIDEN.SPRIDEN_PIDM%TYPE) IS
            SELECT SPRIDEN_ID
                FROM SPRIDEN WHERE SPRIDEN_PIDM = P_PIDM
                AND SPRIDEN_CHANGE_IND IS NULL;
        
        CURSOR C_GET_SYLN_CRSE_TITLE(P_TERM_CODE STVTERM.STVTERM_CODE%TYPE, P_CRN SSBSECT.SSBSECT_CRN%TYPE) IS
            SELECT SCRSYLN_LONG_COURSE_TITLE FROM SCRSYLN, SSBSECT
                WHERE SSBSECT_TERM_CODE = P_TERM_CODE
                AND SSBSECT_CRN = P_CRN
                AND SCRSYLN_SUBJ_CODE = SSBSECT_SUBJ_CODE
                AND SCRSYLN_CRSE_NUMB = SSBSECT_CRSE_NUMB
                AND SCRSYLN_TERM_CODE_EFF = (
                    SELECT MAX(SCRSYLN_TERM_CODE_EFF) FROM SCRSYLN
                        WHERE SCRSYLN_SUBJ_CODE = SSBSECT_SUBJ_CODE
                        AND SCRSYLN_CRSE_NUMB = SSBSECT_CRSE_NUMB
                        AND SCRSYLN_TERM_CODE_EFF <= SSBSECT_TERM_CODE
                );
        
        CURSOR C_GET_SCB_CRSE_TITLE(P_TERM_CODE STVTERM.STVTERM_CODE%TYPE, P_CRN SSBSECT.SSBSECT_CRN%TYPE) IS
            SELECT SCBCRSE_TITLE FROM SCBCRSE, SSBSECT
                WHERE SSBSECT_TERM_CODE = P_TERM_CODE
                AND SSBSECT_CRN = P_CRN
                AND SCBCRSE_SUBJ_CODE = SSBSECT_SUBJ_CODE
                AND SCBCRSE_CRSE_NUMB = SSBSECT_CRSE_NUMB
                AND SCBCRSE_EFF_TERM = (
                    SELECT MAX(SCBCRSE_EFF_TERM) FROM SCBCRSE
                        WHERE SCBCRSE_SUBJ_CODE = SSBSECT_SUBJ_CODE
                        AND SCBCRSE_CRSE_NUMB = SSBSECT_CRSE_NUMB
                        AND SCBCRSE_EFF_TERM <= SSBSECT_TERM_CODE
                );
        
        CURSOR C_GET_TERM_DESC(P_TERM_CODE STVTERM.STVTERM_CODE%TYPE, P_CRN SSBSECT.SSBSECT_CRN%TYPE)IS
            SELECT STVTERM_DESC || 
               (CASE 
                    WHEN STVPTRM_CODE != '1' THEN ', ' || STVPTRM_DESC
                    ELSE ''
                END) AS TERM_PTRM
            FROM STVTERM
            JOIN SSBSECT ON STVTERM_CODE = SSBSECT_TERM_CODE
            JOIN STVPTRM ON STVPTRM_CODE = SSBSECT_PTRM_CODE
            WHERE SSBSECT_TERM_CODE = P_TERM_CODE
            AND SSBSECT_CRN = P_CRN;

        vGcomDesc               shrgcom.SHRGCOM_DESCRIPTION%type;
        vStuName                varchar2(200);
        vStuID                  SPRIDEN.SPRIDEN_ID%type;
        vProfName               varchar2(200);
        vCourseTitle            SCRSYLN.SCRSYLN_LONG_COURSE_TITLE%type;
        vTermDesc               varchar2(40);
        vDateStr                varchar2(40);


        vTextMsg    long;
        vCurr       number;
        vPos        number;
        vDummy      varchar2(400);
        vParam      number;

        lv_gcom_id          VARCHAR2(100);
        lv_original_calif   SHRMRKS.SHRMRKS_GRDE_CODE%TYPE;
        lv_new_calif        SHRMRKS.SHRMRKS_GRDE_CODE%TYPE;
        lv_student_name     varchar2(100);
        lv_student_id       VARCHAR2(9);
        lv_fac_pidm         SPRIDEN.SPRIDEN_PIDM%TYPE;
        lv_fac_name         VARCHAR2(100);
        lv_nrc              SSBSECT.SSBSECT_CRN%TYPE;
        lv_crse_title       SCBCRSE.SCBCRSE_TITLE%TYPE;
        lv_term_desc        VARCHAR2(50);
        lv_curr_date        DATE;

    begin
        vTextMsg := null;
        vCurr := 1;

        vGcomDesc := null;
        vStuID := null;
        vProfName := null;
        vTermDesc := null;
        vDateStr := NULL;

        if trim(p_text) is null then
            return null;
        end if;


        vTextMsg := p_text;
        
        --BA MHI [MCLA:002.2.1] 13/03/2025 Code for email body build
        
        OPEN C_GET_GCOM_ACT(p_term_code, p_crn,p_gcom_id);
        FETCH C_GET_GCOM_ACT INTO lv_gcom_id;
        CLOSE C_GET_GCOM_ACT;
        
        lv_original_calif := p_grde_old;
        lv_new_calif := p_grde_new;
        
        OPEN C_GET_FULL_NAME(p_pidm);
        FETCH C_GET_FULL_NAME INTO lv_student_name;
        CLOSE C_GET_FULL_NAME;
        
        OPEN C_GET_STU_ID(p_pidm);
        FETCH C_GET_STU_ID INTO lv_student_id;
        CLOSE C_GET_STU_ID;
        
        OPEN C_GET_FAC_PIDM(p_term_code, p_crn);
        FETCH C_GET_FAC_PIDM INTO lv_fac_pidm;
        CLOSE C_GET_FAC_PIDM;
        
        OPEN C_GET_FULL_NAME(lv_fac_pidm);
        FETCH C_GET_FULL_NAME INTO lv_fac_name;
        CLOSE C_GET_FULL_NAME;
        
        lv_nrc := p_crn;
        
        OPEN C_GET_SYLN_CRSE_TITLE(p_term_code, p_crn);
        IF(C_GET_SYLN_CRSE_TITLE%NOTFOUND) THEN
            OPEN C_GET_SCB_CRSE_TITLE(p_term_code, p_crn);
            FETCH C_GET_SCB_CRSE_TITLE INTO lv_crse_title;
            CLOSE C_GET_SCB_CRSE_TITLE;
        END IF;
        FETCH C_GET_SYLN_CRSE_TITLE INTO lv_crse_title;
        CLOSE C_GET_SYLN_CRSE_TITLE;
        
        OPEN C_GET_TERM_DESC(p_term_code, p_crn);
        FETCH C_GET_TERM_DESC INTO lv_term_desc;
        CLOSE C_GET_TERM_DESC;
        
        lv_curr_date := SYSDATE;  
            

        vPos := REGEXP_INSTR(p_text, '%',1,vCurr);
        
        
        while vPos > 0 loop

            vDummy := REGEXP_substr(p_text, '[[:digit:]]{1,2}',vPos);
            
            

            vParam := to_number(nvl(vDummy,0));


            if vParam = 1 then

                -- %1: new or updating activity. Get description from SHRGCOM.
                vTextMsg := REGEXP_REPLACE(vTextMsg,
                                           '%' || trim(to_char(vParam)),
                                           lv_gcom_id);

            elsif vParam = 2 then
                vTextMsg := REGEXP_REPLACE(vTextMsg,
                                           '%' || trim(to_char(vParam)),
                                           nvl(trim(p_grde_old),g$_nls.get('X','SQL','Ninguna')));

            elsif vParam = 3 then
                vTextMsg := REGEXP_REPLACE(vTextMsg,
                                           '%' || trim(to_char(vParam)),
                                           nvl(trim(p_grde_new),g$_nls.get('X','SQL','Ninguna')));


            elsif vParam = 4 then
                -- %4: student's name
                vStuName := f_format_name(p_pidm, 'FML' );
                vTextMsg := REGEXP_REPLACE(vTextMsg,
                           '%' || trim(to_char(vParam)),
                           lv_student_name);

            elsif vParam = 5 then
                -- %5: Student's ID
                vStuID := substr(gb_common.f_get_id(p_pidm),2);
                vTextMsg := REGEXP_REPLACE(vTextMsg,
                           '%' || trim(to_char(vParam)),
                           lv_student_id);

            elsif vParam = 6 then
                -- %6: professor's name

                vTextMsg := REGEXP_REPLACE(vTextMsg,
                           '%' || trim(to_char(vParam)),
                           nvl(lv_fac_name,g$_nls.get('X','SQL','Not Assigned')));

             elsif vParam = 7 then
                vTextMsg := REGEXP_REPLACE(vTextMsg,
                           '%' || trim(to_char(vParam)),
                           p_crn);

             elsif vParam = 8 then
                -- %8: Couse title

                vTextMsg := REGEXP_REPLACE(vTextMsg,
                           '%' || trim(to_char(vParam)),
                           lv_crse_title);

             elsif vParam = 9 then
                -- %9: Term's description
                vTermDesc := f_get_term_desc(p_term_code, p_crn);
                vTextMsg := REGEXP_REPLACE(vTextMsg,
                           '%' || trim(to_char(vParam)),
                           vTermDesc);

             elsif vParam = 10 then
                -- %10 system date
                vDateStr := TRIM(to_char(SYSDATE, G$_DATE.GET_NLS_DATE_FORMAT));
                vTextMsg := REGEXP_REPLACE(vTextMsg,
                           '%' || trim(to_char(vParam)),
                           vDateStr);

                else
                    vTextMsg := vTextMsg;
            end if;

            vCurr := vCurr + 1;

            vPos := REGEXP_INSTR(p_text, '%',1,vCurr);

        end loop;
        return vTextMsg;
    end f_replace_text;


    -- based on the configuration in SOAELTR forms, it builds the email body
    PROCEDURE p_PrepareBody(p_pidm             number,
                             p_term_code        varchar2,
                             p_crn              varchar2,
                             p_gcom_id          varchar2,
                             p_seqno            number,
                             p_grde_new         varchar2,
                             p_grde_old         varchar2,
                             p_letter_code      varchar2,
                             p_EmailBody    out clob,
                             p_ErrMsg       out varchar2) is


        CURSOR soreltr_c (c_letter_code soreltl.soreltl_letr_code%TYPE) IS
             SELECT soreltr_text_var ,
                    soreltr_column_id,
                    UPPER(soreltr_format_var) soreltr_format_var
               FROM soreltr
              WHERE soreltr_letr_code = c_letter_code
              ORDER BY soreltr_seq_no;


        -- letter attributes

        vTextMsg                long;
        vEmailBody              clob;
        vCount                  number;
        vDummy                  varchar2(3);

    begin
        p_ErrMsg := null;

        vEmailBody := null;
        vCount := 0;
        p_EmailBody := null;

        

        FOR reg_soreltr IN soreltr_c(p_letter_code) LOOP

            vTextMsg := f_replace_text(reg_soreltr.soreltr_text_var,
                                        p_pidm,
                                        p_term_code,
                                        p_crn,
                                        p_gcom_id,
                                        p_grde_new,
                                         p_grde_old
                                        );
                                     
            IF reg_soreltr.soreltr_format_var IS null AND vTextMsg IS not NULL THEN
              vEmailBody := vEmailBody ||  vTextMsg;

            elsif reg_soreltr.soreltr_format_var = '<P>' and
                    vTextMsg is not null and
                    vEmailBody is null then

                vEmailBody :=  vTextMsg || crlf;

            elsif reg_soreltr.soreltr_format_var = '<P>' and  vTextMsg is null then
                vEmailBody :=  vEmailBody  || crlf;

            ELSIF reg_soreltr.soreltr_format_var = '<BR>' THEN
              vEmailBody := vEmailBody   ||  vTextMsg || crlf ;

             -- vEmailBody := vEmailBody ||  vTextMsg || '<br>';
            ELSIF reg_soreltr.soreltr_format_var = '<H>' THEN
              vEmailBody := vEmailBody || vTextMsg || crlf;

              --vEmailBody := vEmailBody || '<h>' || vTextMsg || '</h>';
            ELSIF reg_soreltr.soreltr_format_var = '<P>' THEN
              vEmailBody := vEmailBody  || crlf || vTextMsg || crlf || crlf;
            END IF;
            
        
        END LOOP;
        
        

        p_EmailBody := vEmailBody;

    end p_PrepareBody;


    -- send an email
    PROCEDURE P_ProcSendEmail (
                                p_sender      VARCHAR2,
                                p_recipient   VARCHAR2,
                                p_subject     VARCHAR2,
                                p_body        CLOB,
                                p_result      OUT VARCHAR2
                               )
        IS
    --
    -- Retrieve server address.
    -- =====================================================
        CURSOR get_email_srvr
        IS
        SELECT GTVSDAX_DESC
          FROM GTVSDAX
         WHERE GTVSDAX_INTERNAL_CODE = 'SMTP_HOST'
           AND GTVSDAX_INTERNAL_CODE_GROUP = 'UTM002';
           
        server_str VARCHAR2(100);
        
        CURSOR GTVSDAX_WALLET_C (c_int_code VARCHAR2, c_group_code VARCHAR2) IS
         SELECT GTVSDAX_COMMENTS
          FROM GTVSDAX
         WHERE GTVSDAX_INTERNAL_CODE        = c_int_code
           AND GTVSDAX_INTERNAL_CODE_GROUP  = c_group_code;
       
        smtp_port   NUMBER(4,0) := 25;     
    
        wallet_path   VARCHAR2(256);

        wallet_pass   VARCHAR2(256);
    
        base64username VARCHAR2(2000);
    
        base64password VARCHAR2(2000);
    
        base64auth     VARCHAR2(4000);
        base64auth2     VARCHAR2(4000);
        
        lv_wallet_act VARCHAR2(1) := 'Y';
        
        lv_sender_user varchar2(100);
        lv_sender_pass varchar2(100);
        
        conn    utl_smtp.connection;
        
        BEGIN
        
        
    --
    -- Retrieve required information
    -- =====================================================
        OPEN get_email_srvr;
            FETCH get_email_srvr INTO server_str;
        CLOSE get_email_srvr;
        
        

        IF server_str IS NULL THEN
            p_result := 'The required gtvsdax configuration is not available (GTVSDAX_INTERNAL_CODE = SMTP_HOST).';
            RETURN;
        END IF;

        IF p_sender IS NULL THEN
            p_result := 'The parameter p_sender is required.';
            RETURN;
        END IF;
        IF p_recipient IS NULL THEN
            p_result :=  'The parameter p_recipient is required.';
            RETURN;
        END IF;
        IF p_subject IS NULL THEN
            p_result :=  'The parameter p_subject is required.';
            RETURN;
        END IF;
        IF p_body IS NULL THEN
            p_result :=  'The parameter p_body is required.';
            RETURN;
        END IF;
    --
    -- Send email.
    -- =====================================================
       BEGIN
           
           OPEN GTVSDAX_WALLET_C ('WALLETPASS','UTM002');

            FETCH GTVSDAX_WALLET_C INTO wallet_pass;
        
            CLOSE GTVSDAX_WALLET_C;
            
            OPEN GTVSDAX_WALLET_C ('WALLETPATH','UTM002');

            FETCH GTVSDAX_WALLET_C INTO wallet_path;
        
            CLOSE GTVSDAX_WALLET_C;
            
            
            OPEN GTVSDAX_WALLET_C ('EMAL_PASS','UTM002');

            FETCH GTVSDAX_WALLET_C INTO lv_sender_pass;
        
            CLOSE GTVSDAX_WALLET_C;
            
            OPEN GTVSDAX_WALLET_C ('EMAL_USER','UTM002');

            FETCH GTVSDAX_WALLET_C INTO lv_sender_user;
        
            CLOSE GTVSDAX_WALLET_C;
            
            
            
    
           IF COALESCE(lv_wallet_act,'N') = 'Y' THEN
    
                conn := utl_smtp.open_connection( host                          => server_str
                                                    ,port                          => smtp_port
                                                    ,wallet_path                   => wallet_path
                                                    ,wallet_password               => wallet_pass
                                                    ,secure_connection_before_smtp => false);
                                                    
                utl_smtp.ehlo(conn, server_str);
                utl_smtp.starttls(conn);
                utl_smtp.ehlo(conn, server_str);
        
          ELSE
                conn := utl_smtp.open_connection(host => server_str
                                                ,port => smtp_port);
            
                utl_smtp.ehlo(conn, server_str);
          END IF;
    
          base64auth2 := UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(UTL_RAW.cast_to_raw(CHR(0) || lv_sender_user || CHR(0) || lv_sender_pass)));
          
          base64auth2 := REPLACE(REPLACE(base64auth2, CHR(13), ''), CHR(10), '');
          
          UTL_SMTP.command(conn, 'AUTH PLAIN');
          UTL_SMTP.command(conn, base64auth2);
    
    
          utl_smtp.mail(conn, p_sender);
    
          utl_smtp.rcpt(conn, p_recipient);
    
          utl_smtp.open_data(conn);
          
          P_BAN_DEBUG('MAIL_SENDING', 'enter conn');
                   
          utl_smtp.write_data(conn, 'From' || ': ' || p_sender || utl_tcp.CRLF);
          
          P_BAN_DEBUG('MAIL_SENDING','conn1');
          
          utl_smtp.write_data(conn, 'To' || ': ' || p_recipient || utl_tcp.CRLF);
          
          P_BAN_DEBUG('MAIL_SENDING','conn2');
          
          utl_smtp.write_data(conn, 'Subject' || ': ' || p_subject || utl_tcp.CRLF);
          
          P_BAN_DEBUG('MAIL_SENDING','conn3');
          
          utl_smtp.write_data(conn, 'Content-Type' || ': ' || 'text/plain' || utl_tcp.CRLF);
          
          P_BAN_DEBUG('MAIL_SENDING','conn4');
          
          utl_smtp.write_data(conn, 'X-Mailer' || ': ' || 'Mailer by Oracle UTL_SMTP' || utl_tcp.CRLF);
          
          P_BAN_DEBUG('MAIL_SENDING','conn5');
          
          utl_smtp.write_data(conn, utl_tcp.CRLF);
          
          P_BAN_DEBUG('MAIL_SENDING','conn6');
          
          utl_smtp.write_raw_data( conn, utl_raw.cast_to_raw( utl_tcp.crlf || p_body || utl_tcp.crlf ) );
          
          P_BAN_DEBUG('MAIL_SENDING','conn7');
          
          utl_smtp.close_data(conn);
          
          P_BAN_DEBUG('MAIL_SENDING','end Data');
          
          utl_smtp.quit(conn);
          
          P_BAN_DEBUG('MAIL_SENDING','end session');
          
      END;
      EXCEPTION 
        WHEN OTHERS THEN
            
            P_BAN_DEBUG(SQLERRM || p_result);
            UTL_SMTP.QUIT(conn);

    END P_ProcSendEmail;
     
    
    -- this procedure builds and send email to students.
    procedure p_BuildEmail  (p_pidm             number,
                             p_term_code        varchar2,
                             p_crn              varchar2,
                             p_gcom_id          varchar2,
                             p_seqno            number,
                             p_grde_new         varchar2,
                             p_grde_old         varchar2,
                             p_ErrMsg       out varchar2)  is

        cursor get_primary_prof_c(cTermCode          varchar2,
                                  cCrn               varchar2) is
            select sa.SIRASGN_PIDM
              from SIRASGN sa
             where SA.SIRASGN_TERM_CODE = cTermCode
               and SA.SIRASGN_CRN = cCrn
               and SA.SIRASGN_PRIMARY_IND = 'Y';
               
        CURSOR C_GET_STU_EMAL_CONF IS
        SELECT GTVSDAX_TRANSLATION_CODE FROM GTVSDAX 
            WHERE GTVSDAX_INTERNAL_CODE = 'S_GTVEMAL'
            AND GTVSDAX_INTERNAL_CODE_GROUP = 'UTM002';
    
        CURSOR C_GET_FAC_EMAL_CONF IS
            SELECT GTVSDAX_TRANSLATION_CODE FROM GTVSDAX 
                WHERE GTVSDAX_INTERNAL_CODE = 'P_GTVEMAL'
                AND GTVSDAX_INTERNAL_CODE_GROUP = 'UTM002';
        
        CURSOR C_GET_P_SUBJECT IS
            SELECT GTVSDAX_COMMENTS FROM GTVSDAX 
                WHERE GTVSDAX_INTERNAL_CODE = 'P_SUB_EMAL'
                AND GTVSDAX_INTERNAL_CODE_GROUP = 'UTM002';
        
        CURSOR C_GET_S_SUBJECT IS
            SELECT GTVSDAX_COMMENTS FROM GTVSDAX 
                WHERE GTVSDAX_INTERNAL_CODE = 'S_SUB_EMAL'
                AND GTVSDAX_INTERNAL_CODE_GROUP = 'UTM002';
                
        CURSOR C_GET_STU_EMAL_BODY(P_EMAL_CODE VARCHAR2) IS
            SELECT SORELTR_FORMAT_VAR, SORELTR_TEXT_VAR 
                FROM SORELTR 
                WHERE SORELTR_LETR_CODE = P_EMAL_CODE; 
        
        CURSOR C_GET_SENDER_EMAL IS
            SELECT GTVSDAX_COMMENTS 
                FROM GTVSDAX 
                WHERE GTVSDAX_INTERNAL_CODE = 'EMAL_OUT' 
                AND GTVSDAX_INTERNAL_CODE_GROUP = 'UTM002';
            
        CURSOR C_GET_FULL_NAME(P_PIDM SPRIDEN.SPRIDEN_PIDM%TYPE) IS
            SELECT (SPRIDEN_FIRST_NAME || ' ' || SPRIDEN_LAST_NAME) AS FULL_NAME
                FROM SPRIDEN WHERE SPRIDEN_PIDM = P_PIDM
                AND SPRIDEN_CHANGE_IND IS NULL;
                
        lv_emal_sender      VARCHAR2(100);
        lv_stu_emal_conf    VARCHAR2(20);
        lv_fac_emal_conf    VARCHAR2(20);
        
        lv_text_type        VARCHAR2(15);
        lv_emal_text        VARCHAR2(100);
        
        lv_student_name     varchar2(100);

        
        lv_emal_body        CLOB;
        
        l_http_request      UTL_HTTP.req;
        l_http_response     UTL_HTTP.resp;
        lv_token            VARCHAR2(100);
        
        lv_url              VARCHAR2(100);
        lv_json_body        CLOB;

        -- professor
        vProfPidm               number;

        -- general
        vSourceEmail            GTVSDAX.GTVSDAX_COMMENTS%type;
        vComments               GTVSDAX.GTVSDAX_COMMENTS%type;
        vBody                   clob;
        vEmailType              GOREMAL.GOREMAL_EMAL_CODE%type;
        vLetter                 SORELTR.SORELTR_LETR_CODE%type;
        vSubject                GTVSDAX.GTVSDAX_COMMENTS%type;
        vFacSubject             GTVSDAX.GTVSDAX_COMMENTS%type;
        vEmail                  GOREMAL.GOREMAL_EMAIL_ADDRESS%type;

    begin
            
            p_ban_debug('EMAIL LAUNCH_637', 'ENTRE' || p_pidm); 
            
            OPEN C_GET_FULL_NAME(p_pidm);
            FETCH C_GET_FULL_NAME INTO lv_student_name;
            CLOSE C_GET_FULL_NAME;
            
            p_ban_debug('EMAIL LAUNCH_637', 'lv_student_name' || lv_student_name); 
            
            OPEN C_GET_STU_EMAL_CONF;
            FETCH C_GET_STU_EMAL_CONF INTO vLetter;
            CLOSE C_GET_STU_EMAL_CONF;
            
            p_ban_debug('EMAIL LAUNCH_637', 'vLetter' || vLetter); 
            
            OPEN C_GET_SENDER_EMAL;
            FETCH C_GET_SENDER_EMAL INTO vSourceEmail;
            CLOSE C_GET_SENDER_EMAL;
            
            p_ban_debug('EMAIL LAUNCH_637', 'vSourceEmail' || vSourceEmail); 
            
            OPEN C_GET_S_SUBJECT;
            FETCH C_GET_S_SUBJECT INTO vSubject;
            CLOSE C_GET_S_SUBJECT;
            
            p_ban_debug('EMAIL LAUNCH_637', 'vSubject' || vSubject); 
            
            OPEN C_GET_P_SUBJECT;
            FETCH C_GET_P_SUBJECT INTO vFacSubject;
            CLOSE C_GET_P_SUBJECT;
            
            p_ban_debug('EMAIL LAUNCH_637', 'vFacSubject' || vFacSubject); 

        -- get student's email type
        vEmailType := gokeacc.f_getgtvsdaxextcode('S_GTVEMAL', 'UTM002');
            
            p_ban_debug('EMAIL LAUNCH_637', 'vEmailType' || vEmailType); 

        if nvl(upper(vEmailType),'UPDATE') like 'UPDATE%' then
            p_ErrMsg := g$_nls.get('X','SQL','Must define %01% parameter in GTVSDAX.','S_GTVEMAL');
            return;
        end if;

        -- get student's email
        open get_email_c(p_pidm, vEmailType);
        fetch get_email_c into vEmail;
        if get_email_c%notfound then
            close get_email_c;
                p_ban_debug('EMAIL LAUNCH_637', 'Email not found. Pidm: ', to_char(p_pidm)); 
            p_ErrMsg := g$_nls.get('X','SQL','Email not found. Pidm: ', to_char(p_pidm));
            return;
        end if;
        close get_email_c;

            p_ban_debug('EMAIL LAUNCH_637', 'vEmail' || vEmail); 
        
        p_PrepareBody(p_pidm,
                      p_term_code,
                      p_crn,
                      p_gcom_id,
                      p_seqno,
                      p_grde_new,
                      p_grde_old,
                      vLetter,
                          lv_emal_body,
                          p_ErrMsg);
            
            p_ban_debug('EMAIL LAUNCH_719',DBMS_LOB.SUBSTR(lv_emal_body, 4000, 1) || ' ' || vSourceEmail );        
           
            
            --EA MHI [MCLA:002.2.1] 13/03/2025 Code for email body build
        
        -- send email to student
        P_ProcSendEmail(vSourceEmail,
                        vEmail,
                        vSubject,
                        lv_emal_body,
                        p_ErrMsg
                        );
        

        -- configure email body to the professor
        -- get Pidm
        open get_primary_prof_c(p_term_code, p_crn);
        fetch get_primary_prof_c into vProfPidm;
        close get_primary_prof_c;
        
        p_ban_debug('EMAIL LAUNCH_637', 'vProfPidm' || vProfPidm); 

        if nvl(upper(vProfPidm),'UPDATE') like 'UPDATE%' then
            p_ErrMsg := g$_nls.get('X','SQL','Professor not assigned.');
            return;
        end if;

        -- get professor's email type
        vEmailType := gokeacc.f_getgtvsdaxextcode('P_GTVEMAL', 'UTM002');
        
         p_ban_debug('EMAIL LAUNCH_637', 'vEmailType' || vEmailType); 

        if nvl(upper(vEmailType),'UPDATE') like 'UPDATE%' then
            p_ErrMsg := g$_nls.get('X','SQL','Must define %01% parameter in GTVSDAX.','P_GTVEMAL');
            return;
        end if;

        -- get professor's email
        open get_email_c(vProfPidm, vEmailType);
        fetch get_email_c into vEmail;
        if get_email_c%notfound then
            close get_email_c;
            p_ErrMsg := g$_nls.get('X','SQL','Email not found. Pidm: ', to_char(vProfPidm));
            return;
        end if;
        close get_email_c;
        
        p_ban_debug('EMAIL LAUNCH_637', 'vEmail' || vEmail); 

        -- get subject title for professor's email
        vSubject := null;
        open get_gtvsdax_comment_c('P_SUB_EMAL', 'UTM002');
        fetch get_gtvsdax_comment_c into vSubject;
        close get_gtvsdax_comment_c;
        
        p_ban_debug('EMAIL LAUNCH_637', 'vSubject' || vSubject); 

        if nvl(upper(vSubject),'UPDATE') like 'UPDATE%' then
            p_ErrMsg := g$_nls.get('X','SQL','Must define %01% parameter in GTVSDAX.','P_SUB_EMAL');
            return;
        end if;

        -- get letter code
        vLetter := null;
        open get_gtvsdax_att_c('P_GTVEMAL', 'UTM002');
        fetch get_gtvsdax_att_c into vLetter;
        if get_gtvsdax_att_c%notfound or upper(vLetter) like 'UPDATE%' then
            close get_gtvsdax_att_c;
            p_ErrMsg := g$_nls.get('X','SQL','Must define %01% parameter in GTVSDAX.','P_GTVEMAL');
            return;
        end if;
        close get_gtvsdax_att_c;
        
        p_ban_debug('EMAIL LAUNCH_637', 'vLetter' || vLetter); 

        p_PrepareBody(p_pidm,
                      p_term_code,
                      p_crn,
                      p_gcom_id,
                      p_seqno,
                      p_grde_new,
                      p_grde_old,
                      vLetter,
                      lv_emal_body,
                      p_ErrMsg
                      );
                          
        
        p_ban_debug('EMAIL LAUNCH_720',DBMS_LOB.SUBSTR(lv_emal_body, 4000, 1) || ' ' || vSourceEmail ); 

        if p_ErrMsg is not null then
            return;
        end if;

        -- send email to professor
        P_ProcSendEmail(vSourceEmail,
                        vEmail,
                        vFacSubject,
                        lv_emal_body,
                        p_ErrMsg
                        );

        if p_ErrMsg is not null then
            return;
        end if;

    end p_BuildEmail;

END SZKSECG;
/
SHOW ERRORS
SET DEFINE ON
