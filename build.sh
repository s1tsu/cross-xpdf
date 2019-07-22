#!/usr/bin/env bash

# docker build . -t cross-xpdf
# docker run -it -v  $(pwd)/build:/output cross-xpdf /bin/bash -c "rm -rf /output/* && cp -r /build/pdftools.tar.gz /output/"

PDIR=`pwd`

echo $PDIR


mkdir -p $PDIR/build \
    && mkdir -p $PDIR/build/freebsd


# /old/xpdf-4.00.tar.gz
cd $PDIR/build/ \
	&& wget -O xpdf-4.00.tar.gz https://xpdfreader-dl.s3.amazonaws.com/old/xpdf-4.00.tar.gz \
	&& mkdir xpdf \
	&& tar -xf xpdf-4.00.tar.gz -C xpdf --strip-components=1 \
	&& cd xpdf \
	&& gsed -i "/^int\smain(/a if(argc!=3 || argv[1][0]=='-' || argv[2][0]=='-') {fprintf(stderr,\"This is a custom xpdf pdfinfo build. Please use the original version!\\\\n%s\\\\n%s\\\\npdfinfo <PDF-file> <output-file>\\\\n\",xpdfVersion,xpdfCopyright); return 1;} else {freopen( argv[argc-1], \"w\", stdout); argc--;}" xpdf/pdfinfo.cc

cp $PDIR/pdftotext.cc $PDIR/build/xpdf/xpdf/pdftotext.cc
cp $PDIR/GlobalParams.h $PDIR/build/xpdf/xpdf/GlobalParams.h
cp $PDIR/GlobalParams.cc $PDIR/build/xpdf/xpdf/GlobalParams.cc
cp $PDIR/gfile.h $PDIR/build/xpdf/goo/gfile.h
cp $PDIR/gfile.cc $PDIR/build/xpdf/goo/gfile.cc

# freebsd
# patch 
cd $PDIR/build \
    &&  svnlite checkout https://svn.freebsd.org/ports/branches/2019Q1/graphics/xpdf4/files ./patches \
    && cd xpdf \
    && patch < $PDIR/build/patches/patch-aconf.h.in \
    && patch < $PDIR/build/patches/patch-cmake-config.txt \
    && patch < $PDIR/build/patches/patch-xpdf_CMakeLists.txt    \
    && patch < $PDIR/build/patches/patch-xpdf-qt_CMakeLists.txt \
    && patch < $PDIR/build/patches/patch-xpdf-qt_XpdfWidgetPrint.cc \


cd $PDIR/build/freebsd \
	&& cmake $PDIR/build/xpdf \
		 -DCMAKE_CXX_FLAGS="-stdlib=libc++ -Os" \
		 -DCMAKE_EXE_LINKER_FLAGS="-static -pthread" \
		 ${COMMON_OPTIONS} \
	&& gmake

mkdir -p $PDIR/build/pdftools \
	&& cd $PDIR/build/pdftools \
	&& cp $PDIR/build/freebsd/xpdf/pdfinfo ./pdfinfo-freebsd \
	&& cp $PDIR/build/freebsd/xpdf/pdftotext ./pdftotext-freebsd \


cd $PDIR/build/ \
	&& wget -O poppler-data.tar.gz https://poppler.freedesktop.org/poppler-data-0.4.8.tar.gz \
	&& mkdir -p poppler-data \
	&& tar -xf poppler-data.tar.gz -C poppler-data --strip-components=1 \
	&& cd pdftools \
	&& mkdir -p poppler-data \
	&& cd poppler-data \
	&& cp -r ../../poppler-data/cidToUnicode ./ \
	&& cp -r ../../poppler-data/cMap ./ \
	&& cp -r ../../poppler-data/nameToUnicode ./ \
	&& cp -r ../../poppler-data/unicodeMap ./ \
	&& cp -r ../../poppler-data/COPYING ./ \
	&& cp -r ../../poppler-data/COPYING.adobe ./ \
	&& cp -r ../../poppler-data/COPYING.gpl2 ./ \
	&& cd .. \
	&& tar -cvzf ../pdftools.tar.gz *









# cd $PDIR
# mkdir -p $PDIR/output
# cp -r $PDIR/build/pdftools.tar.gz $PDIR/output/








