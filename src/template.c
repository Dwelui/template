#include <dwelui/template.h>
#include <stdio.h>

void template_print_hello_world() {
    printf("%s", template_return_hello_world());
}

const char *template_return_hello_world() {
    return "Hello world!";
}
