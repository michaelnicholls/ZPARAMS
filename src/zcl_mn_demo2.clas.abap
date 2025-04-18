CLASS zcl_mn_demo2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  class-METHODS init.
  class-methods main.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mn_demo2 IMPLEMENTATION.
  METHOD init.
zmn_getsetparams=>hideparams(  ).

  zmn_getsetparams=>setparam( description = 'Integer1' parname = 'INT1' parvalue = '66' sequence = '01' overwrite = abap_false ).
  zmn_getsetparams=>setparam( description = 'Integer2' parname = 'INT2' parvalue = '33' sequence = '03' overwrite = abap_false ).
  zmn_getsetparams=>setparam( description = 'Math operator' parname = 'OPERATOR' parvalue = '+' sequence = '02' overwrite = abap_false ).
  zmn_getsetparams=>clearoutput(  ).
  zmn_getsetparams=>write( |Initialized parameters| ).
  ENDMETHOD.

  METHOD main.
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
zmn_getsetparams=>clearoutput(  ).
zmn_getsetparams=>write( |=================Demo 2===========| ).
zmn_getsetparams=>write( result ).
  ENDMETHOD.

ENDCLASS.
