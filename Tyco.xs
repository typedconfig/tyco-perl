#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "../tyco-c/include/tyco_c.h"

MODULE = Tyco           PACKAGE = Tyco

SV*
_load_file_json(path)
    const char* path
  CODE:
    tyco_json_result result = tyco_parse_file_json(path);
    if(result.status != TYCO_OK) {
        const char* message = result.error ? result.error : "Unknown error";
        tyco_json_result_free(&result);
        croak("Tyco parse error: %s", message);
    }
    RETVAL = newSVpv(result.json ? result.json : "", 0);
    tyco_json_result_free(&result);
  OUTPUT:
    RETVAL

SV*
_load_string_json(content, name = "<string>")
    const char* content
    const char* name
  CODE:
    tyco_json_result result = tyco_parse_string_json(content, name);
    if(result.status != TYCO_OK) {
        const char* message = result.error ? result.error : "Unknown error";
        tyco_json_result_free(&result);
        croak("Tyco parse error: %s", message);
    }
    RETVAL = newSVpv(result.json ? result.json : "", 0);
    tyco_json_result_free(&result);
  OUTPUT:
    RETVAL
