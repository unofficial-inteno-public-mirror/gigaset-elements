#!/bin/sh

CURRENT_DIR=$(dirname $0)


source ${CURRENT_DIR}/env.sh


CERTDIR="/usr/gigaset/data/cert"
CERTFILE="${CERTDIR}/cert"
CSR=${CERTFILE}.csr
KEYPAIR=${CERTFILE}.key
PUB=${CERTFILE}.pub
CERT=${CERTFILE}.crt
BACKUP=${CERT}.bkp

OPENSSL_CONF=${CERTDIR}/openssl.cnf


gen_ssl_conf() {
    echo "[ distinguished_name ]"               > ${OPENSSL_CONF}
    echo "C     = DE"                           >> ${OPENSSL_CONF}
    echo "ST    = North Rhine-Westphalia"       >> ${OPENSSL_CONF}
    echo "L     = Dusseldorf"                   >> ${OPENSSL_CONF}
    echo "O     = Gigaset Communications GmbH"  >> ${OPENSSL_CONF}
    echo "CN    = ${DEVICE_ID}"                 >> ${OPENSSL_CONF}
}

gen_ssl_files() {

    # Make sure that cert directory exists
    if ! [ -d ${CERTDIR} ]; then
        mkdir -p ${CERTDIR}
    fi

    # Generate openssl configuration file
    gen_ssl_conf


    # Generate key pair if necessary
    if [ -f ${KEYPAIR} ]; then
        echo "Key file ${KEYPAIR} already exists. Skipping generation."
    else
        echo "Generating key file"
        /usr/bin/coco genkey --out ${KEYPAIR}
    fi

    # Generate certificate request if necessary
    if [ -f ${CSR} ]; then
        echo "CSR file ${CSR} already exists. Skipping generation."
    else
        echo "Generating csr file"
        /usr/bin/coco gencsr --conf ${OPENSSL_CONF} --in ${KEYPAIR} --out ${CSR}
    fi

    # Certificate recovering
    if [ ! -f ${CERT} ]; then
        if [ -f ${BACKUP} ]; then
            echo "Recovering certificate from backup."
            mv ${BACKUP} ${CERT}
        fi
    fi

}


gen_ssl_files

