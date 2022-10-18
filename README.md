# libiwasm

The iwasm core from [wasm-micro-runtime](https://github.com/bytecodealliance/wasm-micro-runtime) packaged for OCaml.

This is just the low-level C library. If you are looking for OCaml bindings to WAMR, keep an eye out for our bindings!

## Usage

Inside your dune file, you can depend on libiwasm as such:

```dune
(library
 (name wamr)
 (public_name wamr)
 (libraries libiwasm)
 (foreign_stubs
  (language c)
  (names wamr_stubs)
  (flags :standard)))
```

We also support the new dune `ctypes` stanza:

```dune
(library
 (name wamr)
 (libraries libiwasm)
 (flags
  (:standard -w -9-27-33))
 (ctypes
  (external_library_name wamr)
  (build_flags_resolver
   (vendored
    (c_flags :standard)
    (c_library_flags :standard)))
  (headers
   (preamble "#include \"%{lib:libiwasm:wasm_export.h}\""))
  (type_description
   (instance Type)
   (functor Wamr_type_description))
  (function_description
   (concurrency sequential)
   (instance Functions)
   (functor Wamr_function_description))
  (generated_types Types_generated)
  (generated_entry_point Wamr)))
```

## Configuration

This project currently configures iwasm to support the needs of [Grain](https://grain-lang.org/), but we plan to support configuration through the `substs` field of our opam file once esy supports it.

The current configuration can be found in our [CMakeLists file](./CMakeLists.txt).

## Contributing

You'll need Node.js and [`esy`](https://esy.sh/docs/en/getting-started.html#install-esy) to build this project.
You should be able to use Opam if you are more comfortable with it, but the core team does all development using esy.

`dune` will take care of compiling WAMR, so to build the project you'll only need to run:

```bash
esy
```

This will take a while. Once it's done, you can run the tests:

```bash
esy test
```
