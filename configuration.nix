##################################################
##                INTRODUCTION                 ##
##################################################

# This NixOS config file is meant to serve as both
# a tool and a reference guide. Its goal is to help
# users who are completely NEW to NixOS and its
# philosophy.

# It does this by adding more visual separation
# throughout the config file. It also provides
# explanations in narrative format so users can
# slow down and better understand what is actually
# happening behind the scenes.

# This is NOT meant to replace official technical
# documentation. Instead, this acts as a guided
# reference that can either be studied on its own
# or actively used as a real NixOS config file
# that you can tweak and expand over time.

# More help is available in the configuration.nix(5)
# man page and in the NixOS manual
# (accessible by running 'nixos-help').


##################################################
##               CONFIG CONTEXT                ##
##################################################

# This first one-line section tells NixOS what kind of
# information should be made available before the real
# configuration begins.
#
# More specifically:
# - "config" contains system configuration values
# - "pkgs" contains available software packages
# - "..." allows additional values/modules to be passed in
#
# The "}" closes the input section.
# The ":" signals the beginning of the actual configuration below.
#
# If you are new, there is a good chance you should not
# modify this section yet.

{ config, pkgs, ... }:


##################################################
##                  IMPORTS                    ##
##################################################

# The Imports section below is used to load
# additional NixOS modules into the system.
#
# On a fresh installation, this usually
# includes the hardware configuration file only.
# This is default generated during installation.

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


##################################################
##           SYSTEM CONFIGURATION               ##
##################################################

# This section is dedicated to declaring the remaining
# system configurations. 

# Given the declarative nature, the order of the 
# configuration settings doesn't really matter, as long as 
# the formatting is correct.  

# To make it more logical to understand, the sections
# are broken up into sub-sections. It starts with 
# lower levels of the system, and works its way up to
# software packages. 



##################################################
##               SYSTEM CORE                  ##
##################################################



# Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

# Define your hostname.
  networking.hostName = "nixos";

# Enable the X11 windowing system.
# NOTE: Many desktop environments automatically pull in
# Wayland support when needed. Beginners usually
# do not need to manually force Wayland globally.
  
  services.xserver.enable = true;

# Enable CUPS to print documents.
  
  services.printing.enable = true;

# Enable sound with pipewire.
  
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;

# Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  
   # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


# Enable XDG Desktop Portals.
# Used by Flatpak and modern desktop/Wayland apps for
# secure desktop integration features.
xdg.portal = {
  enable = true;
  extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];
};

##################################################
##             Networking                      ##
##################################################


# Enable wireless support via wpa_supplicant.
# networking.wireless.enable = true;

 # Configure network proxy if necessary
 # networking.proxy.default = "http://user:password@proxy:port/";
 # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

 # Enable networking
  networking.networkmanager.enable = true;

  # Enable network manager applet
  programs.nm-applet.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


##################################################
##             REGIONAL SETTINGS              ##
##################################################

  # Set your time zone.
  time.timeZone = "America/New_York";


  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };


##################################################
##                   USERS                     ##
##################################################

  # This section declares the current user, often the
  # the first user in the list. 
  
  # If you wanted to add software JUST for this 
  # user and only this user, add package names
  # nested under "packages = with pkgs; ["
  # As an example, we added Thunderbird Email. 
  # Simply uncomment make your software list 
  # beneath.
  
  users.users.profetik777 = {
    isNormalUser = true;
    description = "profetik777";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    #  vlc 
    ];
  };

  # Note: The name of the packages must match
  # how it is named by Nix OS. Search available packages at:
  # https://search.nixos.org/packages
  #
  # You can also search locally from the terminal:
  # nix search nixpkgs <package-name>
  
##################################################
##              SOFTWARE SOURCES               ##
##################################################

# This section declares where you can source your
# software from. For unlocking a wider range of 
# software, it is recommended to allow unfree packages. 

# Allow unfree packages from the Nix package repository.
nixpkgs.config.allowUnfree = true;

# For even more places to install software packages
# from, you can enble Flatpaks, and direct flatpak
# applications to be sourced from Flathub. 

# Enable Flatpak support.
 services.flatpak.enable = true;

# Add the Flathub repository.
 system.activationScripts.flathub = {
   text = ''
     flatpak remote-add --if-not-exists flathub \
       https://flathub.org/repo/flathub.flatpakrepo
   '';
 };
 
# Note: If you want to install flatpak software,
# you can acticate flatpaks, reboot, and open the 
# terminal and add software using the following commands
# as example. Or go to flathub.org and find commands
# there. 

# Example Commands to apply after activated without "#".
# flatpak install flathub org.mozilla.firefox
# flatpak install flathub com.spotify.Client

##################################################
##  SPECIALIZED NIX SOFTWARE PACKAGES          ##
##################################################

  # This section controls the software that is packaged
  # as "program modules" specifically tuned for NixOS with special 
  # configuration "options". By default, Firefox is included for
  # convenience to provide better user experience. If you 
  # want to see the scope of the program options for this, 
  # you can go to etc/nixos/modules/programs/firefox.nix

  # Installs Firefox using the built-in NixOS program option.
  programs.firefox.enable = true;

  # Enable Vim using the built-in NixOS program option.
  programs.vim.enable = true;

##################################################
##           SYSTEM-WIDE SOFTWARE              ##
##################################################

# Software installed in this format makes it available 
# to all users. Unlike "Specialized Nix Software Package"
# these packages typically do not include deeper 
# OS integration or additional configuration layers.

# Note the formatting "with pkgs;" below. This simply
# allows package names to be referenced without needing
# to add the prefix "pkgs." for each software program. 
#
# In the next section, just list packages. To make it 
# easier to manage your list, you can use categories. 

# Remember, some packages need to be named exactly 
# as they are packaged. To ensure the correct package 
# name, simple use one of the following methods: 

# Search for packages online:
# https://search.nixos.org/packages
#
# Search locally from the terminal:
# nix search nixpkgs <package-name> 

environment.systemPackages = with pkgs; [

  # Text Editors
  featherpad
  

  # Utilities
  wget
  git

  # Media
  vlc

];

  # In rare cases, you may want to "pin" software to a
  # specific version due to bugs, compatibility issues,
  # or newer features not yet available in your current channel.
  #
  # Instead of pulling software from your default "pkgs"
  # collection, you can import a different nixpkgs snapshot.
  #
  # Example: Pin Firefox to a specific nixpkgs revision.
  #
  # let
  #   pinnedPkgs = import (builtins.fetchTarball {
  #     url = "https://github.com/NixOS/nixpkgs/archive/SPECIFIC-COMMIT.tar.gz";
  #   }) {};
  # in
  #
  # environment.systemPackages = [
  #   pinnedPkgs.firefox
  # ];
  #
  # Firefox now comes from that exact nixpkgs snapshot
  # instead of your current system channel.
  #
  # --------------------------------------------------
  #
  # Example: Pull Firefox from the unstable/nightly-style
  # nixpkgs channel while keeping the rest of the system stable.
  #
  # let
  #   unstablePkgs = import (builtins.fetchTarball {
  #     url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  #   }) {};
  # in
  #
  # environment.systemPackages = with pkgs; [
  #   unstablePkgs.firefox
  # ];
  #
  # Now only Firefox comes from the unstable branch while
  # the rest of the operating system remains stable.
  
  
#################################################
##                 FLATPAK                     ##
################################################## 
  
# Flatpak provides an additional software layer separated
# from the core operating system. This can help reduce
# dependency conflicts and keep desktop applications more isolated.
#
# This setup enables Flatpak support and adds Flathub
# as a user-level software source.
#
# "User-level" means Flatpak applications are installed
# only for your user account rather than system-wide
# for every user on the machine.

# services.flatpak.enable = true;

# system.activationScripts.addFlathubUserRepo.text = ''
# ${pkgs.flatpak}/bin/flatpak remote-add --user --if-not-exists flathub \
#    https://dl.flathub.org/repo/flathub.flatpakrepo
# '';


##################################################
##         SYSTEM VERSION ORIGIN              ##
################################################## 

# Defines the original NixOS release this system was first
# installed with. NixOS uses this value to preserve compatibility
# for important system data and behavior across upgrades.
#
# This is NOT your current running version.
#
# In most cases, this should remain unchanged after the
# initial installation unless you fully understand the
# migration implications.
#
# Changing this incorrectly can potentially affect:
# - Database formats
# - File locations
# - Service behavior
# - System defaults
#
# Learn more:
# man configuration.nix
# https://search.nixos.org/options?show=system.stateVersion

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
system.stateVersion = "25.11"; # Did you read the comment?

}
