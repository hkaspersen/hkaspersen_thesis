library(DiagrammeR)
library(DiagrammeRsvg)
library(rsvg)

grViz("digraph {
      graph [layout = dot]
      
      node [shape = rectangle, style = filled, fillcolor = Linen]
      
      assembly [label = 'Annotated \nassembly', shape = folder, fillcolor = Lavender]
      roary [label = 'Roary']
      snpsites [label = 'Snp-sites']
      iqtree [label = 'IQTree']
      ggtree [label = 'Ggtree', fillcolor = DarkTurquoise, shape = ellipse]
      snpdists [label = 'Snp-dists']
      disttips [label = 'distTips', fillcolor = DarkTurquoise, shape = ellipse]
      distmatrix [label = 'SNP distance \nmatrix', shape = folder, fillcolor = Ivory]
      patdist [label = 'Patristic \ndistances', shape = folder, fillcolor = Ivory]
      tree [label = 'Phylogenetic \ntree', shape = folder, fillcolor = Ivory]
      
      assembly -> roary -> snpsites -> iqtree -> ggtree -> tree
      iqtree -> disttips -> patdist
      snpsites -> snpdists -> distmatrix
}") %>%
  export_svg() %>% charToRaw() %>% rsvg_png("test.png",
                                            width = 1800,
                                            height = 2400)

grViz("digraph {
      graph [layout = dot]
      
      node [shape = rectangle, style = filled, fillcolor = Linen]
      
      assembly [label = 'Annotated \nassembly', shape = folder, fillcolor = Lavender]
      iqtree [label = 'IQTree']
      ggtree [label = 'Ggtree', fillcolor = DarkTurquoise, shape = ellipse]
      snpdists [label = 'Snp-dists']
      distmatrix [label = 'SNP distance \nmatrix', shape = folder, fillcolor = Ivory]
      tree [label = 'Phylogenetic \ntree', shape = folder, fillcolor = Ivory]
      gubbins [label = 'Gubbins']
      parsnp [label = 'ParSNP']
      harvest [label = 'Harvesttools']
      
      assembly -> parsnp -> harvest -> gubbins -> iqtree -> ggtree
      ggtree -> tree
      gubbins -> snpdists -> distmatrix
}") %>%
  export_svg() %>% charToRaw() %>% rsvg_png("test2.png",
                                            width = 1200,
                                            height = 2600)

