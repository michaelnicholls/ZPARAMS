# ZPARAMS

Has a table ZPARAMS which holds pareameters for a specific user, plus a description, and a value.

There is a global class ZMN_GETSETPARAMS with two class methods:
SETPARAM which sets a value for a paramter, with the option of overwriting a current value
GETPARAM which returns the value of a parameter

There is also an HTTP service ZMN_HTTP which in GET mode, returns a table of the current value of the parameters for a user, 
and in POST mode updates the values.
