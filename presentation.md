%title: UDP with Elixir
%repo: https://github.com/denvaar/gen_udp_playground
%date: Aug 19, 2021

# UDP with Elixir

---

# Attributes of UDP

**User Datagram Protocol**

-   Lightweight
-   Connectionless
-   Unreliable

---

# The :gen_udp Module

**Obtain a socket**

{:ok, socket} = :gen_udp.open(5051, opts)

**Send data**

:ok = :gen_udp.send(socket, {127, 0, 0, 1}, 5051, "hello!")

**Receive data**

{:ok, {sender_host, sender_port, data}} = :gen_udp.recv(socket, 0, 2_000)
