#!/bin/sh

FIRMWARE=$1
CHECKSUM=$2
VERSION=$3
DEVICE_TYPE=$4
DEVICE_ID=$5
TIMEOUT=$6

FIRMWARE_DIR=/usr/gigaset/data/fw

FILE=$(basename "${FIRMWARE}")
CHECKSUM_FILE=${FIRMWARE}.sha256
DW_DIR=$(dirname "${FIRMWARE}")

BASESTATION_FIRMWARE=${FIRMWARE_DIR}/basestation/${VERSION}
SENSOR_FIRMWARE=${FIRMWARE_DIR}/sensors

lock() {
	exec 200>/var/lock/fw_prepare.lock || exit 1
	flock 200
}

unlock() {
	flock -u 200
}

# inform about new firmware
# $1 - type of sensor
# $2 - firmware version
# $3 - file with firmware
# $4 - sensor id
# $5 - timeout
announce() {
	echo \{\"deviceType\":\"$1\",\"version\":\"$2\",\"file\":\"$3\",\"deviceId\":\"$4\",\"timeout\":\"$5\",\"action\":\"announcement\"\} | sender 127.0.0.1 firmware_queue
}

downloaded() {
	echo \{\"deviceType\":\"$1\",\"version\":\"$2\",\"deviceId\":\"$3\",\"files\":\"$4\",\"action\":\"confirm\"\} | sender 127.0.0.1 firmware_queue
}



# remove temporary files
cleanup() {	
	rm -f ${FIRMWARE}
	rm -f ${CHECKSUM_FILE}
	rmdir ${DW_DIR}
	unlock
}

# terminate script
terminate() {
	cleanup
	exit 1
}


# update basestation procedure
update_basestation() {
	if [ ! -d "${BASESTATION_FIRMWARE}" ]; then
		# create final directory for this firmware
		mkdir -p ${BASESTATION_FIRMWARE}
		# extract archive
		tar -xf ${FIRMWARE} -C ${BASESTATION_FIRMWARE}
	fi
	
	# start post-download process
	cd ${BASESTATION_FIRMWARE}
	./start	download
}


# update sensor firmware procedure
update_sensor() {
	# create directory for sensors firmware
	mkdir -p ${SENSOR_FIRMWARE}
	# extract archive
	tar -xf ${FIRMWARE} -C ${SENSOR_FIRMWARE}
	# create list with files inside archive
	FILES=`tar -t -f ${FIRMWARE}`
	# announce new firmware files
	for PACKAGE in ${FILES}
	do
		if [ -f ${SENSOR_FIRMWARE}/${PACKAGE} ]
		then
			announce ${DEVICE_TYPE} ${VERSION} ${PACKAGE} ${DEVICE_ID} ${TIMEOUT} 
		fi		
	done
	# read how many files are inside this archive
	FILES_TOTAL=`tar -t -f ${FIRMWARE} | wc -l`
	downloaded ${DEVICE_TYPE} ${VERSION} ${DEVICE_ID} ${FILES_TOTAL}
}




lock
echo "This file was downloaded:"
echo " firmware file: ${FIRMWARE}"
echo " file: ${FILE}"
echo " checksum: ${CHECKSUM}"
echo " version: ${VERSION}"
echo " device type: ${DEVICE_TYPE}"
echo " device id: ${DEVICE_ID}"
echo " timeout: ${TIMEOUT}"




# create checksum file
echo "${CHECKSUM}  ${FIRMWARE}" >> ${CHECKSUM_FILE}


# verify checksum
# sha256sum -cs ${CHECKSUM_FILE}

# check result
# if [ "$?" -ne 0 ]; then
# 	echo "Checksum verification failed."
# 	terminate
# fi




# switch to dedicated firmware update procedure
case "${DEVICE_TYPE}" in
	"basestation")
		# update_basestation
		echo "not available for CG300"
		;;
	*)
		update_sensor
		;;
esac

cleanup	







