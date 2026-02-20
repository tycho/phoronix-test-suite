#!/bin/bash
pip3 install --user openvino-genai==2025.4 openvino==2025.4 diffusers==0.36.0 optimum==2.1.0 optimum.intel==1.27.0 onnx==1.20.0
EXIT_STATUS=$?
if [ $EXIT_STATUS -ne 0 ]; then
	echo $EXIT_STATUS > ~/install-exit-status
	exit 2
fi
tar -xvf openvino.genai-2025.4.1.0.tar.gz
cd openvino.genai-2025.4.1.0/tools/llm_bench/
#pip install --user optimum-intel@git+https://github.com/huggingface/optimum-intel.git
pip install --user -r requirements.txt
~/.local/bin/optimum-cli export openvino --trust-remote-code --model TinyLlama/TinyLlama-1.1B-Chat-v1.0 TinyLlama-1.1B-Chat-v1.0
~/.local/bin/optimum-cli export openvino --trust-remote-code --model ibm-granite/granite-3.0-8b-instruct granite-3.0-8b-instruct

cd ~
echo "#!/bin/bash
cd openvino.genai-2025.4.1.0/tools/llm_bench/
python3 ./benchmark.py \$@ > \$LOG_FILE
echo \$? > ~/test-exit-status" > openvino-genai
chmod +x openvino-genai
