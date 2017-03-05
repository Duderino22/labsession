resource "google_compute_network" "cr460labsession" {
  name                    = "cr460labsession"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "public" {
  name          = "public"
  ip_cidr_range = "172.16.1.0/24"
  network       = "${google_compute_network.cr460labsession.self_link}"
  region        = "us-east1"
}

resource "google_compute_subnetwork" "workload" {
  name          = "workload"
  ip_cidr_range = "10.1.1.0/24"
  network       = "${google_compute_network.cr460labsession.self_link}"
  region        = "us-east1"
}

resource "google_compute_subnetwork" "backend" {
  name          = "backend"
  ip_cidr_range = "192.168.1.0/24"
  network       = "${google_compute_network.cr460labsession.self_link}"
  region        = "us-east1"
}

resource "google_compute_firewall" "fw-public" {
  name    = "fw-public"
  network = "${google_compute_network.cr460labsession.name}"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
      source_ranges = ["172.16.1.0/24"]
}

resource "google_compute_firewall" "fw-workload" {
  name    = "fw-workload"
  network = "${google_compute_network.cr460labsession.name}"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
    source_ranges = ["10.1.1.0/24"]
  }

resource "google_compute_firewall" "fw-backend" {
  name    = "fw-backend"
  network = "${google_compute_network.cr460labsession.name}"
  allow {
  protocol = "tcp"
  ports    = ["22"]
}
allow {
  protocol = "tcp"
  ports    = ["2379-2380"]
}
    source_ranges = ["192.168.0.0/24"]
    }

 resource "google_dns_record_set" "jump" {
      name = "jump.cr460.com."
      type = "A"
      ttl  = 300

      managed_zone = "cr460"

      rrdatas = ["${google_compute_instance.jumphost.network_interface.0.access_config.0.assigned_nat_ip}"]
    }

    resource "google_dns_record_set" "vault" {
      name = "vault.cr460.com."
      type = "A"
      ttl  = 300

      managed_zone = "cr460"

      rrdatas = ["${google_compute_instance.vault.network_interface.0.access_config.0.assigned_nat_ip}"]
    }
