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
    └── a1310703-93ab-43aa-a9a2-30e07d9df352
        ├── call-qc_1
        │   ├── execution
        │   │   ├── docker_cid
        │   │   ├── glob-bd086f3cf6886852715f2dd55c8bddbc
        │   │   │   ├── cromwell_glob_control_file
        │   │   │   ├── ERR034597_1.small_fastqc.html
        │   │   │   └── ERR034597_1.small_fastqc.zip
        │   │   ├── glob-bd086f3cf6886852715f2dd55c8bddbc.list
        │   │   ├── qc_1
        │   │   │   ├── ERR034597_1.small_fastqc.html
        │   │   │   └── ERR034597_1.small_fastqc.zip
        │   │   ├── rc
        │   │   ├── script
        │   │   ├── script.background
        │   │   ├── script.submit
        │   │   ├── stderr
        │   │   ├── stderr.background
        │   │   ├── stdout
        │   │   └── stdout.background
        │   ├── inputs
        │   │   └── -2123581260
        │   │       └── ERR034597_1.small.fq.gz
        │   └── tmp.3a7553d6
        ├── call-qc_2
        │   ├── execution
        │   │   ├── docker_cid
        │   │   ├── glob-a7337e2991a5db0bf521e4e34f4b7560
        │   │   │   ├── cromwell_glob_control_file
        │   │   │   ├── ERR034597_2.small_fastqc.html
        │   │   │   └── ERR034597_2.small_fastqc.zip
        │   │   ├── glob-a7337e2991a5db0bf521e4e34f4b7560.list
        │   │   ├── qc_2
        │   │   │   ├── ERR034597_2.small_fastqc.html
        │   │   │   └── ERR034597_2.small_fastqc.zip
        │   │   ├── rc
        │   │   ├── script
        │   │   ├── script.background
        │   │   ├── script.submit
        │   │   ├── stderr
        │   │   ├── stderr.background
        │   │   ├── stdout
        │   │   └── stdout.background
        │   ├── inputs
        │   │   └── -2123581260
        │   │       └── ERR034597_2.small.fq.gz
        │   └── tmp.64982b70
        └── call-trimming
            ├── execution
            │   ├── docker_cid
            │   ├── glob-aa81c8454c4316f7ee392b324287f3c4
            │   │   ├── cromwell_glob_control_file
            │   │   ├── ERR034597_1.small.trimmed.1P.fq
            │   │   ├── ERR034597_1.small.trimmed.1U.fq
            │   │   ├── ERR034597_1.small.trimmed.2P.fq
            │   │   └── ERR034597_1.small.trimmed.2U.fq
            │   ├── glob-aa81c8454c4316f7ee392b324287f3c4.list
            │   ├── rc
            │   ├── script
            │   ├── script.background
            │   ├── script.submit
            │   ├── stderr
            │   ├── stderr.background
            │   ├── stdout
            │   ├── stdout.background
            │   └── trimming
            │       ├── ERR034597_1.small.trimmed.1P.fq
            │       ├── ERR034597_1.small.trimmed.1U.fq
            │       ├── ERR034597_1.small.trimmed.2P.fq
            │       └── ERR034597_1.small.trimmed.2U.fq
            ├── inputs
            │   └── -2123581260
            │       ├── ERR034597_1.small.fq.gz
            │       └── ERR034597_2.small.fq.gz
            └── tmp.85fe88f5
```

local container="broadinstitute/cromwell:55"
local wf_type=$(jq -r ".workflow_type" ${run_request})
  local wf_type_version=$(jq -r ".workflow_type_version" ${run_request})
  local cmd_txt="docker run -i --rm ${D_SOCK} -v ${run_dir}:${run_dir} -v /tmp:/tmp -v /usr/bin/docker:/usr/bin/docker -w=${exe_dir} ${container} run ${wf_engine_params} ${wf_url} -i ${wf_params} -m ${exe_dir}/metadata.json --type ${wf_type} --type-version ${wf_type_version} 1>${stdout} 2>${stderr}"
  echo ${cmd_txt} >${cmd}
eval ${cmd_txt} || executor_error
  if [[ ${wf_type} == "CWL" ]]; then
    jq -r ".outputs[].location" "${exe_dir}/metadata.json" | while read output_file; do
cp ${output_file} ${outputs_dir}/
    done
  elif [[ ${wf_type} == "WDL" ]]; then
    jq -r ".outputs | to_entries[] | .value" "${exe_dir}/metadata.json" | while read output_file; do
cp ${output_file} ${outputs_dir}/
done
fi

### snakemake
