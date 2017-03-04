resource "google_compute_network" "cr460labsession" {
  name                    = "cr460labsession"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "public" {
  name          = "public"
  ip_cidr_range = "172.16.1.0/24"
  network       = "${google_compute_network.cr460labsession.self_link}"
  region        = "us-west1"
}

resource "google_compute_subnetwork" "workload" {
  name          = "workload"
  ip_cidr_range = "10.1.1.0/24"
  network       = "${google_compute_network.cr460labsession.self_link}"
  region        = "us-east1"
}

resource "google_compute_subnetwork" "backend" {
  name          = "backend"
  ip_cidr_range = "192.168.0.0/24"
  network       = "${google_compute_network.cr460labsession.self_link}"
  region        = "us-central1"
}

resource "google_compute_firewall" "web" {
  name    = "web"
  network = "${google_compute_network.cr460labsession.name}"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

resource "google_compute_firewall" "ssh" {
  name    = "ssh"
  network = "${google_compute_network.cr460labsession.name}"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

}
resource "google_compute_firewall" "https" {
    name     = "https"
    network  ="${google_compute_network.cr460labsession.name}"
    allow {
      protocol = "tcp"
      ports    = ["443"]
 }
}
resource "google_dns_record_set" "jump" {
  name = "jump.labsession.com."
  type = "A"
  ttl  = 300

  managed_zone = "labsession"

  rrdatas = ["${google_compute_instance.instance1.network_interface.0.access_config.0.assigned_nat_ip}"]
}
