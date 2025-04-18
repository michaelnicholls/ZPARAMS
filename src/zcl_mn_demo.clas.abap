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
" example of zparams using btp
  zmn_getsetparams=>hideparams(  ).

  " getparam will make it visible in the HTML page

    DATA(int1) = CONV i(  zmn_getsetparams=>getparam( 'INT1' ) ).
    DATA(int2) = CONV i(  zmn_getsetparams=>getparam( 'INT2' ) ).

    DATA result TYPE string.

    CASE zmn_getsetparams=>getparam( 'OPERATOR' ).

      WHEN '+'.
        result = |{  int1 }+{ int2 } = { int1 + int2 }|.
      WHEN '-'.
        result = |{  int1 }-{ int2 } = { int1 - int2 }|.
      WHEN '*'.
        result = |{  int1 }*{ int2 } = { int1 * int2 }|.
      WHEN '/'.
        IF int2 IS INITIAL.
          result = 'No division by zero allowed'.
        ELSE.
          result = |{  int1 }/{ int2 } = { conv f( int1 / int2 ) DECIMALS  = 2 }|.
        ENDIF.
      WHEN OTHERS.
        result = |Bad operator: {  zmn_getsetparams=>getparam( 'OPERATOR' ) }|.
    ENDCASE.

     out->write( |{ result }| ).

    ENDMETHOD.
ENDCLASS.
