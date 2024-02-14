function copyitem
{
  if [ -L /$1 ] ; then
    TARGET=$(readlink /$1)
    if echo $TARGET | grep "^/" > /dev/null ; then
      mkdir -p $INST_TARGET$(dirname $TARGET)
      copyitem $(echo $TARGET | sed 's/^\///')
    else
      mkdir -p $INST_TARGET$(dirname /$1)
      copyitem $(dirname /$1 | sed 's/^\///')/$TARGET
    fi
    mkdir -p $INST_TARGET$(dirname /$1)
    ln -s $(readlink /$1) $INST_TARGET/$1
  else
    mkdir -p $INST_TARGET$(dirname /$1)
    cp -av /$1 $INST_TARGET/$1
  fi
}

if [ $# -ne 1 ] ; then
  echo "target directory not specified"
  exit 5
else
  INST_TARGET=$1
fi
for item in $(ldd bin/hello | \
              sed 's/(0x.*//' | \
              awk '{if ($2 == "=>"){if (NF > 2){print $3}} else {print $1}}' | \
              sed 's/^\///' \
            ) ; do
  copyitem $item
done
