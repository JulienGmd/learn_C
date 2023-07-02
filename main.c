#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    char *test_micro = getenv("TEST_MICRO");
    char *test_micro = getenv("abc");
    printf("TEST_MICRO: %s\n", test_micro);
}