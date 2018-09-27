#!/bin/bash

#https://cloud.google.com/text-to-speech/docs/reference/rest/v1beta1/text/synthesize#authorization-scopes
#https://console.cloud.google.com/apis/library/texttospeech.googleapis.com?project=XXXXXX
PROJECT_ID=
CLIENT_ID=
CLIENT_SECRET=
CODE=
REFRESH_TOKEN=

if [ -z "$CLIENT_ID" ]; then
	echo "Need to set CLIENT_ID"
	exit 1
fi
if [ -z "$PROJECT_ID" ]; then
	echo "Need to set PROJECT_ID"
	exit 1
fi
if [ -z "$CLIENT_SECRET" ]; then
	echo "Need to set CLIENT_SECRET"
	exit 1
fi

if [ -z "$REFRESH_TOKEN" ]; then
	if [ -z "$CODE" ]; then
		echo 'Need to set CODE in order to obtain REFRESH_TOKEN, please go to this URL: https://accounts.google.com/o/oauth2/auth?scope=https://www.googleapis.com/auth/cloud-platform&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&access_type=offline&client_id='$CLIENT_ID
	else
		echo "Paste following curl command and set REFRESH_TOKEN: curl -X POST -d \"grant_type=authorization_code&client_id="$CLIENT_ID"&client_secret="$CLIENT_SECRET"&code="$CODE"&redirect_uri=urn:ietf:wg:oauth:2.0:oob\" \"https://www.googleapis.com/oauth2/v3/token\""
	fi
	exit 1
else
	echo -n '{"client_id": "'$CLIENT_ID'", "token_uri": "https://www.googleapis.com/oauth2/v3/token", "client_secret": "'$CLIENT_SECRET'", "scopes": ["https://www.googleapis.com/auth/assistant-sdk-prototype"], "refresh_token": "'$REFRESH_TOKEN'"}' > credentials.json
fi

access_token=$(curl -s -k -X POST -H "Content-Type: application/json" \
	-d '{"client_id":"'$CLIENT_ID'","client_secret":"'$CLIENT_SECRET'","refresh_token":"'$REFRESH_TOKEN'","grant_type":"refresh_token"}' \
	https://www.googleapis.com/oauth2/v4/token | grep -oP '"access_token": "\K([^"]+)')

echo "access_token: "$access_token

#curl -X GET "https://texttospeech.googleapis.com/v1/voices" \
#	 -H "Authorization: Bearer "$access_token \
#	 -H "Content-Type: application/json; charset=utf-8"

languageCode="fr-FR"
#  Wavenet ou Standard		A ou C et B ou D
name='fr-FR-Wavenet-B'
ssmlGender="MALE"

type="ssml"
message=""
message+="<speak>"
message+="<par>"
message+='<media soundLevel=\"+12db\"><audio clipEnd=\"20s\" src=\"https://actions.google.com/sounds/v1/office/keyboard_typing_fast.ogg\"></audio></media>'
message+='<media soundLevel=\"-6db\">'
message+="<speak>"
message+="<p>"
message+="<s>"
message+="Bonjour, "
message+='<break time=\"200ms\"/>'
message+="vous êtes sur la messagerie de ... ...... ."
message+='<break time=\"850ms\"/>'
message+="Actuellement indisponible ou en rendez-vous, il vous invite à lui laisser un SMS ou un email sur .... . Il vous recontactera dans les plus bref délais, merci et à bientôt."
message+="</s>"
message+="</p>"
message+="</speak>"
message+="</media>"
message+="</par>"
message+="</speak>"

speech=$(curl -s \
	 -X POST "https://texttospeech.googleapis.com/v1/text:synthesize" \
	 -H "Authorization: Bearer "$access_token \
	 -H "Content-Type: application/json; charset=utf-8" \
	 --data "{\"input\":{\"$type\":\"$message\"},\"voice\":{\"languageCode\":\"$languageCode\",\"name\":\"$name\",\"ssmlGender\":\"$ssmlGender\"},\"audioConfig\":{\"audioEncoding\":\"LINEAR16\"}}" \
| jq -r '.audioContent')


echo $speech | base64 --decode > /tmp/speech.wav

aplay /tmp/speech.wav

exit 0

