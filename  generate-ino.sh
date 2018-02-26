cp $1 temp
awk -f inserter.awk temp > $1
