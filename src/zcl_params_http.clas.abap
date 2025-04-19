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
    DATA html TYPE string.
    DATA t_fields TYPE tihttpnvp.

    IF request->get_method(  )  = CONV string( if_web_http_client=>post ).

      t_fields = request->get_form_fields(  ).
      LOOP AT t_fields INTO DATA(field).
        DATA(uppername) = to_upper( field-name+5 ).
        UPDATE zparams SET value = @field-value WHERE username = @sy-uname AND param =  @uppername .
      ENDLOOP..
      DATA(myclass) = to_upper( zmn_getsetparams=>getparam( |CLASS| ) ).
      DATA(mymethod) = to_upper( zmn_getsetparams=>getparam( |METHOD| ) ).
      TRY.
          IF mymethod IS NOT INITIAL. CALL METHOD (myclass)=>(mymethod). ENDIF.
        CATCH cx_root INTO data(err).
          zmn_getsetparams=>write( |Error calling { myclass }=>{ mymethod } - { err->get_text(  ) }| ).
      ENDTRY..
    ENDIF.
    zmn_getsetparams=>setparam( description = |Main class| overwrite = abap_false parname = |CLASS| parvalue = |ZCL_{ sy-uname }| sequence = || ).
    zmn_getsetparams=>setparam( description = |Method| overwrite = abap_false parname = |METHOD| parvalue = || sequence = || ).
    myclass = zmn_getsetparams=>getparam( |CLASS| ).
    mymethod = zmn_getsetparams=>getparam( |METHOD| ).
    html =  |<h2>Specify the global class, method, and parameters</h2>| &&
    |<script>function launch(text) \{ document.getElementById("paramMETHOD").value=text; document.getElementById("myform").submit(); \};</script> | &&
    |<form id="myform" method="POST">| &&
     |Global class: <input  name="paramCLASS" value="{ myclass }"> | &&
    |Method: <input id="paramMETHOD"  name="paramMETHOD" value="{ mymethod }"> | &&
    | Note: There might be an <button onclick="launch('INIT')">INIT</button> and <button onclick="launch('MAIN')">MAIN</button> method| &&
    |<table border="1"><tr><th>Parameter</th><th>Description</th><th>Value</th></tr>|.
    SELECT * FROM zparams WHERE username = @sy-uname AND visible IS NOT INITIAL AND param NOT IN ( 'CLASS','METHOD' )
    ORDER BY sequence
    INTO TABLE @DATA(t_params) .
    LOOP AT t_params INTO DATA(params).
      html = | { html }<tr><td>{ params-param }</td><td>{ params-description }</td>| &&


      |<td><input  name="param{ params-param }" value="{ params-value }">| .

    ENDLOOP.
    html = | { html }</table><input type="submit" value="Submit"></form>|.
    SELECT * FROM zoutput WHERE username = @sy-uname ORDER BY sequence INTO TABLE  @DATA(outputs) .
    IF lines( outputs ) > 0.
      html = |{ html }<br>Latest output:|.
      LOOP AT outputs INTO DATA(output).
        html = |{ html }<br>{ output-text }|.
      ENDLOOP.
    ENDIF.
    response->set_text( html ).
  ENDMETHOD.
ENDCLASS.
