CLASS zmn_getsetparams DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS getparam
      IMPORTING parname         TYPE zparams-param
      RETURNING VALUE(parvalue) TYPE zparams-value.
    CLASS-METHODS setparam
      IMPORTING parname     TYPE zparams-param
                parvalue    TYPE zparams-value
                description TYPE zparams-description
                sequence  type zparams-sequence
                overwrite   TYPE abap_boolean.
     class-METHODS hideparams.
    .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZMN_GETSETPARAMS IMPLEMENTATION.


  METHOD getparam.
    data(u_parname) = to_upper(  parname  ).
    CLEAR parvalue.
    SELECT SINGLE value FROM zparams
      WHERE username = @sy-uname
        AND param    = @u_parname
      INTO @parvalue.
    update zparams set visible = 'X' where
    username = @sy-uname
        AND param    = @u_parname.
  ENDMETHOD.


  METHOD setparam.
    " TODO: parameter OVERWRITE is never used (ABAP cleaner)

    DATA params TYPE zparams.
    data(u_parname) = to_upper(  parname  ).

    " is it already there?
    SELECT COUNT( * ) FROM zparams
      WHERE username = @sy-uname
        AND param    = @u_parname
      INTO @DATA(counter).
    IF counter = 0 or overwrite = abap_true .
      params = VALUE #( username    = sy-uname
                        param       = parname
                        description = description
                        sequence = sequence
                        value       = parvalue ).
      MODIFY zparams FROM @params.
    ENDIF.
    update zparams set visible = 'X', sequence = @sequence where username = @sy-uname and param = @u_parname.
  ENDMETHOD.
  METHOD HIDEPARAMS.
    update zparams set visible = ''.
  ENDMETHOD.

ENDCLASS.
