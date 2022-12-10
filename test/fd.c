#include "caml/mlvalues.h"
#include "caml/alloc.h"
#include "caml/memory.h"
#include "caml/fail.h"
#include "caml/signals.h"
#include "caml/custom.h"
#include "caml/callback.h"
#include "caml/bigarray.h"
#include "caml/unixsupport.h"

CAMLprim value int64_of_file_descr(value fd) {
#ifdef _WIN32
    switch (Descr_kind_val(fd)) {
    case KIND_HANDLE:
	return caml_copy_int64((long) (Handle_val(fd)));
    case KIND_SOCKET:
	return caml_copy_int64((long) (Socket_val(fd)));
    }
    return caml_copy_int64(0);
#else
    return caml_copy_int64(Long_val(fd));
#endif
}
