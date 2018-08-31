#!/usr/bin/python3
import subprocess
import csv
import os
from flask import Flask
from flask import render_template

app = Flask(__name__)

with open('/var/www/tesserae/data/common/cts_list.py','r') as inf:
    cts_list = eval(inf.read())

@app.route('/')
def hello_world():
    return 'Hello, World!'

@app.route('/oldsearch/')
def old_read_bin():
    result = subprocess.run(["perl", "/var/www/tesserae/cgi-bin/read_bin_tmv.pl", "--path", "tesresults", "--export", "html"], stdout=subprocess.PIPE)
    return result.stdout

@app.route('/search/<target>/<source>/')
def read_bin(target, source):
    path = os.path.join('search', target, source)
    target_name = cts_list[target]
    source_name = cts_list[source]
    if not os.path.exists(path):
        subprocess.run(["perl", "/var/www/tesserae/cgi-bin/read_table.pl", "--target", target_name, "--source", source_name, "--binary", path])
    result = subprocess.run(["perl", "/var/www/tesserae/cgi-bin/read_bin_tmv.pl", "--path", path, "--export", "html", "--window", "5"], stdout=subprocess.PIPE)
    return result.stdout

@app.route('/hello/')
@app.route('/hello/<name>')
def hello(name=None):
    return render_template('hello.html', name=name)
