source "$(dirname "$0")/funciones.sh"

if [[ $# -eq 0 ]]; then
	echo -e "\n"
	echo -e "---------------------------------------------"
	echo -e "---------- MENU SCRIPT SSH SERVER -'---------"
	echo -e "---------------------------------------------\n"

	echo -e "Para verificar el estado del servicio:"
	echo -e "./SSHPro.sh --verificar\n"

	echo -e "Para re/instalar el paquete:"
	echo -e "./SSHPro.sh --instalar\n"
fi

case $1 in
	--verificar)
		verificar "openssh-server"
		exit 0;
	;;

	--instalar)
		echo -e "Re/Instalacion de Paquetes: \n"
		instalar "openssh-server"
		exit 0
	;;
esac