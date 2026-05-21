REM ************************************************************************************************
REM *                                                                                              *
REM * Script Name : szaschm_090334_objs.sql                                                        *
REM *                                                                                              *
REM *     Project : UTM - Mejoras a Asistencia, Calificaciones e Historia Académica                *
REM *                                                                                              *
REM *                                                                                              *
REM * Description : Load objects in Banner(R).                                                     *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM * AUDIT TRAIL: 8.7   [UTM:002.1.0]                                             INI    DATE     *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM * 1. Creacion del Codigo.                                                      MKU  10/NOV/2015*
REM *    --------------------                                                                      *
REM *    Este script da de alta los objetos desarrollados para UTM en Banner                       *
REM *    Security y en Banner Objects.                                                             *
REM *                                                                                              *
REM ************************************************************************************************
REM *                                                                                              *
REM *  AUDIT TRAIL: 9.3.34                                                         INI DATE        *
REM *  --------------------------------------------------------------------------- --- ----------- *
REM *  1. Creates objects in Banner Security and Banner Objects.                   MHI 11-DEC-2024 *
REM *                                                                                              *
REM *  AUDIT TRAIL: END                                                                            *
REM *                                                                                              *
REM ************************************************************************************************


REM *
REM * Formas
REM * ********************************

SET DEFINE ON
CONNECT general/&&general_password
SET SHOWMODE OFF
SET ECHO OFF
SET VERI OFF
SET HEAD OFF
SET TIME OFF
SET TRIMSPOOL ON

DELETE FROM GENERAL.GUBPAGE
      WHERE gubpage_code = 'SZASCHM';

DELETE general.gubobjs
       WHERE gubobjs_name = 'SZASCHM';

INSERT INTO general.GUBOBJS
       (GUBOBJS_NAME,
        GUBOBJS_DESC,
        GUBOBJS_OBJT_CODE,
        GUBOBJS_SYSI_CODE,
        GUBOBJS_USER_ID,
        GUBOBJS_ACTIVITY_DATE,
        GUBOBJS_HELP_IND,
        GUBOBJS_EXTRACT_ENABLED_IND,
        GUBOBJS_UI_VERSION)         /*default is 'B - Banner8, C- Banner9only, D- UnifiedMenu-banner8/9'     UI VERSION FLAG: This flag indicates if this can be used in Banner9 application. 'D' means it can be used in both*/
VALUES
      ('SZASCHM',
       G$_NLS.GET('X','SQL','Configuración de Esquemas de Evaluación'),
       'FORM',
       'S',
       'BANNER',
       SYSDATE,
       'N',
       'N',
       'D');

COMMIT;

PROMPT
PROMPT ***   Creating Objects in BANSECR
PROMPT

SET DEFINE ON
CONNECT bansecr/&&bansecr_password
SET SHOWMODE OFF
SET ECHO OFF
SET VERI OFF
SET HEAD OFF
SET TIME OFF
SET TRIMSPOOL ON


 DELETE FROM bansecr.guraobj
       WHERE guraobj_object = 'SZASCHM';

 INSERT INTO bansecr.guraobj (guraobj_object,
                              guraobj_default_role,
                              guraobj_current_version,
                              guraobj_sysi_code,
                              guraobj_activity_date)
      VALUES ('SZASCHM',
              'BAN_DEFAULT_M',
              '9.3.34',
              'S',
              SYSDATE);


 DELETE FROM bansecr.guruobj
       WHERE guruobj_object = 'SZASCHM';

 INSERT INTO bansecr.guruobj (guruobj_object,
                              guruobj_role,
                              guruobj_userid,
                              guruobj_activity_date)
      VALUES ('SZASCHM',
              'BAN_DEFAULT_M',
              'BAN_STUDENT_C',
              SYSDATE);

 DELETE FROM BANSECR.GUROWNR
       WHERE gurownr_object = 'SZASCHM';

 INSERT INTO BANSECR.GUROWNR (GUROWNR_OWNER,
                              GUROWNR_OBJECT,
                              GUROWNR_OBJECT_TYPE,
                              GUROWNR_GRANTOR,
                              GUROWNR_PRIV_GRANT,
                              GUROWNR_PRIV_GRANT_ASSIGN,
                              GUROWNR_PRIV_REVOKE,
                              GUROWNR_PRIV_REVOKE_ASSIGN,
                              GUROWNR_PRIV_DELETE,
                              GUROWNR_PRIV_DELETE_ASSIGN,
                              GUROWNR_PRIV_MODIFY,
                              GUROWNR_PRIV_MODIFY_ASSIGN,
                              GUROWNR_USER_ID,
                              GUROWNR_ACTIVITY_DATE,
                              GUROWNR_COMMENTS,
                              GUROWNR_DATA_ORIGIN)
      VALUES ('PUBLIC',
              'SZASCHM',
              'O',
              'BANSECR',
              'Y',
              'Y',
              'Y',
              'Y',
              'Y',
              'Y',
              'Y',
              'Y',
              'BANSECR',
              SYSDATE,
              NULL,
              NULL);

COMMIT;

SET DEFINE ON
CONNECT general/&&general_password
SET SHOWMODE OFF
SET ECHO OFF
SET VERI OFF
SET HEAD OFF
SET TIME OFF
SET TRIMSPOOL ON

DELETE FROM GENERAL.GUBPAGE
       WHERE gubpage_code = 'SZASCHM';

INSERT INTO GENERAL.GUBPAGE (GUBPAGE_CODE ,
           GUBPAGE_NAME ,
                             GUBPAGE_GUBMODU_CODE ,
                             GUBPAGE_USER_ID,
                             GUBPAGE_DATA_ORIGIN,
                 GUBPAGE_ACTIVITY_DATE)
      VALUES ('SZASCHM',
              G$_NLS.GET('X','SQL','Configuración de Esquemas de Evaluación'),
              'SP',
              'BASELINE',
              'BANINST1',
              SYSDATE);

 COMMIT;
REM
REM