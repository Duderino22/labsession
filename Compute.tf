resource "google_compute_instance" "jumphost" {
  name         = "jumphost"
  machine_type = "f1-micro"
  zone         = "us-east1-b"

  disk {
    image = "debian-cloud/debian-8"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.public.name}"
    access_config {

    }
  }

  metadata_startup_script = "apt-get -y install apache2 && systemctl start apache2"
}
resource "google_compute_instance" "vault" {
  name         = "vault"
  machine_type = "f1-micro"
  zone         = "us-east1-b"

  disk {
    image = "coreos-cloud/coreos-stable"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.public.name}"
    access_config {

    }
  }
}
