resource "google_compute_instance" "instance1" {
  name         = "intance1"
  machine_type = "f1-micro"
  zone         = "us-east1-b"

  disk {
      image = "debian-cloud/debian-8"
 }
}
