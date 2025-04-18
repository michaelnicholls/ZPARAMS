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

    CASE request->get_method(  ).
      WHEN CONV string( if_web_http_client=>get ).
        html =  |<h2>Maintain your parameters</h2>| &&
        |<form  method="POST">| &&
        |<table border="1"><tr><th>Parameter</th><th>Description</th><th>Value</th></tr>|.
        SELECT * FROM zparams WHERE username = @sy-uname AND visible IS NOT INITIAL
        ORDER BY sequence
        INTO TABLE @DATA(t_params) .
        LOOP AT t_params INTO DATA(params).
          html = | { html }<tr><td>{ params-param }</td><td>{ params-description }</td>| &&


          |<td><input  name="param{ params-param }" value="{ params-value }">| .

        ENDLOOP.
        html = | { html }</table><input type="submit" value="Update"></form>|.
        SELECT * FROM zoutput WHERE username = @sy-uname ORDER BY sequence INTO TABLE  @DATA(outputs) .
        IF lines( outputs ) > 0.
          html = |{ html }<br>Latest output:<br>================|.
          LOOP AT outputs INTO DATA(output).
            html = |{ html }<br>{ output-text }|.
          ENDLOOP.
        ENDIF.
        response->set_text( html ).
      WHEN CONV string( if_web_http_client=>post ).
        DATA(t_fields) = request->get_form_fields(  ).

        LOOP AT t_fields INTO DATA(field).
          DATA(uppername) = to_upper( field-name+5 ).
          UPDATE zparams SET value = @field-value WHERE username = @sy-uname AND param =  @uppername .
        ENDLOOP..

        response->set_text(  |Parameter values updated. <button onClick="location.replace(location.href);">Refresh</button>| ).
    ENDCASE..
  ENDMETHOD.
ENDCLASS.
