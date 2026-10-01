let
  paul = "age1llf3rkw3c37fdkumgj3lwjyg08ze5y5egl6tkmshsqxmzh286dcsgfzeef";
in
{
  "wgprivate-secret.age".publicKeys = [ paul ];
  "radicale-secret.age".publicKeys = [ paul ];
  "kpn-secret.age".publicKeys = [ paul ];
}
