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
     class-METHODS clearoutput.
     class-methods write IMPORTING text type string.
     class-methods writecode IMPORTING text type string.

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
    update zparams set visible = 'X', sequence = @sequence, description = @description where username = @sy-uname and param = @u_parname.
  ENDMETHOD.
  METHOD HIDEPARAMS.
    update zparams set visible = '' where username = @sy-uname and param not in ( 'CLASS','METHOD' ).
  ENDMETHOD.

  METHOD CLEAROUTPUT.
    delete from zoutput where username = @sy-uname.
  ENDMETHOD.

  METHOD WRITE.
    select max( sequence ) from zoutput  where username = @sy-uname into @data(max).
    max = max + 1.
    data output type zoutput.
    output = value #(    username = sy-uname sequence = max text = text ).
    insert zoutput from @output.
  ENDMETHOD.


  METHOD WRITECODE.
     write( |<code>{ text }</code>| ).
  ENDMETHOD.

ENDCLASS.
