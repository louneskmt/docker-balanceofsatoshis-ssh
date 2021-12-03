#!/bin/bash

USER_NAME=${USER_NAME:-"umbrel"}
USER_PASSWORD=${USER_PASSWORD:-"moneyprintergobrrr"}

NETWORK=${NETWORK:-"mainnet"}
LND_PATH=${LND_PATH:-"/lnd"}
BOS_NODE_NAME=${BOS_NODE_NAME:-"umbrel"}
BOS_NODE_PATH=${BOS_NODE_PATH:-"/home/${USER_NAME}/.bos/${BOS_NODE_NAME}"}
export BOS_DEFAULT_SAVED_NODE=${BOS_NODE_NAME}

# Create user
id -u ${USER_NAME} &>/dev/null || {
	useradd -rm -d /home/${USER_NAME} -s /bin/bash ${USER_NAME}
	echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd
}

# Save node connection details
mkdir -p ${BOS_NODE_PATH}

cat <<EOF > ${BOS_NODE_PATH}/credentials.json
{
  "cert_path": "${LND_PATH}/tls.cert",
  "macaroon_path": "${LND_PATH}/data/chain/bitcoin/${NETWORK}/admin.macaroon",
  "socket": "${LND_IP}:${LND_PORT}"
}
EOF

# Configure motd (SSH welcome message)
cat <<EOF > /etc/motd
#########################
#        UMBREL         #
#  Balance Of Satoshis  #
#########################
EOF

mkdir -p /run/sshd
/usr/sbin/sshd -D