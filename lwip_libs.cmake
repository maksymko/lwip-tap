add_library(lwip_config INTERFACE)

set(LWIP_DIR thirdparty/lwip)
set(LWIP_CONTRIB_DIR thirdparty/lwip-contrib)

set(IP_VERSION ipv4)
target_include_directories(lwip_config
    INTERFACE
    ${CMAKE_SOURCE_DIR}
    ${LWIP_CONTRIB_DIR}/ports/unix/port/include
    ${LWIP_DIR}/src/include/${IP_VERSION}
)

add_library(lwip_headers INTERFACE)
target_include_directories(lwip_headers
    INTERFACE
    ${LWIP_DIR}/src/include
)

add_library(lwip_unix STATIC
    ${LWIP_CONTRIB_DIR}/ports/unix/port/sys_arch.c
)

target_link_libraries(lwip_unix
    PRIVATE
    lwip_config
    PUBLIC
    lwip_headers
)

add_library(lwip_api STATIC
    ${LWIP_DIR}/src/api/api_lib.c
    ${LWIP_DIR}/src/api/api_msg.c
    ${LWIP_DIR}/src/api/err.c
    ${LWIP_DIR}/src/api/netbuf.c
    ${LWIP_DIR}/src/api/netdb.c
    ${LWIP_DIR}/src/api/netifapi.c
    ${LWIP_DIR}/src/api/sockets.c
    ${LWIP_DIR}/src/api/tcpip.c
)

target_link_libraries(lwip_api
    PRIVATE
    lwip_config
    lwip_unix
    PUBLIC
    lwip_headers
)

add_library(lwip_core STATIC
    ${LWIP_DIR}/src/core/def.c
    ${LWIP_DIR}/src/core/dns.c
    ${LWIP_DIR}/src/core/inet_chksum.c
    ${LWIP_DIR}/src/core/init.c
    ${LWIP_DIR}/src/core/ip.c
    ${LWIP_DIR}/src/core/ipv4/acd.c
    ${LWIP_DIR}/src/core/ipv4/autoip.c
    ${LWIP_DIR}/src/core/ipv4/dhcp.c
    ${LWIP_DIR}/src/core/ipv4/etharp.c
    ${LWIP_DIR}/src/core/ipv4/icmp.c
    ${LWIP_DIR}/src/core/ipv4/igmp.c
    ${LWIP_DIR}/src/core/ipv4/ip4.c
    ${LWIP_DIR}/src/core/ipv4/ip4_addr.c
    ${LWIP_DIR}/src/core/ipv4/ip4_frag.c
    ${LWIP_DIR}/src/core/mem.c
    ${LWIP_DIR}/src/core/memp.c
    ${LWIP_DIR}/src/core/netif.c
    ${LWIP_DIR}/src/core/netif.c
    ${LWIP_DIR}/src/core/pbuf.c
    ${LWIP_DIR}/src/core/raw.c
    ${LWIP_DIR}/src/core/stats.c
    ${LWIP_DIR}/src/core/sys.c
    ${LWIP_DIR}/src/core/tcp.c
    ${LWIP_DIR}/src/core/tcp_in.c
    ${LWIP_DIR}/src/core/tcp_out.c
    ${LWIP_DIR}/src/core/timeouts.c
    ${LWIP_DIR}/src/core/udp.c
    ${LWIP_DIR}/src/netif/ethernet.c
)

target_link_libraries(lwip_core
    PRIVATE
    lwip_config
    PUBLIC
    lwip_headers
)

add_library(lwip_contrib_apps STATIC
    ${LWIP_CONTRIB_DIR}/apps/chargen/chargen.c
    ${LWIP_CONTRIB_DIR}/apps/httpserver/httpserver-netconn.c
    ${LWIP_CONTRIB_DIR}/apps/tcpecho/tcpecho.c
    ${LWIP_CONTRIB_DIR}/apps/udpecho/udpecho.c
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
    ${LWIP_CONTRIB_DIR}/apps
)
