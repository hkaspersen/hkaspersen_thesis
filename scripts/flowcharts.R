library(DiagrammeR)
library(DiagrammeRsvg)
library(rsvg)

grViz("digraph {
      graph [layout = dot]
      
      node [shape = rectangle, style = filled, fillcolor = LemonChiffon]
      
      assembly [label = 'Annotated \nassembly', shape = diamond, fillcolor = Salmon]
      roary [label = 'Roary']
      snpsites [label = 'Snp-sites']
      iqtree [label = 'IQTree']
      ggtree [label = 'Ggtree', fillcolor = DarkTurquoise, shape = ellipse]
      snpdists [label = 'Snp-dists']
      disttips [label = 'distTips', fillcolor = DarkTurquoise, shape = ellipse]
      distmatrix [label = 'SNP distance \nmatrix', shape = folder, fillcolor = MediumSeaGreen]
      patdist [label = 'Patristic \ndistances', shape = folder, fillcolor = MediumSeaGreen]
      tree [label = 'Phylogenetic \ntree', shape = folder, fillcolor = MediumSeaGreen]
      
      assembly -> roary -> snpsites -> iqtree -> ggtree -> tree
      iqtree -> disttips -> patdist
      snpsites -> snpdists -> distmatrix
}") %>%
  export_svg() %>% charToRaw() %>% rsvg_png("test.png",
                                            width = 1800,
                                            height = 2400)

grViz("digraph {
      graph [layout = dot]
      
      node [shape = rectangle, style = filled, fillcolor = LemonChiffon]
      
      assembly [label = 'Annotated \nassembly', shape = diamond, fillcolor = Salmon]
      iqtree [label = 'IQTree']
      ggtree [label = 'Ggtree', fillcolor = DarkTurquoise, shape = ellipse]
      snpdists [label = 'Snp-dists']
      distmatrix [label = 'SNP distance \nmatrix', shape = folder, fillcolor = MediumSeaGreen]
      tree [label = 'Phylogenetic \ntree', shape = folder, fillcolor = MediumSeaGreen]
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


grViz("digraph {

      graph [layout = dot,
      ratio = fill]
      
      node [shape = rectangle, style = filled, fillcolor = LemonChiffon, margin = 0.25, penwidth = 0.8]
      
      reads [label = 'Raw reads', shape = diamond, fillcolor = Salmon, fontsize = 22]
      mash [label = 'Mash screen']
      bbduk [label = <bbduk<BR /><FONT POINT-SIZE='8'>k = 31</FONT>>]
      trim [label = <Trimmomatic<BR /><FONT POINT-SIZE='8'>LEADING: 3 TRAILING: 3<BR />SLIDINGWINDOW: 4:15<BR />minlen: 36</FONT>>]
      spades [label = <SPAdes<BR /><FONT POINT-SIZE='8'>cov-cutoff=auto <BR />careful</FONT>>]
      filter [label = <filter fasta <BR />lengths<BR /><FONT POINT-SIZE='8'>-m 500</FONT>>]
      quast [label = 'QUAST']
      bwamem [label = 'BWA mem']
      pilon [label = 'Pilon']
      prokka [label = <Prokka<BR /><FONT POINT-SIZE='8'>genus=Escherichia<BR />species=coli<BR />kingdom=Bacteria<BR />compliant<BR />usegenus<BR />proteins</FONT>>]
      assemblyqual [label = 'Assembly \nquality', shape = folder, fillcolor = MediumSeaGreen]
      annotgenome [label = 'Annotated \nassemblies', shape = folder, fillcolor = MediumSeaGreen]
      contreport [label = 'Contamination \nreport', shape = folder, fillcolor = MediumSeaGreen]
      rscript1 [label = 'R Script', fillcolor = DarkTurquoise, shape = ellipse]
      rscript2 [label = 'R Script', fillcolor = DarkTurquoise, shape = ellipse]
      
      reads -> mash -> rscript1 -> contreport
      trim -> bwamem
      reads -> bbduk -> trim -> spades -> filter -> quast -> rscript2 -> assemblyqual
      filter -> bwamem -> pilon -> prokka -> annotgenome
}") %>%
  export_svg() %>% charToRaw() %>% rsvg_png("assembly_pipeline.png",
                                            width = 1000,
                                            height = 2600)



