install_deps
=========

Installs dependencies as specified by the user for systems using DNF (Fedora, RHEL 8+, etc.). This role can optionally add the NodeSource repository and install Node.js if the `include_node` variable is set to true.

Requirements
------------

- DNF-based Linux distribution

Role Variables
--------------

- include_node: bool
  - default: true
  - description: Whether to include the NodeSource repository and install Node.js.
- desired_packages: list
  - default: ['git']
  - description: A list of packages to install. Node.js will be added to this list if `include_node` is true.

Dependencies
------------

N/A
