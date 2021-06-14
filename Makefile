all:
	rsync -av week* site/ && \
	$(MAKE) clean && \
	Rscript --vanilla -e 'rmarkdown::render_site("site/")'
.PHONY: clean
clean:
	rm -rf site/_site/*

