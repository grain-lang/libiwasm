open Ctypes

(* module Types = Types_generated *)

module Functions (F : Ctypes.FOREIGN) = struct
  open F

  let wasm_runtime_init = foreign "wasm_runtime_init" (void @-> returning bool)

  let wasm_runtime_destroy = foreign "wasm_runtime_destroy" (void @-> returning void)
end

