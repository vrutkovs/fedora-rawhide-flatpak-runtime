#!/bin/sh

SRC_COMMIT=$1
shift
DST_COMMIT=$1
shift
METADATA=$1
shift

set -e
DIR=`mktemp -d .commit-XXXXXX`
GPG_ARGS="--gpg-sign=275852C6 --gpg-homedir=/home/vrutkovs/.gnupg"

set -x
cp $METADATA $DIR/metadata
while (( "$#" )); do
    mkdir -p `dirname $DIR/$2`
    ostree checkout --repo=repo --subpath=$1 -U $SRC_COMMIT $DIR/$2
    shift 2
done
sudo ostree commit --repo=repo --no-xattrs --owner-uid=0 --owner-gid=0 --link-checkout-speedup -s "Commit" ${GPG_ARGS} --branch $DST_COMMIT $DIR
sudo ostree summary -u --repo=repo ${GPG_ARGS}
sudo rm -rf $DIR
