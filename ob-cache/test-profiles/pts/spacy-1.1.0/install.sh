#!/bin/sh
pip3 install --user spacy==3.8.11
pip3 install --user en_core_web_trf-3.8.0-py3-none-any.whl
pip3 install --user en_core_web_lg-3.8.0-py3-none-any.whl
pip3 install --user en_core_web_sm-3.8.0-py3-none-any.whl
echo $? > ~/install-exit-status

tar -xf spacy_benchmarks-1.tar.xz
sed -i 's/iterations = 20/iterations = 50/g' spacy_benchmarks.py
echo "#!/bin/sh
python3 spacy_benchmarks.py \$@ > \$LOG_FILE 2>&1
echo \$? > ~/test-exit-status" > spacy
chmod +x spacy
