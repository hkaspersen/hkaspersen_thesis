library(DiagrammeR)
library(DiagrammeRsvg)
library(rsvg)

grViz("digraph {
      graph [layout = dot]
      
      node [shape = rectangle, style = filled, fillcolor = '#F6E2BC']
      
      assembly [label = 'Annotated \nassembly', shape = diamond, fillcolor = '#75BDE0']
      roary [label = 'Roary']
      snpsites [label = 'Snp-sites']
      iqtree [label = 'IQTree']
      ggtree [label = 'Ggtree', fillcolor = '#3B7097', shape = ellipse, fontcolor = 'white']
      snpdists [label = 'Snp-dists']
      disttips [label = 'distTips', fillcolor = '#3B7097', shape = ellipse, fontcolor = 'white']
      distmatrix [label = 'SNP distance \nmatrix', shape = folder, fillcolor = '#A9D09E']
      patdist [label = 'Patristic \ndistances', shape = folder, fillcolor = '#A9D09E']
      tree [label = 'Phylogenetic \ntree', shape = folder, fillcolor = '#A9D09E']
      
      assembly -> roary -> snpsites -> iqtree -> ggtree -> tree
      iqtree -> disttips -> patdist
      snpsites -> snpdists -> distmatrix
}") %>%
  export_svg() %>% charToRaw() %>% rsvg_png("test.png",
                                            width = 1800,
                                            height = 2400)

grViz("digraph {
      graph [layout = dot]
      
      node [shape = rectangle, style = filled, fillcolor = '#F6E2BC']
      
      assembly [label = 'Annotated \nassembly', shape = diamond, fillcolor = '#75BDE0']
      iqtree [label = 'IQTree']
      ggtree [label = 'Ggtree', fillcolor = '#3B7097', shape = ellipse, fontcolor = 'white']
      snpdists [label = 'Snp-dists']
      distmatrix [label = 'SNP distance \nmatrix', shape = folder, fillcolor = '#A9D09E']
      tree [label = 'Phylogenetic \ntree', shape = folder, fillcolor = '#A9D09E']
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
      
      node [shape = rectangle, style = filled, fillcolor = '#F6E2BC', margin = 0.25, penwidth = 0.8, fontsize = 18]
      
      reads [label = 'Raw reads', shape = diamond, fillcolor = '#75BDE0', fontsize = 22]
      mash [label = 'Mash screen']
      bbduk [label = <bbduk<BR /><FONT POINT-SIZE='12'>k = 31</FONT>>]
      trim [label = <Trimmomatic<BR /><FONT POINT-SIZE='12'>LEADING: 3 TRAILING: 3<BR />SLIDINGWINDOW: 4:15<BR />minlen: 36</FONT>>]
      spades [label = <SPAdes<BR /><FONT POINT-SIZE='12'>cov-cutoff=auto <BR />careful</FONT>>]
      filter [label = <filter fasta <BR />lengths<BR /><FONT POINT-SIZE='12'>-m 500</FONT>>]
      quast [label = 'QUAST']
      bwamem [label = 'BWA mem']
      pilon [label = 'Pilon']
      prokka [label = <Prokka<BR /><FONT POINT-SIZE='12'>compliant<BR />usegenus<BR />proteins</FONT>>]
      assemblyqual [label = 'Assembly \nquality', shape = folder, fillcolor = '#A9D09E']
      annotgenome [label = 'Annotated \nassemblies', shape = folder, fillcolor = '#A9D09E']
      contreport [label = 'Contamination \nreport', shape = folder, fillcolor = '#A9D09E']
      rscript1 [label = 'R Script', fillcolor = '#3B7097', shape = ellipse, fontcolor = 'white']
      rscript2 [label = 'R Script', fillcolor = '#3B7097', shape = ellipse, fontcolor = 'white']
      
      reads -> mash -> rscript1 -> contreport
      trim -> bwamem
      reads -> bbduk -> trim -> spades -> filter -> quast -> rscript2 -> assemblyqual
      filter -> bwamem -> pilon -> prokka -> annotgenome
}") %>%
  export_svg() %>% charToRaw() %>% rsvg_png("assembly_pipeline.png",
                                            width = 1000,
                                            height = 2600)



