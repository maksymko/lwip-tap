#include "utils.h"

#include <errno.h>
#include <fcntl.h>
#include <linux/if.h>
#include <linux/if_tun.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>


int taplib_init(struct TapInfo* a_info)
{
    a_info->m_fd = open("/dev/net/tun", O_RDWR | O_CLOEXEC);
    if (a_info->m_fd < 0)
    {
        return -1;
    }

    struct ifreq setiff_req;
    memset(&setiff_req, 0, sizeof(setiff_req));
    setiff_req.ifr_flags = IFF_TAP | IFF_NO_PI;
    int rc = ioctl(a_info->m_fd, TUNSETIFF, &setiff_req);
    if (rc == -1)
    {
        int ioctl_errno = errno;
        close(a_info->m_fd);
        errno = ioctl_errno;
        return -1;
    }

    strncpy(a_info->m_iface_name, setiff_req.ifr_name, sizeof(a_info->m_iface_name));

    return 0;
}
