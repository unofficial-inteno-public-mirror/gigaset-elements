#!/bin/sh


DATA_DIR="${DATA_DIR:-/usr/gigaset/data}"

CERT_DIR=$DATA_DIR/cert

KEY_FILE=$CERT_DIR/cert.key
CSR_FILE=$CERT_DIR/cert.csr
CERT_FILE=$CERT_DIR/cert.crt
BACKUP_FILE=$CERT_DIR/cert.crt.bkp
OPENSSL_CONF=$CERT_DIR/openssl.cnf


[[ -z "$DEVICE_ID" ]] && {
    # Device id not known, read env
    CURRENT_DIR=$(dirname $0)
    source $CURRENT_DIR/env.sh
}



make_ssl_dir() {
    # Make sure that cert directory exists
    if [ ! -d "$CERT_DIR" ]; then
        mkdir -p "$CERT_DIR"
    fi
}

gen_ssl_conf() {
    echo "[ distinguished_name ]"               >  $OPENSSL_CONF
    echo "C     = DE"                           >> $OPENSSL_CONF
    echo "ST    = North Rhine-Westphalia"       >> $OPENSSL_CONF
    echo "L     = Dusseldorf"                   >> $OPENSSL_CONF
    echo "O     = Gigaset Communications GmbH"  >> $OPENSSL_CONF
    echo "CN    = $DEVICE_ID"                   >> $OPENSSL_CONF
}

gen_ssl_files() {
    # Generate key pair if necessary
    if [ -f "$KEY_FILE" ]; then
        echo "Key file $KEY_FILE already exists. Skipping generation."
    else
        echo "Generating key file"
        KEY_SIZE=${KEY_SIZE:-1024}
        /usr/bin/coco genkey --out "$KEY_FILE" --size $KEY_SIZE
    fi

    # Generate certificate request if necessary
    if [ -f "$CSR_FILE" ]; then
        echo "CSR file $CSR_FILE already exists. Skipping generation."
    else
        echo "Generating csr file"
        /usr/bin/coco gencsr --conf "$OPENSSL_CONF" --in "$KEY_FILE" --out "$CSR_FILE"
    fi

}

recover_cert() {
    # Certificate recovering
    if [ ! -f "$CERT_FILE" ]; then
        if [ -f "$BACKUP_FILE" ]; then
            echo "Recovering certificate from backup."
            mv "$BACKUP_FILE" "$CERT_FILE"
        fi
    fi
}



make_ssl_dir

gen_ssl_conf

gen_ssl_files

recover_cert

