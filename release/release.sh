#!/bin/bash
set -e

echo "Building release..."

python --version
poetry --version

export REV=$(date +%s).$(git -C /src rev-parse HEAD)


# clean copy
# --no-hardlinks is due to an issue running in mac/docker w/ the directory in a mounted volume (i think)
git clone -l --no-hardlinks /src /rel


echo "VERSION:"
echo $REV | tee /rel/__version__.txt


pushd /rel
# build virtualenv (ends up in /rel/.venv)
export POETRY_VIRTUALENVS_IN_PROJECT=true
poetry install --no-dev -E production

# frontend build
yarn install --frozen-lockfile
NODE_ENV=production yarn build
poetry run python manage.py collectstatic

# copy entry script (see file for details)
cp /entry.sh ./

popd

#output release tarball into build directory
mkdir -p /src/_build
tar --exclude-vcs-ignores -zcvf /src/_build/rel-$REV.tar.gz /rel

echo "Packed: rel-$REV.tar.gz"
echo "RELEASE: $REV"
