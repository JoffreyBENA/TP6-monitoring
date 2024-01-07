resource "google_compute_firewall" "allow-ssh" {
    name    = "allow-ssh"
    network = var.network_self_link
    allow {
        protocol = "tcp"
        ports    = ["22"]
    }
    source_ranges = var.firewall_source
    target_tags = [ "nodes" ]
}

resource "google_compute_firewall" "allow-http-https" {
    name    = "allow-http"
    network = var.network_self_link
    allow {
        protocol = "tcp"
        ports    = ["80","443"]
    }
    source_ranges = var.firewall_source
    target_tags = [ "nodes" ]
}

resource "google_compute_firewall" "allow-tcp-icmp-udp" {
    name    = "allow-internal"
    network = var.network_self_link
    allow {
        protocol = "tcp"
    }
    allow {
        protocol = "icmp"
    }
    allow {
        protocol = "udp"
    }
    source_ranges = var.firewall_source
    target_tags = [ "nodes" ]
}
