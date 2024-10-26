CLASS zmn_initparams DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PRIVATE SECTION.
ENDCLASS.


CLASS zmn_initparams IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA t_params TYPE TABLE OF zparams.
    data(operators) = |+-*/|.
    data(rand) = cl_abap_random=>create(  seed = cl_abap_random=>seed(  ) ).

    DELETE FROM zparams.
    SELECT DISTINCT userid FROM I_IAMBusinessUserBusinessRole
      INTO TABLE @DATA(users).

    LOOP AT users INTO DATA(user).

    data(offset) = rand->intinrange( low = 0 high = 3 ).
    data(op) = substring(  val = operators off = offset len = 1 ).
      t_params = VALUE #(  BASE t_params
                          username = |{ user-userid } |
                          ( param = 'INT1' description = 'First integer' value = |{  rand->intinrange(  low = 1 high = 30 ) }| )
                          ( param = 'INT2' description = 'Second integer' value = |{  rand->intinrange(  low = 1 high = 30 ) }| )
                          ( param = 'OPERATOR' description = 'Operator' value = |{ op  }| ) ).


    ENDLOOP.
       MODIFY zparams FROM TABLE @t_params.
    sort users BY UserID.


    out->write( | {  lines( users ) } users updated| ).
  ENDMETHOD.

ENDCLASS.
