# LR_Gapcloser <p>
  LR_Gapcloser is a gap closing tool using long reads from studied species. The long reads could be downloaed from public read archive database (for instance, NCBI SRA database ) or be your own data. Then they are fragmented and aligned to scaffolds using BWA mem algorithm in BWA package. In the package, we provided a compiled bwa, so the user needn't to install bwa. LR_Gapcloser uses the alignments to find the bridging that cross the gap, and then fills the long read original sequence into the genomic gaps. 

<b>SYSTEM REQUIREMENTS</b> <p>
   (1)Perl and Bioperl should be installed on the system. <p>
   (2)GLIBC 2.14 should be installed.<p>

<b>INSTALLING </b> <p>
   1) After downloading the sofware, simply type "tar -zxvf LR_Gapcloser.tar.gz" in the installation directory. The software does not require any special compilation and is already provided as portable precompiled software. 
   2) Then for convenience ,you can type "export PATH=$PATH:your_directory/LR_Gapcloser/" to set the PATH environmental variables.

<b>INPUT FILES</b> <p>
   (1)The scaffold file is required and should be fasta format. The description line or header line, which begins with '>', provides a unique name and/or identifier for the sequence. And the name and/or identifier must not contain a "(:", because in data processing, we will use "(:" as delimiters. <p>
   (2)The long reads file is also required and should be fasta format and the reads must be error corrected. If the file is fastq format, it should be converted into fasta format before running the software. <p>

<b>COMMANDS AND OPTIONS</b> <p>
LR_Gapcloser is run via the shell script: LR_Gapcloser.sh, which could be found in the base installation directory.<p>

Usage info is as follows: <p>

  in Centos system, use "sh LR_Gapcloser.sh -i Scaffold_file -l Corrected-PacBio-read_file -s p " <p>

  in Ubuntu system, use "bash LR_Gapcloser.sh -i Scaffold_file -l Corrected-PacBio-read_file -s p" <p>

Input options <p> 
  -i  the scaffold file that contains gaps, represented by a string of N        [         required ] <p>
  -l  the raw and error-corrected long reads used to close gaps. The file should be fasta format. [         required ] <p>
  -s  sequencing platform: pacbio [p] or nanopore [n]                           [ default:       p ] <p>
  -t  number of threads (for machines with multiple processors), used in the bwa mem alignment processes and the following coverage    
      filteration.     [ default:       5 ] <p>
  -c  the coverage threshold to select high-quality alignments                  [ default:     0.8 ] <p>
  -a  the deviation between gap length and filled sequence length             [ default:     0.2 ] <p>
  -m  to select the reliable tags for gap-closure, the maximal allowed distance from alignment region to gap boundary (bp) [ default:         600 ] <p>
  -n  the number of files that all tags were divided into                     [ default:       5 ] <p>
  -g  the length of tags that a long read would be divided into (bp)          [ default:     300 ] <p>
  -v  the minimal tag alignment length around each boundary of a gap (bp)     [ default:     300 ] <p>
  -r  number of iteration                                                     [ default:       3 ] <p>
  -o  name of output directory                                                [ default: ./Output] <p>

<b>OUTPUT FILES</b><p>
   LR_Gapcloser generated a file named as gapclosed.fasta in the sub-directory of "iteration-3" of the output directory. <p>
