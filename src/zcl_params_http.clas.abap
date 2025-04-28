CLASS zcl_params_http DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_params_http IMPLEMENTATION.
  METHOD if_http_service_extension~handle_request.
    DATA html     TYPE string.
    DATA t_fields TYPE tihttpnvp.

    IF request->get_method( ) = CONV string( if_web_http_client=>post ).
    "============================ common code ====================================
      " -----------------------------  PAI ----------------------------

      LOOP AT t_fields INTO DATA(field).
        DATA(uppername) = to_upper( field-name+5 ).
        UPDATE zparams SET value = @field-value WHERE username = @sy-uname AND param = @uppername.
      ENDLOOP.
      DATA(myclass) = to_upper( zmn_getsetparams=>getparam( |CLASS| ) ).
      DATA(mymethod) = to_upper( zmn_getsetparams=>getparam( |METHOD| ) ).
      DATA r_classdescr TYPE REF TO cl_abap_classdescr.
      IF myclass IS NOT INITIAL.
        TRY.
  "          IF cl_esh_ca_check=>is_active_class( |{ myclass }| ) = abap_true.
  "            r_classdescr ?= cl_abap_typedescr=>describe_by_name( myclass ).
  "           IF NOT line_exists( r_classdescr->methods[ name = 'INIT' ] ). zmn_getsetparams=>hideparams( ). ENDIF.
              IF mymethod IS NOT INITIAL. CALL METHOD (myclass)=>(mymethod). ENDIF.
  "        else.
  "        zmn_getsetparams=>write( |Class { myclass } does not exist.| ).
  "       ENDIF.
          CATCH cx_root INTO DATA(err).

            zmn_getsetparams=>write( |Error calling { myclass }=>{ mymethod } - { err->get_text( ) }| ).

        ENDTRY.

      ENDIF.
    ENDIF.
  " -----------------------------  PBO ----------------------------

    zmn_getsetparams=>setparam( description = |Global class|
                                overwrite   = abap_false
                                parname     = |CLASS|
                                parvalue    = |ZCL_{ sy-uname }|
                                sequence    = |98| ).
    zmn_getsetparams=>setparam( description = |Method eg INIT,MAIN|
                                overwrite   = abap_false
                                parname     = |METHOD|
                                parvalue    = |MAIN|
                                sequence    = |99| ).
    " myclass = zmn_getsetparams=>getparam( |CLASS| ).
    " mymethod = zmn_getsetparams=>getparam( |METHOD| ).
    html = |<h2>Specify the parameters, global class, and method</h2><script>| &&
    |const urlParams = new URLSearchParams(window.location.search);const pClass = urlParams.get('class'); const pMethod=urlParams.get('method'); | &&
    |function launch(text) \{ document.getElementById("paramMETHOD").value=text; document.getElementById("myform").submit(); \};</script> | &&
    |<form id="myform" method="POST">| &&
    |<table border="1"><tr><th>Parameter</th><th>Value</th></tr>|.
    SELECT * FROM zparams
      WHERE username = @sy-uname AND visible IS NOT INITIAL " AND param NOT IN ( 'CLASS','METHOD' )
      ORDER BY sequence
      INTO TABLE @DATA(t_params).
    LOOP AT t_params INTO DATA(params).
      html = | { html }<tr><td><span title="{ params-param }">{ params-description } </span></td>| &&

      |<td><input  id="param{ params-param }" name="param{ params-param }" value="{ params-value }">|.

    ENDLOOP.
    html = |{ html }</table><input type="submit" value="Execute"> <button onclick="launch('INIT')">INIT</button> <button onclick="launch('MAIN')">MAIN</button>| &&
    |<script>if (pClass !== null) \{document.getElementById("paramCLASS").value=pClass;\};| &&
    |if (pMethod !== null) \{document.getElementById("paramMETHOD").value=pMethod;\};</script>| &&

    |</form>|.
    SELECT * FROM zoutput WHERE username = @sy-uname ORDER BY sequence INTO TABLE @DATA(outputs).
    IF lines( outputs ) > 0.
      html = |{ html }<h3>Latest output</h3>|.
      LOOP AT outputs INTO DATA(output).
        html = |{ html }{ output-text }<br>|.
      ENDLOOP.
    ENDIF.
    "=================================================================
    response->set_text( html ).
  ENDMETHOD.
ENDCLASS.
