bnfc_output = $(patsubst %,bnfc/Tog/Raw/%,Abs.hs ErrM.hs Layout.hs Print.hs Lex.x Par.y)
hs_sources = $(shell find src/ -name '*.hs')
alex_file = bnfc/Tog/Raw/Lex
happy_file = bnfc/Tog/Raw/Par
executable = dist/build/tog/tog

.PHONY: build
build: $(executable)

$(bnfc_output): src/Tog/Raw/Raw.cf
	-@mkdir -p bnfc
	-@rm $(bnfc_output)
	@(cd bnfc && bnfc -p Tog -d ../$<)

$(alex_file).hs: $(alex_file).x
	alex $<

$(happy_file).hs: $(happy_file).y
	happy $<

$(executable): $(bnfc_output) $(hs_sources) tog.cabal
	cabal build

.PHONY: bnfc
bnfc: $(bnfc_output)

.PHONY: clean
clean:
	rm -rf bnfc
	cabal clean

.PHONY: test
test: $(executable)
	time ./test

modules.pdf: $(bnfc_output) $(hs_sources)
	graphmod -i src -i bnfc src/Main.hs | dot -T pdf -o modules.pdf

.PHONY: install-prof
install-prof: $(bnfc_output) $(hs_sources)
	cabal install --enable-executable-profiling --enable-library-profiling --disable-documentation

.PHONY: install
install: $(bnfc_output) $(hs_source)
	cabal install --disable-executable-profiling --disable-library-profiling --disable-documentation

.PHONY: ghci
ghci: $(bnfc_output) $(alex_file).hs $(happy_file).hs
	ghci src/Main.hs

