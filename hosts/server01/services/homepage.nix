{ config, ... }:
{
  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;

    bookmarks = [
      {
        SearchEngine = [
          {
            Brave = [
              {
                abbr = "S";
                href = "https://search.brave.com/";
                icon = "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Brave_lion_icon.svg/204px-Brave_lion_icon.svg.png";
              }
            ];
            PerplexitiAI = [
              {
                abbr = "PAI";
                href = "https://https://www.perplexity.ai/";
                icon = "https://spynewsletter.com/wp-content/uploads/2023/11/perplexity-logo.webp";
              }
            ];
            "NixOS Search" = [
              {
                abbr = "NS";
                href = "https://search.nixos.org/packages";
                icon = "https://nixos.org/logo/nix-wiki.png";
              }
            ];
            Google = [
              {
                abbr = "G";
                href = "https://www.google.com";
                icon = "https://upload.wikimedia.org/wikipedia/commons/2/2d/Google-favicon-2015.png";
              }
            ];
          }
        ];
      }
      {
        Developer = [
          {
            Github = [
              {
                abbr = "GH";
                href = "https://github.com/";
                icon = "https://cdn-icons-png.flaticon.com/512/25/25231.png";
              }
            ];
            "NixOS Wiki" = [
              {
                abbr = "NW";
                href = "https://nixos.wiki/";
                icon = "https://nixos.wiki/images/thumb/2/20/Home-nixos-logo.png/207px-Home-nixos-logo.png";
              }
            ];
            "Nixpkgs Pull Request Tracker" = [
              {
                abbr = "NPR";
                href = "https://nixpk.gs/pr-tracker.html";
                icon = "https://nixos.org/logo/nix-wiki.png";
              }
            ];
            "Nixpkgs" = [
              {
                abbr = "NP";
                href = "https://github.com/NixOS/nixpkgs";
                icon = "https://nixos.org/logo/nix-wiki.png";
              }
            ];
            "Arch Wiki" = [
              {
                abbr = "AW";
                href = "https://wiki.archlinux.org/";
                icon = "https://t2.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=http://wiki.archlinux.org&size=128";
              }
            ];
            "ChatGPT" = [
              {
                abbr = "CG";
                href = "https://chat.openai.com/";
                icon = "https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/ChatGPT_logo.svg/768px-ChatGPT_logo.svg.png";
              }
            ];
          }
        ];
      }
      {
        Social = [
          {
            "Reddit" = [
              {
                abbr = "RE";
                href = "https://reddit.com/";
                icon = "https://www.iconpacks.net/icons/2/free-reddit-logo-icon-2436-thumb.png";
              }
            ];
            "Proton Mail" = [
              {
                abbr = "PM";
                href = "https://account.proton.me/mail";
                icon = "https://play-lh.googleusercontent.com/99IPL5W1HvN1TM7awcJ2gihUie-LQ5Ae7W9g0FgCBFJ8hNZnFIOJElyBPNcx4Wcx7A";
              }
            ];
            "Tuta Mail" = [
              {
                abbr = "TU";
                href = "https://app.tuta.com/login";
                icon = "https://upload.wikimedia.org/wikipedia/commons/d/d8/Tutanota-logo.png";
              }
            ];
            "Infomaniak" = [
              {
                abbr = "IK";
                href = "https://login.infomaniak.com/it/login";
                icon = "https://avatars.githubusercontent.com/u/5754857?s=200&v=4";
              }
            ];
            "" = [
              {
                abbr = "";
                href = "";
                icon = "";
              }
            ];
          }
        ];
      }
      {
        Entrateinement = [
          {
            "YouTube" = [
              {
                abbr = "YT";
                href = "https://youtube.com/";
                icon = "https://www.iconpacks.net/icons/2/free-youtube-logo-icon-2431-thumb.png";
              }
            ];
            "Netflix" = [
              {
                abbr = "NT";
                href = "https://www.netflix.com/";
                icon = "https://dwglogo.com/wp-content/uploads/2019/02/netflix_emblem_transparent-1024x854.png";
              }
            ];
            "Prime Video" = [
              {
                abbr = "PV";
                href = "https://www.amazon.com/gp/video/getstarted";
                icon = "https://www.svgrepo.com/show/494362/amazon.svg";
              }
            ];
          }
        ];
      }
    ];

    services = [
      {
        "Home" = [
          {
            "Home Assistant" = {
              description = "Home Assistant";
              href = "cat ${config.sops.secrets.ha-url.path}";
              icon = "https://apps.heimdall.site/storage/icons/homeassistant.svg";
            };
            "Nextcloud" = {
              href = "cat ${config.sops.secrets.nc-url.path}";
              icon = "https://apps.heimdall.site/storage/icons/nextcloud.png";
            };
            "Dockge" = {
              href = "cat ${config.sops.secrets.dockge-url.path}";
              icon = "https://apps.heimdall.site/storage/icons/dockge.svg";
            };
            "Portainer" = {
              href = "cat ${config.sops.secrets.portainer-url.path}";
              icon = "https://apps.heimdall.site/storage/icons/portainer.svg";
            };
          }
        ];
      }
      {
        "Server" = [
          {
            "ROUTER" = {
              href = "cat ${config.sops.secrets.router-url.path}";
              icon = "https://apps.heimdall.site/storage/icons/pfsense.svg";
            };
            "NODE1" = {
              href = "cat ${config.sops.secrets.node1-url.path}";
              icon = "https://apps.heimdall.site/storage/icons/proxmox.png";
            };
            "NODE2" = {
              href = "cat ${config.sops.secrets.node2-url.path}";
              icon = "https://apps.heimdall.site/storage/icons/proxmox.png";
            };
            "BKP" = {
              href = "cat ${config.sops.secrets.bkp-url.path}";
              icon = "https://apps.heimdall.site/storage/icons/proxmox.png";
            };
            "AP" = {
              href = "cat ${config.sops.secrets.ap-url.path}";
              icon = "https://apps.heimdall.site/storage/icons/netgearorbi.png";
            };
            "VoIP" = {
              href = "cat ${config.sops.secrets.voip-url.path}";
              icon = "https://apps.heimdall.site/storage/icons/3cxvoip.png";
            };
          }
        ];
      }
      {
        "Media" = [
          {
            "Jellyfin" = {
              href = "cat ${config.sops.secrets.jf-url.path}";
              icon = "https://apps.heimdall.site/storage/icons/jellyfin.svg";
            };
            "Radarr" = {
              href = "cat ${config.sops.secrets.radarr-url.path}";
              icon = "https://apps.heimdall.site/storage/icons/radarr.svg";
            };
            "Sonarr" = {
              href = "cat ${config.sops.secrets.sonarr-url.path}";
              icon = "https://apps.heimdall.site/storage/icons/sonarr.svg";
            };
            "Jackett" = {
              href = "cat ${config.sops.secrets.jackett-url.path}";
              icon = "https://apps.heimdall.site/storage/icons/jackett.png";
            };
            "Transmission" = {
              href = "cat ${config.sops.secrets.trans-url.path}";
              icon = "https://apps.heimdall.site/storage/icons/transmission.png";
              widget = {
                type = "transmission";
                url = "cat ${config.sops.secrets.trans-wg-url.path}";
                username = "";
                password = "";
                rpcUrl = "/transmission/rpc";
              };
            };
          }
        ];
      }
    ];

    widgets = [
      {
        logo = {
          icon = "https://camo.githubusercontent.com/8c73ac68e6db84a5c58eef328946ba571a92829b3baaa155b7ca5b3521388cc9/68747470733a2f2f692e696d6775722e636f6d2f367146436c41312e706e67";
        };
      }
      {
        datetime = {
          text_size = "3x1";
          format = {
            timeStyle = "short";
            dateStyle = "short";
            hourCycle = "h23";
          };
        };
      }
      {
        search = {
          provider = "brave";
          focus = "false";
          showSearchSuggestions = "true"; #it is optional but seems required by nix module
          target = "_blank";
        };
      }
      {
        openmeteo = {
          label = "Weather";
          timezone = "Europe/Rome";
          units = "metric";
          cache = "5"; # Time in minutes to cache API responses, to stay within limits
        };
      }
    ];

    settings = [
      {
        title = "Homepage";
        background = {
          image = "https://raw.githubusercontent.com/Gingeh/wallpapers/main/minimalistic/hearts.png";
        };
        cardBlur = "xl";
        theme = "dark";
        color = "slate";
        favicon = "https://camo.githubusercontent.com/8c73ac68e6db84a5c58eef328946ba571a92829b3baaa155b7ca5b3521388cc9/68747470733a2f2f692e696d6775722e636f6d2f367146436c41312e706e67";
        hideVersion = "true";
        headerStyle = "underlined";
      }
    ];
  };

  sops.secrets = {
    ap-url = {
      sopsFile = ../../common/secrets.yaml;
    };
    node2-url = {
      sopsFile = ../../common/secrets.yaml;
    };
    node1-url = {
      sopsFile = ../../common/secrets.yaml;
    };
    router-url = {
      sopsFile = ../../common/secrets.yaml;
    };
    bkp-url = {
      sopsFile = ../../common/secrets.yaml;
    };
    voip-url = {
      sopsFile = ../../common/secrets.yaml;
    };
    portainer-url = {
      sopsFile = ../../common/secrets.yaml;
    };
    dockge-url = {
      sopsFile = ../../common/secrets.yaml;
    };
    nc-url = {
      sopsFile = ../../common/secrets.yaml;
    };
    ha-url = {
      sopsFile = ../../common/secrets.yaml;
    };
    jf-url = {
      sopsFile = ../../common/secrets.yaml;
    };
    radarr-url = {
      sopsFile = ../../common/secrets.yaml;
    };
    sonarr-url = {
      sopsFile = ../../common/secrets.yaml;
    };
    jackett-url = {
      sopsFile = ../../common/secrets.yaml;
    };
    trans-url = {
      sopsFile = ../../common/secrets.yaml;
    };
    trans-wg-url = {
      sopsFile = ../../common/secrets.yaml;
    };
  };

  environment.persistence = {
    "/persist".directories = [ "/var/lib/private/homepage-dashboard/logs" ];
  };
}
