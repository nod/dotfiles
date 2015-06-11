#!/bin/bash

if [[ "$#" -lt 2 ]]; then
  echo "ERR incoorect number of arguments" >&2
  echo "usage: ${0} path_to_venv target [target_args]" >&2
  exit
fi

path_to_venv="$1"
shift
target="$1"
shift
target_args="${@:1}"

activate=$path_to_venv/bin/activate
if [ ! -f "$activate" ]; then
  echo ERR $activate does not exist. >&2
  echo     Ensure the path to the virtualenv correct >&2
  exit
fi

if [ ! -x "$target" ]; then
  echo ERR $target either does not exist or is not executable. >&2
  exit
fi

source "$activate"
exec "$target" "$target_args"

