# Start REST Server in Linux
# Author: Grandez
#
max=0
if [ $# gt 1] ; then max=$1 ; fi
Rscript --no-save --no-restore --default-packages="YATABatch" -e "YATABatch::updateTickers(max=$max)"

