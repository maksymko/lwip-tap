#include <catch2/catch_test_macros.hpp>

#include <taplib/utils.h>

#include <errno.h>
#include <fcntl.h>
#include <net/if.h>
#include <string.h>
#include <unistd.h>


TEST_CASE("Test Tap Creation", "[tap]")
{
    struct TapInfo tap_info;
    memset(&tap_info, 0, sizeof(tap_info));

    int rc = taplib_init(&tap_info);
    CAPTURE(strerror(errno));
    REQUIRE(rc == 0);
    REQUIRE(tap_info.m_fd > 0);

    int flags = fcntl(tap_info.m_fd, F_GETFD);
    REQUIRE(flags != -1);

    size_t iface_name_len = strnlen(tap_info.m_iface_name, IFNAMSIZ);
    CHECK(iface_name_len > 0);
}
