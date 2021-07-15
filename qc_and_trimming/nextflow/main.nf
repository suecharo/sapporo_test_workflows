#!/usr/bin/env nextflow

params.fastq_1 = './fastq_1.fq'
params.fastq_2 = './fastq_2.fq'
params.nthreads = 2

qc_fastq_1 = Channel.fromPath(params.fastq_1, checkIfExists:true)
qc_fastq_2 = Channel.fromPath(params.fastq_2, checkIfExists:true)
trimming_fastq_1 = Channel.fromPath(params.fastq_1, checkIfExists:true)
trimming_fastq_2 = Channel.fromPath(params.fastq_2, checkIfExists:true)

params.outdir = './results/qc_and_trimming/nextflow'

process qc_1 {
    container 'quay.io/biocontainers/fastqc:0.11.9--0'
    publishDir params.outdir, mode: 'copy'
    cpus params.nthreads

    input:
        file input from qc_fastq_1

    output:
        file "qc_1/*" into qc_1_result

    """
    mkdir -p qc_1
    fastqc -o qc_1 \
      --threads ${task.cpus} \
      ${input}
    """
}

process qc_2 {
    container 'quay.io/biocontainers/fastqc:0.11.9--0'
    publishDir params.outdir, mode: 'copy'
    cpus params.nthreads

    input:
        file input from qc_fastq_2

    output:
        file "qc_2/*" into qc_2_result

    """
    mkdir -p qc_2
    fastqc -o qc_2 \
      --threads ${task.cpus} \
      ${input}
    """
}

process trimming {
    container 'quay.io/biocontainers/trimmomatic:0.38--1'
    publishDir params.outdir, mode: 'copy'
    cpus params.nthreads

    input:
        file fastq_1 from trimming_fastq_1
        file fastq_2 from trimming_fastq_2

    output:
        file "trimming/*" into trimming_result

    """
    mkdir -p trimming
    trimmomatic \
      PE \
      -threads ${task.cpus} \
      ${fastq_1} \
      ${fastq_2} \
      trimming/${fastq_1.simpleName}.trimmed.1P.fq \
      trimming/${fastq_1.simpleName}.trimmed.1U.fq \
      trimming/${fastq_2.simpleName}.trimmed.2P.fq \
      trimming/${fastq_2.simpleName}.trimmed.2U.fq \
      ILLUMINACLIP:/usr/local/share/trimmomatic/adapters/TruSeq2-PE.fa:2:40:15 \
      LEADING:20 \
      TRAILING:20 \
      SLIDINGWINDOW:4:15 \
      MINLEN:36
    """
}
