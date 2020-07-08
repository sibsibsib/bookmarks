from python:3.8-slim-buster


RUN apt-get update -qq
RUN apt-get install -yq curl git

# install poetry
ENV POETRY_HOME=/usr/local/poetry
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
RUN ln -sf /usr/local/poetry/bin/poetry /usr/local/bin/poetry

# install node
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
RUN curl -o- -L https://yarnpkg.com/install.sh | bash
RUN ln -s /root/.yarn/bin/yarn /usr/local/bin/yarn

COPY release.sh /release.sh
COPY entry.sh /entry.sh

CMD ["/bin/bash"]
