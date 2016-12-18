#!/bin/sh

ip='{query}'

result=$(curl -s https://www.ipip.net/ip.html -H "User-Agent: Safari/537.36" -H "Referer: https://www.ipip.net/ip.html" --data "ip=${ip}" --compressed)

/bin/echo '<?xml version="1.0"?>'
/bin/echo '<items>'

address=`echo "$result" | grep '<div><span id=\"myself\">' -A 1 |tail -n 1| sed "s/<\/span>//g" | sed "s/ //g"`

info=`echo "$result" |grep '<td style=\"text-align: center;\">' | sed -e 's/<[^>]*>//g' | sed "s/ //g" | sed "s/购买此数据//g" |sed "s/（.*）//g"`

# echo $address
# echo $info

if [[ ! -z "$address" ]]; then
	uid=`echo $address | md5 | awk '{print $1}'`
	echo '<item uid="'$uid'" arg="'$address'">'
	echo '<title>'$address'</title>'
	echo '<subtitle>ipip.net 数据</subtitle>'
	echo '<icon>icon.png</icon>'
	echo '</item>'
fi

if [[ ! -z "$info" ]]; then
    head=`echo "$info" | head -n 1`
    tail=`echo "$info" | tail -n 1`
    
    # echo "$head"
    # echo "$tail"

    if [[ "$head" == "$tail" ]]; then
        uid=`echo "$head" | md5 | awk '{print $1}'`
        echo '<item uid="'$uid'" arg="'$head'">'
        echo '<title>'$head'</title>'
        echo '<subtitle>IDC 猜测</subtitle>'
        echo '<icon>icon.png</icon>'
        echo '</item>'
    else
        uid=`echo "$head" | md5 | awk '{print $1}'`
        echo '<item uid="'$uid'" arg="'$head'">'
        echo '<title>'$head'</title>'
        echo '<subtitle>IDC 猜测</subtitle>'
        echo '<icon>icon.png</icon>'
        echo '</item>'

        uid=`echo "$tail" | md5 | awk '{print $1}'`
        echo '<item uid="'$uid'" arg="'$tail'">'
        echo '<title>'$tail'</title>'
        echo '<subtitle>端口数据</subtitle>'
        echo '<icon>icon.png</icon>'
        echo '</item>'
    fi
    
fi


# rtb-asia
rtbresult=$(curl -s "https://ip.rtbasia.com/webservice/ipip?ipstr=${ip}" -H 'Accept-Encoding: gzip, deflate, sdch, br' -H 'Accept-Language: zh-CN,zh;q=0.8' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: https://www.ipip.net/ip.html' -H 'Cache-Control: max-age=0' --compressed | grep '真人概率' | sed -e 's/<[^>]*>//g' | sed -e 's/&nbsp;//g' |sed "s/ //g"|sed "s/	//g")

# echo "$rtbresult"

if [[ ! -z "$rtbresult" ]]; then
	uid=`echo $rtbresult | md5 | awk '{print $1}'`
	echo '<item uid="'$uid'" arg="'$rtbresult'">'
	echo '<title>'$rtbresult'</title>'
	echo '<subtitle>RTBAsia非人类访问量甄别服务</subtitle>'
	echo '<icon>icon.png</icon>'
	echo '</item>'
fi

/bin/echo '</items>'
