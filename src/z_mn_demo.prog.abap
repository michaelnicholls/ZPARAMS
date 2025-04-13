*&---------------------------------------------------------------------*
*& Report z_mn_demo
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_mn_demo.

" example of using zparams with on premise ABAP

zmn_getsetparams=>hideparams(  ).

  zmn_getsetparams=>setparam( description = 'Integer1' parname = 'INT1' parvalue = '66' overwrite = abap_false ).
  zmn_getsetparams=>setparam( description = 'Integer2' parname = 'INT2' parvalue = '33' overwrite = abap_false ).
  zmn_getsetparams=>setparam( description = 'Math operator' parname = 'OPERATOR' parvalue = '+' overwrite = abap_false ).
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
write: Result.
