open Ctypes

module Types = Types_generated

module Functions (F : Ctypes.FOREIGN) = struct
  open F

  let wasm_runtime_init = foreign "wasm_runtime_init" (void @-> returning bool)

  let wasm_runtime_destroy = foreign "wasm_runtime_destroy" (void @-> returning void)

  let wasm_runtime_load = foreign "wasm_runtime_load" (ocaml_bytes @-> size_t @-> ocaml_bytes @-> size_t @-> returning Types.wasm_module_t_opt)

  let wasm_runtime_instantiate = foreign "wasm_runtime_instantiate" (Types.wasm_module_t @-> uint32_t @-> uint32_t @-> ocaml_bytes @-> size_t @-> returning Types.wasm_module_inst_t_opt)

  let wasm_application_execute_main = foreign "wasm_application_execute_main" (Types.wasm_module_inst_t @-> int32_t @-> ptr (ptr char) @-> returning bool)

  let wasm_application_execute_func = foreign "wasm_application_execute_func" (Types.wasm_module_inst_t @-> ocaml_bytes @-> int32_t @-> ptr (ptr char) @-> returning bool)

  let wasm_runtime_set_wasi_args = foreign "wasm_runtime_set_wasi_args" (Types.wasm_module_t @-> ptr ocaml_bytes @-> size_t @-> ptr ocaml_bytes @-> size_t @-> ptr ocaml_bytes @-> size_t @-> ptr ocaml_bytes @-> int @-> returning void)
end

