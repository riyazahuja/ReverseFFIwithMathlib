#include <iostream>
#include <lean/lean.h>

extern "C" size_t my_add(size_t, size_t);




extern "C" void lean_initialize_runtime_module();
extern "C" void lean_initialize();
extern "C" void lean_io_mark_end_initialization();
extern "C" lean_object* initialize_ReverseFFIWithMathlib(uint8_t builtin, lean_object* w);
extern "C" lean_object* initialize_localDep(uint8_t builtin, lean_object* w);


extern "C" lean_object* my_min(size_t, size_t, size_t);


extern "C" lean_object* my_concat(lean_object*, lean_object*);
extern "C" size_t my_count(lean_object*, uint32_t);
extern "C" lean_object* my_monad(uint32_t x_1, lean_object* w);
extern "C" lean_object* my_local(lean_object* s);
extern "C" uint64_t my_factorial(uint64_t n);



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

    



    //Real code starts here!

    //External (Batteries) dependency
    std::cout << "min of 42 7 69 is: " << lean_unbox_usize(my_min(42, 7, 69)) << std::endl;

    //Basic sum function
    std::cout << "sum of 42 7 is: " << my_add(42, 7) << std::endl;

    //Basic string functions
    std::cout << "'hello, ' + 'world!' is: " << lean_string_cstr(my_concat(lean_mk_string("hello, "),lean_mk_string("world!"))) << std::endl;

    //External (Batteries) dependency for strings
    std::cout << "# s in mississippi is: " << my_count(lean_mk_string("mississippi"),'s') << std::endl;


    //IO monad stuff
    lean_object* world = lean_io_mk_world();
    lean_object* io_result = my_monad(10, world);

    if (lean_io_result_is_ok(io_result)) {

        lean_object* lean_value = lean_io_result_get_value(io_result);    
        uint32_t cpp_value = lean_unbox(lean_value);

        std::cout << "Test IO monad: " << cpp_value << std::endl;
        lean_dec_ref(world);
        lean_dec_ref(io_result);
    } else {
        lean_io_result_show_error(io_result);
        lean_dec_ref(world);
        lean_dec_ref(io_result);
        return 1;
    }

    lean_dec_ref(io_result);


    //Local dependency
    std::cout << "Test local dependencies: " << lean_string_cstr(my_local(lean_mk_string("world"))) << std::endl;
    

    //Factorial function timing
    auto start = std::chrono::high_resolution_clock::now();
    uint64_t fact = my_factorial(20);
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> elapsed = end - start;
    double time = elapsed.count();

    std::cout << "20! = " << fact << " | Took " << time << "seconds" << std::endl;
    return 0;
}
