# lwip-tap

lwip-tap is an application of "lwIP - A Lightweight TCP/IP Stack" which is
a small, user-space implementation of the TCP/IP protocol stack.
Using lwip-tap, you can easily plug an instance of lwIP to Linux Bridge or
Open vSwitch through TAP devices. lwip-tap supports multiple network
interfaces, so that it also works as a router. A wide range of different
network topologies can be built flexibly.


## System Requirement

As of now, lwip-tap has been developed only in Linux, more precisely Arch
Linux with latest updates. The original tapif driver available in the
lwip-contrib, however, includes code chunks for other environments as well.
Although lwip-tap is fully supported only in Linux right now, it should
work on any environment that supports TAP/TUN-like devices if the tapif
driver is updated.


## Building

Clone the git repository from GitHub and initialize submodules,

  $ git clone git://github.com/takayuki/lwip-tap.git
  $ cd lwip-tap
  $ git submodule init
  $ git submodule update

CMake is required to build lwip-tap. A compile-time option to enable
debugging facilities lwIP provides is available. See "8. Debugging" below.

```shell
cmake -B build -S. -GNinja
cmake --build build
```

## Running

3. Example: Running lwip-tap with a transient TAP device

The quickest, but less flexible way to run lwip-tap is, having it create
a transient TAP device for you,

  # lwip-tap -i addr=172.16.0.2,netmask=255.255.255.0,gw=172.16.0.1

In this example, lwip-tap (1) creates a transient TAP device, (2) assign
172.16.0.1 to the tap, (3) adds a route 172.16.0.1/255.255.255.0 to the tap,
(4) links an instance of lwIP to the tap, and (5) assign 172.16.0.2 to the
interface of the lwIP. To check if the lwIP is working,

  # ping 172.16.0.2


4. Example: Attach lwip-tap to a persistent TAP device

For more flexible network settings, all the steps mentioned above can be
made separately using persistent TAP devices,

  # ip tuntap add dev tap0 mode tap
  # ip link set dev tap0 up
  # ip addr add 172.16.0.1/24 dev tap0
  # lwip-tap -i name=tap0,addr=172.16.0.2,netmask=255.255.255.0,gw=172.16.0.1

  # ping 172.16.0.2


5. Example: Use DHCP with a persistent TAP device

If you omit an address to an instance, lwip-tap automatically uses DHCP.

  # lwip-tap -i name=tap0


6. Example: Run lwip-tap with Open vSwitch

Add br0 (172.16.0.1),

  # ovs-vsctl add-br br0
  # ip link set dev br0 up
  # ip addr add 172.16.0.1/24 dev br0

Add tap0 to br0,

  # ip tuntap add dev tap0 mode tap
  # ip link set dev tap0 up
  # ovs-vsctl add-port br0 tap0

Run a lwip-tap on tap0 (172.16.0.2),

  # lwip-tap -i name=tap0,addr=172.16.0.2,netmask=255.255.255.0,gw=172.16.0.1

  # ping 172.16.0.2


7. Example: Run lwip-tap as a router

Add br0 (172.16.0.1),

  # ovs-vsctl add-br br0
  # ip link set dev br0 up
  # ip addr add 172.16.0.1/24 dev br0
  # ip route add 172.16.1.0/24 via 172.16.0.2

Add br1 (without IP address),

  # ovs-vsctl add-br br1
  # ip link set dev br1 up

Add tap0 to br0,

  # ip tuntap add dev tap0 mode tap
  # ip link set dev tap0 up
  # ovs-vsctl add-port br0 tap0

Add tap1 and tap2 to br1,

  # ip tuntap add dev tap1 mode tap
  # ip link set dev tap1 up
  # ovs-vsctl add-port br1 tap1

  # ip tuntap add dev tap2 mode tap
  # ip link set dev tap2 up
  # ovs-vsctl add-port br1 tap2

Run one lwip-tap on tap2 (172.16.1.2),

  # lwip-tap \
      -i name=tap2,addr=172.16.1.2,netmask=255.255.255.0,gw=172.16.1.1

Run another lwip-tap on tap0 (172.16.0.2) and tap1 (172.16.1.1), which is
a router between 172.16.0.2/24 and 172.16.1.1/24,

  # lwip-tap \
      -i name=tap0,addr=172.16.0.2,netmask=255.255.255.0,gw=172.16.0.1 \
      -i name=tap1,addr=172.16.1.1,netmask=255.255.255.0

  # ping 172.16.0.2
  # ping 172.16.1.1
  # ping 172.16.1.2


8. Build-in Applications

lwip-tap has currently three built-in applications which has been integrated
from lwip-contrib for debugging purposes. All applications are disabled by
default. Use command-line options to enable those services.

  - echo (port 7) in TCP/UDP (-E)
  - chargen (port 19) in TCP (-C)
  - http (port 80) in TCP (-H)


9. Debugging

lwIP has a compile-time option for debugging which is disable by default.
To enable it, you need to rebuild lwip-tap giving an option to configure,

  $ configure --enable-debug
  $ make

which compiles all object files with LWIP_DEBUG set to 1 and adds another
option -d to lwip-tap.
