resource "local_file" "account_note" {
  filename = "artifacts/account.txt"
  content  = "account=000000000000"
}

resource "aws_s3_bucket" "staged" {
  bucket = "tf-pro-162-staged"
}

resource "aws_s3_object" "note" {
  bucket     = aws_s3_bucket.staged.bucket
  key        = "account.txt"
  source     = local_file.account_note.filename
  depends_on = [local_file.account_note]
}

output "local_file_path" {
  value = local_file.account_note.filename
}

output "object_key" {
  value = aws_s3_object.note.key
}
