let res = Wamr.Functions.wasm_runtime_init () in
if res == true then print_endline "wasm_runtime_init success" else print_endline "wasm_runtime_init fail";

let input = open_in_bin "test.gr.wasm" in
let len = (in_channel_length input) in
let byts = Bytes.create len in
let () = really_input input byts 0 len in
let () = print_endline "Data read" in

let buf_start = Ctypes.ocaml_bytes_start byts in
let buf_size = Bytes.length byts in
let error_buf = Bytes.create 128 in
let error_start = Ctypes.ocaml_bytes_start error_buf in
let error_size = Bytes.length error_buf in
let wasm_mod = Wamr.Functions.wasm_runtime_load buf_start (Unsigned.Size_t.of_int buf_size) error_start (Unsigned.Size_t.of_int error_size) in
let () = match wasm_mod with
  | None -> print_endline (Bytes.to_string error_buf)
  | Some(wasm_mod) -> let () = print_endline "wasm_mod created" in
    let nothing = fun () -> Ctypes.(from_voidp ocaml_bytes null) in
    let zero = fun () -> (Unsigned.Size_t.of_int 0) in
    let () = Wamr.Functions.wasm_runtime_set_wasi_args wasm_mod (nothing ()) (zero ()) (nothing ()) (zero ()) (nothing ()) (zero ()) (nothing ()) 0 in
    let () = print_endline "wasi stuff set" in
    let wasm_mod_inst = Wamr.Functions.wasm_runtime_instantiate wasm_mod (Unsigned.UInt32.of_int 8192) (Unsigned.UInt32.of_int 8192) error_start (Unsigned.Size_t.of_int error_size) in
    let () = match (wasm_mod_inst) with
      | None -> print_endline (Bytes.to_string error_buf)
      | Some(wasm_mod_inst) -> let () = print_endline "wasm_mod instantiated" in
        let start_func_buf = Bytes.of_string "_start" in
        let start_func_start = Ctypes.ocaml_bytes_start start_func_buf in
        let success = Wamr.Functions.wasm_application_execute_func wasm_mod_inst start_func_start (Signed.Int32.of_int 0) (Ctypes.from_voidp (Ctypes.ptr Ctypes.char) Ctypes.null) in
        let () = if success then print_endline "Ran successfully" else print_endline "Failed to run" in
        let () = Wamr.Functions.wasm_runtime_destroy () in
        print_string "wasm_runtime_destroy" in () in ()
