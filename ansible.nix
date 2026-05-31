{ config, pkgs, ... }:
#usually roles and hosts in /etc/ansible/.
{
    environment.etc."ansible/ansible.cfg".text = ''
        [defaults]
        inventory = /home/asur/Documents/cloned/ansible/hosts
        host_key_checking = True
        roles_path = /home/asur/Documents/cloned/ansible/roles

        [ssh_connection]
        pipelining = True
    '';
}
