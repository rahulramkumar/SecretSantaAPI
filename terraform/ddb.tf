resource "aws_dynamodb_table" "participants-table" {
  name     = "secretsanta-participants"

  write_capacity = 1
  read_capacity = 1

  hash_key = "Giver"
  range_key = "Recipient"
  attribute {
    name = "Giver"
    type = "S"
  }

  attribute {
    name = "Recipient"
    type = "S"
  }
}