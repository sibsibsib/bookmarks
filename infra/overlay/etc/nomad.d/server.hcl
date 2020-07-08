# Increase log verbosity
log_level = "DEBUG"

# Setup data dir
data_dir = "/nomad"

# Enable the server
server {
    enabled = true

    # Self-elect, should be 3 or 5 for production
    bootstrap_expect = 1
}


client {
    enabled = true
}

plugin "raw_exec" {
  config {
    enabled = true
    no_cgroups = true
  }
}
