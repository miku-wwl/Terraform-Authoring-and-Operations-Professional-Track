# Static example file for continuous validation.
# Do not move this file to the root module.

# TODO 6: Replace the placeholder source with an HTTP data source named website.
data "TODO" "website" {
  url = "TODO"
}

# TODO 7: Replace the placeholder check name with website_health.
check "TODO" {
  assert {
    # TODO 8: Check for a successful HTTP status code.
    condition = TODO

    # TODO 9: Add a useful unhealthy status message.
    error_message = "TODO"
  }
}
