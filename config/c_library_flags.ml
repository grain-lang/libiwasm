module C = Configurator.V1

let () =
  C.main ~name:"c_library_flags" (fun c ->
      let default = [] in

      let c_library_flags =
        match C.ocaml_config_var c "system" with
        | Some "mingw64" ->
            (* Ref https://github.com/libuv/libuv/blob/v1.44.2/configure.ac#L77 *)
            ["-liphlpapi"; "-luserenv"; "-luv_a"]
        | Some _ -> default
        | None -> default
      in

      C.Flags.write_sexp "c_library_flags.sexp" c_library_flags)
