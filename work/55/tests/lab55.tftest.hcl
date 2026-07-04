run "count_index_expressions_are_correct" {
  command = apply

  assert {
    condition     = output.user_names == ["user-01", "user-02", "user-03"]
    error_message = "user_names must contain user-01, user-02, and user-03."
  }

  assert {
    condition     = output.user_count == 3
    error_message = "user_count must be calculated from local.user_names."
  }

  assert {
    condition     = output.resource_count == 3
    error_message = "terraform_data.user must create one instance per user name with count."
  }

  assert {
    condition     = output.first_user_name == "user-01"
    error_message = "first_user_name must come from terraform_data.user[0].output.name."
  }

  assert {
    condition     = output.second_user_index == 1
    error_message = "second_user_index must come from terraform_data.user[1].output.index."
  }

  assert {
    condition     = output.created_user_names == ["user-01", "user-02", "user-03"]
    error_message = "created_user_names must collect names from all count-created instances."
  }

  assert {
    condition     = output.created_user_labels == ["user-0-user-01", "user-1-user-02", "user-2-user-03"]
    error_message = "created_user_labels must include each count.index and matching user name."
  }
}
