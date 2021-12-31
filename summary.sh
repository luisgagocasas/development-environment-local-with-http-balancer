#!/bin/bash

slave=""
for ((i=1;i<=$2;i++)); do
  slave+=" - http://$1$i;\n"
done

echo -e "
Master:
  - http://$10\n
Slave: \n
$slave"