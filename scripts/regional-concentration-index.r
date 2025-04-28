library(here)
library(dplyr)
library(data.table)
library(rineq)
library(ggplot2)
library(ggstance)
library(rworldmap)
library(RColorBrewer)

get_ci <- function(temp) {
  out <- ci(
    ineqvar = temp$total_attention_score,
    outcome = temp$val, method = "direct"
  )
  l <- tibble(
    ci = out$concentration_index,
    ci_se = sqrt(out$variance),
    ci_lci = ci - 1.96 * ci_se,
    ci_uci = ci + 1.96 * ci_se,
  )
  l
}

gwas_attention <- fread(here("Data/Ncase_merged_dataset_exclude_Injuries.csv")) %>%
  select(cause_name = `Cause Name`, cause_id, total_attention_score) %>%
  filter(!duplicated(cause_id))

gbd1 <- fread(here("Data/april2025/by_sdi_and_sex_3years/IHME-GBD_2021_DATA-f187b5da-1.csv"))
temp1 <- inner_join(gbd1, gwas_attention)
o1 <- group_by(temp1, location_name, sex_name, year) %>%
  do(get_ci(.))
o1$location_name <- factor(o1$location_name, levels = c(
  "High SDI", "High-middle SDI", "Middle SDI",
  "Low-middle SDI", "Low SDI", "Global"
))


o1 %>%
  dplyr::filter(year == 2019) %>%
ggplot(., aes(x = ci, y = sex_name)) +
  geom_point(
    aes(colour = sex_name),
    position = ggstance::position_dodge2v(height = 0.3)
  ) +
  geom_errorbarh(aes(
    xmin = ci_lci,
    xmax = ci_uci,
    colour = sex_name),
  height = 0,
  position = ggstance::position_dodge2v(height = 0.3)
  ) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  facet_grid(location_name ~ .) +
  theme(axis.text.y=element_blank(), axis.ticks.y=element_blank(),legend.position="bottom") +
  labs(x="Concentration index", y="", colour="")


##


gbd2 <- fread(here("Data/april2025/by_sdi_and_year/IHME-GBD_2021_DATA-62748e2d-1.csv"))
temp2 <- inner_join(gbd2, gwas_attention)
o2 <- group_by(temp2, location_name, sex_name, year) %>%
  do(get_ci(.))
o2$location_name <- factor(o2$location_name, levels = c(
  "High SDI", "High-middle SDI", "Middle SDI",
  "Low-middle SDI", "Low SDI", "Global"
))

o2 %>%
ggplot(., aes(y = ci, x = year)) +
  geom_errorbar(colour="grey", aes(
    ymin = ci_lci,
    ymax = ci_uci),
  width = 0) +
  geom_hline(yintercept = 0, linetype = "dashed") + 
  facet_grid(. ~ location_name) +
  geom_smooth(se=FALSE) +
  geom_point() +
  theme_bw() +
  theme(axis.text.x=element_text(angle=90, vjust=0.5)) +
  labs(x="Year", y="Concentration index")
  ggsave(here("figures/ci_by_year.pdf"), width = 10, height = 4)

o1 %>%
  dplyr::filter(year == 2021) %>%
ggplot(., aes(y = ci, x = sex_name)) +
  geom_errorbar(colour="grey", aes(
    ymin = ci_lci,
    ymax = ci_uci),
  width = 0) +
  geom_point() +
  geom_hline(yintercept = 0, linetype = "dashed") + 
  facet_grid(. ~ location_name) +
  geom_smooth(se=FALSE) +
  theme_bw() +
  theme(axis.text.y=element_blank(), axis.ticks.y=element_blank(),legend.position="bottom") +
  labs(x="Sex", y="Concentration index")
  ggsave(here("figures/ci_by_sex.pdf"), width = 10, height = 4)


gbd3 <- fread(here("Data/april2025/by_country/IHME-GBD_2021_DATA-84f55027-1.csv"))
temp3 <- inner_join(gbd3, gwas_attention)
o3 <- group_by(temp3, location_name, sex_name, year) %>%
  do(get_ci(.))

colourPalette <- brewer.pal(5,'RdPu')

spdf <- joinCountryData2Map(o3 %>% filter(year == 1990), joinCode="NAME", nameJoinColumn="location_name")
mapDevice('pdf', file="figures/map1990.pdf")
mapParams <- mapCountryData(spdf, nameColumnToPlot="ci", colourPalette = colourPalette, mapTitle="", addLegend=FALSE, catMethod=seq(min(o3$ci), max(o3$ci), length=10))

do.call(addMapLegend, c(mapParams, legendLabels="all", legendWidth=0.5, legendIntervals="data", legendMar = 2))
dev.off()


spdf <- joinCountryData2Map(o3 %>% filter(year == 2019), joinCode="NAME", nameJoinColumn="location_name")
mapDevice('pdf', file="figures/map2019.pdf")
mapParams <- mapCountryData(spdf, nameColumnToPlot="ci", colourPalette = colourPalette, mapTitle="", addLegend=FALSE, catMethod=seq(min(o3$ci), max(o3$ci), length=10))

do.call(addMapLegend, c(mapParams, legendLabels="all", legendWidth=0.5, legendIntervals="data", legendMar = 2))
dev.off()

spdf <- joinCountryData2Map(o3 %>% filter(year == 2021), joinCode="NAME", nameJoinColumn="location_name")
mapDevice('pdf', file="figures/map2021.pdf")
mapParams <- mapCountryData(spdf, nameColumnToPlot="ci", colourPalette = colourPalette, mapTitle="", addLegend=FALSE, catMethod=seq(min(o3$ci), max(o3$ci), length=10))

do.call(addMapLegend, c(mapParams, legendLabels="all", legendWidth=0.5, legendIntervals="data", legendMar = 2))
dev.off()




## Lorenz curves


# Gini index
temp <- subset(temp1, !duplicated(cause_id))

gini <- ci(
  ineqvar = temp1$total_attention_score,
  outcome = temp1$total_attention_score, method = "direct"
)

sdi_low <- subset(temp1, location_name == "Low SDI" & sex_name=="Both" & year==2019)
ci_low <- ci(
  ineqvar = sdi_low$total_attention_score,
  outcome = sdi_low$val, method = "direct"
)

sdi_high <- subset(temp1, location_name == "High SDI" & sex_name=="Both" & year==2019)
ci_high <- ci(
  ineqvar = sdi_high$total_attention_score,
  outcome = sdi_high$val, method = "direct"
)

global <- subset(temp1, location_name == "Global" & sex_name=="Both" & year==2019)
ci_global <- ci(
  ineqvar = global$total_attention_score,
  outcome = global$val, method = "direct"
)

make_plot_dat <- function(x) {
  myOrder <- order(x$fractional_rank)
  xCoord <- x$fractional_rank[myOrder]
  y <- x$outcome[myOrder]
  cumdist <- cumsum(y) / sum(y)
  tibble(xCoord, cumdist)
}

dat <- bind_rows(
  make_plot_dat(gini) %>% mutate(group = "GWAS Gini index"),
  make_plot_dat(ci_global) %>% mutate(group = "Alignment (Global)"),
  make_plot_dat(ci_low) %>% mutate(group = "Alignment (Low SDI)"),
  make_plot_dat(ci_high) %>% mutate(group = "Alignment (High SDI)")
)

ggplot(aes(x = xCoord, y = cumdist, group = group), data = dat) +
  geom_line(aes(colour = group)) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  theme_bw() +
  theme(legend.position = "bottom", legend.direction = "vertical") +
  labs(
    x = "Fractional rank",
    y = "Cumulative proportion of attention score",
    colour = ""
  ) +
  scale_colour_manual(values = c(
    "#a6cee3",
    "#1f78b4",
    "#b2df8a",
    "#33a02c"
  ))
ggsave(here("figures/lorenz_curve.pdf"), width = 5, height = 6)
