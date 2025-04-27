CLASS zcl_mn_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS init.
    CLASS-METHODS main.
    CLASS-METHODS hello.
    class-METHODS hello_person.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mn_demo IMPLEMENTATION.
  METHOD init.
    zmn_getsetparams=>hideparams(  ).

    zmn_getsetparams=>setparam( description = 'Integer1' parname = 'INT1' parvalue = '66' sequence = '01' overwrite = abap_false ).
    zmn_getsetparams=>setparam( description = 'Integer2' parname = 'INT2' parvalue = '33' sequence = '03' overwrite = abap_false ).
    zmn_getsetparams=>setparam( description = 'Math operator' parname = 'OPERATOR' parvalue = '+' sequence = '02' overwrite = abap_false ).
    zmn_getsetparams=>clearoutput(  ).
    zmn_getsetparams=>writeabap( |Initialized parameters| ).
  ENDMETHOD.

  METHOD main.
    try.
    data(parvalue) =  zmn_getsetparams=>getparam( 'INT1' ).
    DATA(pa_int1) = CONV i(  parvalue ).
    parvalue =  zmn_getsetparams=>getparam( 'INT2' ).
    DATA(pa_int2) = CONV i(  parvalue ).

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
          result = |{  pa_int1 }/{ pa_int2 } = { CONV f( pa_int1 / pa_int2 ) DECIMALS  = 2 }|.
        ENDIF.
      WHEN OTHERS.
        result = |Bad operator: {  zmn_getsetparams=>getparam( 'OPERATOR' ) }|.
    ENDCASE.
    catch cx_root into data(env).
      result = |Error with one of the parameters: { env->get_text(  ) }|.
    endtry.
    zmn_getsetparams=>clearoutput(  ).
    zmn_getsetparams=>writeabap( |================= Demo ===========| ).
    zmn_getsetparams=>writeabap( result ).
  ENDMETHOD.

  METHOD hello.
    zmn_getsetparams=>write( |Hello world!| ).
  ENDMETHOD.

  METHOD hello_person.
    zmn_getsetparams=>writeabap( |Hello, { zmn_getsetparams=>getparam( 'F_NAME' ) }| ).
  ENDMETHOD.

ENDCLASS.
