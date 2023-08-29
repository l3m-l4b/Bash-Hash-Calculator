#!/bin/bash

# Función para calcular y mostrar el hash de un archivo
calculate_hash() {
    local algorithm=$1
    local file=$2

    if [ -f "$file" ]; then
        hash_value=$(openssl dgst -"$algorithm" "$file" | awk '{print $2}')
    else
        hash_value=""
    fi
}

# Habilitar autocompletación para la ruta del archivo y obtener solo el nombre del archivo
read -e -i "" -p "Ingresa la ruta del archivo: " file_path
file_name=$(basename "$file_path")

# Solicitar al usuario que elija un algoritmo
echo "Elige un algoritmo de hash:"
echo "1. SHA-1"
echo "2. SHA-256"
echo "3. SHA-512"
read -p "Ingresa el número del algoritmo: " algorithm_choice

case $algorithm_choice in
    1) algorithm="sha1";;
    2) algorithm="sha256";;
    3) algorithm="sha512";;
    *) echo "Opción no válida."; exit;;
esac

# Calcula el hash utilizando el algoritmo elegido
calculate_hash "$algorithm" "$file_path"
hash_calculated=$hash_value

# Comparar el valor hash proporcionado por el usuario
read -p "Ingresa el valor hash a comparar: " user_hash

# Mostrar los valores hash y compararlos
echo "#############################################################"
echo "#####                      RESULTADO                     ####"
echo "#############################################################"

echo -e "Valor hash calculado: \033[1;34m$hash_calculated\033[0m"
echo -e "Valor hash ingresado: \033[1;34m$user_hash\033[0m"

# Comparar con el valor hash generado
if [ "$user_hash" == "$hash_calculated" ]; then
    echo -e "\033[1;32mEl valor hash $algorithm coincide.\033[0m"
else
    echo -e "\033[1;31mEl valor hash proporcionado no coincide con el valor hash $algorithm generado.\033[0m"
fi
