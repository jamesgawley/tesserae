#!/usr/bin/python3
import subprocess32 as subprocess
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
    result = subprocess.run(["perl", "/var/www/tesserae/cgi-bin/read_bin_tmv.pl", "--path", "tmp/urn:cts:latinLit:tmv0130.tmv002/urn:cts:latinLit:phi1014.phi004/phrase/", "--export", "json", "--window", "5"], capture_output=True)
    return result

@app.route('/search/<target>/<source>/<unit>/')
def read_bin(target, source, unit):
    path = os.path.join('tmp', target, source, unit)
    target_name = cts_list[target]
    source_name = cts_list[source]
    if not os.path.exists(path):
        subprocess.run(["perl", "/var/www/tesserae/cgi-bin/read_table.pl", "--target", target_name, "--source", source_name, "--binary", path, "--unit", unit])
    filepath = path + "results.json"
    result = subprocess.run(["perl", "/var/www/tesserae/cgi-bin/read_bin_tmv.pl", "--path", path, "--export", "json", "--window", "5"], stdout=subprocess.PIPE)
    #result.wait()   
    #f = open(filepath, 'r')
    #contents = f.read()
    #f.close()
    return result.stdout

@app.route('/hello/')
@app.route('/hello/<name>')
def hello(name=None):
    return render_template('hello.html', name=name)
