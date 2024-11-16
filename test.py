from ctypes import *

lean_dir = "/Users/ahuja/.elan/toolchains/leanprover--lean4---v4.14.0-rc2/"
lean = CDLL(lean_dir + "lib/lean/libleanshared.dylib", RTLD_GLOBAL)

CDLL("./.lake/packages/batteries/.lake/build/lib/libBatteries.dylib", RTLD_GLOBAL)
ffi = CDLL("./.lake/build/lib/libreverseffiwithmathlib.dylib", RTLD_GLOBAL)


def main():
    lean.lean_initialize_runtime_module()
    lean.lean_initialize()

    builtin = c_uint8(1)
    # Because of static inlines in lean.h, we have to unfold everything
    lean_io_mk_world = c_uint64(1)

    res = ffi.initialize_ReverseFFIWithMathlib(builtin, lean_io_mk_world)

    lean.lean_io_mark_end_initialization()

    print(f"min of 42 7 69 is: {ffi.my_min(42, 7, 69)}")
    print(f"sum of 42 7 is: {ffi.my_add(42, 7)}")

    print(type(lean.lean_mk_string("hello, ")))

    out = ffi.my_concat(lean.lean_mk_string("hello, "), lean.lean_mk_string("world!"))
    print("hi")

    print(f"'hello, '+'world!' is: {out}")


if __name__ == "__main__":
    main()
