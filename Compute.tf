resource "google_compute_instance" "instance1" {
  name         = "instance1"
  machine_type = "f1-micro"
  zone         = "us-east1-b"

  disk {
    image = "coreos-cloud/coreos-stable"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.workload.name}"
    access_config {

    }
  }

  metadata_startup_script = "apt-get -y install apache2 && systemctl start apache2"
}
resource "google_compute_instance_template" "labtemplate1" {
  name        = "labtemplate1"
  machine_type         = "f1-micro"
  can_ip_forward       = false



  // Create a new boot disk from an image
  disk {
    source_image = "coreos-cloud/coreos-stable"
    auto_delete = true
    boot = true
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.workload.name}"
    subnetwork = "${google_compute_subnetwork.backend.name}"
  }

}

resource "google_compute_instance_group_manager" "labsession" {
  name        = "labsession"

base_instance_name = "workload"
  instance_template  = "${google_compute_instance_template.labtemplate1.self_link}"
  zone               = "us-east1-b"

}

resource "google_compute_autoscaler" "labsession" {
  name   = "labsessionauto"
  zone   = "us-east1-b"
  target = "${google_compute_instance_group_manager.labsession.self_link}"

  autoscaling_policy = {
    max_replicas    = 5
    min_replicas    = 3
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}
