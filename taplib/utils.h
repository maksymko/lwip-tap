#pragma once

#include <net/if.h>

struct TapInfo
{
    char m_iface_name[IFNAMSIZ + 1]; /// Name of the interface
    int m_fd; /// File Descriptor for the Interace
};

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Initialize TAP interface
 *
 * Create New TAP interface and return information about it.
 * @param[out] a_info Information about created interface
 */
int taplib_init(struct TapInfo* a_info);

#ifdef __cplusplus
}
#endif
