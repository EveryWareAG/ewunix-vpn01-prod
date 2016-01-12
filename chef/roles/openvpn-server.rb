# https://supermarket.chef.io/cookbooks/openvpn

name "openvpn-server"
description "The server that runs OpenVPN"
run_list("recipe[vpn-server]")
override_attributes(
    "openvpn" => {
        "script_security" => 2,

        "key" => {
            "country" => "CH",
            "province" => "ZRH",
            "city" => "Zurich",
            "org" => "EveryWare AG",
            "email" => "unix@everyware.ch"
        }
    }
)

# EOF
