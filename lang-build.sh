make -e BUILDDIR=build/en html
make -e BUILDDIR=build/de SPHINXOPTS="-A lang='de' -D language='de'" html
make -e BUILDDIR=build/fr SPHINXOPTS="-A lang='fr' -D language='fr'" html
