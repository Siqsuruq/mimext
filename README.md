# mimext
Tcl Package to get file extention from MIME Type and vise versa. MimeMapper.

Example usage:
----------------------------------------------------------------------------------------------------------
<pre>
% package require mimext
1.1
% mimext get_ext application/pdf
.pdf
% mimext get_mime .ods
application/vnd.oasis.opendocument.spreadsheet
% mimext get_discrete_type application/json
application
% mimext is_valid_extension .xml
1
% mimext is_valid_extension .xmk 
0
</pre>

IANA official references in data folder.
