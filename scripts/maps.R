library(ggmap)
library(RColorBrewer)
library(rworldmap)
library(tidyverse)
library(PBSmapping)
library(readxl)

load("data/hmap_zoom_7_scale4.RData") # load map

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

colnames(mapdata)[1:6] <- c("X","Y","PID","POS","region","subregion")

mapdata2<-clipPolys(mapdata, xlim=xlim, ylim=ylim, keepExtra=TRUE) %>%
  gather(key, value, c(Broiler, Pig, Calf, Turkey)) %>%
  mutate(key = factor(key, ordered = TRUE, levels = c("Broiler","Turkey","Pig","Calf")))

p<- ggmap(hmap) + coord_map(xlim = xlim, ylim = ylim) +
  geom_polygon(data = mapdata2, aes(x = X, y = Y, group = PID, fill = value), color = "black") +
  ggthemes::theme_map() +
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
        legend.title = element_blank(),
        panel.border = element_rect(color = "black", fill = NA),
        strip.text = element_text(size = 10)) +
  facet_wrap(~key, ncol = 2, nrow = 2)

ggsave("images/ecdcdata2.png",
       p,
       dpi = 600,
       units = "cm",
       height = 15,
       width = 15,
       device = "png")




ecdc_data_2 <- ecdc_data %>%
  mutate(category = paste(Species, Year, sep = "_")) %>%
  select(-c(Species, Year)) %>%
  spread(category, CIP) %>%
  rename("region" = Country)



mapdata <- map_data("world") %>%
  left_join(ecdc_data_2, by = "region")

bb<-attr(hmap, "bb")
ylim<-c(bb$ll.lat, bb$ur.lat)
xlim<-c(bb$ll.lon, bb$ur.lon)

colnames(mapdata)[1:6] <- c("X","Y","PID","POS","region","subregion")

mapdata2<-clipPolys(mapdata, xlim=xlim, ylim=ylim, keepExtra=TRUE) %>%
  gather(key, value, contains("_")) %>%
  mutate(Year = sub(".+_", "", key),
         key = sub("_.+", "", key)) %>%
  filter(key == "Broiler")


p2 <- ggmap(hmap) + coord_map(xlim = xlim, ylim = ylim) +
  geom_polygon(data = mapdata2, aes(x = X, y = Y, group = PID, fill = value), color = "black") +
  ggthemes::theme_map() +
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
        legend.title = element_blank(),
        panel.border = element_rect(color = "black", fill = NA),
        strip.text = element_text(size = 10)) +
  facet_grid(~Year)

  
ggsave("images/broiler_trend.png",
       p2,
       dpi = 600,
       units = "cm",
       height = 10,
       width = 20,
       device = "png")
