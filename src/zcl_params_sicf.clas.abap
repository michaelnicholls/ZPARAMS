class ZCL_PARAMS_SICF definition
  public
  final
  create public .

public section.

  interfaces IF_HTTP_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_PARAMS_SICF IMPLEMENTATION.
  METHOD IF_HTTP_EXTENSION~HANDLE_REQUEST.
   DATA html TYPE string.

    CASE server->request->get_method(  ).
      WHEN CONV string( if_web_http_client=>get ).
        html =  |<h2>Maintain your parameters</h2>| &&
        |<form  method="POST">| &&
        |<table border="1"><tr><th>Parameter</th><th>Description</th><th>Value</th></tr>|.
        SELECT * FROM zparams WHERE username = @sy-uname and visible is not INITIAL
        order by param
        INTO TABLE @DATA(t_params) .
        LOOP AT t_params INTO DATA(params).
          html = | { html }<tr><td>{ params-param }</td><td>{ params-description }</td>| &&


          |<td><input  name="param{ params-param }" value="{ params-value }">| .

        ENDLOOP.
        html = | { html }</table><input type="submit" value="Update"></form>|.
        server->response->set_cdata( html ).
      WHEN CONV string( if_web_http_client=>post ).
      data t_fields type tihttpnvp.
         server->request->get_form_fields( CHANGING fields = t_fields ).

        LOOP AT t_fields INTO DATA(field).
        data(uppername) = to_upper( field-name+5 ).
      update zparams set value = @field-value where username = @sy-uname and param =  @uppername .
        ENDLOOP..

        server->response->set_cdata(  |Parameter values updated. <button onClick="location.replace(location.href);">Restart</button>| ).
    ENDCASE..
  ENDMETHOD.

ENDCLASS.
