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
REM Executing the GOKUTLS.sql  file.
REM ****************************************************************************
PROMPT
PROMPT *************************************************************************
PROMPT * Begin: GOKUTLS.sql                                                    *
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
REM Create the GOKUTLS .
REM ****************************************************************************
create or replace PACKAGE BODY GOKUTLS IS
--
-- FILE NAME..: gokutl1.sql
-- RELEASE....: 8.31.2 [MCLA:002.2.0]
-- OBJECT NAME: GOKUTLS
-- PRODUCT....:
-- COPYRIGHT..: Copyright 2025 Ellucian Company L.P. AND its affiliates.
-- DESCRIPTION:
--
-- This package contains several functions and precedures to be reuse in the Modifications
-- for each client
--
-- DESCRIPTION END
--


-- Global variable

  gv_date_mask         VARCHAR2(30) := 'DD-MON-RRRR';
  gv_num_mask          VARCHAR2(30) := 'L99G999G990D99';


  --
  /*****************************************************************************
  ** constants
  *****************************************************************************/
  -- emailserver constants
  --cn_mailhost  CONSTANT VARCHAR2(250) := gzkprmh.f_get_short_value('STU_005', 'EMAIL_HOST');-- 'smtp.ucn.cl';  -- change to your smtp server
  --cn_mailport  CONSTANT PLS_INTEGER   := NVL(TO_NUMBER(gzkprmh.f_get_short_value('STU_005', 'EMAIL_PORT')), 25);
  cn_slash     CONSTANT VARCHAR2(2)   := '\';
  cn_mime_type_txt   CONSTANT VARCHAR2(250) := 'text/plain';
  cn_mime_type_htp   CONSTANT VARCHAR2(250) := 'text/html';
--
-- *******************************************************************
-- * FUNCTIONS                                                       *
-- *******************************************************************
--



--
-- *******************************************************************
-- * PROCEDURES
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
  PROCEDURE p_split_info_to_array ( p_value          IN              VARCHAR2
                                   ,p_sub_value      IN              VARCHAR2
                                   ,p_start_pos      IN              INTEGER DEFAULT 1
                                   ,p_array_result   IN OUT NOCOPY  split_array_tab
                                  )
  IS
  --Variable
    l_value         VARCHAR2(32767);
    l_index_pos     INTEGER;
    l_cntRecs       INTEGER;
    l_index         INTEGER;
    l_startPos      INTEGER;
    l_endPos        INTEGER;
    l_no_occurency  INTEGER;
    l_length        INTEGER;

  BEGIN

    --First validating if the char value is valid
    --In case not valid, it will exit of the process
    IF(p_value IS NULL OR LENGTH(p_value) = 0) THEN
      RETURN;
    END IF;

    --it will get the position of the characted found
    l_index_pos := INSTR(p_value, p_sub_value);

    p_array_result := split_array_tab();

    IF(l_index_pos = 0) THEN
      --Extending the array to fill it
      l_cntRecs := p_array_result.COUNT;
      p_array_result.EXTEND();
      l_index   := p_array_result.NEXT(l_cntRecs);
      p_array_result(l_index).r_split_value := p_value;
      RETURN;
    END IF;

    l_startPos := p_start_pos;
    l_endPos   := 0;
    l_no_occurency := 1;

    LOOP --EFEC,CASH,PRIN
      l_length := LENGTH(p_value);
      l_index_pos := INSTR(p_value, p_sub_value, p_start_pos, l_no_occurency);

      --This is the a special case and it will return it
      IF(l_index_pos = l_startPos ) THEN
        p_array_result := split_array_tab();
        RETURN;
      END IF;

      --Cleaning the value added
      l_value := '';

      IF(l_index_pos > 0) THEN
        l_endPos := l_index_pos;
        l_value := SUBSTR(p_value, l_startPos,  l_endPos - l_startPos );
        l_startPos := l_index_pos + 1;
      ELSIF(l_startPos < l_length ) THEN
        l_value := SUBSTR(p_value, l_startPos);
        l_startPos := l_length;
      END IF;

      IF(l_value IS NOT NULL AND LENGTH(l_value) > 0) THEN
        l_cntRecs := p_array_result.COUNT;
        p_array_result.EXTEND();
        l_index   := p_array_result.NEXT(l_cntRecs);
        p_array_result(l_index).r_split_value := l_value;
        l_no_occurency := l_no_occurency + 1;
      END IF;

    EXIT WHEN l_index_pos = 0;
    END LOOP;

   FOR i in 1..p_array_result.count LOOP
     DBMS_OUTPUT.PUT_LINE(p_array_result(i).r_split_value);
   END LOOP;

  END p_split_info_to_array;


  --
  -- p_split_info_to_array
  --
  -- This procedure will fill the array as a HashMap object
  --
  --
  -- @p_value              Text passed to be split  i.e. 210009305=15876,210009595=789654
  -- @p_sub_value          This is the special character, in this case is a comma character
  -- @p_start_pos          From where start reading the p_value
  -- @p_key_value_result   It will create an array to be with the 210009304 as r_split_key and 15876 value as r_split_value
  --------------------------------------------------------------------------------------------------------------------------
  PROCEDURE p_key_value_info_to_array ( p_value              IN              VARCHAR2
                                       ,p_sub_value          IN              VARCHAR2
                                       ,p_key_separator      IN              VARCHAR2
                                       ,p_start_pos          IN              INTEGER DEFAULT 1
                                       ,p_key_value_result   IN OUT NOCOPY   key_value_array_tab
                                      )
  IS
  --Cursors
  --Variables
    l_split_array_rec     gokutls.split_array_tab;
    l_value               VARCHAR2(32767);
    l_key                 VARCHAR2(100);
    l_key_value           VARCHAR2(32767);

    l_index_pos           INTEGER;
    l_cntRecs             INTEGER;
    l_index               INTEGER;
    l_startPos            INTEGER;
    l_endPos              INTEGER;
    l_no_occurency        INTEGER;
    l_length              INTEGER;

  BEGIN
     p_split_info_to_array ( p_value          => p_value
                            ,p_sub_value      => p_sub_value
                            ,p_start_pos      => p_start_pos
                            ,p_array_result   => l_split_array_rec
                           );
    p_key_value_result := key_value_array_tab();

    l_endPos   := 0;
    l_no_occurency := 1;

    FOR i in 1..l_split_array_rec.count LOOP
      l_value := l_split_array_rec(i).r_split_value;

      --Looking for the p_key_separator
      l_index_pos := INSTR(l_value, p_key_separator, 1, l_no_occurency);

      IF( l_index_pos > 0 ) THEN

        l_key       := SUBSTR(l_value, 1,  l_index_pos - 1 );
        l_key_value := SUBSTR(l_value, l_index_pos + 1, LENGTH(l_value)   );

        IF(l_key IS NOT NULL       AND  LENGTH(l_key) > 0 AND
           l_key_value IS NOT NULL AND  LENGTH(l_key_value) > 0)
        THEN

           l_cntRecs      := p_key_value_result.COUNT;
           p_key_value_result.EXTEND();
           l_index        := p_key_value_result.NEXT(l_cntRecs);
           p_key_value_result(l_index).r_split_key   := l_key;
           p_key_value_result(l_index).r_split_value := l_key_value;

        END IF;

      END IF;

    EXIT WHEN l_index_pos = 0;

    END LOOP;


    FOR i in 1..p_key_value_result.count LOOP
       DBMS_OUTPUT.PUT_LINE(p_key_value_result(i).r_split_value);
    END LOOP;
  END p_key_value_info_to_array;

  /*****************************************************************************
  ** get_directory
  *****************************************************************************/
  --
  -- get directory out of a string
  --
  FUNCTION get_directory( p_string  IN  VARCHAR2)
    RETURN VARCHAR2 IS
  --
    l_return   VARCHAR2(2000);
  --
  BEGIN
    IF p_string IS NOT NULL THEN
      l_return := SUBSTR(p_string, 1, INSTR(p_string, cn_slash, -1)-1);
    END IF;
    RETURN(l_return);
  END;
  --
  /*****************************************************************************
  ** get_file
  *****************************************************************************/
  --
  -- get file out of a string
  --
  FUNCTION get_file ( p_string  IN  VARCHAR2)
    RETURN VARCHAR2 IS
  --
    l_return   VARCHAR2(2000);
  --
  BEGIN
    IF p_string IS NOT NULL THEN
      l_return := SUBSTR(p_string, INSTR(p_string, cn_slash, -1)+1);
    END IF;
    RETURN(l_return);
  END;

  /*****************************************************************************
  ** get_mime_type
  *****************************************************************************/
  --
  -- get mime_type for a file attachment
  --
  FUNCTION get_mime_type( p_file     IN VARCHAR2
                        , p_default  IN VARCHAR2)
    RETURN VARCHAR2 IS
  --
    l_dot      VARCHAR2(10) := '.';
    l_ext      VARCHAR2(10) := substr(p_file, instr(p_file, l_dot, -1)+1);
    l_return   VARCHAR2(250) := p_default;
  --
  BEGIN
    -- get file extention
    l_return := CASE l_ext
                  WHEN 'bmp'  THEN 'image/bmp'
                  WHEN 'doc'  THEN 'application/msword'
                  WHEN 'exe'  THEN 'application/octet-stream'
                  WHEN 'gif'  THEN 'image/gif'
                  WHEN 'htm'  THEN 'text/html'
                  WHEN 'html' THEN 'text/html'
                  WHEN 'jpg'  THEN 'image/jpeg'
                  WHEN 'log'  THEN 'text/plain'
                  WHEN 'mp3'  THEN 'audio/mpeg3'
                  WHEN 'pdf'  THEN 'application/pdf'
                  WHEN 'ppt'  THEN 'application/mspowerpoint'
                  WHEN 'txt'  THEN 'text/plain'
                  WHEN 'wav'  THEN 'audio/wav'
                  WHEN 'xml'  THEN 'text/xml'
                  WHEN 'xls'  THEN 'application/excel'
                  WHEN 'zip'  THEN 'application/zip'
                  ELSE p_default
                END;
    RETURN(l_return);
  END;

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
                        )
  IS
  --Variables
    l_mail_conn     UTL_SMTP.connection;
    l_hasAttachment BOOLEAN := TRUE;

    l_mailconn  utl_smtp.connection;
    l_type      VARCHAR2(250) := cn_mime_type_txt;
    l_attach    BOOLEAN := false;
    l_sqlerrm   VARCHAR2(250);
    l_html      BOOLEAN := FALSE;
    l_handle    BFILE;
    i           NUMBER;
    l_len       NUMBER;

  BEGIN

   IF(p_smtp_host  IS NULL OR
       p_from      IS NULL OR
       p_subject   IS NULL OR
       p_to        IS NULL OR
       p_message   IS NULL )
    THEN
      RETURN;
    END IF;

      l_mailconn := begin_mail( sender     => p_from
                              , recipients => p_to
                              , subject    => p_subject
                              , mime_type  => MULTIPART_MIME_TYPE);
      IF(p_file_name IS NOT NULL) THEN
        begin_attachment( conn  => l_mailconn
                        , mime_type    => get_mime_type(p_file_name, 'application/zip')
                        , inline       => TRUE
                        , filename     => p_file_name
                        , transfer_enc => 'base64');

        l_handle := bfilename(p_doc_dir, p_file_name);
        dbms_lob.open(l_handle,dbms_lob.lob_readonly);
        i   := 1;
        l_len := DBMS_LOB.getLength(l_handle);
        WHILE (i < l_len) LOOP
          IF (i + MAX_BASE64_LINE_WIDTH < l_len) THEN
            UTL_SMTP.Write_Raw_Data(l_mailconn,
                                    UTL_ENCODE.Base64_Encode(DBMS_LOB.Substr(l_handle,
                                                                             MAX_BASE64_LINE_WIDTH,
                                                                             i)));
          ELSE
            UTL_SMTP.Write_Raw_Data(l_mailconn,
                                    UTL_ENCODE.Base64_Encode(DBMS_LOB.Substr(l_handle,
                                                                             (l_len - i) + 1,
                                                                             i)));
          END IF;
          UTL_SMTP.Write_Data(l_mailconn, UTL_TCP.CRLF);
          i := i + MAX_BASE64_LINE_WIDTH;
        END LOOP;

        end_attachment(conn => l_mailconn);
      END IF;
      attach_text(conn      => l_mailconn
                 ,data      => p_message
                 ,mime_type => 'text/html; charset=UTF-8');
      end_mail(conn => l_mailconn);

    EXCEPTION
    WHEN UTL_SMTP.INVALID_OPERATION THEN
      dbms_output.put_line(' Invalid Operation in SMTP transaction.');
    WHEN UTL_SMTP.TRANSIENT_ERROR THEN
      dbms_output.put_line(' Temporary problems with sending email - try again later.');
      l_sqlerrm := substr(sqlerrm, 1, 250);
      dbms_output.put_line(' Others Exception.');
      dbms_output.put_line(' '||l_sqlerrm);

    WHEN UTL_SMTP.PERMANENT_ERROR THEN
      dbms_output.put_line(' Errors in code for SMTP transaction.');
      dbms_output.put_line('---'||substr(sqlerrm, 1, 250));
    WHEN OTHERS THEN
      l_sqlerrm := substr(sqlerrm, 1, 250);
      dbms_output.put_line(' Others Exception.');
      dbms_output.put_line(' '||l_sqlerrm);

  END p_send_mail;



  -- Return the next email address in the list of email addresses, separated
  -- by either a "," or a ";".  The format of mailbox may be in one of these:
  --   someone@some-domain
  --   "Someone at some domain" <someone@some-domain>
  --   Someone at some domain <someone@some-domain>
  FUNCTION get_address(addr_list IN OUT VARCHAR2) RETURN VARCHAR2 IS

    addr VARCHAR2(256);
    i    pls_integer;

    FUNCTION lookup_unquoted_char(str  IN VARCHAR2,
          chrs IN VARCHAR2) RETURN pls_integer AS
      c            VARCHAR2(5);
      i            pls_integer;
      len          pls_integer;
      inside_quote BOOLEAN;
    BEGIN
       inside_quote := false;
       i := 1;
       len := length(str);
       WHILE (i <= len) LOOP

   c := substr(str, i, 1);

   IF (inside_quote) THEN
     IF (c = '"') THEN
       inside_quote := false;
     ELSIF (c = '\') THEN
       i := i + 1; -- Skip the quote character
     END IF;
     GOTO next_char;
   END IF;

   IF (c = '"') THEN
     inside_quote := true;
     GOTO next_char;
   END IF;

   IF (instr(chrs, c) >= 1) THEN
      RETURN i;
   END IF;

   <<next_char>>
   i := i + 1;

       END LOOP;

       RETURN 0;

    END;

  BEGIN

    addr_list := ltrim(addr_list);
    i := lookup_unquoted_char(addr_list, ',;');
    IF (i >= 1) THEN
      addr      := substr(addr_list, 1, i - 1);
      addr_list := substr(addr_list, i + 1);
    ELSE
      addr := addr_list;
      addr_list := '';
    END IF;

    i := lookup_unquoted_char(addr, '<');
    IF (i >= 1) THEN
      addr := substr(addr, i + 1);
      i := instr(addr, '>');
      IF (i >= 1) THEN
  addr := substr(addr, 1, i - 1);
      END IF;
    END IF;

    RETURN addr;
  END;

  -- Write a MIME header
  PROCEDURE write_mime_header(conn  IN OUT NOCOPY utl_smtp.connection,
            name  IN VARCHAR2,
            value IN VARCHAR2) IS
  BEGIN
    utl_smtp.write_data(conn, name || ': ' || value || utl_tcp.CRLF);
  END;

  -- Mark a message-part boundary.  Set <last> to TRUE for the last boundary.
  PROCEDURE write_boundary(conn  IN OUT NOCOPY utl_smtp.connection,
         last  IN            BOOLEAN DEFAULT FALSE) AS
  BEGIN
    IF (last) THEN
      utl_smtp.write_data(conn, LAST_BOUNDARY);
    ELSE
      utl_smtp.write_data(conn, FIRST_BOUNDARY);
    END IF;
  END;

  ------------------------------------------------------------------------
  PROCEDURE mail(sender     IN VARCHAR2,
     recipients IN VARCHAR2,
     subject    IN VARCHAR2,
     message    IN VARCHAR2) IS
    conn utl_smtp.connection;
  BEGIN
    conn := begin_mail(sender, recipients, subject);
    write_text(conn, message);
    end_mail(conn);
  END;

  ------------------------------------------------------------------------
  FUNCTION begin_mail(sender     IN VARCHAR2,
          recipients IN VARCHAR2,
          subject    IN VARCHAR2,
          mime_type  IN VARCHAR2    DEFAULT 'text/plain',
          priority   IN PLS_INTEGER DEFAULT NULL)
          RETURN utl_smtp.connection IS
    conn utl_smtp.connection;
  BEGIN
    conn := begin_session;
    begin_mail_in_session(conn, sender, recipients, subject, mime_type,
      priority);
    RETURN conn;
  END;

  ------------------------------------------------------------------------
  PROCEDURE write_text(conn    IN OUT NOCOPY utl_smtp.connection,
           message IN VARCHAR2) IS
  BEGIN
    utl_smtp.write_raw_data( conn, utl_raw.cast_to_raw( utl_tcp.crlf || message || utl_tcp.crlf ) );
  END;

  ------------------------------------------------------------------------
  PROCEDURE write_mb_text(conn    IN OUT NOCOPY utl_smtp.connection,
        message IN            VARCHAR2) IS
  BEGIN
    utl_smtp.write_raw_data(conn, utl_raw.cast_to_raw(message));
  END;

  ------------------------------------------------------------------------
  PROCEDURE write_raw(conn    IN OUT NOCOPY utl_smtp.connection,
          message IN RAW) IS
  BEGIN
    utl_smtp.write_raw_data(conn, message);
  END;

  ------------------------------------------------------------------------
  PROCEDURE attach_text(conn         IN OUT NOCOPY utl_smtp.connection,
      data         IN VARCHAR2,
      mime_type    IN VARCHAR2 DEFAULT 'text/plain',
      inline       IN BOOLEAN  DEFAULT TRUE,
      filename     IN VARCHAR2 DEFAULT NULL,
            last         IN BOOLEAN  DEFAULT FALSE) IS
  BEGIN
    begin_attachment(conn, mime_type, inline, filename);
    write_text(conn, data);
    end_attachment(conn, last);
  END;

  ------------------------------------------------------------------------
  PROCEDURE attach_base64(conn         IN OUT NOCOPY utl_smtp.connection,
        data         IN RAW,
        mime_type    IN VARCHAR2 DEFAULT 'application/octet',
        inline       IN BOOLEAN  DEFAULT TRUE,
        filename     IN VARCHAR2 DEFAULT NULL,
        last         IN BOOLEAN  DEFAULT FALSE) IS
    i   PLS_INTEGER;
    len PLS_INTEGER;
  BEGIN

    begin_attachment(conn, mime_type, inline, filename, 'base64');

    -- Split the Base64-encoded attachment into multiple lines
    i   := 1;
    len := utl_raw.length(data);
    WHILE (i < len) LOOP
       IF (i + MAX_BASE64_LINE_WIDTH < len) THEN
   utl_smtp.write_raw_data(conn,
      utl_encode.base64_encode(utl_raw.substr(data, i,
      MAX_BASE64_LINE_WIDTH)));
       ELSE
   utl_smtp.write_raw_data(conn,
     utl_encode.base64_encode(utl_raw.substr(data, i)));
       END IF;
       utl_smtp.write_data(conn, utl_tcp.CRLF);
       i := i + MAX_BASE64_LINE_WIDTH;
    END LOOP;

    end_attachment(conn, last);

  END;

  ------------------------------------------------------------------------
  PROCEDURE begin_attachment(conn         IN OUT NOCOPY utl_smtp.connection,
           mime_type    IN VARCHAR2 DEFAULT 'text/plain',
           inline       IN BOOLEAN  DEFAULT TRUE,
           filename     IN VARCHAR2 DEFAULT NULL,
           transfer_enc IN VARCHAR2 DEFAULT NULL) IS
  BEGIN
    write_boundary(conn);
    write_mime_header(conn, 'Content-Type', mime_type);

    IF (filename IS NOT NULL) THEN
        
       IF (inline) THEN
    write_mime_header(conn, 'Content-Disposition',
      'inline; filename="'||filename||'"');
       ELSE
    write_mime_header(conn, 'Content-Disposition',
      'attachment; filename="'||filename||'"');
       END IF;
    END IF;

    IF (transfer_enc IS NOT NULL) THEN
      write_mime_header(conn, 'Content-Transfer-Encoding', transfer_enc);
    END IF;
    utl_smtp.write_data(conn, utl_tcp.CRLF);
  END;

  ------------------------------------------------------------------------
  PROCEDURE end_attachment(conn IN OUT NOCOPY utl_smtp.connection,
         last IN BOOLEAN DEFAULT FALSE) IS
  BEGIN
    utl_smtp.write_data(conn, utl_tcp.CRLF);
    IF (last) THEN
      write_boundary(conn, last);
    END IF;
  END;

  ------------------------------------------------------------------------
  PROCEDURE end_mail(conn IN OUT NOCOPY utl_smtp.connection) IS
  BEGIN
    end_mail_in_session(conn);
    end_session(conn);
  END;

  ------------------------------------------------------------------------
  FUNCTION begin_session RETURN utl_smtp.connection IS
    conn utl_smtp.connection;

  BEGIN
    -- open SMTP connection
    --conn := utl_smtp.open_connection(cn_mailhost, cn_mailport);
    --utl_smtp.helo(conn, cn_mailhost);
    RETURN conn;
  END;

  ------------------------------------------------------------------------
  PROCEDURE begin_mail_in_session(conn       IN OUT NOCOPY utl_smtp.connection,
          sender     IN VARCHAR2,
          recipients IN VARCHAR2,
          subject    IN VARCHAR2,
          mime_type  IN VARCHAR2  DEFAULT 'text/plain',
          priority   IN PLS_INTEGER DEFAULT NULL) IS
    my_recipients VARCHAR2(32767) := recipients;
    my_sender     VARCHAR2(32767) := sender;
  BEGIN

    -- Specify sender's address (our server allows bogus address
    -- as long as it is a full email address (xxx@yyy.com).
    utl_smtp.mail(conn, get_address(my_sender));

    -- Specify recipient(s) of the email.
    WHILE (my_recipients IS NOT NULL) LOOP
      utl_smtp.rcpt(conn, get_address(my_recipients));
    END LOOP;

    -- Start body of email
    utl_smtp.open_data(conn);

    -- Set "From" MIME header
    write_mime_header(conn, 'From', sender);

    -- Set "To" MIME header
    write_mime_header(conn, 'To', recipients);

    -- Set "Subject" MIME header
    write_mime_header(conn, 'Subject', subject);

    -- Set "Content-Type" MIME header
    write_mime_header(conn, 'Content-Type', mime_type);

    -- Set "X-Mailer" MIME header
    write_mime_header(conn, 'X-Mailer', MAILER_ID);

    -- Set priority:
    --   High      Normal       Low
    --   1     2     3     4     5
    IF (priority IS NOT NULL) THEN
      write_mime_header(conn, 'X-Priority', priority);
    END IF;

    -- Send an empty line to denotes end of MIME headers and
    -- beginning of message body.
    utl_smtp.write_data(conn, utl_tcp.CRLF);

    IF (mime_type LIKE 'multipart/mixed%') THEN
      write_text(conn, 'This is a multi-part message in MIME format.' ||
  utl_tcp.crlf);
    END IF;

  END;

  ------------------------------------------------------------------------
  PROCEDURE end_mail_in_session(conn IN OUT NOCOPY utl_smtp.connection) IS
  BEGIN
    utl_smtp.close_data(conn);
  END;

  ------------------------------------------------------------------------
  PROCEDURE end_session(conn IN OUT NOCOPY utl_smtp.connection) IS
  BEGIN
    utl_smtp.quit(conn);
  END;

  PROCEDURE p_send_mail_documents( p_to          IN VARCHAR2
                                  ,p_from        IN VARCHAR2
                                  ,p_subject     IN VARCHAR2
                                  ,p_message     IN VARCHAR2
                                  ,p_smtp_host   IN VARCHAR2
                                  ,p_smtp_port   IN NUMBER DEFAULT 25
                                  ,p_format_type IN VARCHAR2
                                  ,p_doc_dir     IN VARCHAR2 DEFAULT NULL
                                  ,p_file_name   IN VARCHAR2 DEFAULT NULL
                                 )
     IS
   --Variables
     l_mail_conn     UTL_SMTP.connection;
     l_hasAttachment BOOLEAN := TRUE;

     l_mailconn  utl_smtp.connection;
     l_type      VARCHAR2(250) := 'text/plain';--cn_mime_type_txt;
     l_attach    BOOLEAN := false;
     l_sqlerrm   VARCHAR2(250);
     l_html      BOOLEAN := FALSE;
     l_handle    BFILE;
     i           NUMBER;
     l_len       NUMBER;
     v_string varchar2(500);
     v_string2 varchar2(500);
     v_posicion  varchar2(100);
     v_largo_string varchar(500); 

    BEGIN

     IF(p_smtp_host  IS NULL OR
        p_from      IS NULL OR
        p_subject   IS NULL OR
        p_to        IS NULL OR
        p_message   IS NULL )
     THEN
        RETURN;
     END IF;
p_ban_debug('f_global_string','751 gokutils=>' 

||  '{p_from }=>' || p_from 
||  '{p_to }=>' || p_to 
);

     l_mailconn := gokutls.begin_mail( sender     => p_from
                                     , recipients => p_to
                                     , subject    => p_subject
                                     , mime_type  => gokutls.MULTIPART_MIME_TYPE);
      ----------------------------
     v_string := p_file_name;--'Texto_Plan_Escolaridad_Segura.pdf,Detalle_Llenado_Pagare.pdf,PU_13062018_100652_E00010516.pdf';
     v_string2 := '';
     WHILE v_string <> ' ' LOOP
        select instr(v_string, ',') into v_posicion from dual; -- POSICION
        IF(v_posicion  <> 0) THEN 
        select substr(v_string, 1, v_posicion-1) into v_string2 from dual; --STRING A CONSIDERAR
        ELSE
        select length(v_string) into v_posicion from dual; --OBTIENE LARGO DE STRING
        select substr(v_string, 1, v_posicion) into v_string2 from dual; --STRING A CONSIDERAR
        END IF;
        select length(v_string) into v_largo_string from dual; --OBTIENE LARGO DE STRING
        select substr(v_string,v_posicion+1,v_largo_string) into v_string from dual; --QUITA EL STRING YA EVALUADO
        dbms_output.put_line(v_string2);
        p_ban_debug('f_global_string','775= v_string2 ' || v_string2); 
        
        l_handle := bfilename(p_doc_dir, v_string2);
        dbms_lob.open(l_handle,dbms_lob.lob_readonly);

        p_ban_debug('f_global_string','780= fileexists ' || dbms_lob.fileexists(l_handle)); 
        gokutls.begin_attachment( conn  => l_mailconn
                                , mime_type    => gokutls.get_mime_type(v_string2, 'application/zip')
                                , inline       => TRUE
                                , filename     => v_string2
                                , transfer_enc => 'base64');

        
        i   := 1;
        l_len := DBMS_LOB.getLength(l_handle);
        WHILE (i < l_len) LOOP
          IF (i + gokutls.MAX_BASE64_LINE_WIDTH < l_len) THEN
            UTL_SMTP.Write_Raw_Data(l_mailconn,
                                    UTL_ENCODE.Base64_Encode(DBMS_LOB.Substr(l_handle,
                                                                             gokutls.MAX_BASE64_LINE_WIDTH,
                                                                             i)));
          ELSE
            UTL_SMTP.Write_Raw_Data(l_mailconn,
                                    UTL_ENCODE.Base64_Encode(DBMS_LOB.Substr(l_handle,
                                                                             (l_len - i) + 1,
                                                                             i)));
          END IF;
          UTL_SMTP.Write_Data(l_mailconn, UTL_TCP.CRLF);
          i := i + gokutls.MAX_BASE64_LINE_WIDTH;
        END LOOP;
        dbms_lob.close(l_handle);
        --DBMS_LOCK.Sleep( 2 );

        gokutls.end_attachment(conn => l_mailconn);
      --END IF;
      END LOOP;
      ----------------------------
      gokutls.attach_text(conn      => l_mailconn
                 ,data      => p_message
                 ,mime_type => 'text/html; charset=UTF-8');
      gokutls.end_mail(conn => l_mailconn);
      p_ban_debug('f_global_string','811 gokutils=>' ||  '{p_from }=>' || p_from ||  '{p_to }=>' || p_to );
    EXCEPTION
    WHEN UTL_SMTP.INVALID_OPERATION THEN
      dbms_output.put_line(' Invalid Operation in SMTP transaction.');
      p_ban_debug('f_global_string','gokutils Invalid Operation in SMTP transaction' || p_to);
    WHEN UTL_SMTP.TRANSIENT_ERROR THEN
      dbms_output.put_line(' gokutils Temporary problems with sending email - try again later.');
      l_sqlerrm := substr(sqlerrm, 1, 250);
       dbms_output.put_line('xx '||l_sqlerrm);
      p_ban_debug('f_global824',' 824 gokutils Temporary problems with sending email - try again later.' || l_sqlerrm || p_to);

    WHEN UTL_SMTP.PERMANENT_ERROR THEN
      dbms_output.put_line(' Errors in code for SMTP transaction.');
      dbms_output.put_line('---'||substr(sqlerrm, 1, 250));
    p_ban_debug('f_global829','829 gokutils' || substr(sqlerrm, 1, 250) || '-'|| p_to);

    WHEN OTHERS THEN
      l_sqlerrm := substr(sqlerrm, 1, 250);
      dbms_output.put_line(' Others Exception.');
      dbms_output.put_line(' '||l_sqlerrm);
    p_ban_debug('f_global829','835 gokutils' || substr(sqlerrm, 1, 250) || '-'|| p_to);

  END P_send_mail_documents;
  
  --MHI 25/10/2023
  -- Function to send mails with the signed documents as attachment
  
  FUNCTION p_send_mail_documentsBlob (p_to          IN VARCHAR2
                                     ,p_from        IN VARCHAR2
                                     ,p_subject     IN VARCHAR2
                                     ,p_message     IN VARCHAR2
                                     ,p_smtp_host   IN VARCHAR2
                                     ,p_smtp_port   IN NUMBER DEFAULT 25
                                     ,p_format_type IN VARCHAR2
                                     ,p_doc_dir     IN VARCHAR2 DEFAULT NULL
                                     ,p_fixedFiles  IN VARCHAR2
                                     ,p_files_tab   IN files_tab
                                 ) RETURN VARCHAR2
     IS
         l_mail_conn     UTL_SMTP.connection;
         l_hasAttachment BOOLEAN := TRUE;
    
         l_mailconn  utl_smtp.connection;
         l_type      VARCHAR2(250) := 'text/plain';--cn_mime_type_txt;
         l_attach    BOOLEAN := false;
         l_sqlerrm   VARCHAR2(250);
         l_html      BOOLEAN := FALSE;
         l_handle    BFILE;
         i           NUMBER;
         l_len       NUMBER;
         v_string varchar2(500);
         v_string2 varchar2(500);
         v_posicion  varchar2(100);
         v_largo_string varchar(500);
         
         l_blob BLOB := EMPTY_BLOB;
         l_blob_len INTEGER;
         l_amount BINARY_INTEGER := 54;
         v_amount INTEGER;
         l_pos INTEGER := 1;
          l_step        PLS_INTEGER  := 57;
          
         l_file_out     utl_file.file_type;
         l_start        NUMBER := 1;
         l_bytelen      NUMBER := 32000;
         l_blob_length  NUMBER;
         l_buffer       RAW(32760);
         l_length       NUMBER; 
         
     BEGIN
     
         IF(p_smtp_host  IS NULL OR
            p_from      IS NULL OR
            p_subject   IS NULL OR
            p_to        IS NULL OR
            p_message   IS NULL )
         THEN
            RETURN 'No hay configuracion';
         END IF;
                        
        p_ban_debug('mailBlob', 'Blob => ' || p_files_tab(1).r_file_name);
        
        l_mailconn := gokutls.begin_mail( sender     => p_from
                                     , recipients => p_to
                                     , subject    => p_subject
                                     , mime_type  => gokutls.MULTIPART_MIME_TYPE);
        
        if(DBMS_LOB.getLength(p_files_tab(1).r_file_blob) > 0 and p_files_tab(1).r_file_name is not null)then
            dbms_output.put_line('p_files_tab');
                gokutls.begin_attachment( conn  => l_mailconn
                                        , mime_type    => gokutls.get_mime_type(p_files_tab(1).r_file_name, 'application/zip')
                                        , inline       => TRUE
                                        , filename     => p_files_tab(1).r_file_name
                                        , transfer_enc => 'base64');
                l_start := 1;
                l_bytelen := 32000;
        
                dbms_lob.read(p_files_tab(1).r_file_blob, l_bytelen, l_start, l_buffer);
                
                i   := 1;
                l_len := DBMS_LOB.getLength(p_files_tab(1).r_file_blob);
                WHILE (i < l_len) LOOP
                  IF (i + gokutls.MAX_BASE64_LINE_WIDTH < l_len) THEN
                    UTL_SMTP.Write_Raw_Data(l_mailconn,
                                            UTL_ENCODE.Base64_Encode(DBMS_LOB.Substr(p_files_tab(1).r_file_blob,
                                                                                     gokutls.MAX_BASE64_LINE_WIDTH,
                                                                                     i)));
                  ELSE
                    UTL_SMTP.Write_Raw_Data(l_mailconn,
                                            UTL_ENCODE.Base64_Encode(DBMS_LOB.Substr(p_files_tab(1).r_file_blob,
                                                                                     (l_len - i) + 1,
                                                                                     i)));
                  END IF;
                  UTL_SMTP.Write_Data(l_mailconn, UTL_TCP.CRLF);
                  i := i + gokutls.MAX_BASE64_LINE_WIDTH;
                END LOOP;
                
                gokutls.end_attachment(conn => l_mailconn);
        end if;
        
        p_attachmentFromFile(pfileNames    => p_fixedFiles
                          ,p_mailconn    => l_mailconn
                          ,p_doc_dir     => p_doc_dir);
        
      ----------------------------
      gokutls.attach_text(conn      => l_mailconn
                         ,data      => p_message
                         ,mime_type => 'text/html; charset=UTF-8');
      gokutls.end_mail(conn => l_mailconn);
       
      RETURN NULL;
      EXCEPTION
      WHEN UTL_SMTP.INVALID_OPERATION THEN
          dbms_output.put_line(' Invalid Operation in SMTP transaction.');
          RETURN ' Invalid Operation in SMTP transaction.';
      WHEN UTL_SMTP.TRANSIENT_ERROR THEN
          dbms_output.put_line(' Temporary problems with sending email - try again later.');
          RETURN ' Temporary problems with sending email - try again later.';
      WHEN UTL_SMTP.PERMANENT_ERROR THEN
          dbms_output.put_line(' Errors in code for SMTP transaction.');
          dbms_output.put_line('---'|| substr(sqlerrm, 1, 250));
          RETURN ' Errors in code for SMTP transaction.'  || substr(sqlerrm, 1, 250);
      WHEN OTHERS THEN
          l_sqlerrm := substr(sqlerrm, 1, 250);
          dbms_output.put_line(' Others Exception.');
          dbms_output.put_line(' '||l_sqlerrm);
          dbms_output.put_line(' '||DBMS_UTILITY.FORMAT_ERROR_STACK );
          dbms_output.put_line(' '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
      RETURN ' Others Exception.'  || substr(sqlerrm, 1, 250);
     
     END p_send_mail_documentsBlob;
     
     -- MHI 25/10/2023
     -- Procedure to attach to the email to be sent the fixed files.
     
     PROCEDURE p_attachmentFromFile(pfileNames    VARCHAR2
                                ,p_mailconn    IN OUT utl_smtp.connection
                                ,p_doc_dir     IN VARCHAR2 DEFAULT NULL
                                )IS
     
     cursor splitIntoRowsC (pfileNames  VARCHAR2 ) IS
       with rws as (
            select pfileNames str from dual
       )
       select regexp_substr (
           str,
           '[^,]+',
           1,
           level
         ) fileName
        from   rws
      connect by level <= 
           length ( str ) - length ( replace ( str, ',' ) ) + 1;
     
     l_handle    BFILE;
     i           NUMBER;
     l_len       NUMBER;
     v_string varchar2(500);
     v_string2 varchar2(500);
     v_posicion  varchar2(100);
     v_largo_string varchar(500);
     

  BEGIN
    p_ban_debug('BWZKERNS','p_attachmentFromFile pfileNames=' || pfileNames );
    IF(pfileNames IS NULL OR LENGTH(pfileNames) = 0)THEN
        RETURN;
    END IF;
    FOR iRec in splitIntoRowsC(pfileNames => pfileNames) LOOP
        

        gokutls.begin_attachment( conn  => p_mailconn
                                , mime_type    => gokutls.get_mime_type(iRec.fileName, 'application/zip')
                                , inline       => TRUE
                                , filename     => iRec.fileName
                                , transfer_enc => 'base64');
                                
        p_ban_debug('BWZKERNS','p_attachmentFromFile p_doc_dir=' || p_doc_dir );
        p_ban_debug('BWZKERNS','p_attachmentFromFile iRec.fileName=' || iRec.fileName );
        l_handle := bfilename(p_doc_dir, iRec.fileName);
        dbms_lob.open(l_handle,dbms_lob.lob_readonly);
        i   := 1;
        l_len := DBMS_LOB.getLength(l_handle);
        WHILE (i < l_len) LOOP
          IF (i + gokutls.MAX_BASE64_LINE_WIDTH < l_len) THEN
            UTL_SMTP.Write_Raw_Data(p_mailconn,
                                    UTL_ENCODE.Base64_Encode(DBMS_LOB.Substr(l_handle,
                                                                             gokutls.MAX_BASE64_LINE_WIDTH,
                                                                             i)));
          ELSE
            UTL_SMTP.Write_Raw_Data(p_mailconn,
                                    UTL_ENCODE.Base64_Encode(DBMS_LOB.Substr(l_handle,
                                                                             (l_len - i) + 1,
                                                                             i)));
          END IF;
          UTL_SMTP.Write_Data(p_mailconn, UTL_TCP.CRLF);
          i := i + gokutls.MAX_BASE64_LINE_WIDTH;
        END LOOP;
        dbms_lob.close(l_handle);

        gokutls.end_attachment(conn => p_mailconn);

      END LOOP;
    
  END p_attachmentFromFile;

END GOKUTLS;
/
SHOW ERRORS

PROMPT
PROMPT *************************************************************************
PROMPT * End  :  GOKUTLS.sql                                                   *
PROMPT *************************************************************************
PROMPT
REM
REM End Script
REM ****************************************************************************
