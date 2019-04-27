# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # Networking
  networking.dhcpcd.enable = false;
  networking.hostName = "Randy"; # Define your hostname.
  networking.defaultGateway = "10.6.30.1";
  networking.nameservers = [ "8.8.8.8" ];
  networking.interfaces.eno1.ipv4.addresses = [ {
    address = "10.6.30.27";
    prefixLength = 24;
  }];

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "dk";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Enable Docker
  virtualisation.docker.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat # A cat clone with syntax highlighting and Git integration. https://github.com/sharkdp/bat
    curl
    cryptsetup # Disk encryption software
    docker
    docker-compose
    git
    nodejs-10_x # NodeJS v10 Stable
    python37Packages.glances # CLI System monitoring tool
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable zsh
  programs.zsh.enable = true;

  # Enable Oh-my-zsh
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "sudo" "docker" "kubectl" ];
  };

  # Enable The Fuck
  programs.thefuck.enable = true;

  # Enable Vim and make it the default editor
  programs.vim.defaultEditor = true;

  # Define a user account. Don't forget to change initial password after first login.
  users = { 
    mutableUsers = true;
    defaultUserShell = pkgs.zsh; # Make zsh default shell
    users = {
      kerwood = { # Change your username here
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "docker" ];
        initialPassword = "password"; # Initial password, remember to change after first boot.
      };
    };
  };

  # Disable sudo password
  security.sudo.wheelNeedsPassword = false;
  
  # Environment Variables
  # environment.variables = {
  # };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

}
