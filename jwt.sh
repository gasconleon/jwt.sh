#! /bin/bash
# Version: 0.2
# Desc:JWT encode and decode
# Author: Alejandro Gascón
# mail: gascon.leon@gmail.com
# PENDING:
# - Include decoding functions
# - Add support for more algorithms
# - Include default values in payload with their correspondig values (exp, iat, sub)

ayuda() {
	echo "$0 Params:"
	echo -e "\t-b | --b64url <value>\t\tConvert <value> to base64Url and exit"
	echo -e "\t-a | --algorithm <value>\tSet the algorithm to be used. Valid values are:"
	echo -e "\t\t* h | H | HMAC | HS256 -> for HMAC SHA256. This will require to set -S option"
	echo -e "\t\t* r | R | RSA | RS256  -> for RSA SHA256. This will require to set -P option"
	echo -e "\t-S | --secret <value>\t\tSecret to be used with HS256"
	echo -e "\t-P | --pub-key | --pub <file>\tPath to file with the Private RSA to sign the token"
	echo -e "\t-H | --header <value>\t\tJSON value to set as header part of the JWT. If you don't specify this option, It will be generated automatically with -k | --kid value"
	echo -e "\t-p | --payload <value>\t\tJSON value to set as payload part of the JWT"
	echo -e "\t-k | --kid <value>\t\tSet the kid value to be used when autogenerating the header"
}

# Parsing params
while (( $# )); do
	case $1 in
		-h | --help)
			ayuda
			exit 0;
		;;
		-b | --b64url)
			shift;
			echo -e "Base64Url:\n" && echo $(echo -n "$*" | openssl enc -base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n' ) && echo "";
			exit 0;
		;;
		-k | --kid)
			kid=$2;
			shift;
		;;
		-a | --algorithm)
			if [[ "$2" =~ h|H|HMAC|HS256 ]]; then
				cipher="HS256";
			else
				if [[ "$2" =~ r|R|RSA|RS256 ]]; then
					cipher="RS256";
				else
					echo -e "Cypher not known. Valid values are:\n\t - h | H | HMAC | HS256 -> for HS256\n\t - r | R | RSA | RS256 -> for RS256"
					exit 1;
				fi
			fi
			shift;
		;;
		-H | --header)
		 	header=$(jq -c -r . <<< "$2" 2>&1);
			[ $? -ne 0 ] && echo "--header param seems not to be a valid json. Error: $header" && exit 1;
			header=$(echo -n "$header" | openssl enc -base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n' )
			shift;
		;;
		-p | --payload)
		 	payload=$(jq -c -r . <<< "$2" 2>&1);
			[ $? -ne 0 ] && echo "--payload param seems not to be a valid json. Error: $payload" && exit 1;
			payload=$(echo -n "$payload" | openssl enc -base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n' )
			shift;
		;;
		-S | --secret)
			secret="$2"
			shift;
		;;
		-P | --pub-key | --pub)
			[ ! -f $2 ] && echo "$2 is not a file" && exit 1
			pub_key=$2
			shift;
		;;
	esac;
	shift;
done
[[ "$cipher" == "" ]] && echo "Please, set -a | --algorithm option to HS256 or RS256." && exit 2

if [[ "$header" == "" ]]; then
	header=$(jq -c -r . <<< "{\"alg\": \"$cipher\", \"typ\": \"JWT\", \"kid\": \"$kid\"}")
	header=$(echo -n "$header" | openssl enc -base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n' )
fi


case $cipher in
	HS256)
		[[ "$secret" == "" ]] && echo "You need to set a secret with option -S" && exit 2
		signature=$(echo -n "${header}.${payload}" | openssl dgst -sha256 -binary -hmac "${secret}" | openssl enc -base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n' )
		[ $? -ne 0 ] && echo "Some problem occur when generating signature. Error: $signature" && exit 3
	;;
	RS256)
		[[ "$pub_key" == "" ]] && echo "You need to set a secret with option -P" && exit 2
		signature=$(echo -n "${header}.${payload}" | openssl dgst -sha256 -binary -sign ${pub_key} | openssl enc -base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n' )
		[ $? -ne 0 ] && echo "Some problem occur when generating signature. Error: $signature" && exit 3
	;;
	*)
		echo "What happended?? cipher equals to '$cipher'!!" && exit 10
	;;
esac

echo "${header}.${payload}.${signature}"
