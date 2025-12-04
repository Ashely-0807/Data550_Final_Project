# Must define this FIRST before any rules use it
RDS_FILES := output/table_type.rds \
             output/top_movies.rds \
             output/top_tv.rds \
             output/figure1.rds \
             output/figure2.rds

all: finalproject_RZCHEN_1027.pdf

# final PDF report
finalproject_RZCHEN_1027.pdf: code/02_render_report.R finalproject_RZCHEN_1027.Rmd $(RDS_FILES)
	Rscript code/02_render_report.R

# RDS output files
$(RDS_FILES): code/01_make_output.R data/netflix_titles.csv
	Rscript code/01_make_output.R

# Clean Target: Removes generated files
.PHONY: clean
clean:
	@echo "Removing generated .rds files..."
	-rm -f output/*.rds && rm -f finalproject_RZCHEN_1027.pdf
	
docker_report:
	docker run -v "/$$(PWD)/report:/home/rstudio/project/report" \
	  ashley0807/final_project2

	
#Make Install Rule
.PHONY: install

install:
	Rscript -e "renv::restore()"