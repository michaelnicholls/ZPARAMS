CLASS zmn_initparams DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS init .
  PRIVATE SECTION.
ENDCLASS.



CLASS zmn_initparams IMPLEMENTATION.
  METHOD init.
    DATA t_params TYPE TABLE OF zparams.

    DATA(operators) = |+-*/|.
    DATA(rand) = cl_abap_random=>create( seed = cl_abap_random=>seed( ) ).

    DATA(offset) = rand->intinrange( low  = 0
                                     high = 3 ).
    DATA(op) = substring( val = operators
                          off = offset
                          len = 1 ).
    t_params = VALUE #(
        BASE t_params
        username = |{ sy-uname } |
        visible  = 'X'
        ( param       = 'INT1'
          description = 'First integer'
          value       = |{  rand->intinrange( low  = -10
                                              high = 30 ) }| )
        ( param       = 'INT2'
          description = 'Second integer'
          value       = |{  rand->intinrange( low  = -10
                                              high = 30 ) }| )
        ( param = 'OPERATOR' description = 'Operator' value = |{ op  }| )
        ( param       = 'FIXED1'
          description = 'First fixed'
          value       = |{ ( rand->packedinrange( min = -30000
                                                  max = 30000 ) / 100 ) }| )
        ( param       = 'FIXED2'
          description = 'Second fixed'
          value       = |{ ( rand->packedinrange( min = -30000
                                                  max = 30000 ) / 100 ) }| )
        ( param       = 'DATE1'
          description = 'First date'
          value       = |{ xco_cp=>sy->date( )->add( iv_day = rand->intinrange( low  = -30
                                                                                high = 30 ) )->as(
                                                                                           xco_cp_time=>format->abap
                                )->value }| )
        ( param       = 'DATE2'
          description = 'Second date'
          value       = |{ xco_cp=>sy->date( )->add( iv_day = rand->intinrange( low  = -30
                                                                                high = 30 ) )->as(
                                                                                           xco_cp_time=>format->abap
             )->value }| ) ).

    MODIFY zparams FROM TABLE @t_params.

    zmn_getsetparams=>writecode( |Demo parameters created| ).
  ENDMETHOD.
ENDCLASS.
