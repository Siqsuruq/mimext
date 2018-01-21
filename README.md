# mimext
Tcl Package to get file extention from MIME Type

Example usage:
----------------------------------------------------------------------------------------------------------
% package require mimext
1.0
% ::mimext::get_ext application/pdf
application .pdf
% set file_ext [lindex [::mimext::get_ext application/vnd.ms-powerpoint.presentation.macroenabled.12] 1]
.pptm
