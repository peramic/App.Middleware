#!/bin/sh

. /etc/profile

APP=$(realpath $0)

NAME=havis.middleware
DEPS="havis.middleware.tdt havis.middleware.utils havis.middleware.ale-api havis.middleware.ale-impl"
INFO=/opt/havis-apps/info
EXIT=0

do_install()
{
  TMP=$(mktemp -d)
  cd $TMP
  sed '1,/^#EOF#$/d' "$APP" | tar x
  for dep in $DEPS; do
    case "$(dpkg -l $dep | grep "^ii" | awk '/^ii/{print $3}')" in
      2.3.*)
        ;;
      *)
        dpkg -i $dep\.deb
        ;;
    esac
  done
  if dpkg -i $NAME\.deb; then
    #sed '/^#EOF#$/,$d' "$APP" > $INFO/$NAME.app
    EXIT=0
  else
    EXIT=$?
    dpkg -r $NAME
  fi
  cd -
  rm -r $TMP
}

do_extract()
{
  TMP=$(mktemp -d)
  cd $TMP
  sed '1,/^#EOF#$/d' "$APP" | tar x
  for dep in $DEPS; do
    dpkg -x $dep\.deb $TARGET
  done
  dpkg -x $NAME\.deb $TARGET
  cd -
  rm -r $TMP
}

do_remove()
{
  if dpkg -r $NAME; then
    rm -f $INFO/$NAME.app
  else
    EXIT=$?
  fi
  for dep in $(echo $DEPS | awk '{ for (i=NF; i>1; i--) printf("%s ",$i); print $1; }'); do
    dpkg -r $dep
  done
}

case "$1" in
  name)
    echo $NAME.app
    ;;
  install)
    echo "Installing $NAME"
    do_install
    ;;
  remove)
    echo "Removing $NAME"
    do_remove
    ;;
  extract)
    echo "Extracting $NAME"
    do_extract
    ;;
  *)
    echo "Usage: $NAME {install|remove|extract}"
    exit 1
    ;;
esac

exit $EXIT