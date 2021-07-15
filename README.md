# Sapporo test workflows

Sapporo の test 用の workflow。

同じ処理をそれぞれ別の workflow 言語で実装した。

## qc_and_trimming

### cwl

```bash
$ docker run -i --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /tmp:/tmp \
    -v $PWD:$PWD \
    -w=$PWD \
    commonworkflowlanguage/cwltool:1.0.20191225192155 \
    --outdir ./results/qc_and_trimming/cwl \
    ./qc_and_trimming/cwl/trimming_and_qc.cwl \
    --fastq_1 ./qc_and_trimming/ERR034597_1.small.fq.gz \
    --fastq_2 ./qc_and_trimming/ERR034597_2.small.fq.gz \
    --nthreads 2

$ tree results/qc_and_trimming/cwl/
results/qc_and_trimming/cwl/
├── ERR034597_1.small_fastqc.html
├── ERR034597_1.small.fq.trimmed.1P.fq
├── ERR034597_1.small.fq.trimmed.1U.fq
├── ERR034597_1.small.fq.trimmed.2P.fq
├── ERR034597_1.small.fq.trimmed.2U.fq
└── ERR034597_2.small_fastqc.html
```

### nextflow

```bash
$ docker run -i --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $PWD:$PWD \
    -w=$PWD \
    nextflow/nextflow:21.01.1-edge \
    nextflow \
    -dockerize \
    -c ./qc_and_trimming/nextflow/nextflow.config \
    run \
    ./qc_and_trimming/nextflow/main.nf \
    --outdir ./results/qc_and_trimming/nextflow \
    --fastq_1 ./qc_and_trimming/ERR034597_1.small.fq.gz \
    --fastq_2 ./qc_and_trimming/ERR034597_2.small.fq.gz \
    --nthreads 2

$ tree results/qc_and_trimming/nextflow/
results/qc_and_trimming/nextflow/
├── qc_1
│   ├── ERR034597_1.small_fastqc.html
│   └── ERR034597_1.small_fastqc.zip
├── qc_2
│   ├── ERR034597_2.small_fastqc.html
│   └── ERR034597_2.small_fastqc.zip
└── trimming
    ├── ERR034597_1.trimmed.1P.fq
    ├── ERR034597_1.trimmed.1U.fq
    ├── ERR034597_2.trimmed.2P.fq
    └── ERR034597_2.trimmed.2U.fq
```

### wdl

### snakemake
