# ZPARAMS

Has a table ZPARAMS which holds parameters for a specific user, plus a description, and a value.
There is also a table ZOUTOUT which holds any outputs.

There is a global class ZMN_GETSETPARAMS with two class methods:
SETPARAM which sets a value for a paramter, with the option of overwriting a current value, and a sequence number
and GETPARAM which returns the value of a parameter.

For quickly setting up some random values for all the users, there is ZMN_INITPARAMS (BTP ABAP only), and a small demo calculator ZCL_MN_DEMO (BTP ABAP) 
or Z_MN_DEMO ABAP report (on premise).

On BTP ABAP, there is an HTTP service ZMN_HTTP which in GET mode, returns a table of the current value of the parameters for a user, 
and in POST mode updates the values.

If you have problems after cloning the repo, try deleting the ZMN_HTTP service and its associated authorizations. Recreate the service, using the 
ZCL_PARAMS_HTTP handler class, and publish it locally.

With on premise ABAP, if necessary, create an SICF node with handler ZCL_PARAMS_SICF. Activate and use Test to start the page to change parameters.

