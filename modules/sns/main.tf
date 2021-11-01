resource "aws_sns_topic" "topic" {
  count = var.ENABLE_FEEDBACK_SUBMISSION ? 1 : 0
  name  = var.TOPIC_NAME
}

resource "aws_sns_topic_subscription" "email-target" {
  count = var.ENABLE_FEEDBACK_SUBMISSION ? 1 : 0

  topic_arn = aws_sns_topic.topic[count.index].arn
  protocol  = "email"
  endpoint  = var.EMAIL_ENDPOINT
}

