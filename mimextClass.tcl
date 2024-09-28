package provide mimext 1.1
package require Tcl 8.6

oo::class create mimextClass {
    # Top-Level Media Types: https://www.iana.org/assignments/top-level-media-types/top-level-media-types.xhtml#top-level-media-types
	variable topLevelMediaTypes
    variable extToMime
    variable mimeToExt 
    
    constructor { } {
        set topLevelMediaTypes [list application audio example font haptics image message model multipart text video]
        set extToMime [dict create]
        set mimeToExt [dict create]
        try {
            set mimecvs [file join [file dirname [info script]] mime_mappings.txt]
            set file [open $mimecvs r]

            # Read each line, split by comma and populate the dictionaries
            while {[gets $file line] != -1} {
                # Skip empty lines
                if {[string trim $line] eq ""} {
                    continue
                }
                # Split the line by comma to separate mime and extension
                set mimeExt [split $line ","]
                set mimeType [lindex $mimeExt 0]
                set extension [lindex $mimeExt 1]
                # Populate extToMime dictionary
                if {[dict exists $extToMime $extension]} {
                    dict lappend extToMime $extension $mimeType
                } else {
                    dict set extToMime $extension [list $mimeType]
                }

                # Populate mimeToExt dictionary
                if {[dict exists $mimeToExt $mimeType]} {
                    dict lappend mimeToExt $mimeType $extension
                } else {
                    dict set mimeToExt $mimeType [list $extension]
                }
            }
        } finally {
            close $file
        }
    }

    method get_ext {mimeString} {
        try {
            # Normalize mimeString to lowercase for case-insensitive comparison
            set mimeString [string tolower $mimeString]
            if {[dict exists $mimeToExt $mimeString] != 0} {
                return [dict get $mimeToExt $mimeString]
            } else {
                return -code error "Can't find mimetype to extension mapping."
            }
        } on error {errMsg} {
            return -code error "Error in get_ext method: $errMsg"
        }
    }

    method get_mime {extString} {
        try {
            # Normalize extString to lowercase for case-insensitive comparison
            set extString [string tolower $extString]
            if {[dict exists $extToMime $extString] != 0} {
                return [dict get $extToMime $extString]
            } else {
                return -code error "Can't find extension to mimetype mapping."
            }
        } on error {errMsg} {
            return -code error "Error in get_mime method: $errMsg"
        }
    }

    # There are two classes of type: discrete and multipart. 
    # Discrete types are types which represent a single file or medium, such as a single text or music file, or a single video. 
    # A multipart type represents a document that's comprised of multiple component parts, each of which may have its own individual MIME type; or, a multipart type may encapsulate multiple files being sent together in one transaction. 
    # For example, multipart MIME types are used when attaching multiple files to an email.
    # The type is the first part of the MIME type, such as text, image, audio, video, application, or multipart.
    # The subtype is the second part of the MIME type, such as plain, html, jpeg, gif, mp3, mpeg, pdf, zip, or mixed.

    method get_discrete_type {mimeString} {
        try {
            set ix [string first / $mimeString]
            if {$ix >= 0} {
                incr ix -1
                set discrete_type [string range $mimeString 0 $ix]
            } else {
                return -code error "Invalid MIME type: $mimeString"
            }
            if {$discrete_type eq "multipart" || $discrete_type eq "message"} {
                set discrete_type "multipart"
            }
            return -code ok $discrete_type
        } on error {errMsg} {
            return -code error "Error in get_discrete_type method: $errMsg"
        }
    }

    method is_valid_extension {extString} {
        # Normalize extension to lowercase to handle case insensitivity
        set extString [string tolower $extString]
        
        # Check if the given extension exists in the extToMime dictionary
        if {[dict exists $extToMime $extString]} {
            return 1  ;# Extension is valid
        } else {
            return 0  ;# Extension is not valid
        }
    }

    method is_valid_mime {mimeString} {
        # Normalize mimeString to lowercase for case-insensitive comparison
        set mimeString [string tolower $mimeString]
        # Check if the given MIME type exists in the mimeToExt dictionary
        if {[dict exists $mimeToExt $mimeString]} {
            return 1  ;# MIME type is valid
        } else {
            return 0  ;# MIME type is not valid
        }
    }
}

mimextClass create mimext