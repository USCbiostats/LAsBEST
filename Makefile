all:
	rsync -av week* site/ && \
	$(MAKE) clean && \
	Rscript --vanilla -e 'rmarkdown::render_site("site/")'
.PHONY: clean
clean:
	Rscript --vanilla -e 'rmarkdown::clean_site("site/", preview=FALSE)'

