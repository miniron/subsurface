#!/bin/bash
# start from the directory above the combined subsurface & subsurface/libdivecomputer directory
VERSION=$(cd subsurface ; git describe | sed -e 's/-g.*$// ; s/^v// ; s/-/./')
echo "building Subsurface" $VERSION
if [[ -d subsurface_$VERSION ]]; then
	rm -rf subsurface_$VERSION.bak.prev
	mv subsurface_$VERSION.bak subsurface_$VERSION.bak.prev
	mv subsurface_$VERSION subsurface_$VERSION.bak
fi
mkdir subsurface_$VERSION
(cd subsurface ; tar cf - . .git ) | (cd subsurface_$VERSION ; tar xf - )
cd subsurface_$VERSION
dh_make --email dirk@hohndel.org -c gpl2 --createorig --single --yes -p subsurface_$VERSION
rm debian/*.ex debian/*.EX debian/README.*
cp ../subsurface/packaging/ubuntu/control debian/control
cp ../subsurface/packaging/ubuntu/copyright debian/copyright
cp ../subsurface/packaging/ubuntu/rules debian/rules
cp ../subsurface/packaging/ubuntu/source.lintian-overrides debian/source.lintian-overrides
# do something clever with changelog
mv debian/changelog debian/autocl
head -1 debian/autocl | sed -e 's/unstable/trusty/' > debian/changelog
cat ../subsurface/packaging/ubuntu/changelog.txt >> debian/changelog
tail -1 debian/autocl >> debian/changelog
rm -f debian/autocl

debuild -S 
