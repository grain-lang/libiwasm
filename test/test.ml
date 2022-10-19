let res = Wamr.Functions.wasm_runtime_init () in
if res == true then print_endline "wasm_runtime_init success" else print_endline "wasm_runtime_init fail";

let _ = Wamr.Functions.wasm_runtime_destroy () in
print_endline "wasm_runtime_destroy"
