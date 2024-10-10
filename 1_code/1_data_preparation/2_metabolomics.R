library(r4projects)
setwd(get_project_wd())
rm(list = ls())
source('1_code/100_tools.R')

##load data
data1_pos <-
  readxl::read_xlsx(
    "2_data/Multiomics_Microsample&Plasma202312/Metabolomics_Microsample&Plasma202312/附件1_代谢物定性定量结果表_SCORE.xlsx",
    sheet = 1
  )

data1_neg <-
  readxl::read_xlsx(
    "2_data/Multiomics_Microsample&Plasma202312/Metabolomics_Microsample&Plasma202312/附件1_代谢物定性定量结果表_SCORE.xlsx",
    sheet = 2
  )

data1_pos$ID <-
  paste0(data1_pos$ID, "_POS")
data1_neg$ID <-
  paste0(data1_neg$ID, "_NEG")

data1 <-
  rbind(data1_pos, data1_neg)

colnames(data1) <-
  colnames(data1) %>%
  stringr::str_replace_all("-", "_")



##load data
data2_pos <-
  readxl::read_xlsx(
    "2_data/Multiomics_Microsample&Plasma2406OGTT/Metabolomics/附件1_代谢物定性定量结果表.xlsx",
    sheet = 1
  )

data2_neg <-
  readxl::read_xlsx(
    "2_data/Multiomics_Microsample&Plasma2406OGTT/Metabolomics/附件1_代谢物定性定量结果表.xlsx",
    sheet = 2
  )

data2_pos$ID <-
  paste0(data2_pos$ID, "_POS")

data2_neg$ID <-
  paste0(data2_neg$ID, "_NEG")

data2 <-
  rbind(data2_pos, data2_neg)

colnames(data2) <-
  colnames(data2) %>%
  stringr::str_replace_all("-", "_")



###create working directory
dir.create(
  "3_data_analysis/1_data_preparation/2_metabolomics",
  showWarnings = FALSE,
  recursive = TRUE
)
setwd("3_data_analysis/1_data_preparation/2_metabolomics/")


####this is for the dataset from the 2023, test samples
variable_info1 <-
  data1 %>%
  dplyr::select(c(ID:SubClass))

variable_info1 <-
  variable_info1 %>%
  dplyr::rename(variable_id = ID)

expression_data1 <-
  data1 %>%
  dplyr::select(-c(ID:SubClass))

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

metabolomics_data1 <-
  create_mass_dataset(
    expression_data = expression_data1,
    sample_info = sample_info1,
    variable_info = variable_info1
  )

save(metabolomics_data1, file = "metabolomics_data1.RData")





####this is for the dataset from the 2024 OGTT
variable_info2 <-
  data2 %>%
  dplyr::select(c(ID:SubClass))

variable_info2 <-
  variable_info2 %>%
  dplyr::rename(variable_id = ID)

expression_data2 <-
  data2 %>%
  dplyr::select(-c(ID:SubClass))

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

metabolomics_data2 <-
  create_mass_dataset(
    expression_data = expression_data2,
    sample_info = sample_info2,
    variable_info = variable_info2
  )

save(metabolomics_data2, file = "metabolomics_data2.RData")
