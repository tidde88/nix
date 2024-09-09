{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" "repl-flake" ];
  };

  system.autoUpgrade.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Define a user account.
  users.users.tobi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "systemd-journal" ];
    shell = pkgs.zsh;
    hashedPassword = "${HASHED_PASSWORD}";
    #packages = with pkgs; [];
  };

  security.sudo.wheelNeedsPassword = false;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = [ pkgs.zsh ];

  programs = { 
    zsh.enable = true;
    nix-ld.enable = true; 
  };

  # Use systemd-boot
  boot.loader.systemd-boot.enable = true;

  # disable ipv6
  networking.enableIPv6  = false;

  # Select internationalisation properties.
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  i18n.defaultLocale = "en_US.UTF-8";
  environment.variables = {
    TZ = config.time.timeZone;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bash
    coreutils
    curl
    docker
    docker-buildx
    docker-compose
    git
    htop
    linuxHeaders
    mkpasswd
    nettools
    ssh-import-id
    tzdata
    unzip
    util-linux
    wget
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];

  #services.cloud-init.enable = true;
  services.openssh.enable = true;
  services.qemuGuest.enable = true;
  virtualisation.docker.enable = true;

  system.stateVersion = "23.11";
}
