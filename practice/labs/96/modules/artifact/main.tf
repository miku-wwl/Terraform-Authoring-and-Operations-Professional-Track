resource "local_file" "artifact" {
  filename = "${path.root}/output/${var.name}.txt"
  content  = "${var.content}\n"
}
