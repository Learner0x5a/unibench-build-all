#!/bin/bash
# in docker zjuchenyuan/base

COMPILERS="gcc clang"
OPTS='O0 O1 O2 O3 Os'


git clone https://github.com/UNIFUZZ/unibench &&\
cd unibench && \
mkdir mp3gain-1.5.2 && cd mp3gain-1.5.2 && mv ../mp3gain-1.5.2.zip ./ && unzip -q mp3gain-1.5.2.zip && rm mp3gain-1.5.2.zip && cd .. &&\
ls *.zip|xargs -i unzip -q '{}' &&\
ls *.tar.gz|xargs -i tar xf '{}' &&\
rm -r .git/ *.tar.gz *.zip &&\
mv SQLite-8a8ffc86 SQLite-3.8.9 && mv binutils_5279478 binutils-5279478 && mv libtiff-Release-v3-9-7 libtiff-3.9.7 &&\
ls -alh

for compiler in $COMPILERS
do
    for opt in $OPTS
    do
        mkdir -p /d/p/$compiler/$opt/

        make clean
        cd /unibench/exiv2-0.26 && CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" cmake -DEXIV2_ENABLE_SHARED=OFF . &&\
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || : &&\ 
        cp bin/exiv2 /d/p/$compiler/$opt/ &&\
        make clean

        make clean
        apt update && apt install -y libglib2.0-dev gtk-doc-tools libtiff-dev libpng-dev &&\
        cd /unibench/gdk-pixbuf-2.31.1 && CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" ./autogen.sh --enable-static=yes --enable-shared=no --with-included-loaders=yes &&\
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || : &&\
        cp gdk-pixbuf/gdk-pixbuf-pixdata /d/p/$compiler/$opt/ &&\
        make clean

        make clean
        cd /unibench/jasper-2.0.12 && CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" cmake -DJAS_ENABLE_SHARED=OFF -DALLOW_IN_SOURCE_BUILD=ON . &&\
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || : &&\
        cp src/appl/imginfo /d/p/$compiler/$opt/ &&\
        make clean

        make clean
        cd /unibench/jhead-3.00 &&\
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || : &&\
        cp jhead /d/p/$compiler/$opt/ &&\
        make clean

        make clean
        cd /unibench/libtiff-3.9.7 && CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" ./autogen.sh && CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" ./configure --disable-shared &&\
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || : &&\
        cp tools/tiffsplit /d/p/$compiler/$opt/ &&\
        make clean

        make clean
        cd /unibench/lame-3.99.5 && CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" ./configure --disable-shared &&\
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || : &&\
        cp frontend/lame /d/p/$compiler/$opt/ &&\
        make clean

        make clean
        cd /unibench/mp3gain-1.5.2 && sed -i 's/CC=/CC?=/' Makefile &&\
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || : &&\
        cp mp3gain /d/p/$compiler/$opt/ &&\
        make clean

        make clean
        cd /unibench/swftools-0.9.2/ && CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" ./configure &&\
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || : &&\
        cp src/wav2swf /d/p/$compiler/$opt/ &&\
        make clean

        # Comment out ffmpeg for building under travis-ci
        # The memory usage seems to exceed 3GB and may make the whole build job timeout (50 minutes)
        make clean
        apt install -y nasm &&\
        cd /unibench/ffmpeg-4.0.1 && CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" ./configure --disable-shared --cc="$CC" --cxx="$CXX" &&\
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || : &&\
        cp ffmpeg_g /d/p/$compiler/$opt/ffmpeg &&\
        make clean

        make clean
        cd /unibench/flvmeta-1.2.1 && CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" cmake . &&\
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || : &&\
        cp src/flvmeta /d/p/$compiler/$opt/ &&\
        make clean

        make clean
        cd /unibench/Bento4-1.5.1-628 && CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" cmake . &&\
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || : &&\
        cp mp42aac /d/p/$compiler/$opt/ &&\
        make clean

        make clean
        cd /unibench/cflow-1.6 && CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" ./configure &&\
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || : &&\
        cp src/cflow /d/p/$compiler/$opt/ &&\
        make clean

        make clean
        cd /unibench/ncurses-6.1 && CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" ./configure --disable-shared &&\
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || : &&\
        cp progs/tic /d/p/$compiler/$opt/infotocap &&\
        make clean

        make clean
        cd /unibench/jq-1.5 && CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" ./configure --disable-shared &&\
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || : &&\
        cp jq /d/p/$compiler/$opt/ &&\
        make clean

        make clean
        cd /unibench/mujs-1.0.2 &&\
        build=debug CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || : &&\
        cp build/debug/mujs /d/p/$compiler/$opt/ &&\
        make clean

        make clean
        cd /unibench/xpdf-4.00 && CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" cmake . &&\
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || : &&\
        cp xpdf/pdftotext /d/p/$compiler/$opt/ &&\
        make clean

        #--disable-amalgamation can be used for coverage build
        make clean
        apt install -y tcl-dev &&\
        cd /unibench/SQLite-3.8.9 && CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" ./configure --disable-shared &&\ 
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || : &&\
        cp sqlite3 /d/p/$compiler/$opt/ &&\
        make clean

        make distclean
        cd /unibench/binutils-5279478 &&\
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" ./configure --disable-shared &&\
        for i in bfd libiberty opcodes libctf; do cd $i; CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" ./configure --disable-shared && CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || :; cd ..; done  &&\
        cd binutils  &&\
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" ./configure --disable-shared &&\
        make nm-new &&\
        cp nm-new /d/p/$compiler/$opt/nm &&\
        cd .. && make distclean

        make clean
        cd /unibench/binutils-2.28 && CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" ./configure --disable-shared &&\
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || : &&\
        cp binutils/objdump /d/p/$compiler/$opt/ &&\
        make clean

        make clean
        cd /unibench/libpcap-1.8.1 && CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" ./configure --disable-shared &&\
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || : &&\
        cd /unibench/tcpdump-4.8.1 && CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" ./configure &&\
        CC=$compiler CXX=$compiler++ CFLAGS="-g -$opt" CXXFLAGS="-g -$opt" make -j || : &&\
        cp tcpdump /d/p/$compiler/$opt/ &&\
        make clean && cd /unibench/libpcap-1.8.1 && make clean


        md5sum /d/p/gcc/$opt/*
        md5sum /d/p/clang/$opt/*

    done
done
