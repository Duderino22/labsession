resource "google_compute_instance" "work-master" {
  name         = "work-master"
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
}
resource "google_compute_instance_template" "template-workers" {
  name         = "template-workers"
  machine_type = "f1-micro"
  can_ip_forward = false

  disk {
    source_image = "coreos-cloud/coreos-stable"
    auto_delete = true
    boot = true
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.workload.name}"
  }
}
resource "google_compute_instance_group_manager" "grp-workers" {
  name        = "grp-workers"

  base_instance_name = "grp-workers"
  instance_template  = "${google_compute_instance_template.template-workers.self_link}"
  zone               = "us-east1-c"

}

resource "google_compute_autoscaler" "grp-workers-autoscaler" {
  name   = "grp-workers-autoscaler"
  zone   = "us-east1-c"
  target = "${google_compute_instance_group_manager.grp-workers.self_link}"

  autoscaling_policy = {
    max_replicas    = 5
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}
