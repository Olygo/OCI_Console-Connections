# OCI Console Connection Overview

OCI Console Connection provides remote KVM access similar to HP iLO or Dell DRAC, allowing you to connect to your instance even if the network is unreachable.

In OCI, **console connections** provide an alternative method for connecting to an instance when standard network connectivity (SSH or RDP) is unavailable or the instance is unresponsive. This access method is typically used for **troubleshooting or recovery** and works at a lower level than network-based protocols, allowing you to interact directly with the instance's console output. Here’s a breakdown of how it works.

---

## 1. Hypervisor-Level Access

When using a console connection, OCI connects at the hypervisor level, bypassing the instance’s network stack. Here’s how it’s facilitated:

- **Direct Console Output**: OCI accesses the console output of the compute instance via the hypervisor, not by logging into the operating system of the instance itself.

- **Serial Console Access**: For Linux, the hypervisor provides serial console access, allowing you to interact with the instance at the kernel level. This interface typically appears as `/dev/ttyS0` or another serial device, where you can see boot logs, interact with the boot loader, or initiate recovery processes.

	For Windows, the hypervisor provides serial console access when the [Special Administration Console (SAC) has been enabled](./enable-windows-sac.md).

- **VNC Over Hypervisor**: For instances with Desktop environment, the console connection provides an RDP-like interface. This approach works similarly to KVM/IPMI access in traditional data centers but is facilitated through OCI’s cloud infrastructure.

---

## 2. Console Connection Workflow

The sequence of establishing a console connection involves the following steps:

- **Initiating the Connection**: Users initiate the console connection from the OCI Console, which requires permissions to start a console connection on the instance.

- **Connection Setup**: OCI creates a WebSocket connection between the OCI Console and the hypervisor. This session is authenticated and authorized via OCI Identity and Access Management (IAM).

- **Session Authentication**: Once the WebSocket connection is established, IAM credentials are used to authorize the access session. The session ID is passed to authenticate the user securely.

- **Console Viewer**: The viewer interface (browser-based terminal or RDP viewer) becomes available in the OCI Console, allowing the user to interact with the VM.

---

## 3. Mechanisms Involved in Console Connection

- **WebSocket-based Communication**: OCI uses a WebSocket-based protocol for direct communication with the VM’s console output. This approach enables a real-time stream of the console output.

- **Hypervisor Management API**: The underlying API calls and control are handled by the hypervisor management layer, which has direct access to the VM console output, bypassing any network-based access mechanisms within the instance OS.

- **No Dependency on Guest OS**: The connection does not rely on any network or OS configuration within the instance. Even if network settings, firewall rules, or OS configurations are misconfigured, the console connection remains functional because it interfaces directly with the VM through the hypervisor.

---

## 4. Security and Access Control

- **IAM Policies**: Console connections are controlled and governed by OCI IAM policies, ensuring that only authorized users can initiate console sessions.

- **Limited Console Scope**: The console connection provides access only to the console output and input. Users can troubleshoot but do not gain unrestricted access to files or OS-level network services.

- **Automatic Timeout**: Console sessions have a maximum duration and will time out automatically to prevent unauthorized access or resource consumption.

---

## 5. Common Use Cases

Console connections are typically used for:

- **Kernel-Level Troubleshooting**: Viewing kernel logs or diagnosing boot issues.

- **File System Recovery**: Mounting the root filesystem in read-only mode to fix errors or address filesystem corruption.

- **Resetting SSH Configurations or Credentials**: Directly modifying configuration files when SSH is misconfigured or credentials are lost.

- **Rescue Mode and Reboots**: The console interface can enable reboot commands or access the boot loader for rescue mode, enabling recovery actions directly.

---

OCI console connections are designed for low-level, emergency troubleshooting and maintenance by interfacing directly with the hypervisor, independent of the instance’s network or OS conditions.
