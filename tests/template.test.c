#include <dwelui/template.h>
#include <dwelui/test.h>
#include <string.h>

TEST(test, {
    test_assert(strcmp(template_return_hello_world(), "Hello world!") == 0);
})
