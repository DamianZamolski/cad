#!/bin/sh

build() {
  scad_file=$1
  error=$(openscad --hardwarning -o ${scad_file%.scad}.stl $scad_file 2>&1)
  if [ $? -ne 0 ]; then
    echo -e "$scad_file:\n$error\n"
  fi
}

rm --force **/*.stl
for scad_file in **/*.scad; do
  build $scad_file &
done
wait
