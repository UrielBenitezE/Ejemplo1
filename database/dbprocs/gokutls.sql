REM ****************************************************************************
REM *                                                                          *
REM * gokutls.sql                                                              *
REM *                                                                          *
REM ****************************************************************************
REM *                                                                          *
REM * Copyright 2025 Ellucian Company L.P. and its affiliates                  *
REM *                                                                          *
REM * This software contains confidential and proprietary information of       *
REM * Ellucian or its subsidiaries. Use of this software is limited to         *
REM * Ellucian licensees, and is subject to the terms and conditions of one or *
REM * more written license agreements between Ellucian and such licensees.     *
REM *                                                                          *
REM ******************************************************************************
REM *                                                                            *
REM *  Script Name : gokutl1.sql                                                 *
REM *      Project : MOD002                                                      *
REM *                                                                            *
REM ******************************************************************************
REM *                                                                            *
REM * AUDIT TRAIL: 8.31.2 [MCLA:002.2.0]                         INI DATE        *
REM *  -------------------------------------------------------   --- ----------- *
REM *  1. Initial code creation                                  MHI 20-JAN-2025 *
REM *    -------------                                                           *
REM *    This Script creates the GOKUTLS Package body                            *
REM *  ------------------------------------------------------- --- -----------   *
REM *                                                                            *
REM *                                                                            *
REM *                                                                            *
REM *  AUDIT TRAIL: END                                                          *
REM *                                                                            *
REM ******************************************************************************

REM
REM Executing the GOKUTL1.sql  file.
REM ****************************************************************************
PROMPT
PROMPT *************************************************************************
PROMPT * Begin: GOKUTL1.sql                                                    *
PROMPT *************************************************************************
PROMPT

REM
REM Connect to the Database
REM ****************************************************************************
SET DEFINE ON
CONNECT baninst1/&&baninst1_password;
SET DEFINE OFF
SET SHOWMODE OFF
SET ECHO OFF
SET VERI OFF
SET HEAD OFF
SET TIME OFF
SET TRIMSPOOL ON

REM
REM Create the GOKUTL1 .
REM ****************************************************************************
create or replace PACKAGE GOKUTLS IS
--
-- FILE NAME..: gokutls.sql
-- RELEASE....: 8.31.2 [MCLA:002.2.0]
-- OBJECT NAME: GOKUTLS
-- PRODUCT....:
-- COPYRIGHT..: Copyright 2025 Ellucian Company L.P. AND its affiliates.
-- DESCRIPTION:
--
-- This package contains several functions and precedures to be reuse in the Modifications
-- for each client
-- DESCRIPTION END
--

 ----------------------- Customizable Section -----------------------

  -- Customize the SMTP host, port and your domain name below.
  smtp_host   VARCHAR2(256); -- example:'149.24.39.18';     ---'localhost' temp;
  smtp_port   PLS_INTEGER ; --  example = 25;
  smtp_domain VARCHAR2(256); -- example := '149.24.39.18';      -- 'localhost';

  -- Customize the signature that will appear in the email's MIME header.
  -- Useful for versioning.
  MAILER_ID   CONSTANT VARCHAR2(256) := 'Mailer by Oracle UTL_SMTP';

  --------------------- End Customizable Section ---------------------

  -- A unique string that demarcates boundaries of parts in a multi-part email
  -- The string should not appear inside the body of any part of the email.
  -- Customize this if needed or generate this randomly dynamically.
  BOUNDARY        CONSTANT VARCHAR2(256) := '-----7D81B75CCC90D2974F7A1CBD';

  FIRST_BOUNDARY  CONSTANT VARCHAR2(256) := '--' || BOUNDARY || utl_tcp.CRLF;
  LAST_BOUNDARY   CONSTANT VARCHAR2(256) := '--' || BOUNDARY || '--' ||
                                              utl_tcp.CRLF;

  -- A MIME type that denotes multi-part email (MIME) messages.
  MULTIPART_MIME_TYPE CONSTANT VARCHAR2(256) := 'multipart/mixed; boundary="'||
                                                  BOUNDARY || '"';
  MAX_BASE64_LINE_WIDTH CONSTANT PLS_INTEGER   := 76 / 4 * 3;


-- *******************************************************************
-- * CONSTANTS                                                       *
-- *******************************************************************
--

   CONST_FORMAT_HTML          CONSTANT VARCHAR2(7)  :='HTML';


-- *******************************************************************
-- * CURSORS                                                         *
-- *******************************************************************
--


-- *******************************************************************
-- * CUSTOM TYPES                                                    *
-- *******************************************************************
--

--
-- Subtypes
--

  -- A PL/SQL table type of auxiliary related to split process.
  TYPE split_array_rec IS RECORD (
    r_split_value       VARCHAR2(32767)
  );

  -- A PL/SQL table type of auxiliary related related to split process.
  TYPE split_array_tab IS TABLE OF split_array_rec;


  -- A PL/SQL table type of auxiliary related to split process. Pair and Value
  --Like a HashMap
  TYPE key_value_array_rec IS RECORD (
    r_split_key       VARCHAR2(100)
   ,r_split_value     VARCHAR2(32767)
  );

  -- A PL/SQL table type of auxiliary related related to split process.
  --Like a HashMap
  TYPE key_value_array_tab IS TABLE OF key_value_array_rec;


  -- MHI 2023-10-26 
  -- Record to hold the record file name and blob to send 

  TYPE files_rec IS RECORD (
      r_file_name   VARCHAR2(200)
     ,r_file_blob   BLOB
    );

  -- A PL/SQL table to handle information related to the discount history records
  TYPE files_tab IS TABLE OF files_rec;


-- *******************************************************************
-- * FUNCTIONS                                                       *
-- *******************************************************************
--


-- *******************************************************************
-- * PROCEDURE                                                       *
-- *******************************************************************
--

  --
  -- p_split_info_to_array
  --
  -- This procedure will split the value variable i.e. EFEC,CASH,PRIN
  -- It will fill an array and with the sub value passed i.e ','
  --
  --
  -- @p_value
  -- @p_sub_value
  -- @p_start_pos
  -- @p_array_result
  --
  PROCEDURE p_split_info_to_array ( p_value          IN             VARCHAR2
                                   ,p_sub_value      IN             VARCHAR2
                                   ,p_start_pos      IN             INTEGER DEFAULT 1
                                   ,p_array_result   IN OUT NOCOPY  split_array_tab
                                  );

    
  --
  -- p_split_info_to_array
  --
  -- This procedure will fill the array as a HashMap object
  -- It will fill an array and with the sub value passed i.e ','
  --
  --
  -- @p_value              Text passed to be split  i.e. 210009305=15876,210009595=789654
  -- @p_sub_value          This is the special character, in this case is a comma character
  -- @p_key_separator      This is the = character, but it could be a different one
  -- @p_start_pos          From where start reading the p_value
  -- @p_key_value_result   It will create an array to be with the 210009304 as r_split_key and 15876 value as r_split_value
  --
  PROCEDURE p_key_value_info_to_array ( p_value              IN              VARCHAR2
                                       ,p_sub_value          IN              VARCHAR2
                                       ,p_key_separator      IN              VARCHAR2
                                       ,p_start_pos          IN              INTEGER DEFAULT 1
                                       ,p_key_value_result   IN OUT NOCOPY   key_value_array_tab
                                      );


  --
  -- send_mail
  --
  -- This is the email sender so that it can be sent the message
  --
  --
  -- p_to                 this is the field where it will be sent
  -- p_from               this is the field from it will be  sent
  -- p_subject            This is the subject for the email
  -- p_message            This is the main message  for the email
  -- p_smtp_host          This is the
  -- p_smtp_port
  -- p_smtp_port
  -- p_format_type
  ------------------------------------------------------------------------------------
  PROCEDURE p_send_mail ( p_to          IN VARCHAR2
                         ,p_from        IN VARCHAR2
                         ,p_subject     IN VARCHAR2
                         ,p_message     IN VARCHAR2
                         ,p_smtp_host   IN VARCHAR2
                         ,p_smtp_port   IN NUMBER DEFAULT 25
                         ,p_format_type IN VARCHAR2
                         ,p_doc_dir     IN VARCHAR2 DEFAULT NULL
                         ,p_file_name   IN VARCHAR2 DEFAULT NULL
                        );
  -- Extended email API to send email in HTML or plain text with no size limit.
  -- First, begin the email by begin_mail(). Then, call write_text() repeatedly
  -- to send email in ASCII piece-by-piece. Or, call write_mb_text() to send
  -- email in non-ASCII or multi-byte character set. End the email with
  -- end_mail().
  FUNCTION begin_mail(sender     IN VARCHAR2,
          recipients IN VARCHAR2,
          subject    IN VARCHAR2,
          mime_type  IN VARCHAR2    DEFAULT 'text/plain',
          priority   IN PLS_INTEGER DEFAULT NULL)
          RETURN utl_smtp.connection;

  FUNCTION get_mime_type ( p_file     IN VARCHAR2
                         , p_default  IN VARCHAR2)
  RETURN VARCHAR2;
  
  -- Send an attachment with no size limit. First, begin the attachment
  -- with begin_attachment(). Then, call write_text repeatedly to send
  -- the attachment piece-by-piece. If the attachment is text-based but
  -- in non-ASCII or multi-byte character set, use write_mb_text() instead.
  -- To send binary attachment, the binary content should first be
  -- encoded in Base-64 encoding format using the demo package for 8i,
  -- or the native one in 9i. End the attachment with end_attachment.
  PROCEDURE begin_attachment(conn         IN OUT NOCOPY utl_smtp.connection,
           mime_type    IN VARCHAR2 DEFAULT 'text/plain',
           inline       IN BOOLEAN  DEFAULT TRUE,
           filename     IN VARCHAR2 DEFAULT NULL,
           transfer_enc IN VARCHAR2 DEFAULT NULL);

   -- End the attachment.
  PROCEDURE end_attachment(conn IN OUT NOCOPY utl_smtp.connection,
         last IN BOOLEAN DEFAULT FALSE);

  ---------------------------------------------------------------------------------

   -- A simple email API for sending email in plain text in a single call.
  -- The format of an email address is one of these:
  --   someone@some-domain
  --   "Someone at some domain" <someone@some-domain>
  --   Someone at some domain <someone@some-domain>
  -- The recipients is a list of email addresses  separated by
  -- either a "," or a ";"
  PROCEDURE mail(sender     IN VARCHAR2,
                 recipients IN VARCHAR2,
                 subject    IN VARCHAR2,
                message    IN VARCHAR2);

  

  -- Write email body in ASCII
  PROCEDURE write_text(conn    IN OUT NOCOPY utl_smtp.connection,
           message IN VARCHAR2);

  -- Write email body in non-ASCII (including multi-byte). The email body
  -- will be sent in the database character set.
  PROCEDURE write_mb_text(conn    IN OUT NOCOPY utl_smtp.connection,
        message IN            VARCHAR2);

  -- Write email body in binary
  PROCEDURE write_raw(conn    IN OUT NOCOPY utl_smtp.connection,
          message IN RAW);

  -- APIs to send email with attachments. Attachments are sent by sending
  -- emails in "multipart/mixed" MIME format. Specify that MIME format when
  -- beginning an email with begin_mail().

  -- Send a single text attachment.
  PROCEDURE attach_text(conn         IN OUT NOCOPY utl_smtp.connection,
      data         IN VARCHAR2,
      mime_type    IN VARCHAR2 DEFAULT 'text/plain',
      inline       IN BOOLEAN  DEFAULT TRUE,
      filename     IN VARCHAR2 DEFAULT NULL,
            last         IN BOOLEAN  DEFAULT FALSE);

  -- Send a binary attachment. The attachment will be encoded in Base-64
  -- encoding format.
  PROCEDURE attach_base64(conn         IN OUT NOCOPY utl_smtp.connection,
        data         IN RAW,
        mime_type    IN VARCHAR2 DEFAULT 'application/octet',
        inline       IN BOOLEAN  DEFAULT TRUE,
        filename     IN VARCHAR2 DEFAULT NULL,
        last         IN BOOLEAN  DEFAULT FALSE);

  

 

  -- End the email.
  PROCEDURE end_mail(conn IN OUT NOCOPY utl_smtp.connection);

  -- Extended email API to send multiple emails in a session for better
  -- performance. First, begin an email session with begin_session.
  -- Then, begin each email with a session by calling begin_mail_in_session
  -- instead of begin_mail. End the email with end_mail_in_session instead
  -- of end_mail. End the email session by end_session.
  FUNCTION begin_session RETURN utl_smtp.connection;

  -- Begin an email in a session.
  PROCEDURE begin_mail_in_session(conn       IN OUT NOCOPY utl_smtp.connection,
          sender     IN VARCHAR2,
          recipients IN VARCHAR2,
          subject    IN VARCHAR2,
          mime_type  IN VARCHAR2  DEFAULT 'text/plain',
          priority   IN PLS_INTEGER DEFAULT NULL);

  -- End an email in a session.
  PROCEDURE end_mail_in_session(conn IN OUT NOCOPY utl_smtp.connection);

  -- End an email session.
  PROCEDURE end_session(conn IN OUT NOCOPY utl_smtp.connection);

  PROCEDURE p_send_mail_documents( p_to          IN VARCHAR2
                                  ,p_from        IN VARCHAR2
                                  ,p_subject     IN VARCHAR2
                                  ,p_message     IN VARCHAR2
                                  ,p_smtp_host   IN VARCHAR2
                                  ,p_smtp_port   IN NUMBER DEFAULT 25
                                  ,p_format_type IN VARCHAR2
                                  ,p_doc_dir     IN VARCHAR2 DEFAULT NULL
                                  ,p_file_name   IN VARCHAR2 DEFAULT NULL
                                 );
  -- MHI 25/10/2023
  -- Function to send mails with the signed documents as attachment
  -- p_to                 this is the field where it will be sent
  -- p_from               this is the field from it will be  sent
  -- p_subject            This is the subject for the email
  -- p_message            This is the main message  for the email
  -- p_smtp_host          
  -- p_smtp_port
  -- p_smtp_port
  -- p_format_type
  -- p_doc_dir
  -- p_fixedFiles
  -- p_files_tab



   FUNCTION p_send_mail_documentsBlob(p_to          IN VARCHAR2
                                     ,p_from        IN VARCHAR2
                                     ,p_subject     IN VARCHAR2
                                     ,p_message     IN VARCHAR2
                                     ,p_smtp_host   IN VARCHAR2
                                     ,p_smtp_port   IN NUMBER DEFAULT 25
                                     ,p_format_type IN VARCHAR2
                                     ,p_doc_dir     IN VARCHAR2 DEFAULT NULL
                                     ,p_fixedFiles  IN VARCHAR2
                                     ,p_files_tab   IN files_tab
                                 ) RETURN VARCHAR2;

  -- MHI 25/10/2023
  -- Procedure to attach to the email to be sent the fixed files.

    PROCEDURE p_attachmentFromFile(pfileNames    VARCHAR2
                                ,p_mailconn    IN OUT utl_smtp.connection
                                ,p_doc_dir     IN VARCHAR2 DEFAULT NULL
                                );



END GOKUTLS;
/
SHOW ERRORS
WHENEVER SQLERROR CONTINUE;
DROP PUBLIC SYNONYM GOKUTLS;
WHENEVER SQLERROR EXIT ROLLBACK
CREATE PUBLIC SYNONYM GOKUTLS FOR GOKUTLS;
WHENEVER SQLERROR CONTINUE;
SET DEFINE ON

start gurgrtb BANINST1.GOKUTLS
start gurgrth BANINST1.GOKUTLS
SET DEFINE OFF
WHENEVER SQLERROR EXIT ROLLBACK
SET SCAN ON

PROMPT
PROMPT *************************************************************************
PROMPT * End  :  GOKUTLS.sql                                                   *
PROMPT *************************************************************************
PROMPT
REM
REM End Script
REM ****************************************************************************
