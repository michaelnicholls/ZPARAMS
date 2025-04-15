CLASS zcl_mn_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MN_DEMO IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  zmn_getsetparams=>hideparams(  ).

  " getparam will make it visible in the HTML page

    zmn_getsetparams=>setparam( description = 'integer1' parname = 'INT1' parvalue = '55' sequence = '01' overwrite = abap_false ).
    zmn_getsetparams=>setparam( description = 'integer2' parname = 'INT2' parvalue = '19' sequence = '03' overwrite = abap_false ).
    zmn_getsetparams=>setparam( description = 'Operator' parname = 'OPERATOR' parvalue = '+' sequence = '02' overwrite = abap_false ).
    DATA(pa_int1) = CONV i(  zmn_getsetparams=>getparam( 'INT1' ) ).
    DATA(pa_int2) = CONV i(  zmn_getsetparams=>getparam( 'INT2' ) ).

    DATA result TYPE string.

    CASE zmn_getsetparams=>getparam( 'OPERATOR' ).

      WHEN '+'.
        result = |{  pa_int1 }+{ pa_int2 } = { pa_int1 + pa_int2 }|.
      WHEN '-'.
        result = |{  pa_int1 }-{ pa_int2 } = { pa_int1 - pa_int2 }|.
      WHEN '*'.
        result = |{  pa_int1 }*{ pa_int2 } = { pa_int1 * pa_int2 }|.
      WHEN '/'.
        IF pa_int2 IS INITIAL.
          result = 'No division by zero allowed'.
        ELSE.
          result = |{  pa_int1 }/{ pa_int2 } = { conv f( pa_int1 / pa_int2 ) DECIMALS  = 2 }|.
        ENDIF.
      WHEN OTHERS.
        result = |Bad operator: {  zmn_getsetparams=>getparam( 'OPERATOR' ) }|.
    ENDCASE.

     out->write( |{ result }| ).

    ENDMETHOD.
ENDCLASS.
