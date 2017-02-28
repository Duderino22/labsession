resource "google_compute_network" "cr460labsession" {
  name                    = "cr460labsession"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "Public" {
  name          = "Public"
  ip_cidr_range = "172.31.0.0/24"
  network       = "${google_compute_network.cr460labsession.self_link}"
  region        = "us-east1"
}


resource "google_compute_subnetwork" "Workload" {
  name          = "Workload"
  ip_cidr_range = "10.0.1.0/24"
  network       = "${google_compute_network.cr460labsession.self_link}"
  region        = "us-centra1"
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
  network = "${google_compute_network.cr460.name}"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  resource "google_compute_firewall" "https" {
    name    = "https"
    network = "${google_compute_network.cr460.name}"
    allow {
      protocol = "tcp"
      ports    = ["443"]
    }
