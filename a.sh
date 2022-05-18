#!/bin/sh
copy() {
  target_dir="../scxgit/$1-svr"
  file="$1/$1-svr/target/$1-svr-1.2.4.jar"
  if [ -f "$file" ]; then
    mkdir -p "$target_dir"
    cp "$file" "$target_dir"
  fi
}

if [ -f "gateway-server/target/gateway-server-1.2.4.jar" ]; then
  mkdir -p ../scxgit/gateway-server
  cp gateway-server/target/gateway-server-1.2.4.jar ../scxgit/gateway-server
fi

$(copy "cap")
$(copy "jwt")
$(copy "msg")
$(copy "oap")
$(copy "orp")
$(copy "oss")
$(copy "rac")
$(copy "rll")
$(copy "sgn")
$(copy "wxx")
