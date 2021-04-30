all:
	rsync -av week*/ site/ && \
	Rscript --vanilla -e 'rmarkdown::render_site("site/")'
