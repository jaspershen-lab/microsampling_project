library(r4projects)
setwd(get_project_wd())
rm(list = ls())
source('1_code/100_tools.R')

##load data
data1 <-
  readxl::read_xlsx(
    "2_data/Multiomics_Microsample&Plasma202312/Proteomics_Microsample&Plasma202312/Statistics_Summary.xlsx",
    sheet = 2
  )

data2 <-
  readxl::read_xlsx(
    "2_data/Multiomics_Microsample&Plasma2406OGTT/Proteomics/Statistics_Summary.xlsx",
    sheet = 2
  )

###create working directory
dir.create(
  "3_data_analysis/1_data_preparation/1_proteomics",
  showWarnings = FALSE,
  recursive = TRUE
)
setwd("3_data_analysis/1_data_preparation/1_proteomics/")


####this is for the dataset from the 2023, test samples
variable_info1 <-
  data1 %>%
  dplyr::select(c(Protein:SequenceNumber, `GO annotations`:Domain))

variable_info1 <-
  variable_info1 %>%
  dplyr::rename(variable_id = Protein)

expression_data1 <-
  data1 %>%
  dplyr::select(-c(Protein:SequenceNumber, `GO annotations`:Domain))

expression_data1 <-
  as.data.frame(expression_data1)

rownames(expression_data1) <-
  variable_info1$variable_id


sample_info1 <-
  data.frame(sample_id = colnames(expression_data1))

sample_info1 <-
  sample_info1 %>%
  dplyr::mutate(class = case_when(stringr::str_detect(sample_id, "QC") ~ "QC", TRUE ~ "Subject"))

library(tidymass)

proteomics_data1 <-
  create_mass_dataset(
    expression_data = expression_data1,
    sample_info = sample_info1,
    variable_info = variable_info1
  )

save(proteomics_data1, file = "proteomics_data1.RData")






####this is for the experimental samples from the 2024, OGTT
variable_info2 <-
  data2 %>%
  dplyr::select(c(Protein:SequenceNumber, `GO annotations`:Domain))

variable_info2 <-
  variable_info2 %>%
  dplyr::rename(variable_id = Protein)

expression_data2 <-
  data2 %>%
  dplyr::select(-c(Protein:SequenceNumber, `GO annotations`:Domain))

expression_data2 <-
  as.data.frame(expression_data2)

rownames(expression_data2) <-
  variable_info2$variable_id

sample_info2 <-
  data.frame(sample_id = colnames(expression_data2))

sample_info2 <-
  sample_info2 %>%
  dplyr::mutate(class = case_when(stringr::str_detect(sample_id, "QC") ~ "QC", TRUE ~ "Subject"))

library(tidymass)

proteomics_data2 <-
  create_mass_dataset(
    expression_data = expression_data2,
    sample_info = sample_info2,
    variable_info = variable_info2
  )

save(proteomics_data2, file = "proteomics_data2.RData")
