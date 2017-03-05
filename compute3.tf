resource "google_compute_instance" "etcd1" {
  name         = "etcd1"
  machine_type = "f1-micro"
  zone         = "us-east1-b"

  disk {
    image = "coreos-cloud/coreos-stable"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.backend.name}"
    access_config {

    }
  }
}

resource "google_compute_instance" "etcd2" {
  name         = "etcd2"
  machine_type = "f1-micro"
  zone         = "us-east1-b"

  disk {
    image = "coreos-cloud/coreos-stable"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.backend.name}"
    access_config {

    }
  }
}

resource "google_compute_instance" "etcd3" {
  name         = "etcd3"
  machine_type = "f1-micro"
  zone         = "us-east1-b"

  disk {
    image = "coreos-cloud/coreos-stable"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.backend.name}"
    access_config {

    }
  }
}
