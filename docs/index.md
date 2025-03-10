# How to Use NOMAD's Workflow Utilities to Improve Data Management and Facilitate Discovery in Materials Science

NOMAD [[nomad-lab.eu](nomad-lab.eu){:target="_blank"}] [1] is an open-source, community-driven data infrastructure that supports automated (meta)data extraction from a wide range of simulations, including ab initio and advanced many-body calculations, as well as molecular dynamics simulations. NOMAD also provides extensive customization capabilities to support experimental data. NOMAD allows users to store both standardized and custom complex workflows, which streamline data provenance storage and analysis, facilitating efficient curation of AI-ready datasets. This tutorial series will focus on recently developed workflow functionalities and utilities within the NOMAD infrastructure, with a step-by-step guide for storing a custom project workflow that contains tasks involving a variety of distinct data sources. Attendees can then use this knowledge to transform their day-to-day project data management, or even to interface with the NOMAD repository in a high-throughput fashion, opening improved discovery pipelines by leveraging the benefits of NOMAD’s comprehensive and FAIR-compliant data management system [2]. Attendees are welcome to simply watch the demonstration or to follow along on their laptops. For the latter, preparation instructions will be provided in advance below.


[1] Scheidgen, M. et al., JOSS 8, 5388 (2023).

[2] Scheffler, M. et al., Nature 604, 635-642 (2022).

## **Tutorial preparation**

### 1. Create a NOMAD account at [NOMAD Central Deployment](https://nomad-lab.eu/prod/v1/gui/about/information){:target="_blank"}

Click `LOGIN/REGISTER` at the top right.


### 2. Install the nomad-utility-workflows module

Open a terminal and create a virtual environment with python==3.11 (It may be possible to use python>=3.9, but the module has only been fully tested with 3.11):

```sh
python3.11 -m venv .pyenv
. .pyenv/bin/activate
```

Upgrade pip and install uv (recommended):

```sh
pip install --upgrade pip
pip install uv
```

Install the latest pypi version of the plugin using pip:

```bash
uv pip install "nomad-utility-workflows>=0.0.19" --index-url https://gitlab.mpcdf.mpg.de/api/v4/projects/2187/packages/pypi/simple
```

In order to use a Jupyter notebook in the following, install ipython and then create a Jupyter kernel for this venv (this kernel can then be be identified and loaded into your IDE):

```bash
uv pip install --upgrade ipython
uv pip install --upgrade ipykernel
ipython kernel install --user --name=DPG-tutorial
```
<!-- python -m ipykernel install --user --name=DPG-tutorial -->

Now you should be able to simply launch a Jupyter notebook browser with `jupyter notebook` in the terminal.
Open a (new) `.ipynb` file, and then select `DPG-tutorial` from the kernel list.

## **Resources**

### 1. Explore the [NOMAD documentation](https://nomad-lab.eu/prod/v1/docs/){:target="_blank"}.

### 2. Join our vibrant Discord community! [Invitation to Discord :fontawesome-brands-discord:](https://discord.gg/Gyzx3ukUw8){:target="_blank"}
