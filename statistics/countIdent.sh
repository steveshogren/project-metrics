#!/bin/sh

DT=`date +"%m-%d-%y"`
CNT=`git grep  '\.FindAll(' | grep -vE 'Algo.Collateral.Core|Proxies|Database|Test|Reporting|Wilson|packages|lib|Designer' | grep '\.cs:' | wc -l`
echo "['$DT', $CNT]"  >> statistics/findall.csv
CNT=`git grep  '\.Find(' | grep -vE 'Algo.Collateral.Core|Proxies|Database|Test|Reporting|Wilson|packages|lib|Designer' | grep '\.cs:' | wc -l`
echo "['$DT', $CNT]"  >>statistics/find.csv
CNT=`git grep  '\.Save(' | grep -vE 'Algo.Collateral.Core|Proxies|Database|Test|Reporting|Wilson|packages|lib|Designer' | grep '\.cs:' | wc -l`
echo "['$DT', $CNT]"  >> statistics/save.csv
CNT=`git grep  -w 'Identifier' | grep -vE 'Algo.Collateral.Core|Proxies|Database|Test|Reporting|Wilson' | grep '\.cs:' | wc -l `
echo "['$DT', $CNT]"  >> statistics/identifier.csv

