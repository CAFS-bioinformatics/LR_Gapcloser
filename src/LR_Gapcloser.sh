#!/bin/bash
thread=5
coverage=0.8
tolerance=0.2
taglen=300
overstep=300
max_distance=600
number=5
itera=3
output=Output
platform=p
program=`ls -al /proc/$$/fd/ | awk '/255/{print $NF}' | sed 's#/LR_Gapcloser.sh##'`
usage (){
echo "Usage:sh `basename $0` -i Scaffold_file -l Corrected-PacBio-read_file"
echo "  -i    the scaffold file that contains gaps, represented by a string of N          [         required ]"
echo "  -l    the raw and error-corrected long reads used to close gaps. The file should                      "
echo "        be fasta format.                                                               [         required ]"
echo "  -s    sequencing platform: pacbio [p] or nanopore [n]                             [ default:       p ]"

echo "  -t    number of threads (for machines with multiple processors), used in the bwa                      " 
echo "        mem alignment processes and the following coverage filteration.             [ default:       5 ]"
echo "  -c    the coverage threshold to select high-quality alignments                    [ default:     0.8 ]"
echo "  -a    the deviation between gap length and filled sequence length                 [ default:     0.2 ]"
echo "  -m    to select the reliable tags for gap-closure, the maximal allowed                                "   
echo "        distance from alignment region to gap boundary (bp)                         [ default:     600 ]"
echo "  -n    the number of files that all tags were divided into                         [ default:       5 ]"
echo "  -g    the length of tags that a long read would be divided into (bp)              [ default:     300 ]"
echo "  -v    the minimal tag alignment length around each boundary of a gap (bp)         [ default:     300 ]"
echo "  -r    number of iteration                                                         [ default:       3 ]"
echo "  -o    name of output directory                                                    [ default: ./Output]"
exit 1
}
NUMARGS=$#
if [ $NUMARGS == 0 ] 
  then
  usage
else
  while getopts ":i:l:s:t:c:a:m:n:g:v:r:o:" opt;
  do  
    case $opt in
        i)contigs=$OPTARG 
          con=1 ;;
        l)longread=$OPTARG
          lr=1 ;;
        s)platform=$OPTARG;;
        t)thread=$OPTARG ;;
        c)coverage=$OPTARG ;;
        a)tolerance=$OPTARG ;;
        m)max_distance=$OPTARG;;
        n)number=$OPTARG;;
        g)taglen=$OPTARG;;
        v)overstep=$OPTARG;;
        r)itera=$OPTARG;;
        o)output=$OPTARG ;;
        ?)
          usage
          ;;        
        :)
          echo "Option -$OPTARG requires an argument." >&2
          exit 1
          ;;
    esac
  done
if [[ $con -eq 1 ]] && [[ $lr -eq 1 ]] ; then
echo "-i(scaffolds)=$contigs -l(longread)=$longread -s(platform)=$platform -t(thread)=$thread -c(coverage)=$coverage -a(tolerance)=$tolerance -m(max_distance)=$max_distance -n(number)=$number -g(taglen)=$taglen -v(overstep)=$overstep -o(output)=$output"
  if [ ! -d $output ] ; then
    mkdir "$output" 
  else
    echo "The output directory already exists!!! Program stop running !!!"
    exit
  fi
  mkdir $output/tmp
  mkdir $output/iteration-1
  mkdir $output/iteration-1/tmp
  mkdir $output/iteration-1/db
  $program/bwa index -a bwtsw -p $output/iteration-1/db/genome $contigs >$output/iteration-1/db/index.log 2>$output/iteration-1/db/index.error
  perl $program/format_fa.pl $longread $output
  perl $program/change_case_fasta.pl $contigs 1 >$output/genome_uc.fasta
 
  perl $program/tag_generator.pl $output/LR.fasta $taglen >$output/tmp/LR.tag.fa
  
  split -n $number -d $output/tmp/LR.tag.fa 1>$output/tmp/log 2>$output/tmp/error 
  mv x* $output/tmp/

  rm $output/tmp/LR.tag.fa

      for  FILE in $output/tmp/x*
       do
          base_name=`basename $FILE`;
          libraryid=${base_name%};
          if [ "$platform" = "p"  ]; then
          $program/bwa mem -k17 -W40 -r10 -A1 -B1 -O1 -E1 -L0 -t $thread $output/iteration-1/db/genome $FILE >$output/iteration-1/tmp/$libraryid.mem 2>>$output/iteration-1/tmp/mem.error
          else
          $program/bwa mem -k14 -W20 -r10 -A1 -B1 -O1 -E1 -L0 -t $thread $output/iteration-1/db/genome $FILE >$output/iteration-1/tmp/$libraryid.mem 2>>$output/iteration-1/tmp/mem.error
          fi
       done

      for FILE in $output/iteration-1/tmp/x*.mem
       do
        perl $program/coverage_calculator.pl $FILE $FILE.coverage &
       done
      wait
      cat $output/iteration-1/tmp/x*.mem.coverage >$output/iteration-1/tmp/tag_coverage
      rm $output/iteration-1/tmp/x*;
  perl $program/gap_finder.pl $contigs >$output/iteration-1/tmp/gap.location & perl $program/coverage_filter.pl $output/iteration-1/tmp/tag_coverage $coverage >$output/iteration-1/tmp/"$coverage"_tag.coverage
  wait
  perl $program/tag_alignment_filter.pl $output/iteration-1/tmp/"$coverage"_tag.coverage >$output/iteration-1/tmp/tag_alignment_filter.out
  perl $program/retrieve-unique-alignment.pl $output/iteration-1/tmp/"$coverage"_tag.coverage $output/iteration-1/tmp/tag_alignment_filter.out >$output/iteration-1/tmp/tag_alignment_retrieve.out 
  perl $program/best-match-LR.pl $output/iteration-1/tmp/tag_alignment_retrieve.out >$output/iteration-1/tmp/tag_alignment_only.out
  perl $program/tag_orientation_corrector.pl $output/iteration-1/tmp/tag_alignment_only.out >$output/iteration-1/tmp/tag_orientation_corrector.out
  perl $program/block_align.pl $output/iteration-1/tmp/tag_orientation_corrector.out >$output/iteration-1/tmp/tag_orientation_corrector.out.sort
  perl $program/remove_wrong3.pl $output/iteration-1/tmp/tag_orientation_corrector.out.sort >$output/iteration-1/tmp/RW3.out
  perl $program/block_align.pl $output/iteration-1/tmp/RW3.out >$output/iteration-1/tmp/RW3.out.sort
  perl $program/gap_bridging.pl $output/iteration-1/tmp/gap.location $output/iteration-1/tmp/RW3.out.sort >$output/iteration-1/tmp/gap_bridging.out
  perl $program/join_LRlength.pl $output/LR_length $output/iteration-1/tmp/gap_bridging.out >$output/iteration-1/tmp/gap_bridging_LRlength
  perl $program/tag_distance_filter_classify.pl $output/iteration-1/tmp/gap_bridging_LRlength $max_distance $output/iteration-1/tmp classify 
  perl $program/complete_substitute_limiter.pl $output/iteration-1/tmp/classify_complete.txt $tolerance >$output/iteration-1/tmp/complete_Slimite
  perl $program/complete_ultimate_elect.pl $output/iteration-1/tmp/complete_Slimite >$output/iteration-1/tmp/complete_ultimate.out
  perl $program/further_partial_select.pl $output/iteration-1/tmp/classify_partial.txt $overstep >$output/iteration-1/tmp/classify_partial_Select
  perl $program/partial_ultimate_elect.pl $output/iteration-1/tmp/classify_partial_Select 3 >$output/iteration-1/tmp/partial_elect.out
  perl $program/last_Drepeat.pl $output/iteration-1/tmp/complete_ultimate.out $output/iteration-1/tmp/partial_elect.out >$output/iteration-1/tmp/partial_elect_Drepeat.out
  perl $program/group_partial.pl $output/iteration-1/tmp/partial_elect_Drepeat.out $output/iteration-1/tmp group
  perl $program/complete_retriver.pl $output/iteration-1/tmp/group_close_1.txt $output/iteration-1/tmp/tag_coverage >$output/iteration-1/tmp/complete_candidate
  perl $program/retriever_backfill.pl $output/iteration-1/tmp/complete_candidate $output/iteration-1/tmp/group_close_1.txt $output/iteration-1/tmp retrieve $tolerance
  cat $output/iteration-1/tmp/retrieve_ccomplete.out $output/iteration-1/tmp/complete_ultimate.out >$output/iteration-1/tmp/complete_all
  perl $program/info_formatter.pl $output/iteration-1/tmp/complete_all $output/iteration-1/tmp/retrieve_cclose1.out $output/iteration-1/tmp/group_open.txt $output/iteration-1/tmp/group_close_2.txt >$output/iteration-1/tmp/all_info
  perl $program/same_filter.pl $output/iteration-1/tmp/all_info >$output/iteration-1/tmp/new_desame
  perl $program/info_pacify.pl $output/iteration-1/tmp/new_desame >$output/iteration-1/tmp/info_filter2
  perl $program/form_sequence.pl $output/iteration-1/tmp/info_filter2 $output/LR.fasta $output/genome_uc.fasta >$output/iteration-1/gapclosed.fasta
#### iteration estimate
if [ "$itera" -gt 1 ] ;
    then
      j=2
      while [ "$j" -le "$itera" ]
          do
          mkdir $output/iteration-$j
          mkdir $output/iteration-$j/tmp
          i=$(($j-1))
          perl $program/gap_finder.pl $output/iteration-$i/gapclosed.fasta >$output/iteration-$j/tmp/gap.location
          awk -F '[(][:]' '{print $1}' $output/iteration-$j/tmp/gap.location >$output/iteration-$j/tmp/genome.id
          esti=`head $output/iteration-$j/tmp/genome.id`
          if [ "$esti" = "" ] ; then
             rm -r $output/iteration-$j
             break
             else
#### iteration process
  perl $program/find_sequnce_file.pl $output/iteration-$j/tmp/genome.id $output/iteration-$i/gapclosed.fasta >$output/iteration-$j/tmp/tmp_genome.fasta
  mkdir $output/iteration-$j/db
  $program/bwa index -a bwtsw -p $output/iteration-$j/db/genome $output/iteration-$j/tmp/tmp_genome.fasta >$output/iteration-$j/db/index.log 2>$output/iteration-$j/db/index.error
      for  FILE in $output/tmp/x*
        do
          base_name=`basename $FILE`;
          libraryid=${base_name%};
          
          if [ "$platform" = "p"  ]; then
           $program/bwa mem -k17 -W40 -r10 -A1 -B1 -O1 -E1 -L0 -t $thread $output/iteration-$j/db/genome $FILE >$output/iteration-$j/tmp/$libraryid.mem 2>>$output/iteration-$j/tmp/mem.error 
          else
           $program/bwa mem -k14 -W20 -r10 -A1 -B1 -O1 -E1 -L0 -t $thread $output/iteration-$j/db/genome $FILE >$output/iteration-$j/tmp/$libraryid.mem 2>>$output/iteration-$j/tmp/mem.error
          fi
        done
      for FILE in $output/iteration-$j/tmp/x*.mem
            do
              perl $program/coverage_calculator.pl $FILE $FILE.coverage &
            done
        wait
        cat $output/iteration-$j/tmp/x*.mem.coverage >$output/iteration-$j/tmp/tag_coverage
        rm $output/iteration-$j/tmp/x*;
        perl $program/coverage_filter.pl $output/iteration-$j/tmp/tag_coverage $coverage >$output/iteration-$j/tmp/"$coverage"_tag.coverage
  wait
  perl $program/tag_alignment_filter.pl $output/iteration-$j/tmp/"$coverage"_tag.coverage >$output/iteration-$j/tmp/tag_alignment_filter.out
  perl $program/retrieve-unique-alignment.pl $output/iteration-$j/tmp/"$coverage"_tag.coverage $output/iteration-$j/tmp/tag_alignment_filter.out >$output/iteration-$j/tmp/tag_alignment_retrieve.out
  perl $program/best-match-LR.pl $output/iteration-$j/tmp/tag_alignment_retrieve.out >$output/iteration-$j/tmp/tag_alignment_only.out
  perl $program/tag_orientation_corrector.pl $output/iteration-$j/tmp/tag_alignment_only.out >$output/iteration-$j/tmp/tag_orientation_corrector.out
  perl $program/block_align.pl $output/iteration-$j/tmp/tag_orientation_corrector.out >$output/iteration-$j/tmp/tag_orientation_corrector.out.sort
  perl $program/remove_wrong3.pl $output/iteration-$j/tmp/tag_orientation_corrector.out.sort >$output/iteration-$j/tmp/RW3.out
  perl $program/block_align.pl $output/iteration-$j/tmp/RW3.out >$output/iteration-$j/tmp/RW3.out.sort
  perl $program/gap_bridging.pl $output/iteration-$j/tmp/gap.location $output/iteration-$j/tmp/RW3.out.sort >$output/iteration-$j/tmp/gap_bridging.out
  perl $program/join_LRlength.pl $output/LR_length $output/iteration-$j/tmp/gap_bridging.out >$output/iteration-$j/tmp/gap_bridging_LRlength
  perl $program/tag_distance_filter_classify.pl $output/iteration-$j/tmp/gap_bridging_LRlength $max_distance $output/iteration-$j/tmp classify
  perl $program/complete_substitute_limiter.pl $output/iteration-$j/tmp/classify_complete.txt $tolerance >$output/iteration-$j/tmp/complete_Slimite
  perl $program/complete_ultimate_elect.pl $output/iteration-$j/tmp/complete_Slimite >$output/iteration-$j/tmp/complete_ultimate.out
  perl $program/further_partial_select.pl $output/iteration-$j/tmp/classify_partial.txt $overstep >$output/iteration-$j/tmp/classify_partial_Select
  perl $program/partial_ultimate_elect.pl $output/iteration-$j/tmp/classify_partial_Select 3 >$output/iteration-$j/tmp/partial_elect.out
  perl $program/last_Drepeat.pl $output/iteration-$j/tmp/complete_ultimate.out $output/iteration-$j/tmp/partial_elect.out >$output/iteration-$j/tmp/partial_elect_Drepeat.out
  perl $program/group_partial.pl $output/iteration-$j/tmp/partial_elect_Drepeat.out $output/iteration-$j/tmp group
  perl $program/complete_retriver.pl $output/iteration-$j/tmp/group_close_1.txt $output/iteration-$j/tmp/tag_coverage >$output/iteration-$j/tmp/complete_candidate
  perl $program/retriever_backfill.pl $output/iteration-$j/tmp/complete_candidate $output/iteration-$j/tmp/group_close_1.txt $output/iteration-$j/tmp retrieve $tolerance
  cat $output/iteration-$j/tmp/retrieve_ccomplete.out $output/iteration-$j/tmp/complete_ultimate.out >$output/iteration-$j/tmp/complete_all
  perl $program/info_formatter.pl $output/iteration-$j/tmp/complete_all $output/iteration-$j/tmp/retrieve_cclose1.out $output/iteration-$j/tmp/group_open.txt $output/iteration-$j/tmp/group_close_2.txt >$output/iteration-$j/tmp/all_info
  perl $program/same_filter.pl $output/iteration-$j/tmp/all_info >$output/iteration-$j/tmp/new_desame
  perl $program/info_pacify.pl $output/iteration-$j/tmp/new_desame >$output/iteration-$j/tmp/info_filter2
  perl $program/form_sequence.pl $output/iteration-$j/tmp/info_filter2 $output/LR.fasta $output/iteration-$i/gapclosed.fasta >$output/iteration-$j/gapclosed.fasta
          fi
          j=$(( $j + 1))
          done
fi
rm $output/LR.fasta $output/genome_uc.fasta $output/LR_length $output/tmp/x*
else 
  usage
fi
fi
