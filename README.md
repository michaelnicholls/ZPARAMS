# ZPARAMS

Has a table ZPARAMS which holds parameters for a specific user, plus a description, and a value.

There is a global class ZMN_GETSETPARAMS with two class methods:
SETPARAM which sets a value for a paramter, with the option of overwriting a current value
and GETPARAM which returns the value of a parameter.

For quickly setting up some random values for all the users, there is ZMN_INITPARAMS, and a small demo calculator ZCL_MN_DEMO.

There is also an HTTP service ZMN_HTTP which in GET mode, returns a table of the current value of the parameters for a user, 
and in POST mode updates the values.

If you have problems after cloning the repo, try deleting the ZMn_HTTP service and its associated authorizations. Recreeate the service, using the 
ZCL_MN_HTTP handler class, ans publish it locally.
