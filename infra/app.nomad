#
job "bookmarks" {
  datacenters = ["dc1"]
  type        = "service"

  group "application" {

    meta {
      rev = "1593483134.3c3692ae937404380ece1bd1b78d9612f8600a98"
    }

    count = 2

    update {
      canary = 2
      max_parallel = 2
      min_healthy_time = "10s"
      healthy_deadline = "1m"
      auto_revert = true
    }

    restart {
      attempts = 1
      interval = "30s"
      delay = "10s"
      mode = "delay"
    }

    task "django" {
      driver = "raw_exec"

      env {
        DJANGO_STATIC_URL = "/${NOMAD_META_rev}/static/"
      }

      config {
        command = "rel/entry.sh"
        args = [
          "rel/.venv/bin/gunicorn", "--workers=2", "--bind=0.0.0.0:${NOMAD_PORT_http}", "bookmarks.wsgi"
        ]
      }

      artifact {
        source = "http://localhost:8000/_build/rel-${NOMAD_META_rev}.tar.gz"
      }

      resources {
        # fake values for testing
        cpu = 20
        memory = 10

        network {
          mbits = 1  # fake
          port "http" {}
        }
      }

      resources {
        cpu = 20
        memory = 10

        network {
          mbits = 1
          port "http" {}
        }
      }

      env {
        IDENT = "${NOMAD_ALLOC_NAME}-${NOMAD_ALLOC_ID}"
      }

      service "django" {
        port = "http"

        tags = [
          "app",
          "rel-${NOMAD_META_rev}",
          "urlprefix-/",
        ]

        # check {
        #   name = "status"
        #   type = "http"
        #   port = "http"
        #   path = "/status"
        #   interval = "5s"
        #   timeout  = "2s"
        # }

        # had some weird issues getting http status check working (worked fine on an actual machine tho)
        check {
          name = "status"
          type = "script"
          command = "/usr/bin/curl"
          args = ["http://localhost:${NOMAD_PORT_http}/status"]
          interval = "5s"
          timeout = "2s"
        }
      }
    }

    task "static" {
      driver = "raw_exec"

      env {
        SERVER_NAME = "${NOMAD_ALLOC_NAME}-${NOMAD_ALLOC_ID}-static"
        SERVER_HOST = "0.0.0.0"
        SERVER_PORT = "${NOMAD_PORT_http}"
        SERVER_ROOT = "${NOMAD_TASK_DIR}/rel/pub"
        SERVER_ASSETS = "${NOMAD_TASK_DIR}/rel/pub"
      }

      config {
        command = "/usr/local/bin/static-web-server"
      }

      artifact {
        source = "http://localhost:8000/_build/rel-${NOMAD_META_rev}.tar.gz"
      }

      resources {
        # fake values for testing
        cpu = 20
        memory = 10

        network {
          mbits = 1
          port "http" {}
        }
      }

      service "static" {
        port = "http"

        tags = [
          "app.static",
          "rel-${NOMAD_META_rev}",
          "urlprefix-/${NOMAD_META_rev} strip=/${NOMAD_META_rev}",
        ]

        check {
          name = "status"
          type = "tcp"
          port = "http"
          interval = "5s"
          timeout = "2s"
        }
      }
    }
  }

}
