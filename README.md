# nomad-tutorial-workflows

### Full Title:

NOMAD Tutorial Workflows

### Description:

A tutorial demonstrating workflow and project management in NOMAD

> ℹ️ **Note**
> This tutorial was originally presented at the **DPG Spring Meeting 2025**.
> The original version can be found at [Fairmat Tutorial DPG 2025](https://fairmat-nfdi.github.io/fairmat-tutorial-DPG-2025/). This version remains nearly identical, with some minor out-of-date information removed. References to the DPG remain within the tutorial project descriptions.


### How to launch mkdocs pages locally

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

### How to update the gh-page version with mike

After all relevant changes are merged into main branch, checkout an up-to-date main branch locally, and run the following command:

```
mike deploy --push --update-aliases vx.x latest
mike set-default latest --push
```

where x.x corresponds to the next major or minor versions of the repo as appropriate.

> ℹ️ **Tip**
> Make sure that your local gh-pages branch is up to date or delete it.

> ℹ️ **Note**
> Use x.x equal to the current version to overwrite the current version with your changes.

This command will automatically create or overwrite a folder vx.x/ that contains the present version of your docs. This version will also be linked to the latest alias.

First, check to make sure the pages were deployed correctly. Now make a release of the repo with the same version name and tag for proper book-keeping.