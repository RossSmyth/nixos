# NixOS Config

This is my NixOS config. I daily-drive NixOS, both on WSL and on a physical computer.

# Architecture

There are certain tools and settings that all of the machines I use have no matter what. Those are defined in the default modules. Then there are mixins for each module system, Home-Manager and NixOS.

Then each machine defines machine-specific things. There shouldn't be too much that is machine-specific, but there may be some.

## Organization

* [mkMachine.nix](./mkMachine.nix)

Defines the interface of defining machines

* [flake.nix](./flake.nix)

The top-level file that defines all the machines.

* [home-manager](./home-manager)

[Home-Manager](https://searchix.ovh/options/home-manager/search) mix-ins. I try to define as much as possible in Home-Manager as it is generally more flexible.

* [nixos](./nixos)

[NixOS mix-ins](https://searchix.ovh/options/nixos/search). These define the system-level mix-ins.

* [machines](./machines)

The machine-specific definitions. Primarily the hardware, partitions, and kernel configs.
