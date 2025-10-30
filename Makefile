# final PDF report
finalproject_RZCHEN_1027.pdf: code/02_render_report.R finalproject_RZCHEN_1027.Rmd 
	Rscript code/02_render_report.R

# 1. Use the absolute path to your R executable (R.exe)
#    This resolved the Segmentation Fault by using the full R interpreter.
R_BIN := C:/Program Files/R/R-4.5.1/bin/x64/R.exe

# 2. Define Prerequisites
R_SCRIPT := code/01_make_output.R
DATA_FILE := data/netflix_titles.csv

# 3. Define all generated output files
RDS_FILES := output/table_type.rds \
             output/top_movies.rds \
             output/top_tv.rds \
             output/figure1.rds \
             output/figure2.rds

# --- Targets ---

# 1. Phony Target: .rds_outputs
#    This is the main target you call (e.g., 'make .rds_outputs')
.PHONY: .rds_outputs
.rds_outputs: $(RDS_FILES)
	@echo "All RDS outputs are up-to-date."

# 2. Main Build Rule: Creates ALL RDS files
#    This rule ensures the R script only runs once to generate all outputs.
$(RDS_FILES): $(R_SCRIPT) $(DATA_FILE)
	@echo "Running R analysis script: $<"
	"$(R_BIN)" --vanilla < $<


# 3. Clean Target: Removes generated files
.PHONY: clean
clean:
	@echo "Removing generated .rds files..."
	-rm -f output/*.rds && rm -f finalproject_RZCHEN_1027.pdf