#!/bin/bash

# User configuration
USER_NAME=${USER_NAME:-"umbrel"}
USER_PASSWORD=${USER_PASSWORD:-"moneyprintergobrrr"}

# Lightning and BoS configuration
NETWORK=${NETWORK:-"mainnet"}
LND_PATH=${LND_PATH:-"/lnd"}
BOS_NODE_NAME=${BOS_NODE_NAME:-"umbrel"}
BOS_NODE_PATH=${BOS_NODE_PATH:-"/home/${USER_NAME}/.bos/${BOS_NODE_NAME}"}
echo "BOS_DEFAULT_SAVED_NODE=${BOS_NODE_NAME}" >> /etc/environment

# Create user
id -u ${USER_NAME} &>/dev/null || {
	useradd -rm -d /home/${USER_NAME} -u 1000 -s /bin/bash ${USER_NAME}
  groupmod -g 1000 ${USER_NAME}
	echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd
}

# Save umbrel.local host (to avoid node warning)
echo "${LND_IP} umbrel.local" >> /etc/hosts

# Save node connection details
mkdir -p ${BOS_NODE_PATH}

cat <<EOF > ${BOS_NODE_PATH}/credentials.json
{
  "cert_path": "${LND_PATH}/tls.cert",
  "macaroon_path": "${LND_PATH}/data/chain/bitcoin/${NETWORK}/admin.macaroon",
  "socket": "umbrel.local:${LND_PORT}"
}
EOF

chown -R 1000:1000 "/home/${USER_NAME}"

# Configure motd (SSH welcome message)
cat <<EOF > /etc/motd

###################################
#                                 #
#             UMBREL              #
#       Balance Of Satoshis       #
#                                 #
###################################

Usage: bos <command>

EOF

mkdir -p /run/sshd
/usr/sbin/sshd -D