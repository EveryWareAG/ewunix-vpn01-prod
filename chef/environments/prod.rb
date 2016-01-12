name "prod"
description "prod environment"
override_attributes(
    "repo" => {"date" => "2015/q4"},
    "release" => {"git" => "stable"},
    "resolver" => {
        "nameservers" => ["172.16.2.1", "8.8.8.8", "8.8.4.4"],
        "options" => {
            "timeout" => 2, "rotate" => nil
        }
    }
)
