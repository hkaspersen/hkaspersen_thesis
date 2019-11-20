library(ggmap)
library(RColorBrewer)
library(rworldmap)
library(tidyverse)
library(PBSmapping)
library(readxl)

# With google API, considerably slower but nicer-looking

load("data/hmap_zoom_7_scale4.RData") # load pre-downloaded map from google

ecdc_data <- read_excel("data/ECDC_report.xlsx")

ecdc_data_mod <- ecdc_data %>%
  rename("region" = Country) %>%
  group_by(region, Species) %>%
  summarize(mean_cip = mean(CIP, na.rm = TRUE)) %>%
  spread(Species, mean_cip)

mapdata <- map_data("world") %>%
  left_join(ecdc_data_mod, by = "region")

bb<-attr(hmap, "bb")
ylim<-c(bb$ll.lat, bb$ur.lat)
xlim<-c(bb$ll.lon, bb$ur.lon)

colnames(mapdata)[1:6] <- c(
  "X","Y","PID","POS","region","subregion"
  )

mapdata2 <- clipPolys(mapdata,
                      xlim = xlim,
                      ylim = ylim,
                      keepExtra = TRUE) %>%
  gather(key, value, c(Broiler, Pig, Calf, Turkey)) %>%
  mutate(key = factor(
    key,
    ordered = TRUE,
    levels = c("Broiler", "Turkey", "Pig", "Calf")
  ))

p <- ggmap(hmap) + coord_map(xlim = xlim, ylim = ylim) +
  geom_polygon(data = mapdata2,
               aes(
                 x = X,
                 y = Y,
                 group = PID,
                 fill = value
               ),
               color = "black") +
  ggthemes::theme_map() +
  scale_fill_gradient(
    high = "#67000d",
    low = "#fff5f0",
    na.value = "grey80",
    limits = c(0, 100),
    labels = c("0", "25", "50", "75", "100"),
    guide = guide_colourbar(
      ticks = T,
      nbin = 50,
      barheight = .5,
      label = T,
      barwidth = 10,
      label.vjust = 0.5
    )
  ) +
  theme(
    legend.position = "bottom",
    legend.justification = "center",
    legend.direction = "horizontal",
    legend.title = element_blank(),
    panel.border = element_rect(color = "black", fill = NA),
    strip.text = element_text(size = 14),
    strip.background = element_rect(fill = "white"),
    legend.text = element_text(size = 10)
  ) +
  facet_wrap( ~ key, ncol = 2, nrow = 2)

ggsave("images/ecdcdata2.png",
       p,
       dpi = 600,
       units = "cm",
       height = 25,
       width = 25,
       device = "png")



# Method 2, without google maps API

country_data <- countryExData %>%
  mutate(new_test = ifelse(grepl("Europe", GEO_subregion) == TRUE, 1, 0)) %>%
  filter(new_test == 1)

eu_countries <- trimws(unique(country_data$Country))
eu_countries <- c(eu_countries, "UK", "Serbia", "Montenegro", "Kosovo")

ecdc_data <- read_excel("data/ECDC_report.xlsx")
ecdc_data_mod <- ecdc_data %>%
  rename("region" = Country) %>%
  group_by(region, Species) %>%
  summarize(mean_cip = mean(CIP, na.rm = TRUE)) %>%
  spread(Species, mean_cip)


europe_map <- map_data("world", region = eu_countries) %>%
  left_join(ecdc_data_mod, by = "region") %>%
  gather(species, value, c(Broiler, Calf, Pig, Turkey))


p<-ggplot(europe_map, aes(long, lat)) +
  geom_polygon(aes(group = group, fill = value), color = "black") +
  scale_fill_gradient(high = "#67000d",
                      low = "#fff5f0",
                      na.value = "grey90",
                      limits = c(0, 100),
                      labels = c("0", "25", "50", "75", "100"),
                      guide=guide_colourbar(ticks=T,nbin=50,
                                            barheight=.5,label=T, 
                                            barwidth=10,
                                            label.vjust = 0.5)) +
  theme(legend.position="bottom",
        legend.justification="center",
        legend.direction="horizontal",
        panel.background = element_rect(fill = "lightblue",
                                        color = "lightblue",
                                        size = 0.5, linetype = "solid"),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_rect(color = "black", fill = NA),
        legend.title = element_blank()) +
  xlim(-12, 35) +
  ylim(35, 71) +
  facet_wrap(~species) +
  coord_fixed(1.5)


ggsave("images/without_google_API.png",
       p,
       device = "png",
       units = "cm",
       dpi = 600,
       height = 20,
       width = 20)
