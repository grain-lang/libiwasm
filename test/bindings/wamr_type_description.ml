open Ctypes

module Types (F : Ctypes.TYPE) = struct
  open F

  type wasm_module_t

  let wasm_module_t : wasm_module_t structure ptr typ = ptr (structure "WASMModuleCommon")
  let wasm_module_t_opt : wasm_module_t structure ptr option typ = ptr_opt (structure "WASMModuleCommon")

  type wasm_module_inst_t

  let wasm_module_inst_t : wasm_module_inst_t structure ptr typ = ptr (structure "WASMModuleInstanceCommon")
  let wasm_module_inst_t_opt : wasm_module_inst_t structure ptr option typ = ptr_opt (structure "WASMModuleInstanceCommon")
end
