library(here)
library(dplyr)
library(data.table)
library(rineq)
library(ggplot2)
library(ggstance)
library(rworldmap)
library(RColorBrewer)

get_ci <- function(x) {
  out <- ci(
    ineqvar = x$total_attention_score,
    outcome = x$val, method = "direct"
  )
  l <- tibble(
    ci = out$concentration_index,
    ci_se = sqrt(out$variance),
    ci_lci = ci - 1.96 * ci_se,
    ci_uci = ci + 1.96 * ci_se,
    daly_sum = sum(x$val, na.rm=TRUE)
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
length(unique(gbd1$cause_id))
length(unique(gbd2$cause_id))

gbd2 <- fread(here("Data/april2025/by_sdi_and_year/IHME-GBD_2021_DATA-45f67a86-1.csv"))
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
  make_plot_dat(gini) %>% mutate(group = "GWAS attention (Gini index)"),
  make_plot_dat(ci_global) %>% mutate(group = "DALY burden, Global"),
  make_plot_dat(ci_low) %>% mutate(group = "DALY burden, Low SDI"),
  make_plot_dat(ci_high) %>% mutate(group = "DALY burden, High SDI")
)

ggplot(aes(x = xCoord, y = cumdist, group = group), data = dat) +
  geom_line(aes(colour = group)) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  theme_bw() +
  theme(legend.position = "inside", legend.position.inside=c(0.2,0.8)) +
  labs(
    x = "Fractional rank of GWAS attention score",
    y = "Cumulative proportion of outcome",
    colour = "Outcome"
  ) +
  scale_colour_manual(values = c(
    "#a6cee3",
    "#1f78b4",
    "#b2df8a",
    "#33a02c"
  ))
ggsave(here("figures/lorenz_curve.pdf"), width = 6, height = 6)
table(gbd4$age_name) %>% as.data.frame
table(gbd4$age_id) %>% as.data.frame



gbd4 <- fread(here("Data/april2025/by_sdi_and_age/IHME-GBD_2021_DATA-2c936676-1.csv"))
temp4 <- inner_join(gbd4, gwas_attention)
temp4$age_group <- gsub(" years", "", temp4$age_name)
temp4$age_group <- gsub(" year", "", temp4$age_group)
temp4$age_group <- factor(temp4$age_group, levels = c("<1", "2-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", "75-79", "80-84", "85-89", "90-94"))

table(gbd4$age_id, gbd4$location_id, gbd4$year)

o4 <- temp4 %>%
  # filter(age_group != "<1") %>%
  group_by(location_name, age_name, age_group, age_id, year) %>%
  do(get_ci(.)) %>%
  ungroup() %>%
  group_by(location_name, year) %>%
  mutate(daly_prop = daly_sum / sum(daly_sum, na.rm=TRUE))
o4$location_name <- factor(o4$location_name, levels = c(
  "High SDI", "High-middle SDI", "Middle SDI",
  "Low-middle SDI", "Low SDI", "Global"
))

o4 %>%
  dplyr::filter(year == 2019) %>%
  ggplot(., aes(y = ci, x = age_group)) +
    geom_errorbar(colour="grey", aes(
      ymin = ci_lci,
      ymax = ci_uci),
    width = 0) +
    geom_hline(yintercept = 0, linetype = "dashed") + 
    facet_grid(. ~ location_name) +
    geom_point(aes(size=daly_prop)) +
    theme_bw() +
    theme(axis.text.x=element_text(angle=90, vjust=0.5, hjust=1), legend.position = "inside", legend.position.inside=c(0.08,0.2)) +
    labs(x="Age group", y="Concentration index", size="DALY proportion") +
    ylim(-0.7, 0.7)
ggsave(here("figures/ci_by_age.pdf"), width = 10, height = 4)


reg <- group_by(temp4, cause_name, year, location_name) %>%
  do({
    tryCatch({
      .$val <- scale(.$val)[, 1]
      a <- summary(lm(val ~ as.numeric(age_group), data = .))
      b <- a$coefficients[2, 1]
      c <- a$coefficients[2, 4]
      d <- a$coefficients[2, 2]
      e <- a$coefficients[2, 3]
      tibble(
        slope = b,
        pval = c,
        se = d,
        tval = e
      )
    },
    error = function(e) {
      message("Error in regression for cause: ", unique(.$cause_name))
      tibble(
        slope = NA,
        pval = NA,
        se = NA,
        tval = NA
      )
    })
})

reg$pval_adj <- p.adjust(reg$pval, method = "bonferroni")
table(reg$pval_adj < 0.05)

reg %>% arrange(pval_adj)


reg %>% arrange(slope) %>% filter(year == 2021, pval_adj < 0.05) %>% select(cause_name, slope, location_name) %>% as.data.frame

