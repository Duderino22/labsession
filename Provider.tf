// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("account.json")}"
  project     = "cr460-157720"
  region      = "us-east1"
}
