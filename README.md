This is a fake django app for exploring nomad


Layout:

`/bookmarks`
    - contains the django app. It only has 2 views, home (a fake landing page) and status (see urls.py)
    - status outputs the current version and the instance's identity

`/infra`
    - contains the docker image and nomad job files for the runtime

`/release`
    - contains the docker image used for building releases

`/static`
    - the output static files (used as a source for django's collectstatic)


The project includes a makefile for doing stuff. The main commands are:

`release` - build a new release. The packed file will be output to /_build/

`infra_shell` - start up a shell within the infra docker image. This allows you to run commands against the nomad server


'
