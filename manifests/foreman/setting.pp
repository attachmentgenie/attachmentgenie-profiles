define profiles::foreman::setting (
  $value,
) {
  foreman_config_entry { $name:
    value =>$value,
  }
}