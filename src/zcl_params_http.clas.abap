class ZCL_PARAMS_HTTP definition
  public
  create public .

public section.

  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_PARAMS_HTTP IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.
    DATA html TYPE string.

    CASE request->get_method(  ).
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
        response->set_text( html ).
      WHEN CONV string( if_web_http_client=>post ).
        DATA(t_fields) = request->get_form_fields(  ).

        LOOP AT t_fields INTO DATA(field).
        data(uppername) = to_upper( field-name+5 ).
      update zparams set value = @field-value where username = @sy-uname and param =  @uppername .
        ENDLOOP..

        response->set_text(  |Parameter values updated. <button onClick="location.replace(location.href);">Restart</button>| ).
    ENDCASE..
  ENDMETHOD.
ENDCLASS.
