# Sapporo test workflows

Sapporo の test 用の workflow。

同じ処理をそれぞれ別の workflow 言語で実装した。

## qc_and_trimming

![graph]("./qc_and_trimming/graph.png")

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

#### for sapporo

`workflow_url`

`https://github.com/suecharo/sapporo_test_workflows/blob/main/qc_and_trimming/cwl/trimming_and_qc.cwl`

---

`workflow_engine`

`cwltool`

---

`workflow_parameters`

```json
{
  "fastq_1": {
    "class": "File",
    "location": "https://github.com/suecharo/sapporo_test_workflows/raw/main/qc_and_trimming/ERR034597_1.small.fq.gz"
  },
  "fastq_2": {
    "class": "File",
    "location": "https://github.com/suecharo/sapporo_test_workflows/raw/main/qc_and_trimming/ERR034597_2.small.fq.gz"
  }
}
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

#### for sapporo

`worfklow_url`

`https://github.com/suecharo/sapporo_test_workflows/blob/main/qc_and_trimming/nextflow/main.nf`

Nextflow は GitHub URL を書くと、github project として判断されるため、workflow_document を file として attach する必要がある

---

`workflow_engine`

`nextflow`

---

`workflow_engine_parameters`

```json
{
  "-c": "nextflow.config"
}
```

---

`workflow_attachment`

Nextflow は `nextflow.config` を attach する必要がある。

```json
[
  {
    "file_name": "nextflow.config",
    "file_url": "https://github.com/suecharo/sapporo_test_workflows/raw/main/qc_and_trimming/nextflow/nextflow.config"
  },
  {
    "file_name": "ERR034597_1.small.fq.gz",
    "file_url": "https://github.com/suecharo/sapporo_test_workflows/raw/main/qc_and_trimming/ERR034597_1.small.fq.gz"
  },
  {
    "file_name": "ERR034597_2.small.fq.gz",
    "file_url": "https://github.com/suecharo/sapporo_test_workflows/raw/main/qc_and_trimming/ERR034597_2.small.fq.gz"
  }
]
```

---

`workflow_parameters`

```json
{
  "fastq_1": "./ERR034597_1.small.fq.gz",
  "fastq_2": "./ERR034597_2.small.fq.gz",
  "nthread": 2
}
```

### wdl

```bash
$ docker run -i --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $PWD:$PWD \
    -v /tmp:/tmp \
    -v /usr/bin/docker:/usr/bin/docker \
    -w=$PWD \
    broadinstitute/cromwell:55 \
    run \
    ./qc_and_trimming/wdl/qc_and_trimming.wdl \
    -i ./qc_and_trimming/wdl/workflow_params.json \
    -m metadata.json \
    --type WDL \
    --type-version 1.0

$ tree cromwell-executions/
cromwell-executions/
└── qc_and_trimming
            ...
```

#### for sapporo

`workflow_url`

`https://github.com/suecharo/sapporo_test_workflows/blob/main/qc_and_trimming/wdl/qc_and_trimming.wdl`

WDL は workflow document を file として attach しなければならない

---

`workflow_engine`

`cromwell`

---

`workflow_attachment`

WDL は remote file access が出来ないため、file attach する必要がある。

```json
[
  {
    "file_name": "ERR034597_1.small.fq.gz",
    "file_url": "https://github.com/suecharo/sapporo_test_workflows/raw/main/qc_and_trimming/ERR034597_1.small.fq.gz"
  },
  {
    "file_name": "ERR034597_2.small.fq.gz",
    "file_url": "https://github.com/suecharo/sapporo_test_workflows/raw/main/qc_and_trimming/ERR034597_2.small.fq.gz"
  }
]
```

---

`workflow_parameters`

```json
{
  "qc_and_trimming.fastq_1": "ERR034597_1.small.fq.gz",
  "qc_and_trimming.fastq_2": "ERR034597_2.small.fq.gz",
  "qc_and_trimming.nthread": 2
}
```

### snakemake

```bash
$ cd qc_and_trimming/snakemake

$ docker run -i --rm \
    -v $PWD:$PWD \
    -w=$PWD \
    snakemake/snakemake:v5.32.0 \
    snakemake \
    --use-conda \
    --cores 2 \
    --snakefile ./Snakefile \
    --configfile ./config.json

$ tree trimming/
trimming/
├── output.trimmed.1P.fq
├── output.trimmed.1U.fq
├── output.trimmed.2P.fq
└── output.trimmed.2U.fq
```

#### for sapporo

`workflow_url`

`https://github.com/suecharo/sapporo_test_workflows/blob/main/qc_and_trimming/snakemake/Snakefile`

Snakemake は workflow document を file として attach しなければならない

---

`workflow_engine`

`snakemake`

---

`workflow_engine_parameters`

snakemake は config file の扱いが難しい

```json
{
  "--use-conda": "",
  "--cores": 2,
  "--configfile": "workflow_params.json"
}
```

---

`workflow_attachment`

`env.yml` や data set を attatch する

```json
[
  {
    "file_name": "ERR034597_1.small.fq.gz",
    "file_url": "https://github.com/suecharo/sapporo_test_workflows/raw/main/qc_and_trimming/ERR034597_1.small.fq.gz"
  },
  {
    "file_name": "ERR034597_2.small.fq.gz",
    "file_url": "https://github.com/suecharo/sapporo_test_workflows/raw/main/qc_and_trimming/ERR034597_2.small.fq.gz"
  },
  {
    "file_name": "envs.yml",
    "file_url": "https://raw.githubusercontent.com/suecharo/sapporo_test_workflows/main/qc_and_trimming/snakemake/envs.yml"
  }
]
```

---

`workflow_parameters`

```json
{
  "fastq_1": "ERR034597_1.small.fq.gz",
  "fastq_2": "ERR034597_2.small.fq.gz",
  "nthread": 2
}
```
