# system services
#
# This should be run once before trying to run the app.nomad file so that the appropriate system services are running!
#
job "system" {
  datacenters = ["dc1"]
  type = "system"


  group "rel-server" {
    count = 1

    task "service" {
      driver = "raw_exec"

      config {
        command = "/usr/local/bin/static-web-server"
        args = [
         "--name", "rel-server", "--host", "0.0.0.0", "--port", "${NOMAD_PORT_http}", "--root", "/src/", "--assets", "/src/_build/"
         ]
      }

      resources {
        cpu = 20
        memory = 10
        network {
          mbits = 1
          port "http" {
            static = 8000
          }
        }
      }

      service "rel-server" {
        port = "http"

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

  group "fabio" {
    count = 1

    task "service" {
      driver = "raw_exec"

      config {
        command = "/usr/local/bin/fabio"
        args = ["-insecure"]
      }

      resources {
        cpu = 20
        memory = 10
        network {
          mbits = 1
          port "http" {
            static = 9999
          }
          port "ui" {
            static = 9998
          }
        }
      }
    }
  }



}
