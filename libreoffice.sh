#!/bin/bash
LIBREOFFICE_VERSION="7.5.5"
LIBREOFFICE_NAME="LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_deb"
LIBREOFFICE_FILE="${LIBREOFFICE_NAME}.tar.gz"
LIBREOFFICE_URL="https://download.documentfoundation.org/libreoffice/stable/${LIBREOFFICE_VERSION}/deb/x86_64/${LIBREOFFICE_FILE}"


wget ${LIBREOFFICE_URL}
tar -xvf ${LIBREOFFICE_FILE}
apt install ./${LIBREOFFICE_NAME}/DEBS/*.deb

#try convert pttx to pdf
libreoffice --headless --invisible --convert-to pdf template.pptx
