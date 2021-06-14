all:
	$(MAKE) clean && \
		cd site/ && Rscript --vanilla -e 'rmarkdown::render_site(".")'
.PHONY: clean
clean:
	rm -rf site/_site/*

