#!/bin/bash
rm -rf vllm-sources
tar -xf vllm-0.10.0.tar.gz
mv vllm-0.10.0 vllm-sources
pip3 install --user vllm==0.10
#Add VLLM_TARGET_DEVICE support https://docs.vllm.ai/en/stable/configuration/env_vars.html
echo $? > ~/install-exit-status
echo "#!/bin/bash
NUM_GPUS=\`nvidia-smi --query-gpu=name --format=csv,noheader | wc -l\`
EXTRA_ARGS=\"\"
if ! [ \"\$NUM_GPUS\" -eq \"\$NUM_GPUS\" ] 2> /dev/null
then
    echo \"NUM_GPUS is not a number: \$NUM_GPUS\"
else
    EXTRA_ARGS=\"\$EXTRA_ARGS --tensor-parallel-size=\$NUM_GPUS\"
fi
OMP_NUM_THREADS=\$NUM_CPU_PHYSICAL_CORES PATH=~/.local/bin/:\$PATH ~/.local/bin/vllm bench \$@ \$EXTRA_ARGS > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > ~/vllm
chmod +x ~/vllm
