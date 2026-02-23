verificar() {
	local paq=$1
	echo "Buscando al paquete $paq:"

	if rpm -q $paq &> /dev/null; then
		echo -e "El paquete $paq fue instalado previamente.\n";
	else
		echo -e "El paquete $paq no ha sido instalado.\n"
	fi
}

if [[ $# -eq 0 ]]; then
	echo -e "\n"
	echo -e "---------------------------------------------"
	echo -e "---------- MENU SCRIPT SSH SERVER -'---------"
	echo -e "---------------------------------------------\n"

	echo -e "Para verificar el estado del servicio:"
	echo -e "./DNSPro.sh --verificar\n"

	echo -e "Para re/instalar el paquete:"
	echo -e "./DNSPro.sh --instalar\n"
fi

case $1 in
	--verificar)
		verificar "openssh-server"
		exit 0;
	;;

	--instalar)
		instalar() {
			local paq=$1
			echo "Buscando al paquete $paq:"
			if rpm -q $paq &> /dev/null; then
				echo -e "El paquete $paq fue instalado previamente.\n";
				flagSi=1
			else
				echo -e "El paquete $paq no ha sido instalado.\n"
				flagSi=0
			fi

			if [[ $flagSi == "0" ]]; then
				read -p "Deseas instalar el paquete $paq? s/n " res
				res=${res,,}
				if [[ $res == "s" ]]; then
					echo -e "Instalando el paquete $paq.\n"
					sudo dnf install -y $paq
				else
					echo -e "La instalacion fue cancelada.\n"
				fi
			else
				read -p "Deseas reinstalar el paquete $paq? s/n " res
				res=${res,,}
				if [[ $res == "s" ]]; then
					echo -e "Reinstalando el paquete $paq.\n"
					sudo dnf reinstall -y $paq
				else
					echo -e "La instalacion fue cancelada.\n"
				fi
			fi 
		}

		echo -e "Re/Instalacion de Paquetes: \n"
		instalar "bind"
		instalar "bind-utils"
		instalar "bind-doc"
	;;
esac