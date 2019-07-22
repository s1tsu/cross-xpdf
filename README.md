`cross-xpdf` compiles Zotero bundled [xpdf PDF tools](https://www.xpdfreader.com/) for FreeBSD.

`build.sh` is modified based on `Dockerfile`.
I myself use the bundled linux binaries via Linux binary compatibility and do not use this native build.

### Build

Just run the build script.

```
git clone https://github.com/zotero/cross-xpdf
cd cross-xpdf
./build.sh
```

`./build/pdftools.tar.gz` contains the built binaries and `poppler-data` directory.


### Notes
- xpdf download cite
- gnu sed
- patches