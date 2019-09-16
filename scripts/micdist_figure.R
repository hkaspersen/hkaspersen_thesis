# Libraries
library(ggplot2)
library(dplyr)


# Read and clean data from EUCAST
micdist <- read.table("data/micdist.txt",
                      sep = "\t",
                      header = TRUE,
                      stringsAsFactors = FALSE) %>%
  mutate(percent = n / sum(n)* 100, # calculate percentage
         group = case_when(MIC <= 0.064 ~ "Sensitive",
                           MIC > 0.064 & MIC <= 0.5 ~ "Intermediate",
                           MIC > 0.5 ~ "Resistant"),
         group = factor(group,
                        ordered = TRUE,
                        levels = c("Sensitive",
                                   "Intermediate",
                                   "Resistant"))) # group variables


# Plot data
p <- ggplot(micdist,
            aes(factor(MIC), percent)) +
  geom_col(color = "black") + 
  geom_segment(aes(xend = 6.5, y = 7, x = 6.5, yend = 4),
               arrow = arrow(length = unit(0.3, "cm"),
                             type = "closed")) +
  geom_segment(aes(xend = 9.5, y = 4.5, x = 9.5, yend = 1.5),
               arrow = arrow(length = unit(0.3, "cm"),
                             type = "closed")) +
  geom_text(aes(x = 6.5, y = 11),
            label = "ECOFF",
            angle = 90,
            vjust = 0.45) +
  geom_text(aes(x = 9.5, y = 13),
            label = "Clinical breakpoint",
            angle = 90,
            vjust = 0.45) +
  labs(x = "MIC (mg/L)",
       y = "Percent (%) microorganisms",
       fill = NULL) +
  theme_classic() +
  theme(axis.text = element_text(size = 10),
        legend.text = element_text(size = 10),
        axis.title = element_text(size = 12),
        axis.text.x = element_text(angle = 90,
                                   hjust = 1,
                                   vjust = 0.4),
        legend.position = c(0.85,0.85))


# Save plot
ggsave("images/micdist.png",
       p,
       device = "png",
       dpi = 600,
       units = "cm",
       width = 14,
       height = 12)



