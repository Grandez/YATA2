rm icons.txt 2> /dev/null
c:\sdk\R\R-4.1.2\bin\Rscript --default-packages="YATABatch" -e getSlug() > slug.txt
while read -r line; do 
   curl https://coinmarketcap.com/currencies/${line##*( )}/ -o page.txt
   grep -o -E "200x200[0-9]+" > grep.txt
   read -r icon < grep.txt
   echo https://s2.coinmarketcap.com/static/img/coins/${icon}.png >> icons.txt
done < input.file