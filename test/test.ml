let res = Wamr.Functions.wasm_runtime_init () in
if res == true then print_endline "wasm_runtime_init success" else print_endline "wasm_runtime_init fail";

let input = open_in_bin "test.gr.wasm" in
let data = really_input_string input (in_channel_length input) in

let buf = Cstruct_cap.of_string data in
let buf_start = Ctypes.(bigarray_start array1 (Cstruct_cap.unsafe_to_bigarray buf)) in
let buf_size = Bigarray.Array1.dim (Cstruct_cap.unsafe_to_bigarray buf) in
let error_buf = Cstruct_cap.create 1000 in
let error_start = Ctypes.(bigarray_start array1 (Cstruct_cap.unsafe_to_bigarray error_buf)) in
let error_size = Bigarray.Array1.dim (Cstruct_cap.unsafe_to_bigarray error_buf) in
let charptr_to_uint8ptr = Ctypes.(coerce (ptr char) (ptr uint8_t)) in
let wasm_mod = Wamr.Functions.wasm_runtime_load (charptr_to_uint8ptr buf_start) (Unsigned.UInt32.of_int buf_size) error_start (Unsigned.UInt32.of_int error_size) in
let nothing = fun () -> Ctypes.(from_voidp (ptr char) null) in
let zero = fun () -> (Unsigned.UInt32.of_int 0) in
let () = Wamr.Functions.wasm_runtime_set_wasi_args_ex wasm_mod (nothing ()) (zero ()) (nothing ()) (zero ()) (nothing ()) (zero ()) (nothing ()) 0 0 1 2 in
(* let _ = print_endline (Cstruct_cap.to_string error_buf) in *)
let wasm_mod_inst = Wamr.Functions.wasm_runtime_instantiate wasm_mod (Unsigned.UInt32.of_int 8192) (Unsigned.UInt32.of_int 8192) error_start (Unsigned.UInt32.of_int error_size) in
(* let _ = print_endline (Cstruct_cap.to_string error_buf) in *)
let start_func_buf = Cstruct_cap.of_string "_start" in
let start_func_start = Ctypes.(bigarray_start array1 (Cstruct_cap.unsafe_to_bigarray start_func_buf)) in
let success = Wamr.Functions.wasm_application_execute_func wasm_mod_inst start_func_start (Signed.Int32.of_int 0) (Ctypes.from_voidp (Ctypes.ptr Ctypes.char) Ctypes.null) in
let _ = if success then print_endline "Ran successfully" else print_endline "Failed to run" in
let _ = Wamr.Functions.wasm_runtime_destroy () in
print_endline "wasm_runtime_destroy"
