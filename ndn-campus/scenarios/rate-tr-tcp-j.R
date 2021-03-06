#!/usr/bin/Rscript

# rate-tr-tcp-j.R
# Simple R script to make graphs from ndnSIM tracers - Rate tracing
#
# Copyright (c) 2014 Waseda University, Sato Laboratory
# Author: Jairo Eduardo Lopez <jairo@ruri.waseda.jp>
#
# rate-tr-tcp-j.R is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# rate-tr-tcp-j.R is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of              
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               
# GNU Affero Public License for more details.                                 
#                                                                             
# You should have received a copy of the GNU Affero Public License            
# along with rate-tr-tcp-j.R.  If not, see <http://www.gnu.org/licenses/>.
#                    

suppressPackageStartupMessages(library (ggplot2))
suppressPackageStartupMessages(library (scales))
suppressPackageStartupMessages(library (optparse))
suppressPackageStartupMessages(library (doBy))

# set some reasonable defaults for the options that are needed
option_list <- list (
  make_option(c("-f", "--file"), type="character", default="results/rate-trace.txt",
              help="File which holds the raw TCP/IP rate data.\n\t\t[Default \"%default\"]"),
  make_option(c("-e", "--node"), type="character", default="",
              help="Node data to graph. Can be a comma separated list.\n\t\tDefault graphs data for all nodes."),
  make_option(c("-o", "--output"), type="character", default=".",
              help="Output directory for graphs.\n\t\t[Default \"%default\"]"),
  make_option(c("-t", "--title"), type="character", default="Scenario",
              help="Title for the graph")
)

# Load the parser
opt = parse_args(OptionParser(option_list=option_list, description="Creates graphs from ndnSIM L3 Data TCP/IP rate Tracer data"))

data = read.table (opt$file, header=T)
data$Node = factor (data$Node)
data$Kilobits <- data$Kilobytes * 8
data$Type = factor (data$Type)

intdata = data

intdata = subset(intdata, Type %in% c("Out", "In"))

if (nrow(intdata) == 0) {
  cat(sprintf("There is no data. Possibly not a TCP/IP data file.\n"))
  quit("yes")
}

name = ""
filnodes = unlist(strsplit(opt$node, ","))

# Get the basename of the file
tmpname = strsplit(opt$file, "/")[[1]]
filename = tmpname[length(tmpname)]
# Get rid of the extension
noext = gsub("\\..*", "", filename)

# Set the theme for graph output
theme_set(theme_grey(base_size = 24) + 
            theme(axis.text = element_text(colour = "black")))

# Print the Interest information if the data is from TCP/IP 
intdata.combined = ""
g.int = ""
# Filter for a particular node
if (nchar(opt$node) > 0) {
  intdata = subset (intdata, Node %in% filnodes)
  
  if (dim(data)[1] == 0) {
    cat(sprintf("There is no Node %s in this trace!\n", opt$node))
    quit("yes")
  }
  
  intname = sprintf("%s TCP/IP Data rate for Nodes %s", opt$title, opt$node)
  
  intdata.combined = summaryBy (. ~ Time + Node + Type, data=intdata, FUN=sum)
  
  # graph rates on all nodes in Kilobits
  g.int <- ggplot (intdata.combined, aes(x=Time, y=Kilobits.sum, color=Type)) +
    geom_line(aes (linetype=Type), size=0.5) + 
    geom_point(aes (shape=Type), size=1) +  
    ggtitle (intname) +
    ylab ("Rate [Kbits/s]") +
    xlab ("Simulation time (Seconds)") +
    facet_wrap (~ Node)
} else {
  intname = sprintf("%s TCP/IP Data rate", opt$title)
  
  intdata.combined = summaryBy (. ~ Time + Type, data=intdata, FUN=sum)
  
  # graph rates on all nodes in Kilobits
  g.int <- ggplot (intdata.combined, aes(x=Time, y=Kilobits.sum, color=Type)) +
    geom_line(aes (linetype=Type), size=0.5) + 
    geom_point(aes (shape=Type), size=1) +  
    ggtitle (intname) +
    ylab ("Rate [Kbits/s]") +
    xlab ("Simulation time (Seconds)")
}



outInpng = ""
# The output png
if (nchar(opt$node) > 0) {
  outInpng = sprintf("%s/%s-%s-in.png", opt$output, noext, paste(filnodes, sep="", collapse="_"))
} else {
  outInpng = sprintf("%s/%s-in.png", opt$output, noext)
}

png (outInpng, width=1024, height=768)
print (g.int)
x = dev.off ()
