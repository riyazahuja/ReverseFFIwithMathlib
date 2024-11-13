#include <iostream>
#include <lean/lean.h>

extern "C" double my_min(size_t, size_t, size_t);
extern "C" size_t my_add(size_t, size_t);




extern "C" void lean_initialize_runtime_module();
extern "C" void lean_initialize();
extern "C" void lean_io_mark_end_initialization();
extern "C" lean_object* initialize_ReverseFFIWithMathlib(uint8_t builtin, lean_object* w);

extern "C" lean_object* my_concat(lean_object*, lean_object*);
extern "C" size_t my_count(lean_object*, uint32_t);
extern "C" lean_object* my_monad(size_t x_1);


int main(){

    lean_initialize_runtime_module();
    lean_object * res;
    uint8_t builtin = 1;
    res = initialize_ReverseFFIWithMathlib(builtin, lean_io_mk_world());
    if (lean_io_result_is_ok(res)) {
        lean_dec_ref(res);
    } else {
        lean_io_result_show_error(res);
        lean_dec(res);
        return 1;  // do not access Lean declarations if initialization failed
    }
    lean_io_mark_end_initialization();

    
    std::cout << "min of 42 7 69 is: " << my_min(42, 7, 69) << std::endl;
    std::cout << "sum of 42 7 is: " << my_add(42, 7) << std::endl;
    std::cout << "'hello, ' + 'world!' is: " << lean_string_cstr(my_concat(lean_mk_string("hello, "),lean_mk_string("world!"))) << std::endl;
    std::cout << "# s in mississippi is: " << my_count(lean_mk_string("mississippi"),'s') << std::endl;
    std::cout << "Test IO monad: " << lean_io_result_get_value(my_monad(10)) << std::endl;
    return 0;
}
