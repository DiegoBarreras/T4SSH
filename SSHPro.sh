verificar() {
	local paq=$1
	echo "Buscando al paquete $paq:"

	if rpm -q $paq &> /dev/null; then
		echo -e "El paquete $paq fue instalado previamente.\n";
	else
		echo -e "El paquete $paq no ha sido instalado.\n"
	fi
}

prenderservicio() {
    local servicio=$1
    echo "Habilitando el servicio $servicio:"
    systemctl enable $servicio
    systemctl start $servicio
    echo -e "Servicio $servicio habilitado y activo.\n"
}

instalar() {
	local paq=$1
	echo "Buscando al paquete $paq:"
	if rpm -q $paq &> /dev/null; then
		echo -e "El paquete $paq fue instalado previamente.\n";
		read -p "Deseas reinstalar el paquete $paq? s/n " res
		res=${res,,}
		if [[ $res == "s" ]]; then
			echo -e "Reinstalando el paquete $paq.\n"
			sudo dnf reinstall -y $paq
			prenderservicio "sshd"
		else
			echo -e "La instalacion fue cancelada.\n"
		fi
	else
		echo -e "El paquete $paq no ha sido instalado.\n"
		read -p "Deseas instalar el paquete $paq? s/n " res
		res=${res,,}
		if [[ $res == "s" ]]; then
			echo -e "Instalando el paquete $paq.\n"
			sudo dnf install -y $paq
			prenderservicio "sshd"
		else
			echo -e "La instalacion fue cancelada.\n"
		fi
	fi
}

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