FOR /F "usebackq delims=0" %%i in (`python -c %*\nprint(["SET {0}={1}".format(k,v) for kv in locals().iteritems()])`) do 
