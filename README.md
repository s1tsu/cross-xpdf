`cross-xpdf` compiles Zotero bundled [xpdf PDF tools](https://www.xpdfreader.com/) for FreeBSD.

`build.sh` is modified based on `Dockerfile`.
I myself use the bundled linux binaries via Linux binary compatibility and do not use this native build.

### Build

We do not use the Docker since we do not have to cross-compile.
Just run the build script.

```
git clone https://github.com/s1tsu/cross-xpdf
cd cross-xpdf
./build.sh
```

`./build/pdftools.tar.gz` contains the built binaries and `poppler-data` directory.


### Main Changes to the original build script
- changed xpdf download cite
- use GNU sed (gsed)
- apply FreeBSD patches for xpdf4
- use GNU make (gmake)