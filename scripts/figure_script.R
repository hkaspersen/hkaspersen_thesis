# Percent occurrence of QREC per animal species (Art1)

library(tidyverse)
## Calculates 95 % confidence intervals
get_binCI <-
  function(x, n)
    as.numeric(setNames(binom.test(x, n)$conf.int * 100,
                        c("lwr", "upr")))

art1_dataset1 <-
  read.table(
    "data/article1/Dataset1.txt",
    sep = "\t",
    stringsAsFactors = F,
    header = T
  )

total_res_species <- art1_dataset1 %>%
  group_by(NORMart, quin_res) %>%
  count() %>%
  ungroup() %>%
  mutate(quin_res = ifelse(quin_res == 1,
                           "Resistant",
                           "Nonresistant")) %>%
  spread(quin_res, n, fill = 0) %>%
  rowwise() %>%
  mutate(
    Total = Resistant + Nonresistant,
    Percent = Resistant / Total * 100,
    lwr = round(get_binCI(Resistant, Total), 1)[1],
    upr = round(get_binCI(Resistant, Total), 1)[2]
  ) %>%
  mutate(
    NORMart = case_when(
      NORMart == "chi" ~ "Broiler",
      NORMart == "can" ~ "Dog",
      NORMart == "fox" ~ "Red fox",
      NORMart == "tur" ~ "Turkey",
      NORMart == "avi" ~ "Wild Bird",
      NORMart == "chila" ~ "Layer",
      NORMart == "bov" ~ "Cow",
      NORMart == "pig" ~ "Pig",
      NORMart == "equ" ~ "Horse",
      NORMart == "ren" ~ "Reindeer",
      NORMart == "sau" ~ "Sheep"
    )
  )

p <-
  ggplot(total_res_species, aes(reorder(NORMart,
                                        -Percent),
                                Percent)) +
  geom_col(color = "black") +
  geom_errorbar(aes(ymin = lwr,
                    ymax = upr),
                width = 0.5,
                alpha = 0.6) +
  labs(y = "Percent occurrence of QREC") +
  theme_classic() +
  theme(axis.title.x = element_blank(),
        axis.text = element_text(size = 7))


ggsave("images/qrec_epi.png",
       p,
       device = "png",
       dpi = 300,
       units = "cm",
       height = 12,
       width = 14)
