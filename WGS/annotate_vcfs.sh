#!/bin/bash
#SBATCH -J ann_vcfs  #job name for array
#SBATCH -n 2                   # Number of cores
#SBATCH -N 1                    # Ensure that all cores are on one machine
#SBATCH -t 0-01:05              # Runtime in D-HH:MM
#SBATCH -p serial_requeue       # Partition to submit to
#SBATCH --mem=3000               # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -o ../../Output/shell_outs/annotate_vcfs.out      # File to which STDOUT will be written
#SBATCH -e ../../Output/shell_outs/annotate_vcfs.err      # File to which STDERR will be written
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=milo.s.johnson.13@gmail.com  # Email to which notifications will be sent

# Getting sample nammodule load gatk/4.0.2.1-fasrc01
module load jdk/1.8.0_45-fasrc01

OUTD="../../Output/WGS/"

for i in {1..18}
do
  echo "COUNT: $i"
  CHROMO=$(sed -n ${i}'{p;q}' chromo_intervals.txt)
  java -Xmx4g -jar ~/snpEff/snpEff.jar -c ~/snpEff/snpEff.config -v w303_vlte ${OUTD}chromo_vcfs/${CHROMO}_final.vcf > ${OUTD}chromo_vcfs/${CHROMO}_final.ann.vcf
done

