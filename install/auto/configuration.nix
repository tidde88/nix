{ config, lib, pkgs, ... }: {
	imports = [
		<nixpkgs/nixos/modules/profiles/all-hardware.nix>
		<nixpkgs/nixos/modules/profiles/base.nix>
		#installer-only ./hardware-configuration.nix
	];

	nixpkgs.config.allowUnfree = true;

	security.sudo.wheelNeedsPassword = false;

	# default hostname
	networking.hostName = "nixos";
	# disable ipv6
	networking.enableIPv6  = false;

	time.timeZone = "Europe/Berlin";

	services.openssh.enable = true;
	services.qemuGuest.enable = true;
	virtualisation.docker.enable = true;

	nix.settings = {
		auto-optimise-store = true;
		experimental-features = [ "nix-command" "flakes" "repl-flake" ];
	};

	users.mutableUsers = false;
	users.users.root = {
		hashedPassword = "*";
	};

	users.users.tobi = {
		isNormalUser = true;
		extraGroups = [ "wheel" "docker" "systemd-journal" ];
		shell = pkgs.zsh;
		hashedPassword = "$y$j9T$CiLH54UEhcnY/A04N8.Bz0$uegUxZq6IGKULc0H/SGChuay5hB6LkVGv4OJlRH4gf1";
	};

	users.defaultUserShell = pkgs.zsh;
	environment.shells = [ pkgs.zsh ];

	programs = {
		# needed for vscode remote ssh
		nix-ld.enable = true; 
	 	zsh = {
			enable = true;
			autosuggestions.enable = true;
			zsh-autoenv.enable = false;
			syntaxHighlighting.enable = true;
	 };
};

	i18n.defaultLocale = "en_US.UTF-8";
	environment.variables = {
		TZ = config.time.timeZone;
	};

	services.avahi = {
		enable = true;
		ipv4 = true;
		ipv6 = true;
		nssmdns = true;
		publish = { enable = true; domain = true; addresses = true; };
	};

	environment.systemPackages = with pkgs; [
		coreutils
		curl
		docker
		docker-buildx
		git
		htop
		linuxHeaders
		lsof
		mkpasswd
		nano
		nettools
		openssl
		python3
		python3Packages.pip
		ssh-import-id
		tmux
		tzdata
		unzip
		util-linux
		wget
		zsh-autosuggestions
		zsh-syntax-highlighting
	];
}
