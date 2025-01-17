# A list of the calls to do the WGS analysis

First, doing a round of alignment and SNP calling on only the generation 70 samples to refine our reference.
This just fixes SNPs found in the founding genotypes that are not in our W303 reference. It isn't perfect and doesn't
add in the markers or anything, and also is done once for all 3 founders - a, alpha, and diploid. Anyways, the point
is just to make a new reference fasta so we end up with vcf files with fewer SNPs by getting rid of the obvious culprits.

## Runs bwa etc. on gen 70 WGS files using the original w303 reference
sbatch --array=1-90 orig_pilon_wgs_runner.sh

## combines bams from gen 70 samples, runs pilon, and tidies up to produce a new fasta and gff
sbatch combine_ref_bams_and_pilon.sh

This is after doing pilon stuff

## Fixes up the new reference for use
sbatch setup_ref.sh

## bwa, gatk
sbatch --array=1-540 wgs_runner.sh

## bwa, gatk on an earlier lane of the batch 2 samples that had quality issues with read 2, but turned out OK in the end
sbatch --array=1-90,180-269,370-449 lane_w_R2_issues_wgs_runner.sh

sbatch --array=1-90,180-269,370-449 combining_B2_lanes_wgs_runner.sh

## gatk combining
sbatch --array=1-18 combine_vcfs_combined_option.sh
(those jobs were an absolute nightmare to get done, some took over 2 days... maybe there is a better way...)

## see how_I_setup_snpEFF.txt for how that worked

sbatch annotate_vcfs_combined_option.sh

## combines all the separate chromosome vcfs, adds some annotations, filters and outputs per well. Also does multi-hit gene analysis and GO enrichment
sbatch vcf_parsing_combined_option.sh

## calculating depth and looking for copy number variants
sbatch calc_coverage.sh
sbatch --array=1-3 plot_coverage

## Structural variant calling with smoove (Lumpy). All calls from inside SV directory.
sbatch --array=1-90 run_smoove.sh
sbatch merge_smoove.sh
sbatch --array=1-90 genotype_smoove.sh
sbatch finish_smoove.sh
sbatch annotate_vcfs_lumpy.sh

## That's it for the core variant calling pipeline. There are additional scripts here for looking at SVs and pulling evidence from the bams for the browser, but that's all secondary
