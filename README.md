# nomad-tutorial-workflows

### Full Title:

NOMAD Tutorial Workflows

### Description:

A tutorial demonstrating workflow and project management in NOMAD

> ℹ️ **Note**
> This tutorial was originally presented at the **DPG Spring Meeting 2025**.
> The original version can be found at [Fairmat Tutorial DPG 2025](https://fairmat-nfdi.github.io/fairmat-tutorial-DPG-2025/). This version remains nearly identical, with some minor out-of-date information removed. References to the DPG remain within the tutorial project descriptions.


### How to mkdocs pages locally

Create a virtual environment with Python3.xx (>=3.11 suggested):
```
python3 -m venv .pyenvtuto
```
and activate it in your shell:
```
. .pyenvtuto/bin/activate
```
upgrade pip
```
pip install --upgrade pip
```

Install the mkdocs dependencies:
```
pip install -r requirements_docs.txt
```

Launch locally:
```
mkdocs serve
```

The output on the terminal should have these lines:
```
...
INFO     -  Building documentation...
INFO     -  Cleaning site directory
INFO     -  Documentation built in 0.29 seconds
INFO     -  [14:31:29] Watching paths for changes: 'docs', 'mkdocs.yml'
INFO     -  [14:31:29] Serving on http://127.0.0.1:8000/
...
```
Then click on the http address to launch the MKDocs.
