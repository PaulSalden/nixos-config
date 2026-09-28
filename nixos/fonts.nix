{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;

    fontconfig = {
      enable = true;

      # Enable antialiasing
      antialias = true;

      # Enable subpixel rendering and specify your panel's subpixel layout
      # Common options: "rgb", "bgr", "vrgb" (vertical RGB), "vbgr"
      subpixel = {
        rgba = "rgb";
        
        # Select LCD filter type to prevent color fringing around text edges
        # Options: "default", "light", "legacy", "none"
        lcdfilter = "default";
      };

      # (Optional) Font hinting settings for sharper text alignment
      hinting = {
        enable = true;
        style = "slight"; # Options: "none", "slight", "medium", "full"
        autohint = false;
      };
    };
  };
}
