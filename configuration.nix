##############################################################
##                                                          ##
##        ANNOTATED NIXOS CONFIG GUIDE - VERSION 0.67       ##
##                                                          ##
##############################################################

##################################################
##                INTRODUCTION                 ##
##################################################

# This NixOS config file is meant to serve as both
# an educational tool for learning the anatomy of a 
# average Nix Config File, while also serving as 
# a template that can be copied and tweaked for 
# personal use. 

# It is written up as reference guide on purpose, 
# which is why there is so much commenting within 
# the config file. 

# Its goal is to help users who are completely 
# NEW to NixOS. 

# It does this by enhancing the default layout that comes
# with a fresh install of NixOS and rearranges the 
# sequence order of the configurations options. 

# To aid in readibility, we provide section headers 
# to group similar batches of configurations while
# also trying to apply a logical order and structure
# to to the config file. 

# We begin with low level system configurations 
# (like the bootloader and networking), then declare 
# things like the desktop environments (lxqt for simplicity)
# and eventually make our way to software applications. 

# With education being a goal with this document, 
# we provide some explanations for configuration/formating
# and terminology whenever warranted. 

# NOTE: This is NOT meant to replace official technical
# documentation. Instead, this acts as a quick guide
# reference that can either be studied on its own
# or actively used as a real NixOS config file
# that you can tweak and expand over time.

# More help is available in the configuration.nix(5)
# man page and in the NixOS manual
# (accessible by running 'nixos-help').

# Tip: If you plan on using this file, make sure
# you change the username from the example in the 
# file to yours! 

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

# Notice, how the "{" above the line of "imports = "
# isn't closed out with "}" until the very end of this
# config file. 

##################################################
##           SYSTEM CONFIGURATION               ##
##################################################

# This section is dedicated to declaring the remaining
# system configurations. 

# Given the declarative nature, the order of the 
# configuration settings doesn't really matter, as long as 
# the formatting is correct.  



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

 # Enable tailscale
  services.tailscale.enable = true; 

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
  
  users.users.Put-Your-Username-Here = {
    isNormalUser = true;
    description = "And-Also-Here-Username";
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
##  DESKTOP ENVIRONMENTS / WINDOW MANAGERS     ##
##################################################

# As mentioned earlier, the goal of this guide is 
# to learn the Nix Config file. For the sake of 
# simplicity, we are just sticking with LXQT. 

# Enable the Login Manager to sign in. 
services.xserver.displayManager.sddm.enable = true;

# Enable the LXQt desktop environment
services.xserver.desktopManager.lxqt.enable = true;

# Enable XDG Desktop Portals.
# Portals are used by desktop evironments and applications 
# regardless of its origin or type (NixOS packages or Flatpak). 
# To ensure a seemless experience for integration features
# like file pickers, screenshots, screen sharing, and opening links
# the following is needed. Note, this does assume application 
# developers are keeping up with Portal development. If not, some
# of these features can produce bugs or not function. 

# Most of the time, this is handled by a Desktop Environment
# entirely, but because we are using LXQT, we will share what
# a configuration looks like here. 

xdg.portal = {
  enable = true;
  lxqt.enable = true;
  config.common.default = [ "lxqt" ];
};
  
##################################################
##              SOFTWARE SOURCES               ##
##################################################

# This section declares where you can source your
# software from. For unlocking a wider range of 
# software, it is recommended to allow unfree packages. 

# Allow unfree packages from the Nix package repository.
nixpkgs.config.allowUnfree = true;

##################################################
##         SOFTWARE SOURCE: FLATPAK            ##
##################################################

# For even more places to install software packages
# from, you can enable Flatpaks, and direct Flatpak
# applications to be sourced from Flathub.

# Enable Flatpak support.
services.flatpak.enable = true;

# Note: If you want to install Flatpak software,
# activate Flatpak support with the comamnd above,
#, reboot, and then use
# the following command to enable it as a repo. 
# This will allow Gnome Software to "see" the
# flathub repo within the Gnome Software Center.  


# flatpak install flathub com.spotify.Client

# If you want to find software you can install, you can 
# run flatpak search [ name of software ] or go to 
# flathub.org and find the officila flatpak packaging
# names and run the associated commands listed.

# Note: If you want to install flatpaks via a GUI,
# you can install a software center that pairs with
# a Desktop Environment (eg Gnome or Plasma). We don't 
# want this learning guide to be Desktop Environment 
# specific, so for educational purpose, we refer you
# to use the terminal. 

##################################################
##  SOFTWARE SOURCE: Nix Program Modules         ##
##################################################

# This is not your typical NixOS software package section.
# This section controls the software that is packaged
# as "program modules". This means you can specifically 
# tune software just for better NixOS configuration "options".
# By default, Firefox is included for convenience to 
# provide better user experience. 

# If you want to see the nature of the program options 
# that are applied to the software, you can 
# go to the following file path: 
#    etc/nixos/modules/programs/firefox.nix

# Installs Firefox using the built-in NixOS program option.
  programs.firefox.enable = true;


##################################################
##           SYSTEM-WIDE SOFTWARE              ##
##################################################

# Software installed in this format makes it available 
# to ALL users (remember, the Users section gave you 
# an option to setup software packages per user).

# Note the formatting "with pkgs;" below. This simply
# allows package names to be referenced without needing
# to add the prefix "pkgs." for each software program. 
#
# This makes it easier to manage your list. Do you want
# better organize your list of packages? Add categories. 

# Just remember, packages need to be named exactly 
# as they are packaged within NixOS. To ensure the correct 
# package name, simple use one of the following methods: 

# 1 Search for packages online:
# https://search.nixos.org/packages
#
# 2 Search locally from the terminal:
# nix search nixpkgs <package-name> 

# Add your nix software packages here. 
environment.systemPackages = with pkgs; [

  # Text Editors
  featherpad
  vim

  # Utilities
  wget
  git
  gnome-software
  # Media
  vlc

];

##################################################
## BONUS:Pinning Software Versions and Channels   ##
##################################################

# Here is a optional bonus tip. In rare cases, 
# you may want to "pin" software to a
# specific version due to bugs, compatibility issues,
# or newer features not yet available in your current channel.

# Instead of pulling software from your default "pkgs"
# collection, you can import a different nixpkgs snapshot.

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
  
  
##################################################
##              APPLYING CHANGES               ##
##################################################

# After editing configuration.nix, apply your changes with:
#
# sudo nixos-rebuild switch
#
# If you want to test a configuration before making it the default
# boot option, you can use:
#
# sudo nixos-rebuild test

# The next section is more for NixOS historical purposes and 
# can be left as is. 


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
