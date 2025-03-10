CLASS zmn_initparams DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZMN_INITPARAMS IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA t_params TYPE TABLE OF zparams.
    DATA(operators) = |+-*/|.
    DATA(rand) = cl_abap_random=>create(  seed = cl_abap_random=>seed(  ) ).

    DELETE FROM zparams.
    SELECT DISTINCT userid FROM I_IAMBusinessUserBusinessRole
      INTO TABLE @DATA(users).

    LOOP AT users INTO DATA(user).

      DATA(offset) = rand->intinrange( low = 0 high = 3 ).
      DATA(op) = substring(  val = operators off = offset len = 1 ).
      t_params = VALUE #(  BASE t_params
                          username = |{ user-userid } |
                          visible = 'Y'
                          ( param = 'INT1' description = 'First integer' value = |{  rand->intinrange(  low = -10  high = 30 ) }| )
                          ( param = 'INT2' description = 'Second integer' value = |{  rand->intinrange(  low = -10  high = 30 ) }| )
                          ( param = 'OPERATOR' description = 'Operator' value = |{ op  }| )
                          (  param = 'FIXED1' description = 'First fixed' value =  |{ ( rand->packedinrange(  min = -30000   max = 30000 ) / 100 ) }| )
                          (  param = 'FIXED2' description = 'Second fixed' value =  |{ ( rand->packedinrange(  min = -30000   max = 30000 ) / 100 ) }| )
                          (  param = 'DATE1'
                          description = 'First date'
                            value =  |{ xco_cp=>sy->date(  )->add( iv_day = rand->intinrange(  low = -30  high = 30 ) )->as(   xco_cp_time=>format->abap
                                             )->value }| )
                             (  param = 'DATE2'
                        description = 'Second date'
                            value =  |{ xco_cp=>sy->date(  )->add( iv_day = rand->intinrange(  low = -30  high = 30 ) )->as(   xco_cp_time=>format->abap
                                             )->value }| )

                          ).


    ENDLOOP.
    MODIFY zparams FROM TABLE @t_params.
    SORT users BY UserID.


    out->write( | {  lines( users ) } users updated| ).
  ENDMETHOD.
ENDCLASS.
