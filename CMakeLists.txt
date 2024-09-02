cmake_minimum_required(VERSION 3.22)

project(LwIP-TAPIF)

set(CMAKE_CXX_STANDARD 17)

find_package(Threads REQUIRED)

add_compile_options(-Wall -fdiagnostics-color=always)

add_library(lwip_config INTERFACE)

set(IP_VERSION ipv4)
target_include_directories(lwip_config
    INTERFACE
    ${CMAKE_SOURCE_DIR}
    lwip-contrib/ports/unix/port/include
    lwip/src/include/${IP_VERSION}
)

add_library(lwip_headers INTERFACE)
target_include_directories(lwip_headers
    INTERFACE
    lwip/src/include
)

add_library(lwip_unix STATIC
  lwip-contrib/ports/unix/port/sys_arch.c
)

target_link_libraries(lwip_unix
    PRIVATE
    lwip_config
    PUBLIC
    lwip_headers
)

add_library(lwip_api STATIC
  lwip/src/api/api_lib.c
  lwip/src/api/api_msg.c
  lwip/src/api/err.c
  lwip/src/api/netbuf.c
  lwip/src/api/netdb.c
  lwip/src/api/netifapi.c
  lwip/src/api/sockets.c
  lwip/src/api/tcpip.c
)

target_link_libraries(lwip_api
    PRIVATE
    lwip_config
    lwip_unix
    PUBLIC
    lwip_headers
)

add_library(lwip_core STATIC
  lwip/src/core/def.c
  lwip/src/core/dns.c
  lwip/src/core/inet_chksum.c
  lwip/src/core/init.c
  lwip/src/core/ip.c
  lwip/src/core/ipv4/acd.c
  lwip/src/core/ipv4/autoip.c
  lwip/src/core/ipv4/dhcp.c
  lwip/src/core/ipv4/etharp.c
  lwip/src/core/ipv4/icmp.c
  lwip/src/core/ipv4/igmp.c
  lwip/src/core/ipv4/ip4.c
  lwip/src/core/ipv4/ip4_addr.c
  lwip/src/core/ipv4/ip4_frag.c
  lwip/src/core/mem.c
  lwip/src/core/memp.c
  lwip/src/core/netif.c
  lwip/src/core/netif.c
  lwip/src/core/pbuf.c
  lwip/src/core/raw.c
  lwip/src/core/stats.c
  lwip/src/core/sys.c
  lwip/src/core/tcp.c
  lwip/src/core/tcp_in.c
  lwip/src/core/tcp_out.c
  lwip/src/core/timeouts.c
  lwip/src/core/udp.c
  lwip/src/netif/ethernet.c
)

target_link_libraries(lwip_core
    PRIVATE
    lwip_config
    PUBLIC
    lwip_headers
)

add_library(lwip_contrib_apps STATIC
  lwip-contrib/apps/chargen/chargen.c
  lwip-contrib/apps/httpserver/httpserver-netconn.c
  lwip-contrib/apps/tcpecho/tcpecho.c
  lwip-contrib/apps/udpecho/udpecho.c
)

target_link_libraries(lwip_contrib_apps
    PRIVATE
    lwip_config
    PUBLIC
    lwip_headers
    lwip_api
    lwip_core
)
target_include_directories(lwip_contrib_apps
    INTERFACE
    lwip-contrib/apps
)


add_library(my_tapif STATIC tapif.c)
target_include_directories(my_tapif
    PUBLIC
    ${CMAKE_SOURCE_DIR}
)
target_link_libraries(my_tapif
    PUBLIC
    lwip_core
    lwip_config
)

add_executable(lwip-tap lwip-tap.c)
target_link_libraries(lwip-tap
    PRIVATE
    my_tapif
    lwip_core
    lwip_api
    lwip_config
    lwip_contrib_apps
    lwip_unix
)
