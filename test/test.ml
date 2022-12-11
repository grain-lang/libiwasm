let res = Wamr.Functions.wasm_runtime_init () in
if res == true then print_endline "wasm_runtime_init success" else print_endline "wasm_runtime_init fail";

let input = open_in_bin "test.gr.wasm" in
let data = really_input_string input (in_channel_length input) in
let () = print_endline "Data read" in

let buf = Cstruct_cap.of_string data in
let buf_start = Ctypes.(bigarray_start array1 (Cstruct_cap.unsafe_to_bigarray buf)) in
let buf_size = Bigarray.Array1.size_in_bytes (Cstruct_cap.unsafe_to_bigarray buf) in
let () = print_endline "buf created" in
let error_buf = Cstruct_cap.create 1000 in
let error_start = Ctypes.(bigarray_start array1 (Cstruct_cap.unsafe_to_bigarray error_buf)) in
let error_size = Bigarray.Array1.size_in_bytes (Cstruct_cap.unsafe_to_bigarray error_buf) in
let charptr_to_uint8ptr = Ctypes.(coerce (ptr char) (ptr uint8_t)) in
let wasm_mod = Wamr.Functions.wasm_runtime_load (charptr_to_uint8ptr buf_start) (Unsigned.UInt32.of_int buf_size) error_start (Unsigned.UInt32.of_int error_size) in
let () = print_endline "wasm_mod created" in
let () = print_endline (Cstruct_cap.to_string error_buf) in
let nothing = fun () -> Ctypes.(from_voidp (ptr char) null) in
let zero = fun () -> (Unsigned.UInt32.of_int 0) in
(* let dir1 = Ctypes.CArray.of_string "." in
let dir1_start = Ctypes.CArray.start dir1 in
let dir2 = Ctypes.CArray.of_string "/tmp" in
let dir2_start = Ctypes.CArray.start dir2 in
let dirs = Ctypes.CArray.of_list Ctypes.(ptr char) [dir1_start; dir2_start] in *)
let stdin = Unix.openfile "./stdin" [Unix.O_CREAT; O_RDWR] 0o777 in
let stdout = Unix.openfile "./stdout" [Unix.O_CREAT; O_RDWR] 0o777 in
let stderr = Unix.openfile "./stderr" [Unix.O_CREAT; O_RDWR] 0o777 in
(* let (_, stderr) = Unix.pipe () in *)
let stdin = Fd.int64_of_file_descr stdin in
let stdout = Fd.int64_of_file_descr stdout in
let stderr = Fd.int64_of_file_descr stderr in
let () = Wamr.Functions.wasm_runtime_set_wasi_args_ex wasm_mod (nothing ()) (zero ()) (nothing ()) (zero ()) (nothing ()) (zero ()) (nothing ()) 0 stdin stdout stderr in
(* let () = Wamr.Functions.wasm_runtime_set_wasi_args wasm_mod (Ctypes.CArray.start dirs) (Unsigned.UInt32.of_int 2) (nothing ()) (zero ()) (nothing ()) (zero ()) (nothing ()) 0 in *)
let () = print_endline "wasi stuff set" in
let wasm_mod_inst = Wamr.Functions.wasm_runtime_instantiate wasm_mod (Unsigned.UInt32.of_int 8192) (Unsigned.UInt32.of_int 8192) error_start (Unsigned.UInt32.of_int error_size) in
let () = print_endline "wasm_mod instantiated" in
let () = print_endline (Cstruct_cap.to_string error_buf) in
let start_func_buf = Cstruct_cap.of_string "_start" in
let start_func_start = Ctypes.(bigarray_start array1 (Cstruct_cap.unsafe_to_bigarray start_func_buf)) in
let success = Wamr.Functions.wasm_application_execute_func wasm_mod_inst start_func_start (Signed.Int32.of_int 0) (Ctypes.from_voidp (Ctypes.ptr Ctypes.char) Ctypes.null) in
let () = if success then print_endline "Ran successfully" else print_endline "Failed to run" in
let () = Wamr.Functions.wasm_runtime_destroy () in
print_endline "wasm_runtime_destroy"
