#!/bin/bash
declare -A cor=( [0]="\033[1;37m" [1]="\033[1;34m" [2]="\033[1;31m" [3]="\033[1;33m" [4]="\033[1;32m" )
barra="\033[0m\e[34m======================================================\033[1;37m"
SCPdir="/etc/newadm" && [[ ! -d ${SCPdir} ]] && exit 1
SCPfrm="/etc/ger-frm" && [[ ! -d ${SCPfrm} ]] && exit
SCPinst="/etc/ger-inst" && [[ ! -d ${SCPinst} ]] && exit
SCPidioma="${SCPdir}/idioma" && [[ ! -e ${SCPidioma} ]] && touch ${SCPidioma}

#PAYYLOADS
link_bin="https://raw.githubusercontent.com/AAAAAEXQOSyIpN2JZ0ehUQ/ADM-ULTIMATE-NEW-FREE/master/Install/payloads"
[[ ! -e /bin/payloads ]] && wget -O /bin/payloads ${link_bin} > /dev/null 2>&1 && chmod +x /bin/payloads

#PREENXE A VARIAVEL $IP
meu_ip () {
MEU_IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
MEU_IP2=$(wget -qO- ipv4.icanhazip.com)
[[ "$MEU_IP" != "$MEU_IP2" ]] && IP="$MEU_IP2" || IP="$MEU_IP"
}

msg -azu "$(fun_trans "GERADOR DE PAYLOAD") \033[1;32m[NEW-ADM]"
msg -bar
msg -ama "$(fun_trans " Digite um host para criar payloads genericas!")"
msg -bar
read -p "$(fun_trans " host"): " valor1
if [ "$valor1" = "" ]; then
msg -bra "$(fun_trans "N�o adicione nada.")"
return
fi
meu_ip
valor2="$IP"
if [ "$valor2" = "" ]; then
valor2="127.0.0.1"
fi
msg -bar
msg -ama "$(fun_trans "ESCOLHA O METODO DE REQUISICAO")"
msg -bar
echo -e "\033[1;37m 1-GET"
echo -e " 2-CONNECT"
echo -e " 3-PUT"
echo -e " 4-OPTIONS"
echo -e " 5-DELETE"
echo -e " 6-HEAD"
echo -e " 7-TRACE"
echo -e " 8-PROPATCH"
echo -e " 9-PATCH"
msg -bar
read -p "[1-9]: " valor3
case $valor3 in
1)
req="GET"
;;
2)
req="CONNECT"
;;
3)
req="PUT"
;;
4)
req="OPTIONS"
;;
5)
req="DELETE"
;;
6)
req="HEAD"
;;
7)
req="TRACE"
;;
8)
req="PROPATCH"
;;
9)
req="PATCH"
;;
*)
req="GET"
;;
esac
msg -bar
msg -ama "$(fun_trans "E POR ULTIMO, ESCOLHA")"
msg -ama "$(fun_trans "METODO DE INJECAO!")"
msg -bar
echo -e "\033[1;37m 1-realData"
echo -e " 2-netData"
echo -e " 3-raw"
msg -bar
read -p "[1-3]: " valor4
case $valor4 in
1)
in="realData"
;;
2)
in="netData"
;;
3)
in="raw"
;;
*)
in="netData"
;;
esac
msg -bar
name=$(echo $valor1 | awk -F "/" '{print $2'})
if [ "$name" = "" ]; then
name=$(echo $valor1 | awk -F "/" '{print $1'})
fi
esquelet="/bin/payloads"
sed -s "s;realData;abc;g" $esquelet > $HOME/$name.txt
sed -i "s;netData;abc;g" $HOME/$name.txt
sed -i "s;raw;abc;g" $HOME/$name.txt
sed -i "s;abc;$in;g" $HOME/$name.txt
sed -i "s;get;$req;g" $HOME/$name.txt
sed -i "s;mhost;$valor1;g" $HOME/$name.txt
sed -i "s;mip;$valor2;g" $HOME/$name.txt
if [ "$(cat $HOME/$name.txt | egrep -o "$valor1")" = "" ]; then
echo -e ""
echo -e "\033[1;33m $(fun_trans "ALGO DEU") \033[1;36m$(fun_trans "ERRADO!")"
rm $HOME/$name.txt
return
fi
echo -e "\033[1;36m $(fun_trans "SUCESSO, PAYLOADS GERADAS")"
echo -e "\033[1;36m $(fun_trans "DIRETORIO:") \033[1;32m$HOME/$name.txt"
msg -bar