{ config, lib, pkgs, ... }:
let
  cfg = config.services.dashy;
  roleName = "dashy";
  roleEnabled = builtins.elem roleName config.homelab.currentHost.roles;

  settings = {
    pageInfo = {
      title = "Homelab";
      description = "homelab made entirelly with nixos";
      navLinks = [
        {
          title = "GitHub";
          path = "https://github.com/badele/nix-homelab";
        }
      ];
    };
    appConfig = {
      theme = "nord-frost";
      layout = "auto";
      iconSize = "medium";
      language = "fr";
      statusCheck = false;
      hideComponents.hideSettings = false;

      # Todo: fix this and remove statusCheckUrl
      statusCheckAllowInsecure = true;
    };
    sections = [
      {
        name = "Monitoring";
        icon = "fas fa-monitor-heart-rate";
        items = [
          {
            title = "Uptime";
            url = "https://uptime.h";
            statusCheckUrl = "http://uptime.h";
            icon = "hl-uptime-kuma";
          }
          {
            title = "Statping";
            url = "https://statping.h";
            statusCheckUrl = "http://statping.h";
            icon = "hl-statping";
          }
          {
            title = "Grafana";
            url = "https://grafana.h";
            statusCheckUrl = "http://grafana.h";
            icon = "hl-grafana";
          }
          {
            title = "Prometheus";
            url = "https://prometheus.h";
            statusCheckUrl = "http://prometheus.h";
            icon = "hl-prometheus";
          }
          {
            title = "Smokeping";
            url = "https://smokeping.h";
            statusCheckUrl = "http://smokeping.h";
            icon = "hl-smokeping";
          }
          {
            title = "Loki";
            url = "https://loki.h/services";
            statusCheckUrl = "http://loki.h/services";
            icon = "hl-loki";
          }
          rec {
            title = "nix-cache";
            url = "https://nixcache.h/nix-cache-info";
            statusCheckUrl = "http://nixcache.h:5000/nix-cache-info";
            icon = "https://camo.githubusercontent.com/33a99d1ffcc8b23014fd5f6dd6bfad0f8923d44d61bdd2aad05f010ed8d14cb4/68747470733a2f2f6e69786f732e6f72672f6c6f676f2f6e69786f732d6c6f676f2d6f6e6c792d68697265732e706e67";
          }
        ];
      }
      {
        name = "Tools";
        icon = "fas fa-rocket";
        items = [
          {
            title = "mikrotik";
            url = "192.168.254.254";
            icon = "hl-mikrotik";
          }
        ];
      }
      {
        name = "Website";
        icon = "fas fa-bookmark";
        items = [
          {
            title = "Nix packages/Options";
            url = "https://search.nixos.org/packages";
            icon = "favicon";
          }
          {
            title = "Google";
            url = "https://www.google.fr";
            icon = "favicon";
          }
          {
            title = "Github";
            url = "https://github.com/badele";
            icon = "favicon";
          }
        ];
      }
      {
        name = "Widgets";
        widgets = [
          {
            type = "apod";
          }
        ];
      }
    ];
  };
in
{

  imports = [
    ../../modules/nixos/dashy.nix
    ../modules/system/containers.nix
  ];

  services.dashy = {
    inherit settings;
    enable = roleEnabled;
    imageTag = "2.1.1";
    port = 8081;
    extraOptions = [
      "-p"
      "${toString cfg.port}:80"
    ];
  };
}
