library(readxl)
library(dplyr)
library(ggplot2)


data <- read_xlsx("data/nordic_data.xlsx") %>%
  mutate(Year = factor(Year)) %>%
  filter(Species %in% c("Broiler","Cattle","Pig")) %>%
  mutate(Report = case_when(Report == "DANMAP" ~ "Denmark",
                            Report == "NORM-VET" ~ "Norway",
                            Report == "SVARM" ~ "Sweden"))



palette <- c("Denmark" = "#FDBE83",
             "Norway" = "#C8A3B5",
             "Sweden" = "#2F4E68")


p<-ggplot(data, aes(Year, Occurrence, color = Report, group = Report)) +
  geom_point() +
  geom_line() +
  theme_bw() +
  theme(legend.title = element_blank(),
        strip.text = element_text(size = 18, face = "bold"),
        legend.text = element_text(size = 18),
        axis.text = element_text(size = 16),
        axis.title = element_text(size = 18)) +
  scale_color_manual(values = palette) +
  labs(y = "Percent (%) Occurrence") +
  facet_wrap(~Species, nrow = 3, ncol = 1)


ggsave("images/pdfs/qrec_occurrence_nordic.png",
       p,
       device = "png",
       units = "cm",
       dpi = 600,
       height = 25,
       width = 25)
