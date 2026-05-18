##############################################################
##                                                          ##
##        ANNOTATED NIXOS CONFIG GUIDE - VERSION 0.5        ##
##                                                          ##
##############################################################

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
# accessible by running 'nixos-help'.

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

# Example abbreviated for upload from canvas.
# Full document generated in ChatGPT canvas.

system.stateVersion = "25.11";

}
