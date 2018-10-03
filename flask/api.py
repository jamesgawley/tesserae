#!/usr/bin/python3
import subprocess
import csv
import os
from flask import Flask
from flask import render_template


app = Flask(__name__)

with open('/var/www/tesserae/data/common/cts_list.py','r') as inf:
    cts_backward = eval(inf.read())
cts_list = {v:k for k, v in cts_backward.items()}

@app.route('/')
def hello_world():
    return 'Hello, World!'

@app.route('/oldsearch/')
def old_read_bin():
    result = subprocess.Popen(["perl", "/var/www/tesserae/cgi-bin/read_bin_tmv.pl", "--path", "tesresults", "--export", "html"], stdout=subprocess.PIPE)
    return result.stdout

@app.route('/search/<target>/<source>/<unit>/<format>')
def read_bin(target, source, format):
    path = os.path.join('tmp', target, source, unit)
    target_name = cts_list[target]
    source_name = cts_list[source]
    if not os.path.exists(path):
        cmd = " ".join(["perl", "/var/www/tesserae/cgi-bin/read_table.pl", "--target", target_name, "--source", source_name, "--binary", path])
        subprocess.Popen(cmd, shell=True)
    cmd = " ".join(["perl", "/var/www/tesserae/cgi-bin/read_bin_tmv.pl", "--path", path, "--export", format, "--window", "5"])
    result = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
        .read()

@app.route('/hello/')
@app.route('/hello/<name>')
def hello(name=None):
    return render_template('hello.html', name=name)
