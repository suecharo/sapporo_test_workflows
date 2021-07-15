version 1.0
task qc_1 {
  input {
    File fastq
    Int nthread
  }

  command {
    mkdir -p qc_1
    fastqc -o qc_1 \
      --threads ${nthread} \
      ${fastq}
  }

  output {
    Array[File] results = glob("qc_1/*")
  }

  runtime {
    cpu: nthread
    docker: "quay.io/biocontainers/fastqc:0.11.9--0"
  }
}

task qc_2 {
  input {
    File fastq
    Int nthread
  }

  command {
    mkdir -p qc_2
    fastqc -o qc_2 \
      --threads ${nthread} \
      ${fastq}
  }

  output {
    Array[File] results = glob("qc_2/*")
  }

  runtime {
    cpu: nthread
    docker: "quay.io/biocontainers/fastqc:0.11.9--0"
  }
}

task trimming {
  input {
    File fastq_1
    File fastq_2
    Int nthread
    String sample_name = basename(fastq_1, ".fq.gz")
  }

  command {
    mkdir -p trimming
    trimmomatic \
      PE \
      -threads ${nthread} \
      ${fastq_1} \
      ${fastq_2} \
      trimming/${sample_name}.trimmed.1P.fq \
      trimming/${sample_name}.trimmed.1U.fq \
      trimming/${sample_name}.trimmed.2P.fq \
      trimming/${sample_name}.trimmed.2U.fq \
      ILLUMINACLIP:/usr/local/share/trimmomatic/adapters/TruSeq2-PE.fa:2:40:15 \
      LEADING:20 \
      TRAILING:20 \
      SLIDINGWINDOW:4:15 \
      MINLEN:36
  }

  output {
    Array[File] results = glob("trimming/*")
  }

  runtime {
    cpu: nthread
    docker: "quay.io/biocontainers/trimmomatic:0.38--1"
  }
}

workflow qc_and_trimming {
  input {
    File fastq_1
    File fastq_2
    Int nthread
  }

  call qc_1 { input: fastq=fastq_1, nthread=nthread }
  call qc_2 { input: fastq=fastq_2, nthread=nthread }
  call trimming { input: fastq_1=fastq_1, fastq_2=fastq_2, nthread=nthread }
}